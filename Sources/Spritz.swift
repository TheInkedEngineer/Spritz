//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

public class Spritz {
  
  /// The object containing all municipalities with their respective data.
  internal static var italianPlaceOfBirth: [PlaceOfBirth] {
    do { return try Spritz.parseCSV(for: .italy) }
    catch let error {
      guard let error = error as? Spritz.ParsingError else {
        fatalError("Unexpected error.")
      }
      switch error {
      case .fileNotFound: fatalError("could not locate the file.")
      case .corruptedData(let message): fatalError("\(message)")
      }
    }
  }
  
  /// The object containing all countries with their respective data.
  internal static var foreignPlaceOfBirth: [PlaceOfBirth] {
    do { return try Spritz.parseCSV(for: .foreign) }
    catch let error {
      guard let error = error as? Spritz.ParsingError else {
        fatalError("Unexpected error.")
      }
      switch error {
      case .fileNotFound: fatalError("could not locate the file.")
      case .corruptedData(let message): fatalError("\(message)")
      }
    }
  }
  
  // MARK: - Init
  
  // This class does not need to be instantiated.
  private init() {}
  
  // MARK: - Methods
  
  public static func generateCF(from info: SpritzInfoProvider) throws -> String {
    let lastNameRepresentation = try Spritz.lastNameRepresentation(from: info.lastName)
    let firstNameRepresentation = try Spritz.firstNameRepresentation(from: info.lastName)
    let dateAndSexRepresentation = Spritz.birthDateAndSexRepresentation(sex: info.sex, birthdate: info.dateOfBirth)
    let placeOfBirthRepresentation = try Spritz.placeOfBirthRepresentation(info.placeOfBirth)
    let firstFifteenLetters = lastNameRepresentation + firstNameRepresentation + dateAndSexRepresentation + placeOfBirthRepresentation
    let controlCharacter = Spritz.controlCharacter(for: firstFifteenLetters)
    
    return firstFifteenLetters + controlCharacter
  }
  
  public static func isValid(_ codiceFiscale: String, for info: SpritzInfoProvider) -> Bool {
    guard codiceFiscale.count == 16 else {
      return false
    }
    
    return true
  }
}

// MARK: - Properties and Enums

extension Spritz {
  /// List of possible decoding errors.
  public enum ParsingError: Error {
    case fileNotFound
    case corruptedData(_ message: String)
  }
  
  /// The number of consonants to check for.
  private enum ConsonantsInName {
    case zero, fourPlus, threePlus, three, two, one
  }
  
  /// The letter equivalent of each month.
  private enum MonthRepresentation: Int {
    case A = 1, B, C, D, E, F, G, H, I, J, K, L
    
    /// Returns the case value as a `String`.
    var asString: String {
      String(describing: self.self)
    }
  }
  
  /// The italian alphabet from A to Z.
  private enum Alphabet: String, CaseIterable {
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
  
  /// The classification of countries as per CF.
  internal enum Country {
    case italy
    case foreign
  }
  
  /// Single digits from 0 to 9.
  private enum SingleDigitNumber: Int {
    case zero, one, two, three, four, five, six, seven, eight, nine
    
    /// The value of the digit when in an even position inside the CF.
    var evenPositionValue: Int {
      rawValue
    }
    
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
  }
  
  /// The vowels in the italian language.
  private static let italianVowels = "AEIOU"
  
  /// The `Spritz` bundle.
  private static let bundle = Bundle(for: Spritz.self)
  
}

// MARK: - Internal Functions

extension Spritz {
  
  /// Parses the `CSV` file present in the bundle.
  /// - throws: `Spritz.ParsingError`
  internal static func parseCSV(for country: Country) throws -> [PlaceOfBirth] {
    let fileName = country == .italy ? "listaComuni" : "listaStati"
    
    guard let filepath = Spritz.bundle.path(forResource: fileName, ofType: "csv") else {
      throw Spritz.ParsingError.fileNotFound
    }
    
    guard let content = try? String(contentsOfFile: filepath) else {
      throw Spritz.ParsingError.corruptedData("Could not stringify the content of the file.")
    }
    
    return try content.components(separatedBy: "\n").compactMap { newEntry -> PlaceOfBirth? in
      // For some reason, there is always an empty line at the end of the csv, when parsing its components.
      // This makes sure if that is the case, to return a nil which is filtered through the `compactMap`.
      if newEntry.isEmpty { return nil }
      
      let parsedData = newEntry.components(separatedBy: ";")
      
      guard parsedData.count == 2 else {
        throw Spritz.ParsingError.corruptedData("Was expecting 2 fields, got \(parsedData.count) while parsing \(newEntry).")
      }
      
      guard parsedData[0].count == 4 else {
        throw Spritz.ParsingError.corruptedData("Was expecting 4 digits for `CodiceStatistico`, but received \(parsedData[0]) instead.")
      }
      
      return PlaceOfBirth(
        code: parsedData[0],
        name: parsedData[1]
      )
    }
  }
  
