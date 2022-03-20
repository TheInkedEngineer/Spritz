import XCTest

@testable import Spritz

final class DataNormalizerTests: XCTestCase {
  func test_normalizing_lastName() {
    XCTAssertEqual(DataNormalizer.normalize(lastName: "D'ACUNTO"), "DCN")
    XCTAssertEqual(DataNormalizer.normalize(lastName: "Sàfa"), "SFA")
    XCTAssertEqual(DataNormalizer.normalize(lastName: "AOeeeuiI"), "AOE")
    XCTAssertEqual(DataNormalizer.normalize(lastName: "ROSSI"), "RSS")
    XCTAssertEqual(DataNormalizer.normalize(lastName: "ROSI"), "RSO")
    XCTAssertEqual(DataNormalizer.normalize(lastName: "RUISI"), "RSU")
    XCTAssertEqual(DataNormalizer.normalize(lastName: "SFERA"), "SFR")
    XCTAssertEqual(DataNormalizer.normalize(lastName: "IT"), "TIX")
    XCTAssertEqual(DataNormalizer.normalize(lastName: ""), "XXX")
    XCTAssertEqual(DataNormalizer.normalize(lastName: "O"), "OXX")
  }
  
  func test_normalizing_firstName() {
    XCTAssertEqual(DataNormalizer.normalize(firstName: "Gianfranco"), "GFR")
    XCTAssertEqual(DataNormalizer.normalize(firstName: "BARBARA"), "BBR")
    XCTAssertEqual(DataNormalizer.normalize(firstName: "Aldo Maria"), "LMR")
    XCTAssertEqual(DataNormalizer.normalize(firstName: "MARCO"), "MRC")
    XCTAssertEqual(DataNormalizer.normalize(firstName: "MATI"), "MTA")
    XCTAssertEqual(DataNormalizer.normalize(firstName: "IT"), "TIX")
    XCTAssertEqual(DataNormalizer.normalize(firstName: ""), "XXX")
    XCTAssertEqual(DataNormalizer.normalize(firstName: "O"), "OXX")
  }
  
  func test_birthDateAndSexCharacters_successfullyNormalized() {
    let letters1 = DataNormalizer.normalize(date: Spritz.Models.Date(day: 2, month: .march, year: 1992)!, sex: .male)
    XCTAssertEqual(letters1, "92C02")
    
    let letters2 = DataNormalizer.normalize(date: Spritz.Models.Date(day: 21, month: .november, year: 1997)!, sex: .female)
    XCTAssertEqual(letters2, "97S61")
  }
  
  func test_placeOfBirth_when_foreign_correctlyExtracted() {
    XCTAssertEqual(try! DataNormalizer.normalize(placeOfBirth: .foreign(countryName: "libano")), "Z229")
  }
  
  func test_placeOfBirth_when_italian_correctlyExtracted() {
    XCTAssertEqual(try! DataNormalizer.normalize(placeOfBirth: .italy(municipality: "pavia")), "G388")
  }
  
  func test_placeOfBirth_thorws_when_invalidPlace_isPassed() {
    XCTAssertThrowsError(try DataNormalizer.normalize(placeOfBirth: .italy(municipality: "povia"))) {
      XCTAssertEqual($0 as! DataNormalizer.Error, .invalidPlaceOfBirth("Municipality: povia"))
    }
  }
  
  func test_checksum_throws_if_passedData_isNot_correctLength() {
    XCTAssertThrowsError(try DataNormalizer.checksum(for: "")) {
      XCTAssertEqual($0 as! DataNormalizer.Error, .invalidLength(expected: 15, actual: 0))
    }
  }
  
  func test_checksum_correctly_calculated() {
    XCTAssertEqual(try! DataNormalizer.checksum(for: "RSSBBR69C48F839"), "A")
    XCTAssertEqual(try! DataNormalizer.checksum(for: "RIOLAI80T12Z112"), "N")
    XCTAssertEqual(try! DataNormalizer.checksum(for: "MRCMLD92C42D969"), "R")
    XCTAssertEqual(try! DataNormalizer.checksum(for: "SFAFRS82C12Z22V"), "T")
    XCTAssertEqual(try! DataNormalizer.checksum(for: "MRCMLD82C42D96V"), "E")
    XCTAssertEqual(try! DataNormalizer.checksum(for: "SFAFRS82C02Z2NV"), "D")
  }
  
  // MARK: - Helpers
  
  func test_characters_correctly_segregated() {
    // GIVEN
    let string = "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"
    
    // WHEN
    let segregatedData = DataNormalizer.segregateLetters(in: string)
    
    // THEN
    XCTAssertEqual(segregatedData.consonants.count, 42)
    XCTAssertEqual(segregatedData.vowels.count, 10)
    XCTAssertEqual(segregatedData.vowels.first!, Character("a"))
    XCTAssertEqual(segregatedData.consonants.last!, Character("z"))
  }
  
  func test_characters_segregated_inOrder() {
    // GIVEN
    let string = "ThisContainsBoth"
    
    // WHEN
    let segregatedData = DataNormalizer.segregateLetters(in: string)
    let joined = (segregatedData.consonants + segregatedData.vowels).map {
      String($0)
    }.joined(separator: "")
    
    
    // THEN
    XCTAssertEqual(joined, "ThsCntnsBthioaio")
  }
}
