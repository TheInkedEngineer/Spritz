//
//  File.swift
//  
//
//  Created by Firas Safa on 10/03/22.
//

import XCTest
@testable import Spritz

class CollectionExtensionsTests: XCTestCase {
  func testIsNotEmptyReturnsTrue() {
    let array = [1]
    XCTAssertTrue(array.isNotEmpty)
  }

  func testIsNotEmptyReturnsFalse() {
    let array: [Int] = []
    XCTAssertFalse(array.isNotEmpty)
  }

  func testSafePositiveSubscriptSuccessful() {
    let dict = ["one", "two"]
    let element0 = dict[safe: 0]
    let element1 = dict[safe: 1]

    XCTAssertEqual(element0, "one")
    XCTAssertEqual(element1, "two")
  }

  func testSafePositiveSubscriptReturnsNil() {
    let dict = ["one": 1, "two": 2]
    let element = dict[safe: 3]

    XCTAssertNil(element)
  }

  func testSafeNegativeSubscriptReturnsNil() {
    let dict = ["one": 1, "two": 2]
    let element = dict[safe: -1]

    XCTAssertNil(element)
  }
}
