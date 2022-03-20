//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

extension Spritz.Models {
  /// Possible places of birth.
  public enum PlaceOfBirth: CustomStringConvertible, Equatable {
    public var description: String {
      switch self {
        case let .italy(municipality):
          return "Municipality: \(municipality)"
          
        case let .foreign(countryName):
          return "Country: \(countryName)"
      }
    }
    
    /// The user was born in Italy. The municipality is provided as value **in italian**.
    /// Refer to `comuni.csv` for a full list of names.
    case italy(municipality: String)
    
    /// The user was born outside of Italy. The name of the country is provided as value **in italian**.
    /// Refer to `stati.csv` for a full list of names.
    case foreign(countryName: String)
  }
  
  /// A place of birth outside of `Italy`.
  internal struct Country: PlaceOfBirthProvider {
    /// A unique identifier for the country or municipality.
    let code: String
    
    /// The name of the municipality.
    let name: String
  }
  
  /// A place of birth inside of `Italy`.
  internal struct Municipality: PlaceOfBirthProvider {
    /// A unique identifier for the country or municipality.
    let code: String
    
    /// The name of the municipality.
    let name: String
  }
}
