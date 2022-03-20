import Foundation

extension Character {
  /// Checks if the character is a vowel.
  var isVowel: Bool {
    "AEIOUaeiou".contains (self)
  }
  
  /// Checks if the character is a consonant.
  var isConsonant: Bool {
    !isVowel
  }
}
