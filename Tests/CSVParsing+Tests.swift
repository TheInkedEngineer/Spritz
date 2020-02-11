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
    XCTAssertEqual(places[5210], PlaceOfBirth(code: "G566", name: "SAN BENEDETTO VAL DI SAMBRO"))
  }
  
  func testParsingForeignPlaceOfBirth() {
    let places = Spritz.foreignPlacesOfBirth
    XCTAssertEqual(places.count, 248)
    XCTAssertEqual(places[75], PlaceOfBirth(code: "Z229", name: "LIBANO"))
  }
}
