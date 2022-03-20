import Foundation

/// An encapsulator of methods responsible for normalizing data.
internal enum DataNormalizer {
  /// An alias for a tuple containing an array of consonants and an an array of vowels.
  typealias SegregatedLetters = (consonants: [Character], vowels: [Character])
  
  /// The  number to add to a girl's birth day to normalize it for the fiscal code.
  static let numberToAddToFemaleBirthDay = 40
  
  /// Normalizes the string based of the last name logic.
  ///
  /// The normalization of the last name consists of:
  ///
  /// - First 3 consonants, if available.
  ///   - Example: ROSI BIANCA -> RSB
  ///
  /// - If N consonants < 3, then first N consonants followed by vowels.
  ///   - Example: ROSI -> RSO
  ///
  /// - If string length < 3, the missing letters are replaced by X.
  ///   - Example: IT -> TIX
  static func normalize(lastName: String) -> String {
    let cleanString = lastName.strippedForCF().uppercased()
    let segregateLetters = segregateLetters(in: cleanString)
    
    return nameRepresentation(from: segregateLetters)
  }
  
  /// Normalizes the string based on the first name logic.
  ///
  /// The normalization of the name consists of:
  ///
  /// - If name has 4 or more consonants, the first, third and fourth consonants are taken.
  ///   - Example: GIANFRANCO -> GFR
  ///
  /// - If name has 3 consonants, they are taken in order..
  ///   - Example: MARIANA -> MRN
  ///
  /// - If N consonants < 3, then first N consonants followed by vowels in order.
  ///   - Example: ROSA -> RSO
  ///
  /// - If string length < 3, the missing letters are replaced by X.
  ///   - Example: IT -> TIX
  static func normalize(firstName: String) -> String {
    let cleanString = firstName.strippedForCF().uppercased()
    var segregateLetters = segregateLetters(in: cleanString)
    
    if segregateLetters.consonants.count > 3 {
      // We drop the second constant, and proceed with the shared logic.
      segregateLetters.consonants.remove(at: 1)
    }
    
    return nameRepresentation(from: segregateLetters)
  }
  
  /// Normalizes the values of the date based on the user sex.
  ///
  /// - Parameters:
  ///   - date: The date of birth.
  ///   - sex: The legal sex of the person.
  ///
  /// - Returns: 5 letters based of the date and sex of the person.
  static func normalize(date: Spritz.Models.Date, sex: Spritz.Models.Sex) -> String {
    "\(date.normalizedYear)\(date.month.letterRepresentation)\(date.normalizedDay(for: sex))"
  }
  
  /// Normalizes the birth place into its fiscal code representation.
  ///
  /// - Parameter placeOfBirth: The place of birth. An option from `Spritz.Models.PlaceOfBirth`.
  ///
  /// - Returns: The code associated with the place of birth.
  static func normalize(placeOfBirth: Spritz.Models.PlaceOfBirth) throws -> String {
    var place: PlaceOfBirthProvider?
    
    switch placeOfBirth {
      case let .italy(municipality):
        let normalizedMunicipality = municipality.strippedForCF().lowercased()
        
        place = try Spritz.italianPlacesOfBirth.first(where: {
          $0.name.strippedForCF().lowercased() == normalizedMunicipality
        })
        
      case let .foreign(countryName):
        let normalizedCountryName = countryName.strippedForCF().lowercased()
        
        place = try Spritz.foreignPlacesOfBirth.first(where: {
          // We use contains instead of equality, to allow a slight margin of diversity.
          // Example: Gaza instead of Striscia di Gaza
          $0.name.lowercased().contains(normalizedCountryName)
        })
    }
    
    guard let code = place?.code else {
      throw DataNormalizer.Error.invalidPlaceOfBirth(placeOfBirth.description)
    }
    
    return code
  }
  
