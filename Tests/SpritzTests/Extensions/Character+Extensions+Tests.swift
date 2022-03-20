import XCTest

@testable import Spritz

final class CharacterExtensionsTest: XCTestCase {
  func test_isVowel_returns_true_when_character_isAVowel() {
    XCTAssertTrue(Character("a").isVowel)
    XCTAssertTrue(Character("e").isVowel)
    XCTAssertTrue(Character("i").isVowel)
    XCTAssertTrue(Character("o").isVowel)
    XCTAssertTrue(Character("u").isVowel)
  }
  
  func test_isVowel_returns_false_when_character_isAVowel() {
    XCTAssertFalse(Character("b").isVowel)
    XCTAssertFalse(Character("c").isVowel)
    XCTAssertFalse(Character("d").isVowel)
    XCTAssertFalse(Character("f").isVowel)
    XCTAssertFalse(Character("g").isVowel)
    XCTAssertFalse(Character("h").isVowel)
    XCTAssertFalse(Character("j").isVowel)
    XCTAssertFalse(Character("k").isVowel)
    XCTAssertFalse(Character("l").isVowel)
    XCTAssertFalse(Character("m").isVowel)
    XCTAssertFalse(Character("n").isVowel)
    XCTAssertFalse(Character("p").isVowel)
    XCTAssertFalse(Character("q").isVowel)
    XCTAssertFalse(Character("r").isVowel)
    XCTAssertFalse(Character("s").isVowel)
    XCTAssertFalse(Character("t").isVowel)
    XCTAssertFalse(Character("v").isVowel)
    XCTAssertFalse(Character("w").isVowel)
    XCTAssertFalse(Character("x").isVowel)
    XCTAssertFalse(Character("y").isVowel)
    XCTAssertFalse(Character("z").isVowel)
  }
  
  func test_isConsonant_returns_false_when_character_isAVowel() {
    XCTAssertFalse(Character("a").isConsonant)
    XCTAssertFalse(Character("e").isConsonant)
    XCTAssertFalse(Character("i").isConsonant)
    XCTAssertFalse(Character("o").isConsonant)
    XCTAssertFalse(Character("u").isConsonant)
  }
  
  func test_isConsonant_returns_true_when_character_isAVowel() {
    XCTAssertTrue(Character("b").isConsonant)
    XCTAssertTrue(Character("c").isConsonant)
    XCTAssertTrue(Character("d").isConsonant)
    XCTAssertTrue(Character("f").isConsonant)
    XCTAssertTrue(Character("g").isConsonant)
    XCTAssertTrue(Character("h").isConsonant)
    XCTAssertTrue(Character("j").isConsonant)
    XCTAssertTrue(Character("k").isConsonant)
    XCTAssertTrue(Character("l").isConsonant)
    XCTAssertTrue(Character("m").isConsonant)
    XCTAssertTrue(Character("n").isConsonant)
    XCTAssertTrue(Character("p").isConsonant)
    XCTAssertTrue(Character("q").isConsonant)
    XCTAssertTrue(Character("r").isConsonant)
    XCTAssertTrue(Character("s").isConsonant)
    XCTAssertTrue(Character("t").isConsonant)
    XCTAssertTrue(Character("v").isConsonant)
    XCTAssertTrue(Character("w").isConsonant)
    XCTAssertTrue(Character("x").isConsonant)
    XCTAssertTrue(Character("y").isConsonant)
    XCTAssertTrue(Character("z").isConsonant)
  }
}


