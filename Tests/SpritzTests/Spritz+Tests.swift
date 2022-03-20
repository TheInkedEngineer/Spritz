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
      var firstName = "Firas"
      var lastName = "Safa"
      var dateOfBirth = Spritz.Models.Date(day: 2, month: .march, year: 1992)!
      var sex = Spritz.Models.Sex.male
      var placeOfBirth = Spritz.Models.PlaceOfBirth.foreign(countryName: "LIBano")
    }
    
    XCTAssertEqual(try! Spritz.generateCF(from: Person()), "SFAFRS92C02Z229F")
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
  
  func test_extractingOriginalFiscalCode_from_Omocodia_returnsSame_when_alreadyOriginal() throws {
    let fiscalCode = "SFAFRS92C02Z229F"
    
    XCTAssertEqual(try Spritz.originalFiscalCode(from: fiscalCode), fiscalCode)
  }
    
  func test_extractingOriginalFiscalCode_from_Omocodia() throws {
    let filtered = try Spritz.originalFiscalCode(from: "SFAFRS92C02Z22VU")
    XCTAssertEqual(filtered, "SFAFRS92C02Z229F")
    
    let filtered2 = try? Spritz.originalFiscalCode(from: "SFAFRS92C02Z2NVF")
    XCTAssertEqual(filtered2, "SFAFRS92C02Z229F")
  }
  
  func test_extractingOriginalFiscalCode_throws_whenCorrupted() {
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
