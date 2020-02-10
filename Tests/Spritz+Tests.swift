//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation
import XCTest

@testable import Spritz

class SpritzTests: XCTestCase {
  
  func testPlacesOfBirthReturnTupleWithCorrectNumberOfElements() {
    XCTAssertEqual(Spritz.placesOfBirth.italian.count, 8229)
    XCTAssertEqual(Spritz.placesOfBirth.foreign.count, 248)
  }
  
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
  
  func testIsValidForAllFields() {
    let result = try? Spritz.isValid("SFAFRS92C02Z229F").get()
    XCTAssertNotNil(result)
    XCTAssertTrue(result!)
  }
  
  func testIsValidForFirstAndLastName() {
    let result = try? Spritz.isValid("SFAFRSZZZZZZZZZE", inlcude: [.firstName, .lastName]).get()
    XCTAssertNotNil(result)
    XCTAssertTrue(result!)
  }
  
  func testIsValidForDateOfBirthAndSex() {
    let result = try? Spritz.isValid("ZZZZZZ92C02ZZZZN", inlcude: [.dateOfBirth, .sex]).get()
    XCTAssertNotNil(result)
    XCTAssertTrue(result!)
  }
  
  func testIsValidForPlaceOFBirth() {
    let result = try? Spritz.isValid("ZZZZZZZZZZZZ229E", inlcude: [.firstName, .lastName]).get()
    XCTAssertNotNil(result)
    XCTAssertTrue(result!)
  }
  
  func testIsValidForACertonPerson() {
    struct Person: SpritzInformationProvider {
      var firstName = "Firas"
      var lastName = "Safa"
      var dateOfBirth = Date(timeIntervalSince1970: 699562877)
      var sex = Sex.male
      var placeOfBirth = "Libano"
    }
    
    let person = Person()
    
    let result = try? Spritz.isValid("SFAFRS92C02Z229F", for: person).get()
    XCTAssertNotNil(result)
    XCTAssertTrue(result!)
  }
}
