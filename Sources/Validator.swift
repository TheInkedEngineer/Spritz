//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

public struct Spritz {
  
  private enum ConsonantsInName {
    case fourPlus
    case threePlus
    case three
    case two
    case one
    case zero
  }
  
  private enum Month: Int {
    case A = 1, B, C, D, E, F, G, H, I, J, K, L
    
    var stringRepresentation: String {
      String(describing: self.self)
    }
  }
  
  /// The vowels in the italian language.
  private static let italianVowels = "AEIOU"
  
  static func generateCF(from info: SpritzInfoProvider) -> String {
    let lastNameRepresentation = significantLastNameCharacters(from: info.lastName)
    let firstNameRepresentation = significantLastNameCharacters(from: info.lastName)
    
    return lastNameRepresentation + firstNameRepresentation
  }
  
  static func isValid(_ codiceFiscale: String, for info: SpritzInfoProvider) -> Bool {
    true
  }
}

extension Spritz {
  internal static func significantLastNameCharacters(from name: String) -> String {
    let name = name.strippedForCF().uppercased()
    
    if let shortNameCharacters = shortNameTransformer(name) {
      return shortNameCharacters
    }
    
    let segregatedLetters = segregateLetters(in: name)
    let vowels = segregatedLetters.vowels
    let consonants = segregatedLetters.consonants
    
    switch consonants.count {
    case 3...: return longNameTransformer(name, numberOfConsonants: .three, consonants: consonants, vowels: vowels)
    case 2   : return longNameTransformer(name, numberOfConsonants: .two  , consonants: consonants, vowels: vowels)
    case 1   : return longNameTransformer(name, numberOfConsonants: .one  , consonants: consonants, vowels: vowels)
    case 0   : return longNameTransformer(name, numberOfConsonants: .zero , consonants: consonants, vowels: vowels)
    default  : fatalError("Unexpected Number Of Consonants")
    }
  }
  
  internal static func significantFirstNameCharacters(from name: String) -> String {
    let name = name.strippedForCF().uppercased()
    
    if let shortNameCharacters = shortNameTransformer(name) { return shortNameCharacters }
    
    let segregatedLetters = segregateLetters(in: name)
    let vowels = segregatedLetters.vowels
    let consonants = segregatedLetters.consonants
    
    switch consonants.count {
    case 4...: return longNameTransformer(name, numberOfConsonants: .fourPlus, consonants: consonants, vowels: vowels)
    case 3   : return longNameTransformer(name, numberOfConsonants: .three   , consonants: consonants, vowels: vowels)
    case 2   : return longNameTransformer(name, numberOfConsonants: .two     , consonants: consonants, vowels: vowels)
    case 1   : return longNameTransformer(name, numberOfConsonants: .one     , consonants: consonants, vowels: vowels)
    case 0   : return longNameTransformer(name, numberOfConsonants: .zero    , consonants: consonants, vowels: vowels)
    default: fatalError("Unexpected Number Of Consonants")
    }
  }
  
  internal static func significantBirthDateAndSexCharacters(sex: Sex, birthdate: Date) -> String {
    let monthAndDayComponents = Calendar(identifier: .gregorian).dateComponents([.day, .month, .year], from: birthdate)
    
    guard
      let dayAsInt = monthAndDayComponents.day,
      let monthAsInt = monthAndDayComponents.month,
      let yearAsInt = monthAndDayComponents.year,
      let month = Spritz.Month(rawValue: monthAsInt)
      
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
}

// MARK: - Private Helpers

extension Spritz {
  private static func segregateLetters(in name: String) -> (consonants: [String], vowels: [String]) {
    (
      consonants: name.filter { !Spritz.italianVowels.contains($0) }.map{ String($0) },
      vowels: name.filter { Spritz.italianVowels.contains($0) }.map{ String($0) }
    )
  }
  
  private static func shortNameTransformer(_ name: String) -> String? {
    let segregatedLetters = segregateLetters(in: name)
    let vowelsInName = segregatedLetters.vowels
    let consonantsInName = segregatedLetters.consonants
    
    guard !name.isEmpty else { fatalError("Name cannot be empty") }
    
    if name.count == 1 { return name + "XX" }
    
    if name.count == 2 {
      if consonantsInName.count == 2 { return consonantsInName[0] + consonantsInName[1] + "X" }
      if vowelsInName.count == 2 { return vowelsInName[0] + vowelsInName[1] + "X" }
      return consonantsInName[0] + vowelsInName[0] + "X"
    }
    
    return nil
  }
  
  private static func longNameTransformer(_ name: String, numberOfConsonants: ConsonantsInName, consonants: [String], vowels: [String]) -> String {
    switch numberOfConsonants {
    case .fourPlus         : return consonants[0] + consonants[2] + consonants[3]
    case .threePlus, .three: return consonants[0...2].reduce("") { $0 + $1 }
    case .two              : return consonants[0] + consonants[1] + vowels[0]
    case .one              : return consonants[0] + vowels[0] + vowels[1]
    case .zero             : return vowels[0...2].reduce("") { $0 + $1 }
    }
  }
}
