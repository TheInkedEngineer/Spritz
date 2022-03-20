import Foundation
import XCTest

@testable import Spritz

final class SpritzTests: XCTestCase {
  func testPlacesOfBirthReturnTupleWithCorrectNumberOfElements() {
    XCTAssertEqual(try! Spritz.placesOfBirth.italian.count, 8229)
    XCTAssertEqual(try! Spritz.placesOfBirth.foreign.count, 248)
  }
  
  func test_generatingCF() {
    struct Person: SpritzInformationProvider {
      var firstName = "Ali"
      var lastName = "Iorio"
      var dateOfBirth = Spritz.Models.Date(day: 12, month: .december, year: 1980)!
      var sex = Spritz.Models.Sex.male
      var placeOfBirth = Spritz.Models.PlaceOfBirth.foreign(countryName: "germania")
    }
    
    XCTAssertEqual(try! Spritz.generateFiscalCode(from: Person()), "RIOLAI80T12Z112N")
  }
  
  func test_generatingCF_throws_when_invalidPlaceOfBirth() {
    struct Person: SpritzInformationProvider {
      var firstName = "Ali"
      var lastName = "Iorio"
      var dateOfBirth = Spritz.Models.Date(day: 12, month: .december, year: 1980)!
      var sex = Spritz.Models.Sex.male
      var placeOfBirth = Spritz.Models.PlaceOfBirth.foreign(countryName: "asdfgadsgadg")
    }
    
    XCTAssertThrowsError(try Spritz.generateFiscalCode(from: Person())) {
      XCTAssertEqual($0 as! Spritz.Error, .invalidData)
    }
  }
  
  func test_generatingCF_throws_when_invalidCharacter() {
    struct Person: SpritzInformationProvider {
      var firstName = "Ali"
      var lastName = "Iorio"
      var dateOfBirth = Spritz.Models.Date(day: 12, month: .december, year: 1980)!
      var sex = Spritz.Models.Sex.male
      var placeOfBirth = Spritz.Models.PlaceOfBirth.foreign(countryName: "asdfgadsgadg")
    }
    
    XCTAssertThrowsError(try Spritz.generateFiscalCode(from: Person())) {
      XCTAssertEqual($0 as! Spritz.Error, .invalidData)
    }
  }
  
  func test_validFiscalCodes() {
    XCTAssertTrue(Spritz.isValid("FYFQNG56A56L292G"))
    XCTAssertTrue(Spritz.isValid("BPCPHG61L19D964J"))
    XCTAssertTrue(Spritz.isValid("RRYNYX98M51B246E"))
    XCTAssertTrue(Spritz.isValid("VMTSRF99L64I745C"))
    XCTAssertTrue(Spritz.isValid("BTMLSZ40C46H152F"))
    XCTAssertTrue(Spritz.isValid("JTKDDV98T57G187N"))
    XCTAssertTrue(Spritz.isValid("RNLKCS49M41E309A"))
    XCTAssertTrue(Spritz.isValid("YKASKZ88S08G120R"))
  }
  
  func test_invalidFiscalCodes() {
    // Fake invalid omocodia
    XCTAssertFalse(Spritz.isValid("SFAFRS92C02ZN2ZW"))
    
    // Letter in name is number
    XCTAssertFalse(Spritz.isValid("1YFQNG56A56L292G"))
    
    // Invalid day
    XCTAssertFalse(Spritz.isValid("VMTSRF99L94I745C"))
    
    // Invalid foreign country
    XCTAssertFalse(Spritz.isValid("RNLKCS49M41Z999A"))
    
    // Invalid municipality
    XCTAssertFalse(Spritz.isValid("RNLKCS49M41E000S"))
    
    // Invalid Checksum.
    XCTAssertFalse(Spritz.isValid("RNLKCS49M41E999A"))
  }
  
  func test_isCorrect_fiscalCode_givenPerson_return_true() {
    struct Person: SpritzInformationProvider {
      var firstName = "Ali"
      var lastName = "Iorio"
      var dateOfBirth = Spritz.Models.Date(day: 12, month: .december, year: 1980)!
      var sex = Spritz.Models.Sex.male
      var placeOfBirth = Spritz.Models.PlaceOfBirth.foreign(countryName: "germania")
    }
    
    XCTAssertTrue(Spritz.isCorrect(fiscalCode: "RIOLAI80T12Z112N", for: Person()))
  }
  
  func test_isCorrect_fiscalCode_givenPerson_return_false_if_fiscalCodeInvalid() {
    struct Person: SpritzInformationProvider {
      var firstName = "Ali"
      var lastName = "Iorio"
      var dateOfBirth = Spritz.Models.Date(day: 12, month: .december, year: 1980)!
      var sex = Spritz.Models.Sex.male
      var placeOfBirth = Spritz.Models.PlaceOfBirth.foreign(countryName: "germania")
    }
    
    XCTAssertFalse(Spritz.isCorrect(fiscalCode: "asf", for: Person()))
  }
  
  func test_isCorrect_fiscalCode_givenPerson_return_false_if_personDataInvalid() {
    struct Person: SpritzInformationProvider {
      var firstName = "Ali"
      var lastName = "Iorio"
      var dateOfBirth = Spritz.Models.Date(day: 12, month: .december, year: 1980)!
      var sex = Spritz.Models.Sex.male
      var placeOfBirth = Spritz.Models.PlaceOfBirth.foreign(countryName: "adsgdswghs")
    }
    
    XCTAssertFalse(Spritz.isCorrect(fiscalCode: "RIOLAI80T12Z112N", for: Person()))
  }
  
  func test_extractingOriginalFiscalCode_from_Omocodia_returnsSame_when_alreadyOriginal() throws {
    let fiscalCode = "RIOLAI80T12Z112N"
    
    XCTAssertEqual(try Spritz.originalFiscalCode(from: fiscalCode), fiscalCode)
  }
    
  func test_extractingOriginalFiscalCode_from_Omocodia() throws {
    let filtered = try Spritz.originalFiscalCode(from: "MRCMLD92C42D96VG")
    XCTAssertEqual(filtered, "MRCMLD92C42D969R")
  }
  
  func test_extractingOriginalFiscalCode_throws_whenCorrupted() {
    XCTAssertThrowsError(try Spritz.originalFiscalCode(from: "safg")) {
      XCTAssertEqual($0 as! Spritz.Error, .invalidFiscalCode)
    }
    
    XCTAssertThrowsError(try Spritz.originalFiscalCode(from: "SFAFRSA2C02Z229X")) {
      XCTAssertEqual($0 as! Spritz.Error, .invalidFiscalCode)
    }
    
    XCTAssertThrowsError(try Spritz.originalFiscalCode(from: "SFAFRS92C02ZN2VJ")) {
      XCTAssertEqual($0 as! Spritz.Error, .invalidFiscalCode)
    }
    
    XCTAssertThrowsError(try Spritz.originalFiscalCode(from: "SFAFRS92C02ZN2ZW")) {
      XCTAssertEqual($0 as! Spritz.Error, .invalidFiscalCode)
    }
  }
}
