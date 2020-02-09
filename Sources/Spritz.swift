//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

/// The main class of the pod. It can not be instantiated, nor it should be since all methods are static.
/// It provides a variable `placesOfBirth` which is a tuple containing all places of birth divided by the two keys: `italian` and `foreign`.
public class Spritz {
  // This class does not need to be instantiated.
  internal init() {}
  
  // MARK: - Public Properties
  
  /// A tuple with two keys `italian` and `foreign`, each containing an array with all the places in italy and countries respectively.
  public static var placesOfBirth: (italian: [String], foreign: [String]) {
    (italianPlacesOfBirth.map{$0.name}, foreignPlacesOfBirth.map{$0.name})
  }
  
  // MARK: - Public Methods
  
  public static func generateCF(from info: SpritzInformationProvider) throws -> String {
    let lastNameRepresentation = try Spritz.Transformer.lastName(from: info.lastName)
    let firstNameRepresentation = try Spritz.Transformer.firstName(from: info.lastName)
    let dateAndSexRepresentation = Spritz.Transformer.birthDateAndSex(sex: info.sex, birthdate: info.dateOfBirth)
    let placeOfBirthRepresentation = try Spritz.Transformer.placeOfBirth(info.placeOfBirth)
    let firstFifteenLetters = lastNameRepresentation + firstNameRepresentation + dateAndSexRepresentation + placeOfBirthRepresentation
    let controlCharacter = Spritz.Transformer.controlCharacter(for: firstFifteenLetters)
    
    return firstFifteenLetters + controlCharacter
  }
  
  public static func isValid(_ codiceFiscale: String, for info: SpritzInformationProvider) -> Bool {
    guard codiceFiscale.count == 16 else {
      return false
    }
    
    return true
  }
}

// MARK: - internal Properties

extension Spritz {
  /// The vowels in the italian language.
  internal static let italianVowels = "AEIOU"
  
  /// The `Spritz` bundle.
  internal static let bundle = Bundle(for: Spritz.self)
  
  /// The object containing all municipalities with their respective data.
  internal static var italianPlacesOfBirth: [PlaceOfBirth] {
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
  internal static var foreignPlacesOfBirth: [PlaceOfBirth] {
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
}
