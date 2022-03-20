import Foundation
import XCTest

@testable import Spritz

final class ParserTests: XCTestCase {
  func testParsingItalianPlaceOfBirth() {
    let places = try! Spritz.italianPlacesOfBirth
    let expected = Spritz.Models.Municipality(code: "G566", name: "SAN BENEDETTO VAL DI SAMBRO")
    XCTAssertEqual(places.count, 8229)
    XCTAssertEqual(places[5210].name, expected.name)
    XCTAssertEqual(places[5210].code, expected.code)
  }
  
  func testParsingForeignPlaceOfBirth() {
    let places = try! Spritz.foreignPlacesOfBirth
    let expected = Spritz.Models.Country(code: "Z229", name: "LIBANO")
    XCTAssertEqual(places.count, 248)
    XCTAssertEqual(places[75].name, expected.name)
    XCTAssertEqual(places[75].code, expected.code)
  }
  
  func test_parserThrows_when_code_isMoreThan_fourLetters() {
    let string =
    """
    AAAAA;ComuneA
    """
    
    XCTAssertThrowsError(try Parser.parse(string, ofType: Spritz.Models.Municipality.self)) {
      XCTAssertEqual($0 as! Parser.Error, .corruptedData(.invalidCodeLength(expected: 4, actual: 5, value: "AAAAA")))
    }
  }
  
  func test_parserThrows_when_line_hasMoreThan_twoFields() {
    let string =
    """
    AAAA;ComuneA;
    """
    
    XCTAssertThrowsError(try Parser.parse(string, ofType: Spritz.Models.Municipality.self)) {
      XCTAssertEqual($0 as! Parser.Error, .corruptedData(.invalidNumberOfFields(expected: 2, actual: 3, lineContent: "AAAA;ComuneA;")))
    }
  }
  
  func test_parser_returns_emptyArray_when_type_unexpected() {
    let string =
    """
    AAAA;ComuneA
    """
    
    struct Random: PlaceOfBirthProvider {
      let code: String
      
      let name: String
    }
    
    XCTAssertTrue(try! Parser.parse(string, ofType: Random.self).isEmpty)
  }
}
