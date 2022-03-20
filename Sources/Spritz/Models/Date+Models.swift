import Foundation

extension Spritz.Models {
  /// A custom date model.
  /// It consists of a day, month and year.
  /// If an invalid date is passed, it returns nil.
  public struct Date {
    /// The day of the month.
    /// If an invalid day is passed, example: 30 February, the initializer will fail.
    let day: Int
    
    /// The month.
    let month: Month
    
    /// The year.
    let year: Int
    
    /// The normalized representation of the year.
    var normalizedYear: String {
      String(String(year).suffix(2))
    }
    
    /// Creates an instance of `Spritz.Models.Date`.
    ///
    /// If invalid data is passed, the initializer will fail.
    public init?(
      day: Int,
      month: Month,
      year: Int
    ) {
      guard day > 0, year > 0, day <= month.maxDaysPerMonth else {
        return nil
      }
      
      if month == .february, !Self.isLeapYear(year), day > 28 {
        return nil
      }
      
      self.day = day
      self.month = month
      self.year = year
    }
    
    func normalizedDay(for sex: Spritz.Models.Sex) -> String {
      switch sex {
      case .male:
          return String(format: "%02d",  day)
          
      case .female:
          return String(format: "%02d", day + DataNormalizer.numberToAddToFemaleBirthDay)
      }
    }
    
    static func isValid(day: Int, in month: Month) -> Bool {
      // Case for man
      (day > 0 && day <= month.maxDaysPerMonth)
      
      ||
      
      // Case for female
      (
        day > DataNormalizer.numberToAddToFemaleBirthDay &&
        day - DataNormalizer.numberToAddToFemaleBirthDay <= month.maxDaysPerMonth
      )
    }
    
    /// Checks if a given passed year is Leap of not.
    static func isLeapYear(_ year: Int) -> Bool {
      ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
    }
  }
}

// MARK: - Data Structures

extension Spritz.Models.Date {
  /// The list of all months of the year.
  public enum Month: CaseIterable {
    /// The month of January.
    case january
    
    /// The month of February.
    case february
    
    /// The month of March.
    case march
    
    /// The month of April.
    case april
    
    /// The month of May.
    case may
    
    /// The month of June.
    case june
    
    /// The month of July.
    case july
    
    /// The month of August.
    case august
    
    /// The month of September.
    case september
    
    /// The month of October.
    case october
    
    /// The month of November.
    case november
    
    /// The month of December.
    case december
    
    /// Returns a month given its letter representation, if valid.
    init?(letterRepresentation: Character) {
      let match = Month.allCases.first {
        $0.letterRepresentation == letterRepresentation.uppercased()
      }
      
      guard let month = match else {
        return nil
      }
      
      self = month
    }
    
    /// The letter representation of the month used in the fiscal code.
    internal var letterRepresentation: String {
      switch self {
        case .january:
          return "A"
          
        case .february:
          return "B"
          
        case .march:
          return "C"
          
        case .april:
          return "D"
          
        case .may:
          return "E"
          
        case .june:
          return "H"
          
        case .july:
          return "L"
          
        case .august:
          return "M"
          
        case .september:
          return "P"
          
        case .october:
          return "R"
          
        case .november:
          return "S"
          
        case .december:
          return "T"
          
      }
    }
    
    /// The maximum number of days in a given month.
    internal var maxDaysPerMonth: Int {
      switch self {
        case .january:
          return 31
          
        case .february:
          return 29 // we assume it is 29, because there is no way to know if the year is leap or not from the two digits alone.
          
        case .march:
          return 31
          
        case .april:
          return 30
          
        case .may:
          return 31
          
        case .june:
          return 30
          
        case .july:
          return 31
          
        case .august:
          return 31
          
        case .september:
          return 30
          
        case .october:
          return 31
          
        case .november:
          return 30
          
        case .december:
          return 31
      }
    }
  }
  
}
