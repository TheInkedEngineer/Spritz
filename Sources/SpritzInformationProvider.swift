//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

/// The sex of the person.
public enum Sex: String {
  case male
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
  /// Refer to `italianPlaceOfBirth.csv` for the proper names as per italian bureaucracy.
  var placeOfBirth: String { get set }
}
