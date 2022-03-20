import XCTest

@testable import Spritz

final class PlaceOfBirthEnumTests: XCTestCase {
  func test_description() {
    let country = Spritz.Models.PlaceOfBirth.foreign(countryName: "Libano")
    let municipality = Spritz.Models.PlaceOfBirth.italy(municipality: "Pavia")
    
    XCTAssertEqual(country.description, "Country: Libano")
    XCTAssertEqual(municipality.description, "Municipality: Pavia")
  }
}
