//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

/// The sex of the person.
public enum Sex: String {
  /// A legally male person.
  case male
  /// A legally female person.
  case female
}

/// A protocol used by `Spritz` to generate and validate the `Codice Fiscale`.
public protocol SpritzInformationProvider {
  /// The first name of the person.
  var firstName: String { get set }
  /// The last name of the person.
  var lastName: String { get set }
  /// The last name of the person.
  var dateOfBirth: Date { get set }
  /// The sex of the user.
  var sex: Sex { get set }
  /// The italian province or country where the user was born.
  /// Should use full name. Do not use abreviation, or any sort of representation.
  /// Refer to `comuni.csv` or `stati.csv` for the proper names as per italian bureaucracy.
  var placeOfBirth: String { get set }
}

/// An `OptionSet` containing all possible fields needed to generate the `Codice Fiscale`
public struct CodiceFiscaleFields: OptionSet {
  public let rawValue: Int
  
  public init(rawValue: Int) { self.rawValue = rawValue }
  
  /// The first name of the person.
  public static let firstName = CodiceFiscaleFields(rawValue: 1 << 0)
  /// The last name of the person.
  public static let lastName = CodiceFiscaleFields(rawValue: 1 << 1)
  /// The last name of the person.
  public static let dateOfBirth = CodiceFiscaleFields(rawValue: 1 << 2)
  /// The sex of the user.
  public static let sex = CodiceFiscaleFields(rawValue: 1 << 3)
  /// The italian province or country where the user was born.
  /// Should use full name. Do not use abreviation, or any sort of representation.
  /// Refer to `comuni.csv` or `stati.csv` for the proper names as per italian bureaucracy.
  public static let placeOfBirth = CodiceFiscaleFields(rawValue: 1 << 4)
  /// A list containing all the possibile options.
  public static let all: CodiceFiscaleFields = [.firstName, .lastName, .dateOfBirth, .sex, .placeOfBirth]
}
