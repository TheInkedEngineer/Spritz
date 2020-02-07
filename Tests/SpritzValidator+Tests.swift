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
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "PALUMBO"), "PLM")
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "Covino"), "CVN")
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "D'ACUNTO"), "DCN")
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "De lUCa"), "DLC")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith2Consonants() {
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "SAFA"), "SFA")
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "SAFà"), "SFA")
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "Sàfa"), "SFA")
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "GORI"), "GRO")
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "LIETO"), "LTI")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith1Consonant() {
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "ALEUI"), "LAE")
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "Alea"), "LAE")
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "MAIO"), "MAI")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith0Consonant() {
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "AOeeeuiI"), "AOE")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith0ConsonantAndShort() {
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "AO"), "AOX")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith1ConsonantAndShort() {
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "IH"), "HIX")
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "RE"), "REX")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith2ConsonantAndShort() {
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "CL"), "CLX")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith1ConsonantAndSuperShort() {
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "C"), "CXX")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith0ConsonantAndSuperShort() {
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "A"), "AXX")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith4Consonants() {
    XCTAssertEqual(Spritz.significantFirstNameCharacters(from: "BARBARA"), "BBR")
    XCTAssertEqual(Spritz.significantFirstNameCharacters(from: "Mariangela"), "MNG")
    XCTAssertEqual(Spritz.significantFirstNameCharacters(from: "Aldo Maria"), "LMR")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith3Consonants() {
    XCTAssertEqual(Spritz.significantFirstNameCharacters(from: "Bruno"), "BRN")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith2Consonants() {
    XCTAssertEqual(Spritz.significantFirstNameCharacters(from: "Luca"), "LCU")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith1Consonants() {
    XCTAssertEqual(Spritz.significantFirstNameCharacters(from: "LIA"), "LIA")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith2ConsonantAndShort() {
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "CL"), "CLX")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith1ConsonantAndSuperShort() {
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "C"), "CXX")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith0ConsonantAndSuperShort() {
    XCTAssertEqual(Spritz.significantLastNameCharacters(from: "A"), "AXX")
  }
  
  func testSignificantBirthDateAndSexCharactersSuccessfull() {
    // timeInterval 699575077 = 2 marzo 1992
    let letters1 = Spritz.significantBirthDateAndSexCharacters(sex: .male, birthdate: Date(timeIntervalSince1970: 699575077))
    XCTAssertEqual(letters1, "92C02")
    
    // timeinterval 880151077 = 21 novembre 1997
    let letters2 = Spritz.significantBirthDateAndSexCharacters(sex: .female, birthdate: Date(timeIntervalSince1970: 880151077))
    XCTAssertEqual(letters2, "97K61")
  }
}
