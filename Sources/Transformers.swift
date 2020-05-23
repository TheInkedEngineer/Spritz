//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

// MARK: - Internal Functions

internal extension Spritz {
  
  /// Namespacing functions that do all the transformation
  enum Transformer {}
}

internal extension Spritz.Transformer {
  /// Generates the CF representation of a given last name.
  static func lastName(from name: String) throws -> String {
    let name = name.strippedForCF().uppercased()
    
    if let shortNameCharacters = try shortNameComposer(name) {
      return shortNameCharacters
    }
    
    let segregatedLetters = segregateLetters(in: name)
    let vowels = segregatedLetters.vowels
    let consonants = segregatedLetters.consonants
    
    switch consonants.count {
    case 3...: return longNameComposer(numberOfConsonants: .three, consonants: consonants, vowels: vowels)
    case 2   : return longNameComposer(numberOfConsonants: .two  , consonants: consonants, vowels: vowels)
    case 1   : return longNameComposer(numberOfConsonants: .one  , consonants: consonants, vowels: vowels)
    case 0   : return longNameComposer(numberOfConsonants: .zero , consonants: consonants, vowels: vowels)
    default  : fatalError("Unexpected Number Of Consonants")
    }
  }
  
  /// Generates the CF representation of a given first name.
  static func firstName(from name: String) throws -> String {
    let name = name.strippedForCF().uppercased()
    
    if let shortNameCharacters = try shortNameComposer(name) { return shortNameCharacters }
    
    let segregatedLetters = segregateLetters(in: name)
    let vowels = segregatedLetters.vowels
    let consonants = segregatedLetters.consonants
    
    switch consonants.count {
    case 4...: return longNameComposer(numberOfConsonants: .fourPlus, consonants: consonants, vowels: vowels)
    case 3   : return longNameComposer(numberOfConsonants: .three   , consonants: consonants, vowels: vowels)
    case 2   : return longNameComposer(numberOfConsonants: .two     , consonants: consonants, vowels: vowels)
    case 1   : return longNameComposer(numberOfConsonants: .one     , consonants: consonants, vowels: vowels)
    case 0   : return longNameComposer(numberOfConsonants: .zero    , consonants: consonants, vowels: vowels)
    default: fatalError("Unexpected Number Of Consonants")
    }
  }
  
  /// Generates the CF representation of a given sex and birth date.
  static func birthDateAndSex(sex: Sex, birthdate: Date) throws -> String {
    let monthAndDayComponents = Calendar(identifier: .gregorian).dateComponents([.day, .month, .year], from: birthdate)
    
    guard
      let dayAsInt   = monthAndDayComponents.day,
      let monthAsInt = monthAndDayComponents.month,
      let yearAsInt  = monthAndDayComponents.year,
      let month      = MonthRepresentation(rawValue: monthAsInt)
      
      else {
        throw Spritz.ParsingError.corruptedData("Could not parse date")
    }
    
    if month == .B, !Spritz.Transformer.isLeapYear(yearAsInt), dayAsInt > 28 {
      throw Spritz.ParsingError.corruptedData("Invalid date. February has only 28 days in a non-leap year.")
    }
    
    var day: String {
      switch sex {
      case .male: return String(format: "%02d",  dayAsInt)
      case .female: return String(format: "%02d", dayAsInt + 40)
      }
    }
    
    let year = String(yearAsInt).suffix(2)
    
    return "\(year)\(month)\(day)"
  }
  
  /// Extract the code associated to the place of birth.
  static func placeOfBirth(_ place: String) throws -> CodiceStatistico {
    var occurrence = Spritz.italianPlacesOfBirth.first { $0.name.lowercased().strippedForCF() == place.lowercased().strippedForCF() }
    if let comune = occurrence { return comune.code }
    occurrence = Spritz.foreignPlacesOfBirth.first { $0.name.lowercased().strippedForCF() == place.lowercased().strippedForCF() }
    if let country = occurrence { return country.code }
    throw Spritz.ParsingError.corruptedData("Could not find the codice statistico for \(place). Make sure the spelling was correct.")
  }
  
  /// Calculates the CF final control character based on the first 15 characters.
  /// - Parameter currentCF: The first 15 characters of the `Codice Fiscale`.
  static func controlCharacter(for currentCF: String) -> String {
    assert(currentCF.count == 15, "The passed `CF` should be 15 characters long. Received \(currentCF) instead.")
    
    let stringAsArrayOfCharacters = currentCF.map { String($0) }
    
    let evenLettersSum = stride(from: stringAsArrayOfCharacters.startIndex + 1, to: stringAsArrayOfCharacters.endIndex, by: 2)
      .reduce(0) { result, newValue -> Int in
        if let number = Int(stringAsArrayOfCharacters[newValue]) { return result + number }
        guard let letter = Alphabet(rawValue: stringAsArrayOfCharacters[newValue].uppercased()) else { fatalError("Letter does not exist") }
        return result + letter.evenPositionValue
    }
    
    let oddLettersSum = stride(from: stringAsArrayOfCharacters.startIndex, to: stringAsArrayOfCharacters.endIndex, by: 2)
      .reduce(0) { result, newValue -> Int in
        if let number = Int(stringAsArrayOfCharacters[newValue]) {
          guard let value = SingleDigitNumber(rawValue: number) else { fatalError("This is not a number")}
          return result + value.oddPositionValue
        }
        guard let letter = Alphabet(rawValue: stringAsArrayOfCharacters[newValue].uppercased()) else { fatalError("Letter does not exist") }
        return result + letter.oddPositionValue
    }
    
    guard let controlLetter = Alphabet(position: (evenLettersSum + oddLettersSum) % 26) else {
      fatalError("Should never happen, but no for bangs")
    }
    
    return controlLetter.rawValue
  }
}

