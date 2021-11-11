//
//  Created by Joseph Roque on 2021-11-10.
//

import Foundation

public struct Piece: Equatable {

  public let owner: Player
  public let `class`: Class

  public func canMove(from: Board.Notation, to: Board.Notation, in state: GameState) -> Bool {
    // Can't move to a position you already occupy
    guard from != to else { return false }

    if let pieceAtPosition = state.board.pieceAt(to), pieceAtPosition.class == self.class {
      // Unable to capture an identical piece
      return false
    }

    switch self.class {
    case .circle: return Piece.circleCanMove(from: from, to: to, in: state)
    case .triangle: return Piece.triangleCanMove(from: from, to: to, in: state)
    case .square: return Piece.squareCanMove(from: from, to: to, in: state)
    }
  }

}

// MARK: - Type

extension Piece {

  public enum Class: Equatable {
    case triangle
    case circle
    case square
  }

  private static func circleCanMove(from: Board.Notation, to: Board.Notation, in state: GameState) -> Bool {
    let (fromX, fromY, toX, toY) = Piece.notationToCoords(from: from, to: to)

    return (
      (fromX + 2 == toX && (fromY == toY - 1 || fromY == toY + 1)) ||
      (fromX - 2 == toX && (fromY == toY - 1 || fromY == toY + 1)) ||
      (fromY + 2 == toY && (fromX == toX - 1 || fromX == toX + 1)) ||
      (fromY - 2 == toY && (fromX == toX - 1 || fromX == toX + 1))
    )
  }

  private static func triangleCanMove(from: Board.Notation, to: Board.Notation, in state: GameState) -> Bool {
    let (fromX, fromY, toX, toY) = Piece.notationToCoords(from: from, to: to)

    return (
      (fromX + 1 == toX && fromY == toY) ||
      (fromX - 1 == toX && fromY == toY) ||
      (fromX == toX && fromY + 1 == toY) ||
      (fromX == toX && fromY - 1 == toY)
    )
  }

  // swiftlint:disable:next cyclomatic_complexity
  private static func squareCanMove(from: Board.Notation, to: Board.Notation, in state: GameState) -> Bool {
    let (fromX, fromY, toX, toY) = Piece.notationToCoords(from: from, to: to)

    if fromX == toX {
      if fromY < toY {
        for i in (fromY + 1...toY) {
          if !state.board.isEmptyAt(x: fromX, y: i) {
            return false
          }
        }

        return true
      } else if fromY > toY {
        for i in (toY..<fromY) {
          if !state.board.isEmptyAt(x: fromX, y: i) {
            return false
          }
        }

        return true
      }
    } else if fromY == toY {
      if fromX < toX {
        for i in (fromX + 1...toX) {
          if !state.board.isEmptyAt(x: i, y: fromY) {
            return false
          }
        }

        return true
      } else if fromX > toX {
        for i in (toY..<fromY) {
          if !state.board.isEmptyAt(x: i, y: fromY) {
            return false
          }
        }

        return true
      }
    }

    return false
  }

  // swiftlint:disable:next large_tuple
  private static func notationToCoords(from: Board.Notation, to: Board.Notation) -> (Int, Int, Int, Int) {
    let fromCoord = from.asCoordinate
    let (fromX, fromY) = (fromCoord % Board.size, fromCoord / Board.size)
    let toCoord = to.asCoordinate
    let (toX, toY) = (toCoord % Board.size, toCoord / Board.size)

    return (fromX, fromY, toX, toY)
  }

}
