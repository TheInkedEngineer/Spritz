//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation
import XCTest

@testable import Spritz

class SpritzCodiceFiscaleGeneratorTest: XCTestCase {
  func testGeneratingCF() {
    struct Person: SpritzInformationProvider {
      var firstName = "Firas"
      var lastName = "Safa"
      var dateOfBirth = Date(timeIntervalSince1970: 699562877)
      var sex = Sex.male
      var placeOfBirth = "Libano"
    }
    
    XCTAssertEqual(try! Spritz.generateCF(from: Person()), "SFAFRS92C02Z229F")
  }
}

