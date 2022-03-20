//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

/// A protocol used by `Spritz` to generate and validate the `Codice Fiscale`.
public protocol SpritzInformationProvider {
  /// The first name of the person.
  var firstName: String { get }
  
  /// The last name of the person.
  var lastName: String { get }
  
  /// The last name of the person.
  var dateOfBirth: Spritz.Models.Date { get }
  
  /// The sex of the user.
  var sex: Spritz.Models.Sex { get }
  
  /// The Italian province or country where the user was born.
  /// Should use full name. Do not use abbreviation, or any sort of representation.
  /// Refer to `comuni.csv` or `stati.csv` for the proper names as per Italian bureaucracy.
  var placeOfBirth: Spritz.Models.PlaceOfBirth { get }
}
