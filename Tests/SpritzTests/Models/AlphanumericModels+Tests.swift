import XCTest

@testable import Spritz

final class AlphanumericModelsTests: XCTestCase {
  
  // MARK: - Alphabet
  
  func test_alphabet_evenValue_isCorrect() {
    XCTAssertEqual(Spritz.Models.Alphabet.A.evenPositionValue, 0)
    XCTAssertEqual(Spritz.Models.Alphabet.B.evenPositionValue, 1)
    XCTAssertEqual(Spritz.Models.Alphabet.C.evenPositionValue, 2)
    XCTAssertEqual(Spritz.Models.Alphabet.D.evenPositionValue, 3)
    XCTAssertEqual(Spritz.Models.Alphabet.E.evenPositionValue, 4)
    XCTAssertEqual(Spritz.Models.Alphabet.F.evenPositionValue, 5)
    XCTAssertEqual(Spritz.Models.Alphabet.G.evenPositionValue, 6)
    XCTAssertEqual(Spritz.Models.Alphabet.H.evenPositionValue, 7)
    XCTAssertEqual(Spritz.Models.Alphabet.I.evenPositionValue, 8)
    XCTAssertEqual(Spritz.Models.Alphabet.J.evenPositionValue, 9)
    XCTAssertEqual(Spritz.Models.Alphabet.K.evenPositionValue, 10)
    XCTAssertEqual(Spritz.Models.Alphabet.L.evenPositionValue, 11)
    XCTAssertEqual(Spritz.Models.Alphabet.M.evenPositionValue, 12)
    XCTAssertEqual(Spritz.Models.Alphabet.N.evenPositionValue, 13)
    XCTAssertEqual(Spritz.Models.Alphabet.O.evenPositionValue, 14)
    XCTAssertEqual(Spritz.Models.Alphabet.P.evenPositionValue, 15)
    XCTAssertEqual(Spritz.Models.Alphabet.Q.evenPositionValue, 16)
    XCTAssertEqual(Spritz.Models.Alphabet.R.evenPositionValue, 17)
    XCTAssertEqual(Spritz.Models.Alphabet.S.evenPositionValue, 18)
    XCTAssertEqual(Spritz.Models.Alphabet.T.evenPositionValue, 19)
    XCTAssertEqual(Spritz.Models.Alphabet.U.evenPositionValue, 20)
    XCTAssertEqual(Spritz.Models.Alphabet.V.evenPositionValue, 21)
    XCTAssertEqual(Spritz.Models.Alphabet.W.evenPositionValue, 22)
    XCTAssertEqual(Spritz.Models.Alphabet.X.evenPositionValue, 23)
    XCTAssertEqual(Spritz.Models.Alphabet.Y.evenPositionValue, 24)
    XCTAssertEqual(Spritz.Models.Alphabet.Z.evenPositionValue, 25)
  }
  
  func test_alphabet_oddValue_isCorrect() {
    XCTAssertEqual(Spritz.Models.Alphabet.A.oddPositionValue, 1)
    XCTAssertEqual(Spritz.Models.Alphabet.B.oddPositionValue, 0)
    XCTAssertEqual(Spritz.Models.Alphabet.C.oddPositionValue, 5)
    XCTAssertEqual(Spritz.Models.Alphabet.D.oddPositionValue, 7)
    XCTAssertEqual(Spritz.Models.Alphabet.E.oddPositionValue, 9)
    XCTAssertEqual(Spritz.Models.Alphabet.F.oddPositionValue, 13)
    XCTAssertEqual(Spritz.Models.Alphabet.G.oddPositionValue, 15)
    XCTAssertEqual(Spritz.Models.Alphabet.H.oddPositionValue, 17)
    XCTAssertEqual(Spritz.Models.Alphabet.I.oddPositionValue, 19)
    XCTAssertEqual(Spritz.Models.Alphabet.J.oddPositionValue, 21)
    XCTAssertEqual(Spritz.Models.Alphabet.K.oddPositionValue, 2)
    XCTAssertEqual(Spritz.Models.Alphabet.L.oddPositionValue, 4)
    XCTAssertEqual(Spritz.Models.Alphabet.M.oddPositionValue, 18)
    XCTAssertEqual(Spritz.Models.Alphabet.N.oddPositionValue, 20)
    XCTAssertEqual(Spritz.Models.Alphabet.O.oddPositionValue, 11)
    XCTAssertEqual(Spritz.Models.Alphabet.P.oddPositionValue, 3)
    XCTAssertEqual(Spritz.Models.Alphabet.Q.oddPositionValue, 6)
    XCTAssertEqual(Spritz.Models.Alphabet.R.oddPositionValue, 8)
    XCTAssertEqual(Spritz.Models.Alphabet.S.oddPositionValue, 12)
    XCTAssertEqual(Spritz.Models.Alphabet.T.oddPositionValue, 14)
    XCTAssertEqual(Spritz.Models.Alphabet.U.oddPositionValue, 16)
    XCTAssertEqual(Spritz.Models.Alphabet.V.oddPositionValue, 10)
    XCTAssertEqual(Spritz.Models.Alphabet.W.oddPositionValue, 22)
    XCTAssertEqual(Spritz.Models.Alphabet.X.oddPositionValue, 25)
    XCTAssertEqual(Spritz.Models.Alphabet.Y.oddPositionValue, 24)
    XCTAssertEqual(Spritz.Models.Alphabet.Z.oddPositionValue, 23)
  }
  