  /// Generates the CF representation of a given last name.
  internal static func lastNameRepresentation(from name: String) throws -> String {
    let name = name.strippedForCF().uppercased()
    
    if let shortNameCharacters = try shortNameTransformer(name) {
      return shortNameCharacters
    }
    
    let segregatedLetters = segregateLetters(in: name)
    let vowels = segregatedLetters.vowels
    let consonants = segregatedLetters.consonants
    
    switch consonants.count {
    case 3...: return longNameTransformer(numberOfConsonants: .three, consonants: consonants, vowels: vowels)
    case 2   : return longNameTransformer(numberOfConsonants: .two  , consonants: consonants, vowels: vowels)
    case 1   : return longNameTransformer(numberOfConsonants: .one  , consonants: consonants, vowels: vowels)
    case 0   : return longNameTransformer(numberOfConsonants: .zero , consonants: consonants, vowels: vowels)
    default  : fatalError("Unexpected Number Of Consonants")
    }
  }
  
  /// Generates the CF representation of a given first name.
  internal static func firstNameRepresentation(from name: String) throws -> String {
    let name = name.strippedForCF().uppercased()
    
    if let shortNameCharacters = try shortNameTransformer(name) { return shortNameCharacters }
    
    let segregatedLetters = segregateLetters(in: name)
    let vowels = segregatedLetters.vowels
    let consonants = segregatedLetters.consonants
    
    switch consonants.count {
    case 4...: return longNameTransformer(numberOfConsonants: .fourPlus, consonants: consonants, vowels: vowels)
    case 3   : return longNameTransformer(numberOfConsonants: .three   , consonants: consonants, vowels: vowels)
    case 2   : return longNameTransformer(numberOfConsonants: .two     , consonants: consonants, vowels: vowels)
    case 1   : return longNameTransformer(numberOfConsonants: .one     , consonants: consonants, vowels: vowels)
    case 0   : return longNameTransformer(numberOfConsonants: .zero    , consonants: consonants, vowels: vowels)
    default: fatalError("Unexpected Number Of Consonants")
    }
  }
  
