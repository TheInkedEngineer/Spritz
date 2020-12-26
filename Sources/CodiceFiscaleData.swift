//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

/// A default object conforming to `SpritzInformationProvider`.
public struct CodiceFiscaleData: SpritzInformationProvider {
  /// The abbreviation of the first name of the person.
  /// There is no way to extract the full information from the CF itself.
  public let firstName: String
  /// The abbreviation of the last name of the person.
  /// There is no way to extract the full information from the CF itself.
  public let lastName: String
  /// The last name of the person.
  public let dateOfBirth: Date
  /// The sex of the user.
  public let sex: Sex
  /// The Italian province or country where the user was born.
  /// Should use full name. Do not use abbreviation, or any sort of representation.
  /// Refer to `comuni.csv` or `stati.csv` for the proper names as per Italian bureaucracy.
  public let placeOfBirth: String
}