  func test_initializer_correctlyCreatesNewValue_fromPosition() {
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 0), .A)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 1), .B)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 2), .C)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 3), .D)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 4), .E)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 5), .F)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 6), .G)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 7), .H)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 8), .I)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 9), .J)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 10), .K)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 12), .M)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 13), .N)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 14), .O)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 15), .P)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 16), .Q)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 17), .R)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 18), .S)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 19), .T)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 20), .U)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 21), .V)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 22), .W)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 23), .X)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 24), .Y)
    XCTAssertEqual(Spritz.Models.Alphabet(evenPosition: 25), .Z)
  }
  
  func test_init_fails_when_evenPosition_greaterThan_25_or_lessThan_0() {
    XCTAssertNil(Spritz.Models.Alphabet(evenPosition: Int.random(in: 26 ... 1_000_000_000)))
    XCTAssertNil(Spritz.Models.Alphabet(evenPosition: -Int.random(in: 0 ... 1_000_000_000)))
  }
  
  // MARK: - Single Digits
  
  func test_digit_evenValue_isCorrect() {
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.zero.evenPositionValue, 0)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.one.evenPositionValue, 1)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.two.evenPositionValue, 2)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.three.evenPositionValue, 3)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.four.evenPositionValue, 4)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.five.evenPositionValue, 5)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.six.evenPositionValue, 6)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.seven.evenPositionValue, 7)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.eight.evenPositionValue, 8)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.nine.evenPositionValue, 9)
  }
  
  func test_digit_oddValue_isCorrect() {
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.zero.oddPositionValue, 1)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.one.oddPositionValue, 0)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.two.oddPositionValue, 5)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.three.oddPositionValue, 7)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.four.oddPositionValue, 9)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.five.oddPositionValue, 13)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.six.oddPositionValue, 15)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.seven.oddPositionValue, 17)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.eight.oddPositionValue, 19)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.nine.oddPositionValue, 21)
  }
  
  func test_digit_omocodiaValue_isCorrect() {
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.zero.omocodiaValue, "L")
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.one.omocodiaValue, "M")
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.two.omocodiaValue, "N")
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.three.omocodiaValue, "P")
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.four.omocodiaValue, "Q")
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.five.omocodiaValue, "R")
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.six.omocodiaValue, "S")
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.seven.omocodiaValue, "T")
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.eight.omocodiaValue, "U")
    XCTAssertEqual(Spritz.Models.SingleDigitNumber.nine.omocodiaValue, "V")
  }
  
  func test_digit_initializedFrom_omocodiaCorrespondence() {
    XCTAssertEqual(Spritz.Models.SingleDigitNumber(omocodiaValue: "L"), .zero)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber(omocodiaValue: "M"), .one)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber(omocodiaValue: "N"), .two)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber(omocodiaValue: "P"), .three)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber(omocodiaValue: "Q"), .four)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber(omocodiaValue: "R"), .five)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber(omocodiaValue: "S"), .six)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber(omocodiaValue: "T"), .seven)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber(omocodiaValue: "U"), .eight)
    XCTAssertEqual(Spritz.Models.SingleDigitNumber(omocodiaValue: "V"), .nine)
  }
  
  func test_digit_initializerFails_when_OmocodiaValueInvalid() {
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "A"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "B"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "C"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "D"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "E"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "F"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "G"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "H"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "I"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "J"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "K"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "O"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "W"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "X"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "Y"))
    XCTAssertNil(Spritz.Models.SingleDigitNumber(omocodiaValue: "Z"))
    
  }
}
