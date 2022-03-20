import Foundation

extension Spritz {
  public enum Error: Swift.Error {
    /// The provided fiscal code has an invalid format.
    case invalidFiscalCode
    
    /// The provided data to generate the fiscal code was not valid.
    case invalidData
  }
}
