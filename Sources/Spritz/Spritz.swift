import Foundation

public enum Spritz {
  /// A name-compatible typealias for a String representing a fiscal code.
  public typealias CodiceFiscale = String
  
  /// A tuple with two keys `Italian` and `foreign`, each containing an array with all the places in Italy and countries respectively.
  internal static var placesOfBirth: (italian: [String], foreign: [String]) {
    get throws {
      try (Spritz.italianPlacesOfBirth.map{$0.name}, Spritz.foreignPlacesOfBirth.map{$0.name})
    }
  }
  
  /// The object containing all municipalities with their respective data.
  internal static var italianPlacesOfBirth: [Spritz.Models.Municipality] {
    get throws {
      try Parser.parse(.comuni)
    }
  }
  
  /// The object containing all countries with their respective data.
  internal static var foreignPlacesOfBirth: [Spritz.Models.Country] {
    get throws {
      try Parser.parse(.stati)
    }
  }
  
  // MARK: - Functions
  
  /// Generates the `Codice Fiscale` from the given information.
  ///
  /// - Parameter info: An object adhering to `SpritzInformationProvider` protocol providing the necessary data.
  /// - Returns: A 16 letter long string representing the fiscal code based on the provided data.
  /// - Throws: `Spritz.Error.invalidData` if the data is not valid. That can occur if an unsupported character was passed, or the place of birth was invalid.
  public static func generateCF(from info: SpritzInformationProvider) throws -> CodiceFiscale {
    let placeOfBirthRepresentation: String!
    
    let lastNameRepresentation = DataNormalizer.normalize(lastName: info.lastName)
    let firstNameRepresentation = DataNormalizer.normalize(firstName: info.firstName)
    let dateAndSexRepresentation = DataNormalizer.normalize(date: info.dateOfBirth, sex: info.sex)
    
    do {
      placeOfBirthRepresentation = try DataNormalizer.normalize(placeOfBirth: info.placeOfBirth)
    } catch {
      
      throw Spritz.Error.invalidData
    }
    
    let checksumLessValue = lastNameRepresentation + firstNameRepresentation + dateAndSexRepresentation + placeOfBirthRepresentation
    // It is ok to force unwrap.
    // The motives why checksum fails, cannot occur here.
    // The names are cleaned, and given that we are computing the `checksumLessValue` we are sure it is 15 letters long.
    let checksum = try! DataNormalizer.checksum(for: checksumLessValue)
    
    return checksumLessValue + checksum
  }
  
  /// Checks whether or not a fiscal code is valid.
  ///
  /// - Parameters:
  ///   - value: The `CodiceFiscale` to control.
  ///
  /// - Returns: `true` if valid. `false` otherwise.
  public static func isValid(_ value: CodiceFiscale) -> Bool {
    // Help evaluating the fiscal code in case an omocodia version is passed.
    guard let codiceFiscale = try? originalFiscalCode(from: value) else {
      return false
    }
    
    let content = codiceFiscale.map {
      $0
    }
    
    guard
      content[0].isLetter,
      content[1].isLetter,
      content[2].isLetter,
      content[3].isLetter,
      content[4].isLetter,
      content[5].isLetter,
      content[6].isNumber,
      content[7].isNumber,
      let month = Models.Date.Month(letterRepresentation: content[8]),
      content[11].isLetter,
      content[12].isNumber,
      content[13].isNumber,
      content[14].isNumber,
      content[15].isLetter
    else {
      return false
    }
    
    guard
      let day = Int(
        content[9...10]
          .reduce(into: "") {
            $0 += String($1)
          }
      ),
      Models.Date.isValid(day: day, in: month)
    else {
      return false
    }
    
    let placeOfBirthCode = content[11...14].map {
      String($0)
    }.joined(separator: "")
    
    if content[11].uppercased() == "Z" {
      guard
        let places = try? Spritz.foreignPlacesOfBirth,
        places.contains(where: { $0.code == placeOfBirthCode })
      else {
        return false
      }
    } else {
      guard
        let places = try? Spritz.italianPlacesOfBirth,
        places.contains(where: { $0.code == placeOfBirthCode })
      else {
        return false
      }
    }
    
    guard
      let expectedChecksum = try? DataNormalizer.checksum(for: value.strippedChecksum()),
      Character(expectedChecksum) == content[15]
    else {
      return false
    }
    
    return true
  }
  
