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
    let places = Spritz.italianPlaceOfBirth
    XCTAssertEqual(places.count, 8229)
  }
  
  func testParsingForeignPlaceOfBirth() {
    let places = Spritz.foreignPlaceOfBirth
    XCTAssertEqual(places.count, 248)
  }
}
