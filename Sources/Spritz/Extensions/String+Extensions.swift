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
    self.filter {
      $0.isLetter
    }
    .folding(options: .diacriticInsensitive, locale: nil)
  }
}

internal extension Spritz.CodiceFiscale {
  func strippedChecksum() -> Spritz.CodiceFiscale {
    assert(count == 16)
    
    var mutable = self
    mutable.removeLast()
    
    return mutable
  }
}
