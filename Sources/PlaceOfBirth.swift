//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

/// A `typealias` for a statistical code used to represent a country or an italian municipality.
public typealias CodiceStatistico = String

/// A single italian municipality. There are over 7000 of them all over italy.
/// Each one has a unique code, that code is used in the `Codice Fiscale`.
struct PlaceOfBirth: Hashable {
  /// The `CodiceStatistico` of the municipality.
  let code: CodiceStatistico
  /// The name of the municipality.
  let name: String
}
