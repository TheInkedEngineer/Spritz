import Foundation

/// Encapsulator of data parsing logic.
enum Parser {
  /// Parses the data inside a `CSV` file.
  ///
  /// - Parameter file: An option from `Parser.File`.
  ///
  /// - Returns: An array of objects conforming to `PlaceOfBirth`.
  static func parse<T: PlaceOfBirthProvider>(_ file: Parser.File) throws -> [T] {
    // Since we inject the file name from an enum, it will always be found.
    let filePath = Bundle.module.path(forResource: file.rawValue, ofType: "csv")!
    let content = try String(contentsOfFile: filePath)
    
    switch file {
      case .stati:
        return try parse(content, ofType: Spritz.Models.Country.self) as! [T]
        
      case .comuni:
        return try parse(content, ofType: Spritz.Models.Municipality.self) as! [T]
    }
  }
  
  /// Parses the content of a `String` and transforms in into an array of the passed format.
  static func parse<T: PlaceOfBirthProvider>(_ content: String, ofType type: T.Type) throws -> [T] {
    try content
      .components(separatedBy: "\n")
      .compactMap { newEntry -> T? in
        // There is always an empty line at the end of the CSV, when parsing its components.
        // This makes sure if that is the case, to return a nil which is filtered through the `compactMap`.
        if newEntry.isEmpty {
          return nil
        }
        
        let parsedData = newEntry.components(separatedBy: ";")
        
        guard parsedData.count == 2 else {
          throw Error.corruptedData(.invalidNumberOfFields(actual: parsedData.count, lineContent: newEntry))
        }
        
        guard parsedData[0].count == 4 else {
          throw Error.corruptedData(.invalidCodeLength(actual: parsedData[0].count, value: parsedData[0]))
        }
        
        if type is Spritz.Models.Country.Type {
          return Spritz.Models.Country(code: parsedData[0], name: parsedData[1]) as? T
        }
        
        if type is Spritz.Models.Municipality.Type {
          return Spritz.Models.Municipality(code: parsedData[0], name: parsedData[1]) as? T
        }
        
        return nil
      }
  }
}

extension Parser {
  /// The files available to parse.
  /// The `RawValue` should represent the name of the file on disk.
  enum File: String {
    case comuni
    case stati
  }
}

// MARK: - Errors

extension Parser {
  /// Possible errors when parsing `CSV data`.
  enum Error: Swift.Error, Equatable {
    /// A data being parsed is corrupted.
    case corruptedData(_ reason: Parser.File.Error)
  }
}

extension Parser.File {
  /// Possible errors that can be found inside the files being parsed.
  enum Error: Swift.Error, Equatable {
    /// An invalid number of fields was found.
    /// The expected and found number of fields are always provided.
    /// The content of the line where the error was thrown is provided.
    case invalidNumberOfFields(expected: Int = 2, actual: Int, lineContent: String)
    
    /// The found code had an invalid length.
    /// The expected and found number of fields are always provided.
    /// The content of the line where the error was thrown is provided.
    case invalidCodeLength(expected: Int = 4, actual: Int, value: String)
  }
}
