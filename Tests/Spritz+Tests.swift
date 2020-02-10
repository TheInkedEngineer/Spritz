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
    let result = try? Spritz.isValid("SFAFRS92C02Z229F", inlcude: [.firstName, .lastName]).get()
    XCTAssertNotNil(result)
    XCTAssertTrue(result!)
  }
  
  func testIsValidForDateOfBirthAndSex() {
    let result = try? Spritz.isValid("ZZZZZZ92C02Z229W", inlcude: [.dateOfBirth, .sex]).get()
    XCTAssertNotNil(result)
    XCTAssertTrue(result!)
  }
  
  func testIsValidForPlaceOFBirth() {
    let result = try? Spritz.isValid("SFAFRS92C02Z229F", inlcude: [.placeOfBirth]).get()
    XCTAssertNotNil(result)
    XCTAssertTrue(result!)
  }
  
  func testIsValidForACertonPerson() {
    struct Person: SpritzInformationProvider {
      var firstName = "First"
      var lastName = "Last"
      var dateOfBirth = Date(timeIntervalSince1970: 602562877)
      var sex = Sex.female
      var placeOfBirth = "Cagliari"
    }
    
    let person = Person()
    
    let result = try? Spritz.isValid("SFAFRS92C02Z229F", for: person).get()
    XCTAssertNotNil(result)
    XCTAssertTrue(result!)
  }
  
  func testFilterOmocodia() {
    let filtered = try? Spritz.filterOmocodia(in: "SFAFRS92C02Z22VF")
    XCTAssertEqual(filtered, "SFAFRS92C02Z229F")
    
    let filtered2 = try? Spritz.filterOmocodia(in: "SFAFRS92C02Z2NVF")
    XCTAssertEqual(filtered2, "SFAFRS92C02Z229F")
    
    do {
      _ = try Spritz.filterOmocodia(in: "SFAFRS92C02ZN2VF")
    } catch let error {
      guard case Spritz.ParsingError.corruptedData("Invalid CF.") = error else {
        XCTFail()
        return
      }
      XCTAssertTrue(true)
    }
  }
  
  func testShallowIsProperlyConfigured() {
    XCTAssertTrue(Spritz.isProperlyStructured("SFAFRS92C02Z229F"))
    XCTAssertTrue(Spritz.isProperlyStructured("SFAFRS92C02Z22VF"))
    XCTAssertFalse(Spritz.isProperlyStructured("SFAFRS92C02ZN2VF"))
    XCTAssertFalse(Spritz.isProperlyStructured("S2AFRS92C02Z22VF"))
  }
}