  /// Checks if the fiscal code matches the data of the user.
  ///
  /// This method takes into account omocodia, therefore it is preferred over generating your own fiscal code and comparing it.
  /// If the provided fiscal code, or person data provided are invalid, this method will return false.
  /// - Parameters:
  ///   - fiscalCode: The fiscal code to validate.
  ///   - person: The data related to the person.
  /// - Returns: A Bool representing whether or no the fiscal code is valid for that person.
  public static func isCorrect(fiscalCode: String, for person: SpritzInformationProvider) -> Bool {
    guard
      // Generate the correct fiscal code given the data.
      let correctFiscalCode = try? generateCF(from: person),
      // Filter the passed fiscal code from any possible omocodia.
      let proposedFiscalCode = try? originalFiscalCode(from: fiscalCode)
    else {
      return false
    }
    
    return correctFiscalCode == proposedFiscalCode
  }
}

// MARK: - Helpers

internal extension Spritz {
  /// Returns the same fiscal code, filtering out any possible altered values caused by [omocodia](https://it.wikipedia.org/wiki/Omocodia).
  ///
  /// Omocodia occurs when two or more people has:
  /// - The same first and last name
  /// - Born on the same day, of the same year
  /// - From the same sex
  /// - In the same place
  ///
  /// A fiscal code has digits in the following positions (where first element is in position 0):
  /// - 6
  /// - 7
  /// - 9
  /// - 10
  /// - 12
  /// - 13
  /// - 14
  ///
  /// The algorithm consists of substituting the digits in the previously mentioned positions with a digit follow the map found in `Spritz.Models.SingleDigitNumber.omocodiaValue`.
  /// The change starts from the most right element (last position).
  ///
  /// The control letter is recalculated. Therefore once the original numbers are restored, the checksum is changed as well.
  static func originalFiscalCode(from omocodia: CodiceFiscale) throws -> String {
    guard omocodia.count == 16 else {
      throw Spritz.Error.invalidFiscalCode
    }
    
    var characters = omocodia
      .map {
        $0
      }
    
    // Create an array of characters in the digits position.
    let convertibleDigits = [characters[14], characters[13], characters[12], characters[10], characters[9], characters[7], characters[6]]
    
    // If all array is digits, then no omocodia is present.
    guard convertibleDigits.contains(where: \.isLetter) else {
      return omocodia
    }
    
    guard
      let expectedChecksum = try? DataNormalizer.checksum(for: omocodia.strippedChecksum()),
      let actualChecksum = characters.last,
      Character(expectedChecksum) == actualChecksum
    else {
      throw Spritz.Error.invalidFiscalCode
    }
    
    try convertibleDigits.enumerated().forEach {
      if $0.element.isLetter {
        guard let digit = Spritz.Models.SingleDigitNumber(omocodiaValue: $0.element)?.rawValue else {
          throw Spritz.Error.invalidFiscalCode
        }
        
        characters[characters.lastIndex(of: $0.element)!] = Character("\(digit)")
      } else {
        guard !convertibleDigits[$0.offset ..< convertibleDigits.endIndex].dropFirst().contains(where: \.isLetter) else {
          throw Spritz.Error.invalidFiscalCode
        }
      }
    }
    
    let firstFifteenLetters = characters
      .dropLast()
      .reduce(""){
        $0 + String($1)
      }
    
    let checksum = try DataNormalizer.checksum(for: firstFifteenLetters)
    
    return firstFifteenLetters.appending(checksum)
  }
}
