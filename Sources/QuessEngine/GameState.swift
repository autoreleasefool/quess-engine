//
//  Created by Joseph Roque on 2021-11-10.
//

public class GameState {

  public let board = Board()

  private var updates: [Board.Update] = []

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

  public func apply(_ movement: Movement) -> Bool {
    guard !isFinished else { return false }

    guard movement.piece.owner == currentPlayer else {
      return false
    }

    guard movement.piece.canMove(from: movement.from, to: movement.to, in: self) else {
      return false
    }

    let update = board.apply(movement)
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

    if board.blackPieces().count == 1 && board.whitePieces().count == 1 {
      endState = .draw
      return
    }

    if board.pieces(forPlayer: player).contains(where: {
      board.position(ofPiece: $0)?.isWithinStartZone(for: opponent) ?? false
    }) {
      endState = .ended(winner: player)
      return
    }

    if possibleMoves(forPlayer: opponent).isEmpty {
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