  /// A value computed based on the first 15 letters of the fiscal code.
  ///
  /// **NOTE:** No control on the soundness of the passed value is done. The only condition is that the String is 15 letters long.
  ///
  /// **Algorithm :**
  /// The checksum value (also known as Control Internal Number) is evaluated based on the following algorithm:
  /// - Alphanumeric characters are separated based on the position between even and odd.
  /// - A numerical value is assigned to each character based on its position following values found in `Spritz.Models.Alphabet` and `Spritz.Models.SingleDigitNumber`.
  /// - All values are summed then divided by 26. The output is converted based on the `Spritz.Models.ControlCharacter` enum.
  ///
  /// - Parameter currentCF: A 15 character long string representing a fiscal code.
  ///
  /// - Returns: A 1 character string representing the control character.
  static func checksum(for fiscalCode: String) throws -> String {
    guard fiscalCode.count == 15 else {
      throw DataNormalizer.Error.invalidLength(expected: 15, actual: fiscalCode.count)
    }
    
    let stringAsArrayOfCharacters = fiscalCode.map {
      String($0)
    }
    
    // The stride iterates over odd numbers because the index is position - 1 in an array. So index 1 is second element, hence even.
    let evenLettersSum = try stride(
      from: stringAsArrayOfCharacters.startIndex + 1,
      to: stringAsArrayOfCharacters.endIndex,
      by: 2
    ).reduce(into: 0) {
      if
        let digit = Int(stringAsArrayOfCharacters[$1]),
        let number = Spritz.Models.SingleDigitNumber(rawValue: digit)
      {
        $0 += number.evenPositionValue
      } else if let letter = Spritz.Models.Alphabet(rawValue: stringAsArrayOfCharacters[$1].uppercased()) {
        $0 += letter.evenPositionValue
      } else {
        throw DataNormalizer.Error.invalidCharacter("\($1)")
      }
    }
    
    let oddLettersSum = try stride(
      from: stringAsArrayOfCharacters.startIndex,
      to: stringAsArrayOfCharacters.endIndex,
      by: 2
    ).reduce(into: 0) {
      if
        let digit = Int(stringAsArrayOfCharacters[$1]),
        let number = Spritz.Models.SingleDigitNumber(rawValue: digit)
      {
        $0 += number.oddPositionValue
      } else if let letter = Spritz.Models.Alphabet(rawValue: stringAsArrayOfCharacters[$1].uppercased()) {
        $0 += letter.oddPositionValue
      } else {
        throw DataNormalizer.Error.invalidCharacter("\($1)")
      }
    }
    
    return Spritz.Models.Alphabet(evenPosition: (evenLettersSum + oddLettersSum) % 26)!.rawValue
  }
}

// MARK: - Helpers

extension DataNormalizer {
  /// Separates the consonants and the vowels from the passed name parameter.
  ///
  /// - Parameter name: The name from which to extract the consonants and vowels.
  ///
  /// - Returns: A tuple containing the consonants and vowels in order as they appear in the string.
  static func segregateLetters(in name: String) -> (consonants: [Character], vowels: [Character]) {
    let characters = name.map {
      $0
    }
    
    let consonants = characters.filter {
      $0.isConsonant
    }
    
    let vowels = characters.filter {
      $0.isVowel
    }
    
    return (consonants: consonants, vowels: vowels)
  }
  
  /// Given SegregatedLetters, it returns a string of the first 3 letters, replacing missing ones with an X.
  /// - Parameter segregateLetters: A `SegregatedLetters` object.
  /// - Returns: A 3 letters long String.
  private static func nameRepresentation(from segregateLetters: SegregatedLetters) -> String {
    let orderedCharacters = (segregateLetters.consonants + segregateLetters.vowels).map {
      String($0)
    }
    
    return (0...2).reduce(into: "") {
      $0 += orderedCharacters[safe: $1] ?? "X"
    }
  }
}


// MARK: - Error

extension DataNormalizer {
  enum Error: Swift.Error, Equatable {
    /// The place of birth was invalid. Its associated code could not be found.
    case invalidPlaceOfBirth(_ requested: String)
    
    /// The length of the string was invalid. The expected and actual values are passed as associated values.
    case invalidLength(expected: Int, actual: Int)
    
    /// The character had an invalid format.
    case invalidCharacter(_ found: String)
  }
}
