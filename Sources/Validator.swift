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
  
  
  /// The vowels in the italian language.
  private static let italianVowels = "AEIOU"
  
  static func generateCF(from info: SpritzInfoProvider) -> String {
    ""
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
    case 3...:
      return longNameTransformer(name, numberOfConsonants: .three, consonants: consonants, vowels: vowels)
      
    case 2:
      return longNameTransformer(name, numberOfConsonants: .two, consonants: consonants, vowels: vowels)
      
    case 1:
      return longNameTransformer(name, numberOfConsonants: .one, consonants: consonants, vowels: vowels)
      
    case 0:
      return longNameTransformer(name, numberOfConsonants: .zero, consonants: consonants, vowels: vowels)
      
    default:
      fatalError("Unexpected Number Of Consonants")
    }
  }
  
  /**
   Il nome presenta almeno quattro consonanti: in tal caso si considerano, nell'ordine, la prima, la terza e la quarta consonante. Ad esempio BARBARA diviene BBR.
   Il nome presenta tre consonanti: in tal caso si considerano le tre consonanti ordinatamente. Ad esempio SERGIO diviene SRG.
   Il nome presenta due consonanti ed è composto da almeno tre lettere: in tal caso si considerano le due consonanti ordinatamente e poi la prima vocale.
   Il nome presenta una consonante ed è composto da almeno tre lettere: in tal caso si considera l'unica consonante seguita dalle prime due vocali.
   Il nome non contiene consonanti: in tal caso si considerano, nell'ordine, le prime tre vocali del nome e, qualora queste fossero meno di tre, si completa con tante X quante ne mancano (ovviamente, a meno di cognomi di una sola lettera - ipotesi abbastanza scartabile - di X ne occorrerà una sola).
   Il nome è composto da meno di tre lettere: in tal caso si considereranno, nell'ordine, le eventuali consonanti, le eventuali vocali e tante X quante ne occorrono per avere tre caratteri (ovviamente, a meno di nomi d'una sola lettera - ipotesi abbastanza scartabile - di X ne occorrerà una sola).
   */
  internal static func significantFirstNameCharacters(from name: String) -> String {
    let name = name.strippedForCF().uppercased()
    
    if let shortNameCharacters = shortNameTransformer(name) {
      return shortNameCharacters
    }
    
    let segregatedLetters = segregateLetters(in: name)
    let vowels = segregatedLetters.vowels
    let consonants = segregatedLetters.consonants
    
    switch consonants.count {
    case 4...:
      return longNameTransformer(name, numberOfConsonants: .fourPlus, consonants: consonants, vowels: vowels)
      
    case 3:
      return longNameTransformer(name, numberOfConsonants: .three, consonants: consonants, vowels: vowels)
      
    case 2:
      return longNameTransformer(name, numberOfConsonants: .two, consonants: consonants, vowels: vowels)
      
    case 1:
      return longNameTransformer(name, numberOfConsonants: .one, consonants: consonants, vowels: vowels)
      
    case 0:
      return longNameTransformer(name, numberOfConsonants: .zero, consonants: consonants, vowels: vowels)
      
    default:
      fatalError("Unexpected Number Of Consonants")
    }
  }
  
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
    case .fourPlus:
      return consonants[0] + consonants[2] + consonants[3]
      
    case .threePlus, .three:
      return consonants[0...2].reduce("") { $0 + $1 }
      
    case .two:
      return consonants[0] + consonants[1] + vowels[0]
      
    case .one:
      return consonants[0] + vowels[0] + vowels[1]
      
    case .zero:
      return vowels[0...2].reduce("") { $0 + $1 }
    }
  }
}
