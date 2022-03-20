import Foundation

/// A guideline for creating an object providing necessary information to compose the place of birth of an individual.
internal protocol PlaceOfBirthProvider {
  /// A unique identifier for the country or municipality.
  var code: String { get }
  
  /// The name of the municipality.
  var name: String { get }
}
