//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

/// A `typealias` for a statistical code used to represent a country or an Italian municipality.
public typealias CodiceStatistico = String

/// A single Italian municipality. There are over 7000 of them all over Italy.
/// Each one has a unique code, that code is used in the `Codice Fiscale`.
struct PlaceOfBirth: Hashable {
  /// The `CodiceStatistico` of the municipality.
  let code: CodiceStatistico
  /// The name of the municipality.
  let name: String
}
