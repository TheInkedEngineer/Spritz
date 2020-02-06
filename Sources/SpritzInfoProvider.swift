//
//  Spritz
//
//  Copyright © TheInkedEngineer. All rights reserved.
// 

import Foundation

public enum Sex {
  case male
  case female
}

public protocol CFInfoProvider {
  
  /// The first name of the person.
  var firstName: String { get set }
  
  /// The last name of the person.
  var lastName: String { get set }
  
  /// The last name of the person.
  var dateOfBirth: Date { get set }
  
  /// The sex of the user.
  var ser: Sex { get set }
}
