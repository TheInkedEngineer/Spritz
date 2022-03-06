//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

internal extension String {
  /// Mutates the string from all whitespaces, special characters and accents.
  mutating func stripForCF() {
    self = strippedForCF()
  }
  
  /// Returns a copy of the string which is stripped from all whitespaces, special characters and accents.
  func strippedForCF() -> String {
    self.filter { $0.isLetter }.folding(options: .diacriticInsensitive, locale: .current)
  }
}
