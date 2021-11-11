//
//  Created by Joseph Roque on 2021-11-10.
//

import Foundation

public class Board {

  public static let size = 6

  private var grid: [Int: Piece]

  public init() {
    self.grid = [
      // Create white pieces
      Notation.D1.asCoordinate: Piece(owner: .white, class: .triangle),
      Notation.E2.asCoordinate: Piece(owner: .white, class: .triangle),
      Notation.F3.asCoordinate: Piece(owner: .white, class: .triangle),
      Notation.E1.asCoordinate: Piece(owner: .white, class: .circle),
      Notation.F2.asCoordinate: Piece(owner: .white, class: .circle),
      Notation.F1.asCoordinate: Piece(owner: .white, class: .square),

      // Create black pieces
      Notation.A4.asCoordinate: Piece(owner: .black, class: .triangle),
      Notation.B5.asCoordinate: Piece(owner: .black, class: .triangle),
      Notation.C6.asCoordinate: Piece(owner: .black, class: .triangle),
      Notation.A5.asCoordinate: Piece(owner: .black, class: .circle),
      Notation.B6.asCoordinate: Piece(owner: .black, class: .circle),
      Notation.A6.asCoordinate: Piece(owner: .black, class: .square),
    ]
  }

  public func pieceAt(x: Int, y: Int) -> Piece? {
    guard (0..<Board.size).contains(x) && (0..<Board.size).contains(y) else {
      return nil
    }

    return grid[Board.coordinateToIndex(x: x, y: y)]
  }

  public func pieceAt(_ notation: Notation) -> Piece? {
    grid[notation.asCoordinate]
  }

  public func isEmptyAt(x: Int, y: Int) -> Bool {
    pieceAt(x: x, y: y) == nil
  }

  public func isEmpty(at notation: Notation) -> Bool {
    pieceAt(notation) == nil
  }

  // MARK: Coordinates

  public static func coordinateToIndex(x: Int, y: Int) -> Int {
    return y * Board.size + x
  }
}

// MARK: - Notation

extension Board {

  // swiftlint:disable identifier_name

  public enum Notation: Int {
    case A1, A2, A3, A4, A5, A6
    case B1, B2, B3, B4, B5, B6
    case C1, C2, C3, C4, C5, C6
    case D1, D2, D3, D4, D5, D6
    case E1, E2, E3, E4, E5, E6
    case F1, F2, F3, F4, F5, F6

    public var asCoordinate: Int {
      return rawValue
    }

    public func isWithinStartZone(for player: Player) -> Bool {
      switch self {
      case .F1, .E1, .F2, .D1, .E2, .F3: return player == .white
      case .A6, .A5, .B6, .A4, .B5, .C6: return player == .black
      default: return false
      }
    }
  }

  // swiftlint:enable identifier_name

}
