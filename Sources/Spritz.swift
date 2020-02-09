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
  public static func isValid(_ codiceFiscale: String, inlcude fields: CodiceFiscaleFields = .all) -> Result<Bool, Spritz.ParsingError> {
    let array = codiceFiscale.uppercased().map { String($0) }
    guard array.count == 16 else { return .failure(.corruptedData("CF should be 16 character long")) }
    
    if fields.contains(.lastName) {
      let lastNameAreLetters = array[0...2].filter { Character($0).isLetter }.count == 3
      guard lastNameAreLetters else { return .failure(.corruptedData("First three elements should be letters.")) }
    }
    
    if fields.contains(.firstName) {
      let firstNameAreLetters = array[3...5].filter { Character($0).isLetter }.count == 3
      guard firstNameAreLetters else { return .failure(.corruptedData("Element 4, 5 and 6 should be letters.")) }
    }
    
    if fields.contains([.dateOfBirth, .sex]) {
      let yearOfBirthIsInt = Int(array[6]) != nil && Int(array[7]) != nil
      guard yearOfBirthIsInt else { return .failure(.corruptedData("Element 5 and 6 represent a year and should be numbers.")) }
      
      
      let monthOfBirth = Spritz.Transformer.MonthRepresentation(stringValue: array[8])
      guard let month = monthOfBirth else { return .failure(.corruptedData("The month letter should be between A and L included."))}
      
      guard
        let day = Int(array[9...10].reduce(""){ $0 + $1 }),
        day > 0 && day < 72,
        (day <= month.maxDaysPerMonth || (day > 40 && day <= month.maxDaysPerMonth + 30))
        else {
          return .failure(
            .corruptedData(
              """
              Based on the sex and month, the day is not valid. Should be between 0 and \(month.maxDaysPerMonth)" if male,
              or between 41 and \(month.maxDaysPerMonth + 30) if female.
              """
            ))
      }
    }
    
    if fields.contains(.placeOfBirth) {
      let placeOfBirth = array[11] != "Z" ?
        Spritz.italianPlacesOfBirth.first { $0.code == array[11...14].reduce("") { $0 + $1 }} :
        Spritz.foreignPlacesOfBirth.first { $0.code == array[11...14].reduce("") { $0 + $1 }}
      guard placeOfBirth != nil else { return .failure(.corruptedData("The 4 digits representing place of birth are not valid.")) }
    }
    
    let firstFifteenLetters = array[0...14].reduce("") { $0 + $1 }
    guard Spritz.Transformer.controlCharacter(for: firstFifteenLetters) == array[15] else {
      return .failure(.corruptedData("\(Spritz.Transformer.controlCharacter(for: firstFifteenLetters)) but got \(array[15]) instead."))
    }
    
    return .success(true)
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

// MARK: - Helpers

internal extension Spritz {
  /// Omocodia is when two or more people has the same first and last name, born on the same day, of the same year from the same sex in the same municipality.
  /// In such dase, starting from the most right number, one digit is changed from a number to a letter based on a special table.
  /// The control letter however remains the same. Therefore we can strip the CF from the conversions and treat it like a normal CF.
  static func filterOmocodia(in codiceFiscale: String) throws -> String {
    var array = codiceFiscale.uppercased().map { String($0) }
    let possibleConvertedDigits = [array[-2], array[-3], array[-4], array[-6], array[-7], array[-9], array[-10]]
    var digitNotFound = false
    
    try possibleConvertedDigits.forEach { element in
      guard (digitNotFound || Int(element) == nil) else {
        throw Spritz.ParsingError.corruptedData("Invalid CF.")
      }
      
      if Character(element).isLetter {
        guard let digit = Spritz.Transformer.SingleDigitNumber(omocodiaValue: element)?.rawValue else {
          throw Spritz.ParsingError.corruptedData(
            "Invalid value for letter \(array[-2]). It is not equivalent to any digit. Make sure to insert a valid CF.")
        }
        guard let indexOfElement = array.lastIndex(of: element) else {
          fatalError("Something went extremely wrong.")
        }
        array[indexOfElement] = String(digit)
      } else {
        digitNotFound = true
      }
    }
    
    
    if Character(array[-2]).isLetter {
      guard let digit = Spritz.Transformer.SingleDigitNumber(omocodiaValue: array[-2])?.rawValue else {
        throw Spritz.ParsingError.corruptedData(
          "Invalid value for letter \(array[-2]). It is not equivalent to any digit. Make sure to insert a valid CF.")
      }
      array[-2] = String(digit)
    }
    
    if Character(array[-3]).isLetter {
      guard let digit = Spritz.Transformer.SingleDigitNumber(omocodiaValue: array[-3])?.rawValue else {
        throw Spritz.ParsingError.corruptedData(
          "Invalid value for letter \(array[-3]). It is not equivalent to any digit. Make sure to insert a valid CF.")
      }
      array[-3] = String(digit)
    }
    
    if Character(array[-4]).isLetter {
      guard let digit = Spritz.Transformer.SingleDigitNumber(omocodiaValue: array[-4])?.rawValue else {
        throw Spritz.ParsingError.corruptedData(
          "Invalid value for letter \(array[-4]). It is not equivalent to any digit. Make sure to insert a valid CF.")
      }
      array[-4] = String(digit)
    }
    
    if Character(array[-6]).isLetter {
      guard let digit = Spritz.Transformer.SingleDigitNumber(omocodiaValue: array[-6])?.rawValue else {
        throw Spritz.ParsingError.corruptedData(
          "Invalid value for letter \(array[-6]). It is not equivalent to any digit. Make sure to insert a valid CF.")
      }
      array[-6] = String(digit)
    }
    
    if Character(array[-7]).isLetter {
      guard let digit = Spritz.Transformer.SingleDigitNumber(omocodiaValue: array[-7])?.rawValue else {
        throw Spritz.ParsingError.corruptedData(
          "Invalid value for letter \(array[-7]). It is not equivalent to any digit. Make sure to insert a valid CF.")
      }
      array[-7] = String(digit)
    }
    
    if Character(array[-9]).isLetter {
      guard let digit = Spritz.Transformer.SingleDigitNumber(omocodiaValue: array[-9])?.rawValue else {
        throw Spritz.ParsingError.corruptedData(
          "Invalid value for letter \(array[-9]). It is not equivalent to any digit. Make sure to insert a valid CF.")
      }
      array[-9] = String(digit)
    }
    
    if Character(array[-10]).isLetter {
      guard let digit = Spritz.Transformer.SingleDigitNumber(omocodiaValue: array[-10])?.rawValue else { throw
        Spritz.ParsingError.corruptedData(
          "Invalid value for letter \(array[-10]). It is not equivalent to any digit. Make sure to insert a valid CF.")
      }
      array[-10] = String(digit)
    }
    
    return array.reduce(""){ $0 + $1 }
  }
}
