import XCTest

@testable import Spritz

final class CodiceFiscaleDataTest: XCTestCase {
  func test_model_correctlyInitialized() {
    let model = Spritz.Models.CodiceFiscaleData(
      firstName: "First",
      lastName: "last",
      dateOfBirth: Spritz.Models.Date(day: 2, month: .april, year: 1987)!,
      sex: .female,
      placeOfBirth: .foreign(countryName: "francia")
    )
    
    XCTAssertEqual(model.firstName, "First")
    XCTAssertEqual(model.lastName, "last")
    XCTAssertEqual(model.dateOfBirth.day, 2)
    XCTAssertEqual(model.dateOfBirth.month, .april)
    XCTAssertEqual(model.dateOfBirth.year, 1987)
    XCTAssertEqual(model.sex, .female)
    XCTAssertEqual(model.placeOfBirth, .foreign(countryName: "francia"))
  }
}
