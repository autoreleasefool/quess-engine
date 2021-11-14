//
//  Created by Joseph Roque on 2021-11-10.
//

import Foundation

public struct Piece: Hashable {

  public let owner: Player
  public let `class`: Class
  public let index: Int

  public init(owner: Player, class: Class, index: Int) {
    self.owner = owner
    self.class = `class`
    self.index = index
  }

  public func canMove(from: Board.Notation, to: Board.Notation, in state: GameState) -> Bool {
    // Can't move to a position you already occupy
    guard from != to else { return false }

    // Unable to capture an identical piece
    if let pieceAtPosition = state.board.pieceAt(to), pieceAtPosition.class == self.class {
      return false
    }

    switch self.class {
    case .circle: return Piece.circleCanMove(from: from, to: to, in: state)
    case .triangle: return Piece.triangleCanMove(from: from, to: to, in: state)
    case .square: return Piece.squareCanMove(from: from, to: to, in: state)
    }
  }

  public func moves(in state: GameState) -> [Movement] {
    switch self.class {
    case .circle: return movesAsCircle(in: state)
    case .triangle: return movesAsTriangle(in: state)
    case .square: return movesAsSquare(in: state)
    }
  }

}

// MARK: - Type

extension Piece {

  public enum Class: Hashable {
    case triangle
    case circle
    case square
  }

}

// MARK: - Circle

extension Piece {

  private func movesAsCircle(in state: GameState) -> [Movement] {
    guard let position = state.board.position(ofPiece: self) else { return [] }
    return [
      (-2, 1),
      (-2, -1),
      (-1, 2),
      (-1, -2),
      (1, 2),
      (1, -2),
      (2, 1),
      (2, -1),
    ].compactMap {
      guard let dest = position.adding(x: $0, y: $1) else { return nil }
      return Movement(piece: self, from: position, to: dest)
    }
  }

  private static func circleCanMove(from: Board.Notation, to: Board.Notation, in state: GameState) -> Bool {
    let (fromX, fromY) = from.toCoord
    let (toX, toY) = to.toCoord

    return (
      (fromX + 2 == toX && (fromY == toY - 1 || fromY == toY + 1)) ||
      (fromX - 2 == toX && (fromY == toY - 1 || fromY == toY + 1)) ||
      (fromY + 2 == toY && (fromX == toX - 1 || fromX == toX + 1)) ||
      (fromY - 2 == toY && (fromX == toX - 1 || fromX == toX + 1))
    )
  }

}

// MARK: - Triangle

extension Piece {

  private func movesAsTriangle(in state: GameState) -> [Movement] {
    guard let position = state.board.position(ofPiece: self) else { return [] }

    return [
      (-1, 0),
      (1, 0),
      (0, -1),
      (0, 1),
    ].compactMap {
      guard let dest = position.adding(x: $0, y: $1) else { return nil }
      return Movement(piece: self, from: position, to: dest)
    }
  }

  private static func triangleCanMove(from: Board.Notation, to: Board.Notation, in state: GameState) -> Bool {
    from.up == to || from.down == to || from.left == to || from.right == to
  }

}

// MARK: - Square

extension Piece {

  private func movesAsSquare(in state: GameState) -> [Movement] {
    guard let startPosition = state.board.position(ofPiece: self) else { return [] }
    var moves: [Movement] = []

    var previousPosition = startPosition
    let directions: [KeyPath<Board.Notation, Board.Notation?>] = [\.left, \.right, \.up, \.down]
    directions.forEach { direction in
      while let targetPosition = previousPosition[keyPath: direction] {
        if state.board.isEmpty(at: targetPosition) {
          moves.append(Movement(piece: self, from: startPosition, to: targetPosition))
        } else {
          break
        }
        previousPosition = targetPosition
      }
    }

    return moves
  }

  private static func squareCanMove(from: Board.Notation, to: Board.Notation, in state: GameState) -> Bool {
    let (fromX, fromY) = from.toCoord
    let (toX, toY) = to.toCoord

    if fromX == toX {
      let startY = fromY < toY ? fromY : toY
      let endY = fromY > toY ? fromY : toY

      for i in (startY + 1...endY) {
        if !state.board.isEmptyAt(x: fromX, y: i) {
          return false
        }
      }

      return true
    } else if fromY == toY {
      let startX = fromX < toX ? fromX : toX
      let endX = fromX > toX ? fromX : toX

      for i in (startX + 1...endX) {
        if !state.board.isEmptyAt(x: i, y: fromY) {
          return false
        }
      }

      return true
    }

    return false
  }

}
