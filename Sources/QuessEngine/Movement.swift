//
//  Created by Joseph Roque on 2021-11-11.
//

import Foundation

public struct Movement: Hashable {

  public let piece: Piece
  public let to: Board.RankFile

  public init(piece: Piece, to: Board.RankFile) {
    self.piece = piece
    self.to = to
  }

  public func quessify(withState state: GameState) throws -> QuessMove {
    guard let from = state.board.position(ofPiece: piece) else {
      throw QuessEngineError.failedConversion
    }

    return QuessMove(from: from, to: to)
  }

}

public struct QuessMove: Hashable {

  public let from: Board.RankFile
  public let to: Board.RankFile

  public init(from: Board.RankFile, to: Board.RankFile) {
    self.from = from
    self.to = to
  }

  public func chessify(withState state: GameState) throws -> Movement {
    guard let piece = state.board.pieceAt(from) else {
      throw QuessEngineError.failedConversion
    }

    return Movement(piece: piece, to: to)
  }

}

public enum QuessEngineError: Error {
  case failedConversion
}

public extension Collection where Element == QuessMove {

  func chessify(withState state: GameState) throws -> [Movement] {
    try map { try $0.chessify(withState: state) }
  }

}

public extension Collection where Element == Movement {

  func quessify(withState state: GameState) throws -> [QuessMove] {
    try map { try $0.quessify(withState: state) }
  }

}
