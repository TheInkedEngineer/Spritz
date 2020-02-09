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
  
  /// Generates the `Codice Fiscale` from the given information.
  public static func generateCF(from info: SpritzInformationProvider) throws -> String {
    let lastNameRepresentation = try Spritz.Transformer.lastName(from: info.lastName)
    let firstNameRepresentation = try Spritz.Transformer.firstName(from: info.firstName)
    let dateAndSexRepresentation = try Spritz.Transformer.birthDateAndSex(sex: info.sex, birthdate: info.dateOfBirth)
    let placeOfBirthRepresentation = try Spritz.Transformer.placeOfBirth(info.placeOfBirth)
    let firstFifteenLetters = lastNameRepresentation + firstNameRepresentation + dateAndSexRepresentation + placeOfBirthRepresentation
    let controlCharacter = Spritz.Transformer.controlCharacter(for: firstFifteenLetters)
    
    return firstFifteenLetters + controlCharacter
  }
  
  
  /// Validates a `Codice Fiscale` checking only for the passed fields.
  /// - Parameters:
  ///   - codiceFiscale: The `Codice Fiscale` to control.
  ///   - fields: The `CodiceFiscaleFields` to check. Defaults to `.all`. If `.dateOfBirth` or `.sex` are excluded, both are not checked for they are related.
  public static func isValid(_ codiceFiscale: String, inlcude fields: CodiceFiscaleFields = .all) -> Bool {
    let array = codiceFiscale.uppercased().map{String($0)}
    guard array.count == 16 else { return false }
    
    if fields.contains(.lastName) {
      let lastNameAreLetters = array[0...2].filter { Character($0).isLetter }.count == 3
      guard lastNameAreLetters else { return false }
    }
    
    if fields.contains(.firstName) {
      let firstNameAreLetters = array[3...5].filter { Character($0).isLetter }.count == 3
      guard firstNameAreLetters else { return false }
    }
    
    if fields.contains([.dateOfBirth, .sex]) {
      let yearOfBirthIsInt = array[6...7].filter { Int($0) != nil }.count == 2
      guard yearOfBirthIsInt else { return false }
      
      
      let monthOfBirth = Spritz.Transformer.MonthRepresentation(stringValue: array[8])
      guard let month = monthOfBirth else { return false}
      
      guard
        let day = Int(array[9...10].reduce(""){ $0 + $1 }),
        day > 0 && day < 72,
        (day <= month.maxDaysPerMonth || (day > 40 && day <= month.maxDaysPerMonth + 30))
        else {
          return false
      }
    }
    
    if fields.contains(.placeOfBirth) {
      let placeOfBirth = array[11] != "Z" ?
        Spritz.italianPlacesOfBirth.first { $0.code == array[11...14].reduce("") { $0 + $1 }} :
        Spritz.foreignPlacesOfBirth.first { $0.code == array[11...14].reduce("") { $0 + $1 }}
      guard placeOfBirth != nil else { return false }
    }
    
    guard Spritz.Transformer.controlCharacter(for: array[0...14].reduce("") { $0 + $1 }) == array[15] else { return false }
    
    return true
  }
  
  /// Returns a `Result<Bool, Spritz.ParsingError>` based on a passed `Codice Fiscale` and information.
  public static func isValid(_ codiceFiscale: String, for info: SpritzInformationProvider) -> Result<Bool, Spritz.ParsingError> {
    guard codiceFiscale.count == 16 else { return .failure(.corruptedData("CF should be 16 character long")) }
    
    do {
      let generatedCF = try Spritz.generateCF(from: info)
      guard generatedCF == codiceFiscale.uppercased() else { return .failure(.corruptedData("The CF is valid, but does not belong to this user.")) }
      return .success(true)
    } catch let error {
      guard let error = error as? Spritz.ParsingError else {
        fatalError("Unexpected error.")
      }
      switch error {
      case .fileNotFound: fatalError("could not locate the countries file.")
      case .corruptedData(let message): return .failure(.corruptedData(message))
      }
    }
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
