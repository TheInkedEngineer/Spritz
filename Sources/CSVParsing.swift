//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

extension Spritz {
  /// List of possible decoding errors.
  public enum ParsingError: Error {
    /// The `csv` file was not found.
    case fileNotFound
    /// A data being parsed is corrupted.
    case corruptedData(_ message: String)
  }
  
  /// The classification of countries as per CF.
  internal enum Country {
    case italy
    case foreign
  }
  
  /// Parses the `CSV` file present in the bundle.
  /// - throws: `Spritz.ParsingError`
  internal static func parseCSV(for country: Country) throws -> [PlaceOfBirth] {
    let fileName = country == .italy ? "comuni" : "stati"
    
    guard let filepath = Spritz.bundle?.path(forResource: fileName, ofType: "csv") else {
      throw Spritz.ParsingError.fileNotFound
    }
    
    guard let content = try? String(contentsOfFile: filepath) else {
      throw Spritz.ParsingError.corruptedData("Could not stringify the content of the file.")
    }
    
    return try content.components(separatedBy: "\n").compactMap { newEntry -> PlaceOfBirth? in
      // For some reason, there is always an empty line at the end of the csv, when parsing its components.
      // This makes sure if that is the case, to return a nil which is filtered through the `compactMap`.
      if newEntry.isEmpty { return nil }
      
      let parsedData = newEntry.components(separatedBy: ";")
      
      guard parsedData.count == 2 else {
        throw Spritz.ParsingError.corruptedData("Was expecting 2 fields, got \(parsedData.count) while parsing \(newEntry).")
      }
      
      guard parsedData[0].count == 4 else {
        throw Spritz.ParsingError.corruptedData("Was expecting 4 digits for `CodiceStatistico`, but received \(parsedData[0]) instead.")
      }
      
      return PlaceOfBirth(
        code: parsedData[0],
        name: parsedData[1]
      )
    }
  }
}