  /// Generates the CF representation of a given sex and birth date.
  internal static func birthDateAndSexRepresentation(sex: Sex, birthdate: Date) -> String {
    let monthAndDayComponents = Calendar(identifier: .gregorian).dateComponents([.day, .month, .year], from: birthdate)
    
    guard
      let dayAsInt   = monthAndDayComponents.day,
      let monthAsInt = monthAndDayComponents.month,
      let yearAsInt  = monthAndDayComponents.year,
      let month      = Spritz.MonthRepresentation(rawValue: monthAsInt)
      
      else {
        fatalError("Could not parse date")
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
  
  internal static func placeOfBirthRepresentation(_ place: String) throws -> CodiceStatistico {
    let occurence = italianPlaceOfBirth.first { $0.name.strippedForCF() == place.strippedForCF() }
    guard let comune = occurence else {
      throw Spritz.ParsingError.corruptedData("Could not find the codice statistico for \(place). Make sure the spelling was correct.")
    }
    return comune.code
  }
  
  /// Calculates the CF final control character based on the first 15 characters.
  /// - Parameter currentCF: The first 15 characters of the `Codice Fiscale`.
  internal static func controlCharacter(for currentCF: String) -> String {
    assert(currentCF.count == 15, "The passed `CF` should be 15 chracters long. Received \(currentCF) instead.")
    
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

// MARK: - Private Helpers

private extension Spritz {
  
  /// Sperates the consonants and the vowels from the passed name parameter.
  private static func segregateLetters(in name: String) -> (consonants: [String], vowels: [String]) {
    (
      consonants: name.filter { !Spritz.italianVowels.contains($0) }.map{ String($0) },
      vowels: name.filter { Spritz.italianVowels.contains($0) }.map{ String($0) }
    )
  }
  
  /// If a name is short (that is, one or two letters long) it generates its representation. If not returns nil.
  private static func shortNameTransformer(_ name: String) throws -> String? {
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
  private static func longNameTransformer(numberOfConsonants: ConsonantsInName, consonants: [String], vowels: [String]) -> String {
    switch numberOfConsonants {
    case .fourPlus         : return consonants[0] + consonants[2] + consonants[3]
    case .threePlus, .three: return consonants[0...2].reduce("") { $0 + $1 }
    case .two              : return consonants[0] + consonants[1] + vowels[0]
    case .one              : return consonants[0] + vowels[0] + vowels[1]
    case .zero             : return vowels[0...2].reduce("") { $0 + $1 }
    }
  }
}

// MARK: - To delete

extension Spritz {
//  internal static func dioCane() throws {
//    guard let filepath = Spritz.bundle.path(forResource: "listaComuni1", ofType: "csv") else {
//      throw Spritz.ParsingError.fileNotFound
//    }
//
//    guard let content = try? String(contentsOfFile: filepath) else {
//      throw Spritz.ParsingError.corruptedData("Could not stringify the content of the file.")
//    }
//
//    let comuni = try content.components(separatedBy: "\r\n").compactMap { newEntry -> PlaceOfBirth? in
//      // For some reason, there is always an empty line at the end of the csv, when parsing its components.
//      // This makes sure if that is the case, to return a nil which is filtered through the `compactMap`.
//      if newEntry.isEmpty { return nil }
//
//      let parsedData = newEntry.components(separatedBy: ";")
//
//      guard parsedData.count == 2 else {
//        throw Spritz.ParsingError.corruptedData("Was expecting 2 fields, got \(parsedData.count) while parsing \(newEntry).")
//      }
//
//      guard parsedData[0].count == 4 else {
//        throw Spritz.ParsingError.corruptedData("Was expecting 4 digits for `CodiceStatistico`, but received \(parsedData[0]) instead.")
//      }
//
//      return PlaceOfBirth(code: parsedData[0], name: parsedData[1])
//    }
//
//    guard let filepath2 = Spritz.bundle.path(forResource: "listaComuni2", ofType: "csv") else {
//      throw Spritz.ParsingError.fileNotFound
//    }
//
//    guard let content2 = try? String(contentsOfFile: filepath2) else {
//      throw Spritz.ParsingError.corruptedData("Could not stringify the content of the file.")
//    }
//
//    let comuni2 = try content2.components(separatedBy: "\r\n").compactMap { newEntry -> PlaceOfBirth? in
//      // For some reason, there is always an empty line at the end of the csv, when parsing its components.
//      // This makes sure if that is the case, to return a nil which is filtered through the `compactMap`.
//      if newEntry.isEmpty { return nil }
//
//      let parsedData = newEntry.components(separatedBy: ";")
//
//      guard parsedData.count == 2 else {
//        throw Spritz.ParsingError.corruptedData("Was expecting 2 fields, got \(parsedData.count) while parsing \(newEntry).")
//      }
//
//      guard parsedData[0].count == 4 else {
//        throw Spritz.ParsingError.corruptedData("Was expecting 4 digits for `CodiceStatistico`, but received \(parsedData[0]) instead.")
//      }
//
//      return PlaceOfBirth(code: parsedData[0], name: parsedData[1])
//    }
//
//    let megaComuni =
//      comuni.map{PlaceOfBirth(code: $0.code, name: $0.name, dioCan: $0.name.lowercased().strippedForCF()) } +
//      comuni2.map{PlaceOfBirth(code: $0.code, name: $0.name, dioCan: $0.name.lowercased().strippedForCF()) }
//
//    let cleaned = megaComuni.reduce([]) { result, pob -> [PlaceOfBirth] in
//      let filtered = result.filter { $0.code == pob.code && $0.dioCan == pob.dioCan }
//      if !filtered.isEmpty {
//        return result
//      }
//      var res = result
//      res.append(pob)
//      return res
//    }
//
//
//    var str = ""
//
//    cleaned.sorted{$0.code < $1.code}.forEach {
//      str += "\($0.code);\($0.name) \n"
//    }
//
//    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//
//        let fileURL = dir.appendingPathComponent("listaComuni.csv")
//
//        //writing
//        do {
//            try str.write(to: fileURL, atomically: true, encoding: .utf8)
//        }
//        catch let error {print(error)}
//    }
//  }
}