// MARK: - Helpers

internal extension Spritz.Transformer {
  /// Sperates the consonants and the vowels from the passed name parameter.
  static func segregateLetters(in name: String) -> (consonants: [String], vowels: [String]) {
    (
      consonants: name.filter { !Spritz.italianVowels.contains($0) }.map{ String($0) },
      vowels: name.filter { Spritz.italianVowels.contains($0) }.map{ String($0) }
    )
  }
  
  /// If a name is short (that is, one or two letters long) it generates its representation. If not returns nil.
  static func shortNameComposer(_ name: String) throws -> String? {
    let segregatedLetters = segregateLetters(in: name)
    let vowelsInName = segregatedLetters.vowels
    let consonantsInName = segregatedLetters.consonants
    
    guard !name.isEmpty else { throw Spritz.ParsingError.corruptedData("Name cannot be empty.") }
    
    if name.count == 1 { return name + "XX" }
    
    if name.count == 2 {
      if consonantsInName.count == 2 { return consonantsInName[0] + consonantsInName[1] + "X" }
      if vowelsInName.count == 2 { return vowelsInName[0] + vowelsInName[1] + "X" }
      return consonantsInName[0] + vowelsInName[0] + "X"
    }
    
    return nil
  }
  
  /// Based on the number of Consonants, if generates the representation from the passed passed parameters.
  static func longNameComposer(numberOfConsonants: ConsonantsInName, consonants: [String], vowels: [String]) -> String {
    switch numberOfConsonants {
    case .fourPlus         : return consonants[0] + consonants[2] + consonants[3]
    case .threePlus, .three: return consonants[0...2].reduce("") { $0 + $1 }
    case .two              : return consonants[0] + consonants[1] + vowels[0]
    case .one              : return consonants[0] + vowels[0] + vowels[1]
    case .zero             : return vowels[0...2].reduce("") { $0 + $1 }
    }
  }
  
  /// Checks if a given passed year is Leap of not.
  static func isLeapYear(_ year: Int) -> Bool {
    ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
  }
}

// MARK: - Enums

internal extension Spritz.Transformer {
  /// The number of consonants to check for.
  enum ConsonantsInName {
    case zero, fourPlus, threePlus, three, two, one
  }
  
  /// The letter equivalent of each month.
  enum MonthRepresentation: Int, CaseIterable {
    case A = 1, B, C, D, E, H, L, M, P, R, S, T
    
    init?(stringValue: String) {
      let found = MonthRepresentation.allCases.first { $0.asString == stringValue.uppercased()}
      guard let month = found  else {
        return nil
      }
      self = month
    }
    
    /// Returns the case value as a `String`.
    var asString: String {
      String(describing: self.self)
    }
    
    var maxDaysPerMonth: Int {
      switch self {
      case .A: return 31
      case .B: return 29 // we assume it is 29, because there is no way to know if the year is leap or not from the two digits alone.
      case .C: return 31
      case .D: return 30
      case .E: return 31
      case .H: return 30
      case .L: return 31
      case .M: return 31
      case .P: return 30
      case .R: return 31
      case .S: return 30
      case .T: return 31
      }
    }
  }
  
  /// The italian alphabet from A to Z.
  enum Alphabet: String, CaseIterable {
    case A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z
    
    /// Creates and Alphabet and returns it based on its position starting with 0.
    init?(position: Int) {
      guard position >= 0, position <= 25 else { return nil }
      self = Alphabet.allCases[position]
    }
    
    /// The value of the alphabet when in an even position inside the CF.
    var evenPositionValue: Int {
      guard let position = Alphabet.allCases.firstIndex(of: self) else {
        fatalError("No idea how this can EVER happen. But still better than using a bang.")
      }
      return Int(position)
    }
    
    /// The value of the alphabet when in an odd position inside the CF.
    var oddPositionValue: Int {
      switch self {
      case .A: return 1
      case .B: return 0
      case .C: return 5
      case .D: return 7
      case .E: return 9
      case .F: return 13
      case .G: return 15
      case .H: return 17
      case .I: return 19
      case .J: return 21
      case .K: return 2
      case .L: return 4
      case .M: return 18
      case .N: return 20
      case .O: return 11
      case .P: return 3
      case .Q: return 6
      case .R: return 8
      case .S: return 12
      case .T: return 14
      case .U: return 16
      case .V: return 10
      case .W: return 22
      case .X: return 25
      case .Y: return 24
      case .Z: return 23
      }
    }
  }
  
  /// Single digits from 0 to 9.
  enum SingleDigitNumber: Int, CaseIterable {
    case zero, one, two, three, four, five, six, seven, eight, nine
    
    init?(omocodiaValue: String) {
      let found = SingleDigitNumber.allCases.first { $0.equivalentForOmocodia == omocodiaValue.uppercased()}
      guard let digit = found  else {
        return nil
      }
      self = digit
    }
    
    /// The value of the digit when in an even position inside the CF.
    var evenPositionValue: Int { rawValue }
    
    /// The value of the digit when in an odd position inside the CF.
    var oddPositionValue: Int {
      switch self {
      case .zero : return 1
      case .one  : return 0
      case .two  : return 5
      case .three: return 7
      case .four : return 9
      case .five : return 13
      case .six  : return 15
      case .seven: return 17
      case .eight: return 19
      case .nine : return 21
      }
    }
    
    /// The value of the integer as a letter when substituted to overcome `Omocodia`.
    var equivalentForOmocodia: String {
      switch self {
      case .zero : return "L"
      case .one  : return "M"
      case .two  : return "N"
      case .three: return "P"
      case .four : return "Q"
      case .five : return "R"
      case .six  : return "S"
      case .seven: return "T"
      case .eight: return "U"
      case .nine : return "V"
      }
    }
  }
}
