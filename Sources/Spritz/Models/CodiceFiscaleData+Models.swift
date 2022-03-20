import Foundation

extension Spritz.Models {
  /// A default object conforming to `SpritzInformationProvider`.
  public struct CodiceFiscaleData: SpritzInformationProvider {
    /// The first name of the user.
    public let firstName: String
    
    /// The last name of the user.
    public let lastName: String
    
    /// An instance of `Spritz.Models.Date` associated with the birth date of the user.
    public let dateOfBirth: Spritz.Models.Date
    
    /// The sex of the user.
    public let sex: Spritz.Models.Sex
    
    /// The Italian province or country where the user was born.
    /// Should use full name. Do not use abbreviation, or any sort of representation.
    /// Refer to `comuni.csv` or `stati.csv` for the proper names as per Italian bureaucracy.
    public let placeOfBirth: Spritz.Models.PlaceOfBirth
    
    // MARK: Init
    
    /// Creates a new instance of `Spritz.Models.CodiceFiscaleData`
    /// - Parameters:
    ///   - firstName: The first name of the person.
    ///   - lastName: The last name of the person.
    ///   - dateOfBirth: An instance of `Spritz.Models.Date` associated with the birth date of the person.
    ///   - sex: The sex of the person.
    ///   - placeOfBirth: The place where the user was born.
    public init(firstName: String, lastName: String, dateOfBirth: Spritz.Models.Date, sex: Spritz.Models.Sex, placeOfBirth: Spritz.Models.PlaceOfBirth) {
      self.firstName = firstName
      self.lastName = lastName
      self.dateOfBirth = dateOfBirth
      self.sex = sex
      self.placeOfBirth = placeOfBirth
    }
  }
}
