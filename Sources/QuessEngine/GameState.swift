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

  public private(set) var winner: Player?
  public private(set) var isFinished: Bool = false

  public init() {}

  public func allPossibleMoves() -> [Movement] {
    guard !isFinished else { return [] }
    let pieces = board.pieces(forPlayer: currentPlayer)
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
    return true
  }

  public func undo() {
    guard let undone = updates.popLast() else { return }
    board.undo(undone)
  }

}
