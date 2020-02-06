//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

internal extension String {
  mutating func stripForCF() {
    self = strippedForCF()
  }
  
  func strippedForCF() -> String {
    self.filter { $0.isLetter }.folding(options: .diacriticInsensitive, locale: .current)
  }
}
