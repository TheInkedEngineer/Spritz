//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation
import XCTest

@testable import Spritz

class StringExtensionsTests: XCTestCase {
  
  func testNameCleanup1() {
    var name = "de luca"
    name.stripForCF()
    XCTAssertEqual(name, "deluca")
  }
  
  func testNameCleanup2() {
    var name = "d'asti"
    name.stripForCF()
    XCTAssertEqual(name, "dasti")
  }
  
  func testNameCleanup3() {
    var name = "salvà"
    name.stripForCF()
    XCTAssertEqual(name, "salva")
  }
  
  func testNameCleanup4() {
    let name = "salvà"
    let strippedName = name.strippedForCF()
    XCTAssertEqual(name, "salvà")
    XCTAssertEqual(strippedName, "salva")
  }
}
