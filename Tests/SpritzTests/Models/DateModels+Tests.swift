import XCTest

@testable import Spritz

final class DateModelTests: XCTestCase {
  func test_init_fails_when_dataInvalid() {
    XCTAssertNil(Spritz.Models.Date(day: -1, month: .november, year: 2000))
    XCTAssertNil(Spritz.Models.Date(day: 1, month: .november, year: -2000))
    XCTAssertNil(Spritz.Models.Date(day: 37, month: .november, year: 2000))
    XCTAssertNil(Spritz.Models.Date(day: 30, month: .february, year: 2000))
    XCTAssertNil(Spritz.Models.Date(day: 29, month: .february, year: 2022))
  }
  
  func test_init_succeeds_when_dataValid() {
    XCTAssertNotNil(
      Spritz.Models.Date(
        day: Int.random(in: 1...28),
        month: Spritz.Models.Date.Month.allCases.randomElement()!,
        year: Int.random(in: 1...3000)
      )
    )
  }
  
  func test_year_normalizedValue() {
    let date = Spritz.Models.Date(day: 29, month: .january, year: 2022)
    
    XCTAssertEqual(date?.normalizedYear, "22")
  }
  
  func test_day_normalizedValue() {
    let randomDay = Int.random(in: 1...28)
    
    let date = Spritz.Models.Date(
      day: randomDay,
      month: Spritz.Models.Date.Month.allCases.randomElement()!,
      year: Int.random(in: 1...3000)
    )
    
    XCTAssertEqual(Int(date!.normalizedDay(for: .male)), randomDay)
    XCTAssertEqual(Int(date!.normalizedDay(for: .female)), randomDay + DataNormalizer.numberToAddToFemaleBirthDay)
  }
  
  func test_leapYear_return_true() {
    XCTAssertTrue(Spritz.Models.Date.isLeapYear(16))
    XCTAssertTrue(Spritz.Models.Date.isLeapYear(1600))
  }
  
  func test_leapYear_return_false() {
    XCTAssertFalse(Spritz.Models.Date.isLeapYear(2022))
  }
  
  func test_monthLetterRepresentation_isCorrect() {
    XCTAssertEqual(Spritz.Models.Date.Month.january.letterRepresentation, "A")
    XCTAssertEqual(Spritz.Models.Date.Month.february.letterRepresentation, "B")
    XCTAssertEqual(Spritz.Models.Date.Month.march.letterRepresentation, "C")
    XCTAssertEqual(Spritz.Models.Date.Month.april.letterRepresentation, "D")
    XCTAssertEqual(Spritz.Models.Date.Month.may.letterRepresentation, "E")
    XCTAssertEqual(Spritz.Models.Date.Month.june.letterRepresentation, "H")
    XCTAssertEqual(Spritz.Models.Date.Month.july.letterRepresentation, "L")
    XCTAssertEqual(Spritz.Models.Date.Month.august.letterRepresentation, "M")
    XCTAssertEqual(Spritz.Models.Date.Month.september.letterRepresentation, "P")
    XCTAssertEqual(Spritz.Models.Date.Month.october.letterRepresentation, "R")
    XCTAssertEqual(Spritz.Models.Date.Month.november.letterRepresentation, "S")
    XCTAssertEqual(Spritz.Models.Date.Month.december.letterRepresentation, "T")
  }
  
  func test_init_succeeds_from_letterRepresentation() {
    XCTAssertEqual(Spritz.Models.Date.Month(letterRepresentation: "A"), .january)
    XCTAssertEqual(Spritz.Models.Date.Month(letterRepresentation: "B"), .february)
    XCTAssertEqual(Spritz.Models.Date.Month(letterRepresentation: "C"), .march)
    XCTAssertEqual(Spritz.Models.Date.Month(letterRepresentation: "D"), .april)
    XCTAssertEqual(Spritz.Models.Date.Month(letterRepresentation: "E"), .may)
    XCTAssertEqual(Spritz.Models.Date.Month(letterRepresentation: "H"), .june)
    XCTAssertEqual(Spritz.Models.Date.Month(letterRepresentation: "L"), .july)
    XCTAssertEqual(Spritz.Models.Date.Month(letterRepresentation: "M"), .august)
    XCTAssertEqual(Spritz.Models.Date.Month(letterRepresentation: "P"), .september)
    XCTAssertEqual(Spritz.Models.Date.Month(letterRepresentation: "R"), .october)
    XCTAssertEqual(Spritz.Models.Date.Month(letterRepresentation: "S"), .november)
    XCTAssertEqual(Spritz.Models.Date.Month(letterRepresentation: "T"), .december)
  }
  
  func test_init_fails_from_wrong_letterRepresentation() {
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "F"))
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "G"))
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "I"))
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "J"))
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "K"))
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "N"))
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "O"))
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "Q"))
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "U"))
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "V"))
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "W"))
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "X"))
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "Y"))
    XCTAssertNil(Spritz.Models.Date.Month(letterRepresentation: "Z"))
  }
  
  func test_month_maxNumberOfDays_isCorrect() {
    XCTAssertEqual(Spritz.Models.Date.Month.january.maxDaysPerMonth, 31)
    XCTAssertEqual(Spritz.Models.Date.Month.february.maxDaysPerMonth, 29)
    XCTAssertEqual(Spritz.Models.Date.Month.march.maxDaysPerMonth, 31)
    XCTAssertEqual(Spritz.Models.Date.Month.april.maxDaysPerMonth, 30)
    XCTAssertEqual(Spritz.Models.Date.Month.may.maxDaysPerMonth, 31)
    XCTAssertEqual(Spritz.Models.Date.Month.june.maxDaysPerMonth, 30)
    XCTAssertEqual(Spritz.Models.Date.Month.july.maxDaysPerMonth, 31)
    XCTAssertEqual(Spritz.Models.Date.Month.august.maxDaysPerMonth, 31)
    XCTAssertEqual(Spritz.Models.Date.Month.september.maxDaysPerMonth, 30)
    XCTAssertEqual(Spritz.Models.Date.Month.october.maxDaysPerMonth, 31)
    XCTAssertEqual(Spritz.Models.Date.Month.november.maxDaysPerMonth, 30)
    XCTAssertEqual(Spritz.Models.Date.Month.december.maxDaysPerMonth, 31)
  }
  
  func test_isValid_normalizedDay() {
    XCTAssertTrue(Spritz.Models.Date.isValid(day: 1, in: .january))
    XCTAssertTrue(Spritz.Models.Date.isValid(day: 31, in: .january))
    XCTAssertTrue(Spritz.Models.Date.isValid(day: 29, in: .february))
    XCTAssertTrue(Spritz.Models.Date.isValid(day: 41, in: .january))
    XCTAssertTrue(Spritz.Models.Date.isValid(day: 71, in: .january))
    XCTAssertTrue(Spritz.Models.Date.isValid(day: 69, in: .february))
    
    XCTAssertFalse(Spritz.Models.Date.isValid(day: 32, in: .january))
    XCTAssertFalse(Spritz.Models.Date.isValid(day: -1, in: .january))
    XCTAssertFalse(Spritz.Models.Date.isValid(day: 30, in: .february))
    XCTAssertFalse(Spritz.Models.Date.isValid(day: 72, in: .january))
    XCTAssertFalse(Spritz.Models.Date.isValid(day: 70, in: .february))
  }
}
