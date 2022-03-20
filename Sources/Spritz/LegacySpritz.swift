////
////  Spritz
////
////  Copyright © TheInkedEngineer. All rights reserved.
//// 
//
//import Foundation
//
///// The main class of the pod. It can not be instantiated, nor it should be since all methods are static.
///// It provides a variable `placesOfBirth` which is a tuple containing all places of birth divided by the two keys: `Italian` and `foreign`.
//public class LegacySpritz {
//  // This class does not need to be instantiated.
//  internal init() {}
//  
//  // MARK: - Public Properties
//  
//  
//  
//  // MARK: - Public Methods
//  
//  
//  
//  /// Returns a `Result<Bool, Spritz.ParsingError>` based on the validation of the `Codice Fiscale` checking only for the passed fields.
//  /// - Parameters:
//  ///   - codiceFiscale: The `Codice Fiscale` to control.
//  ///   - fields: The `CodiceFiscaleFields` to check. Defaults to `.all`. If `.dateOfBirth` or `.sex` are excluded, both are not checked for they are related.
//  public static func isValid(_ codiceFiscale: String) throws -> Result<Bool, Spritz.Error> {
//    let filteredFromOmocodia = try Spritz.originalFiscalCode(from: codiceFiscale)
//    let array = filteredFromOmocodia.uppercased().map { String($0) }
//    guard array.count == 16 else { return .failure(.parsingError("CF should be 16 character long")) }
//    
//    
//    let lastNameAreLetters = array[0...2].filter { Character($0).isLetter }.count == 3
//    guard lastNameAreLetters else { return .failure(.parsingError("First three elements should be letters.")) }
//    
//    
//    
//    let firstNameAreLetters = array[3...5].filter { Character($0).isLetter }.count == 3
//    guard firstNameAreLetters else { return .failure(.parsingError("Element 4, 5 and 6 should be letters.")) }
//    
//    
//    
//    let yearOfBirthIsInt = Int(array[6]) != nil && Int(array[7]) != nil
//    guard yearOfBirthIsInt else { return .failure(.parsingError("Element 5 and 6 represent a year and should be numbers.")) }
//    
//    
//    let monthOfBirth = Spritz.Models.Date.Month(letterRepresentation: Character(array[8]))
//    guard let month = monthOfBirth else { return .failure(.parsingError("The month letter should be between A and L included."))}
//    
//    guard
//      let day = Int(array[9...10].reduce("") { $0 + $1 }),
//      day > 0 && day < 72,
//      (day <= month.maxDaysPerMonth || (day > 40 && day <= month.maxDaysPerMonth + 30))
//    else {
//      return .failure(
//        .parsingError(
//              """
//              Based on the sex and month, the day is not valid. Should be between 0 and \(month.maxDaysPerMonth)" if male,
//              or between 41 and \(month.maxDaysPerMonth + 30) if female.
//              """
//        ))
//      
//    }
//    
//    let placeOfBirth = array[11] != "Z" ?
//    try! Spritz.italianPlacesOfBirth.first { $0.code == array[11...14].reduce("") { $0 + $1 }} as? PlaceOfBirthProvider :
//    try! Spritz.foreignPlacesOfBirth.first { $0.code == array[11...14].reduce("") { $0 + $1 }} as? PlaceOfBirthProvider
//    guard placeOfBirth != nil else { return .failure(.parsingError("The 4 digits representing place of birth are not valid.")) }
//    
//    
//    let firstFifteenLetters = array[0...14].reduce("") { $0 + $1 }
//    guard try DataNormalizer.checksum(for: firstFifteenLetters) == array[15] else {
//      return .failure(.parsingError("\(try DataNormalizer.checksum(for: firstFifteenLetters)) but got \(array[15]) instead."))
//    }
//    
//    return .success(true)
//  }
//  
//  /// Returns a `Result<Bool, Spritz.ParsingError>` based on a passed `Codice Fiscale` and information.
//  /// - Parameters:
//  ///   - codiceFiscale: The `codice fiscale` to evaluate.
//  ///   - info: An object adhering to `SpritzInformationProvider` protocol.
//  public static func isValid(_ codiceFiscale: String, for info: SpritzInformationProvider) -> Result<Bool, Spritz.Error> {
//    guard codiceFiscale.count == 16 else { return .failure(.parsingError("CF should be 16 character long")) }
//    
//    do {
//      let filteredFromOmocodia = try Spritz.originalFiscalCode(from: codiceFiscale)
//      let generatedCF = try Spritz.generateCF(from: info)
//      guard generatedCF == filteredFromOmocodia.uppercased() else {
//        return .failure(.parsingError("The CF is valid, but does not belong to this user."))
//      }
//      return .success(true)
//    } catch let error {
//      guard let error = error as? Parser.Error else {
//        fatalError("Unexpected error.")
//      }
//      switch error {
//        case .fileNotFound: return .failure(.parsingError("File not found"))
//        case .corruptedData(let message): return .failure(.parsingError(message))
//      }
//    }
//  }
//  
//  /// Returns a `Bool` based on the validation of the `Codice Fiscale` checking only for the passed fields.
//  /// - Parameters:
//  ///   - codiceFiscale: The `Codice Fiscale` to control.
//  ///   - fields: The `CodiceFiscaleFields` to check. Defaults to `.all`. If `.dateOfBirth` or `.sex` are excluded, both are not checked for they are related.
//  public static func isValid(_ codiceFiscale: String) -> Bool {
//    (try? LegacySpritz.isValid(codiceFiscale).get()) != nil
//  }
//  
//  /// Returns a `Bool` based on a passed `Codice Fiscale` and information.
//  /// - Parameters:
//  ///   - codiceFiscale: The `codice fiscale` to evaluate.
//  ///   - info: An object adhering to `SpritzInformationProvider` protocol.
//  public static func isValid(_ codiceFiscale: String, for info: SpritzInformationProvider) -> Bool {
//    (try? LegacySpritz.isValid(codiceFiscale, for: info).get()) != nil
//  }
//  
//  /// Checks if the passed `Codice Fiscale` is properly structured regardless of info.
//  /// This is a very high level check and should not be used unless necessary for lack of data.
//  public static func isProperlyStructured(_ codiceFiscale: String) -> Bool {
//    let pattern = "^[a-zA-Z]{6}[0-9]{2}[abcdehlmprstABCDEHLMPRST]{1}[0-9]{2}([a-zA-Z]{1}[0-9]{3})[a-zA-Z]{1}$"
//    let codiceFiscale = (try? Spritz.originalFiscalCode(from: codiceFiscale)) ?? ""
//    let range = NSRange(location: 0, length: codiceFiscale.utf16.count)
//    let regex = try? NSRegularExpression(pattern: pattern)
//    return regex?.firstMatch(in: codiceFiscale, options: [], range: range) != nil
//  }
//}
