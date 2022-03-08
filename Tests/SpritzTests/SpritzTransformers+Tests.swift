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
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "PALUMBO"), "PLM")
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "Covino"), "CVN")
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "D'ACUNTO"), "DCN")
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "De lUCa"), "DLC")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith2Consonants() {
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "SAFA"), "SFA")
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "SAFà"), "SFA")
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "Sàfa"), "SFA")
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "GORI"), "GRO")
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "LIETO"), "LTI")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith1Consonant() {
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "ALEUI"), "LAE")
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "Alea"), "LAE")
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "MAIO"), "MAI")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith0Consonant() {
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "AOeeeuiI"), "AOE")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith0ConsonantAndShort() {
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "AO"), "AOX")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith1ConsonantAndShort() {
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "IH"), "HIX")
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "RE"), "REX")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith2ConsonantAndShort() {
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "CL"), "CLX")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith1ConsonantAndSuperShort() {
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "C"), "CXX")
  }
  
  func testSignificantCharafterFromLastNameSuccessfulFromLongNameWith0ConsonantAndSuperShort() {
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "A"), "AXX")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith4Consonants() {
    XCTAssertEqual(try! Spritz.Transformer.firstName(from: "BARBARA"), "BBR")
    XCTAssertEqual(try! Spritz.Transformer.firstName(from: "Mariangela"), "MNG")
    XCTAssertEqual(try! Spritz.Transformer.firstName(from: "Aldo Maria"), "LMR")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith3Consonants() {
    XCTAssertEqual(try! Spritz.Transformer.firstName(from: "Bruno"), "BRN")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith2Consonants() {
    XCTAssertEqual(try! Spritz.Transformer.firstName(from: "Luca"), "LCU")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith1Consonants() {
    XCTAssertEqual(try! Spritz.Transformer.firstName(from: "LIA"), "LIA")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith2ConsonantAndShort() {
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "CL"), "CLX")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith1ConsonantAndSuperShort() {
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "C"), "CXX")
  }
  
  func testSignificantCharafterFromFirstNameSuccessfulFromLongNameWith0ConsonantAndSuperShort() {
    XCTAssertEqual(try! Spritz.Transformer.lastName(from: "A"), "AXX")
  }
  
  func testSignificantBirthDateAndSexCharactersSuccessfull() {
    // timeInterval 699575077 = 2 marzo 1992
    let letters1 = try! Spritz.Transformer.birthDateAndSex(sex: .male, birthdate: Date(timeIntervalSince1970: 699575077))
    XCTAssertEqual(letters1, "92C02")
    
    // timeinterval 880151077 = 21 novembre 1997
    let letters2 = try! Spritz.Transformer.birthDateAndSex(sex: .female, birthdate: Date(timeIntervalSince1970: 880151077))
    XCTAssertEqual(letters2, "97S61")
  }
  
  func testFetchingPlaceOfBirthCodeCorrectlyForeign() {
    XCTAssertEqual(try! Spritz.Transformer.placeOfBirth("libano"), "Z229")
  }
  
  func testControlLetterGenerator() {
    XCTAssertEqual(Spritz.Transformer.controlCharacter(for: "RSSBBR69C48F839"), "A")
    XCTAssertEqual(Spritz.Transformer.controlCharacter(for: "SFAFRS92C02Z229"), "F")
    XCTAssertEqual(Spritz.Transformer.controlCharacter(for: "SFAFRS92C02Z22V"), "U")
  }
}
