//
//  Created by Joseph Roque on 2021-11-10.
//

public class GameState {

  public let board = Board()

  internal private(set) var updates: [Board.Update] = []

  public var history: [Movement] {
    updates.map { $0.movement }
  }

  public private(set) var currentPlayer: Player = .white

  public private(set) var endState: EndState?

  public var isFinished: Bool {
    endState != nil
  }

  public var winner: Player? {
    guard case let .ended(player) = endState else { return nil }
    return player
  }

  public init() {}

  public func allPossibleMoves() -> [Movement] {
    possibleMoves(forPlayer: currentPlayer)
  }

  public func possibleMoves(forPlayer player: Player) -> [Movement] {
    guard !isFinished else { return [] }
    let pieces = board.pieces(forPlayer: player)
    return pieces.flatMap { piece in
      piece.moves(in: self)
    }
  }

  public func check(_ movement: Movement) -> Bool {
    return !isFinished &&
      movement.piece.owner == currentPlayer &&
      movement.piece.canMove(to: movement.to, in: self)
  }

  @discardableResult public func apply(_ quessMove: QuessMove) -> Bool {
    guard let piece = board.pieceAt(quessMove.from) else { return false }
    let movement = Movement(piece: piece, to: quessMove.to)
    let update = board.move(piece: piece, from: quessMove.from, to: quessMove.to)
    updates.append(update)
    currentPlayer = currentPlayer.next

    updateWinState(afterMove: movement)
    return true
  }

  @discardableResult public func apply(_ movement: Movement) -> Bool {
    guard let from = board.position(ofPiece: movement.piece), check(movement) else { return false }

    let update = board.move(piece: movement.piece, from: from, to: movement.to)
    updates.append(update)
    currentPlayer = currentPlayer.next

    updateWinState(afterMove: movement)
    return true
  }

  public func undo() {
    guard let undone = updates.popLast() else { return }
    if isFinished {
      endState = nil
    }

    currentPlayer = currentPlayer.next
    board.undo(undone)
  }

  private func updateWinState(afterMove lastMove: Movement) {
    let player = lastMove.piece.owner
    let opponent = lastMove.piece.owner.opponent

    if board.pieces(forPlayer: .white).count == 1 && board.pieces(forPlayer: .black).count == 1 {
      endState = .draw
      return
    }

    if board.atLeastTwoOpponentPieces(inStartZoneFor: opponent) {
      endState = .ended(winner: player)
      return
    }

    let pieces = board.pieces(forPlayer: opponent)
    if !pieces.contains(where: { $0.hasAnyMoves(in: self) }) {
      endState = .ended(winner: player)
      return
    }
  }

}

// MARK: End state

extension GameState {

  public enum EndState {
    case draw
    case ended(winner: Player)
  }

}
