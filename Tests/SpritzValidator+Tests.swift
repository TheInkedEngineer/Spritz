//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation
import XCTest

@testable import Spritz

class SpritzValidatorTests: XCTestCase {
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith3Consonants() {
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "PALUMBO"), "PLM")
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "Covino"), "CVN")
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "D'ACUNTO"), "DCN")
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "De lUCa"), "DLC")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith2Consonants() {
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "SAFA"), "SFA")
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "SAFà"), "SFA")
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "Sàfa"), "SFA")
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "GORI"), "GRO")
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "LIETO"), "LTI")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith1Consonant() {
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "ALEUI"), "LAE")
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "Alea"), "LAE")
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "MAIO"), "MAI")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith0Consonant() {
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "AOeeeuiI"), "AOE")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith0ConsonantAndShort() {
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "AO"), "AOX")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith1ConsonantAndShort() {
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "IH"), "HIX")
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "RE"), "REX")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith2ConsonantAndShort() {
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "CL"), "CLX")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith1ConsonantAndSuperShort() {
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "C"), "CXX")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith0ConsonantAndSuperShort() {
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "A"), "AXX")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith4Consonants() {
    XCTAssertEqual(try! Spritz.firstNameRepresentation(from: "BARBARA"), "BBR")
    XCTAssertEqual(try! Spritz.firstNameRepresentation(from: "Mariangela"), "MNG")
    XCTAssertEqual(try! Spritz.firstNameRepresentation(from: "Aldo Maria"), "LMR")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith3Consonants() {
    XCTAssertEqual(try! Spritz.firstNameRepresentation(from: "Bruno"), "BRN")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith2Consonants() {
    XCTAssertEqual(try! Spritz.firstNameRepresentation(from: "Luca"), "LCU")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith1Consonants() {
    XCTAssertEqual(try! Spritz.firstNameRepresentation(from: "LIA"), "LIA")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith2ConsonantAndShort() {
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "CL"), "CLX")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith1ConsonantAndSuperShort() {
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "C"), "CXX")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith0ConsonantAndSuperShort() {
    XCTAssertEqual(try! Spritz.lastNameRepresentation(from: "A"), "AXX")
  }
  
  func testSignificantBirthDateAndSexCharactersSuccessfull() {
    // timeInterval 699575077 = 2 marzo 1992
    let letters1 = Spritz.birthDateAndSexRepresentation(sex: .male, birthdate: Date(timeIntervalSince1970: 699575077))
    XCTAssertEqual(letters1, "92C02")
    
    // timeinterval 880151077 = 21 novembre 1997
    let letters2 = Spritz.birthDateAndSexRepresentation(sex: .female, birthdate: Date(timeIntervalSince1970: 880151077))
    XCTAssertEqual(letters2, "97K61")
  }
  
  func testControlLetterGenerator() {
    XCTAssertEqual(Spritz.controlCharacter(for: "RSSBBR69C48F839"), "A")
    
    XCTAssertEqual(Spritz.controlCharacter(for: "SFAFRS92C02Z229"), "F")
  }
}
