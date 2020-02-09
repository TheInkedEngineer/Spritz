//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation
import XCTest

@testable import Spritz

class SpritzParserTests: XCTestCase {
  func testParsingItalianPlaceOfBirth() {
    let places = Spritz.italianPlacesOfBirth
    XCTAssertEqual(places.count, 8229)
  }
  
  func testParsingForeignPlaceOfBirth() {
    let places = Spritz.foreignPlacesOfBirth
    XCTAssertEqual(places.count, 248)
  }
}
