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

  public func canMove(to: Board.RankFile, in state: GameState) -> Bool {
    // Piece must be on the board
    guard let from = state.board.position(ofPiece: self) else { return false }

    // Basic checks for valid positioning
    guard self.canOccupy(position: to, from: from, in: state) else { return false }

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

  public func hasAnyMoves(in state: GameState) -> Bool {
    switch self.class {
    case .circle: return hasAnyMovesAsCircle(in: state)
    case .triangle: return hasAnyMovesAsTriangle(in: state)
    // Square just needs to be able to move one space in one direction, as a triangle
    case .square: return hasAnyMovesAsTriangle(in: state)
    }
  }

  private func canOccupy(position: Board.RankFile, from: Board.RankFile, in state: GameState) -> Bool {
    // Can't move to a position you already occupy
    guard from != position else { return false }

    // Unable to capture an identical piece or color
    if let pieceAtPosition = state.board.pieceAt(position),
       pieceAtPosition.class == self.class || pieceAtPosition.owner == self.owner {
      return false
    }

    return true
  }

}

// MARK: - Type

extension Piece {

  public enum Class: Hashable, CaseIterable {
    case triangle
    case circle
    case square

    public var isUniquePerPlayer: Bool {
      switch self {
      case .triangle, .circle: return false
      case .square: return true
      }
    }
  }

}

// MARK: - Circle

extension Piece {

  private static let circleMoveDeltas = [
    (-2, 1),
    (-2, -1),
    (-1, 2),
    (-1, -2),
    (1, 2),
    (1, -2),
    (2, 1),
    (2, -1),
  ]

  private func movesAsCircle(in state: GameState) -> [Movement] {
    guard let position = state.board.position(ofPiece: self) else { return [] }
    return Self.circleMoveDeltas.compactMap {
      guard let dest = position.adding(x: $0, y: $1),
            canOccupy(position: dest, from: position, in: state)
      else {
        return nil
      }
      return Movement(piece: self, to: dest)
    }
  }

  private func hasAnyMovesAsCircle(in state: GameState) -> Bool {
    guard let position = state.board.position(ofPiece: self) else { return false }
    return Self.circleMoveDeltas.contains {
      guard let dest = position.adding(x: $0, y: $1) else { return false }
      return canOccupy(position: dest, from: position, in: state)
    }
  }

  private static func circleCanMove(from: Board.RankFile, to: Board.RankFile, in state: GameState) -> Bool {
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

  private static let triangleMoveDeltas = [
    (-1, 0),
    (1, 0),
    (0, -1),
    (0, 1),
  ]

  private func movesAsTriangle(in state: GameState) -> [Movement] {
    guard let position = state.board.position(ofPiece: self) else { return [] }

    return Self.triangleMoveDeltas.compactMap {
      guard let dest = position.adding(x: $0, y: $1),
            canOccupy(position: dest, from: position, in: state)
      else {
        return nil
      }
      return Movement(piece: self, to: dest)
    }
  }

  private func hasAnyMovesAsTriangle(in state: GameState) -> Bool {
    guard let position = state.board.position(ofPiece: self) else { return false }
    return Self.triangleMoveDeltas.contains {
      guard let dest = position.adding(x: $0, y: $1) else { return false }
      return canOccupy(position: dest, from: position, in: state)
    }
  }

  private static func triangleCanMove(from: Board.RankFile, to: Board.RankFile, in state: GameState) -> Bool {
    from.up == to || from.down == to || from.left == to || from.right == to
  }

}

// MARK: - Square

extension Piece {

  private static let squareDirections: [KeyPath<Board.RankFile, Board.RankFile?>] = [\.left, \.right, \.up, \.down]

  private func movesAsSquare(in state: GameState) -> [Movement] {
    guard let startPosition = state.board.position(ofPiece: self) else { return [] }
    var moves: [Movement] = []

    Self.squareDirections.forEach { direction in
      var previousPosition = startPosition
      while let targetPosition = previousPosition[keyPath: direction] {
        if canOccupy(position: targetPosition, from: startPosition, in: state) {
          moves.append(Movement(piece: self, to: targetPosition))
        } else {
          break
        }

        // Stop searching when we've reached another piece
        if state.board.pieceAt(targetPosition) != nil { break }
        previousPosition = targetPosition
      }
    }

    return moves
  }

  private static func squareCanMove(from: Board.RankFile, to: Board.RankFile, in state: GameState) -> Bool {
    let (fromX, fromY) = from.toCoord
    let (toX, toY) = to.toCoord

    if fromX == toX {
      let startY = fromY < toY ? fromY : toY
      let endY = fromY > toY ? fromY : toY

      for i in (startY + 1..<endY) {
        if !state.board.isEmptyAt(x: fromX, y: i) {
          return false
        }
      }

      return true
    } else if fromY == toY {
      let startX = fromX < toX ? fromX : toX
      let endX = fromX > toX ? fromX : toX

      for i in (startX + 1..<endX) {
        if !state.board.isEmptyAt(x: i, y: fromY) {
          return false
        }
      }

      return true
    }

    return false
  }

}
