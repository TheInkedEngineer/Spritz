import Foundation

// MARK: - Alphabet

extension Spritz.Models {
  /// The alphabet mapping.
  enum Alphabet: String, CaseIterable {
    /// The `A` letter of the alphabet.
    /// Even position value: 0
    /// Odd position value: 1
    case A
    
    /// The `B` letter of the alphabet.
    /// Even position value: 1
    /// Odd position value: 0
    case B
    
    /// The `C` letter of the alphabet.
    /// Even position value: 2
    /// Odd position value: 5
    case C
    
    /// The `D` letter of the alphabet.
    /// Even position value: 3
    /// Odd position value: 7
    case D
    
    /// The `E` letter of the alphabet.
    /// Even position value: 4
    /// Odd position value: 9
    case E
    
    /// The `F` letter of the alphabet.
    /// Even position value: 5
    /// Odd position value: 13
    case F
    
    /// The `G` letter of the alphabet.
    /// Even position value: 6
    /// Odd position value: 15
    case G
    
    /// The `H` letter of the alphabet.
    /// Even position value: 7
    /// Odd position value: 17
    case H
    
    /// The `I` letter of the alphabet.
    /// Even position value: 8
    /// Odd position value: 19
    case I
    
    /// The `J` letter of the alphabet.
    /// Even position value: 9
    /// Odd position value: 21
    case J
    
    /// The `K` letter of the alphabet.
    /// Even position value: 10
    /// Odd position value: 2
    case K
    
    /// The `L` letter of the alphabet.
    /// Even position value: 11
    /// Odd position value: 4
    case L
    
    /// The `M` letter of the alphabet.
    /// Even position value: 12
    /// Odd position value: 18
    case M
    
    /// The `N` letter of the alphabet.
    /// Even position value: 13
    /// Odd position value: 20
    case N
    
    /// The `O` letter of the alphabet.
    /// Even position value: 14
    /// Odd position value: 11
    case O
    
    /// The `P` letter of the alphabet.
    /// Even position value: 15
    /// Odd position value: 3
    case P
    
    /// The `Q` letter of the alphabet.
    /// Even position value: 16
    /// Odd position value: 6
    case Q
    
    /// The `R` letter of the alphabet.
    /// Even position value: 17
    /// Odd position value: 8
    case R
    
    /// The `S` letter of the alphabet.
    /// Even position value: 18
    /// Odd position value: 12
    case S
    
    /// The `T` letter of the alphabet.
    /// Even position value: 19
    /// Odd position value: 14
    case T
    
    /// The `U` letter of the alphabet.
    /// Even position value: 20
    /// Odd position value: 16
    case U
    
    /// The `V` letter of the alphabet.
    /// Even position value: 21
    /// Odd position value: 10
    case V
    
    /// The `W` letter of the alphabet.
    /// Even position value: 22
    /// Odd position value: 22
    case W
    
    /// The `X` letter of the alphabet.
    /// Even position value: 23
    /// Odd position value: 25
    case X
    
    /// The `Y` letter of the alphabet.
    /// Even position value: 24
    /// Odd position value: 24
    case Y
    
    /// The `Z` letter of the alphabet.
    /// Even position value: 25
    /// Odd position value: 23
    case Z
    
    
    /// The integer value associated with the letter if it is in an even position inside the fiscal code.
    var evenPositionValue: Int {
      Alphabet.allCases.firstIndex(of: self)!
    }
    
    /// The integer value associated with the letter if it is in an odd position inside the fiscal code.
    var oddPositionValue: Int {
      switch self {
        case .A:
          return 1
          
        case .B:
          return 0
          
        case .C:
          return 5
          
        case .D:
          return 7
          
        case .E:
          return 9
          
        case .F:
          return 13
          
        case .G:
          return 15
          
        case .H:
          return 17
          
        case .I:
          return 19
          
        case .J:
          return 21
          
        case .K:
          return 2
          
        case .L:
          return 4
          
        case .M:
          return 18
          
        case .N:
          return 20
          
        case .O:
          return 11
          
        case .P:
          return 3
          
        case .Q:
          return 6
          
        case .R:
          return 8
          
        case .S:
          return 12
          
        case .T:
          return 14
          
        case .U:
          return 16
          
        case .V:
          return 10
          
        case .W:
          return 22
          
        case .X:
          return 25
          
        case .Y:
          return 24
          
        case .Z:
          return 23
      }
    }
    
    /// Creates and Alphabet and returns it based on its position starting with 0.
    ///
    /// This is used to fetch the control character. The mapping of the control character is mapped to numbers between 0 and 25, where 0 is A and 25 is Z.
    init?(evenPosition: Int) {
      guard evenPosition >= 0, evenPosition <= 25 else { return nil }
      self = Alphabet.allCases[evenPosition]
    }
  }
}

// MARK: - SingleDigitNumber

extension Spritz.Models {
  /// The single digit (0-9) mapping.
  enum SingleDigitNumber: Int, CaseIterable {
    /// spelled out.
    /// Even position value: 0
    /// Odd position value: 1
    case zero
    
    /// spelled out.
    /// Even position value: 1
    /// Odd position value: 0
    case one
    
    /// spelled out.
    /// Even position value: 2
    /// Odd position value: 5
    case two
    
    /// spelled out.
    /// Even position value: 3
    /// Odd position value: 7
    case three
    
    /// spelled out.
    /// Even position value: 4
    /// Odd position value: 9
    case four
    
    /// spelled out.
    /// Even position value: 5
    /// Odd position value: 13
    case five
    
    /// spelled out.
    /// Even position value: 6
    /// Odd position value: 15
    case six
    
    /// spelled out.
    /// Even position value: 7
    /// Odd position value: 17
    case seven
    
    /// spelled out.
    /// Even position value: 8
    /// Odd position value: 19
    case eight
    
    /// spelled out.
    /// Even position value: 9
    /// Odd position value: 21
    case nine
    
    /// Returns a single digit given an letter, if that letter is part of the digit <-> alphabet omocodia conversion.
    init?(omocodiaValue: Character) {
      let found = SingleDigitNumber.allCases.first {
        $0.omocodiaValue == omocodiaValue.uppercased()
      }
      
      guard let digit = found else {
        return nil
      }
      
      self = digit
    }
    
    /// The value of the digit when in an even position inside the CF.
    var evenPositionValue: Int {
      rawValue
    }
    
    /// The value of the digit when in an odd position inside the CF.
    var oddPositionValue: Int {
      switch self {
        case .zero :
          return 1
          
        case .one  :
          return 0
          
        case .two  :
          return 5
          
        case .three:
          return 7
          
        case .four :
          return 9
          
        case .five :
          return 13
          
        case .six  :
          return 15
          
        case .seven:
          return 17
          
        case .eight:
          return 19
          
        case .nine :
          return 21
      }
    }
    
    /// The value of the integer as a letter when substituted to overcome `Omocodia`.
    var omocodiaValue: String {
      switch self {
        case .zero :
          return "L"
          
        case .one  :
          return "M"
          
        case .two  :
          return "N"
          
        case .three:
          return "P"
          
        case .four :
          return "Q"
          
        case .five :
          return "R"
          
        case .six  :
          return "S"
          
        case .seven:
          return "T"
          
        case .eight:
          return "U"
          
        case .nine :
          return "V"
      }
    }
  }
}
