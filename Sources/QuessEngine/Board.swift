//
//  Created by Joseph Roque on 2021-11-10.
//
//     -----------------------
//  6 |   |   |   | ▲ | ● | ■ |
//  5 |   |   |   |   | ▲ | ● |
//  4 |   |   |   |   |   | ▲ |
//  3 | △ |   |   |   |   |   |
//  2 | ○ | △ |   |   |   |   |
//  1 | □ | ○ | △ |   |   |   |
//     -----------------------
//      A   B   C   D   E   F

import Foundation

public class Board {

  public static let size = 6

  private var grid: [Board.RankFile: Piece]
  private var pieces: [Piece: Board.RankFile]

  public init() {
    self.grid = [
      // Create white pieces
      .A3: Piece(owner: .white, class: .triangle, index: 1),
      .B2: Piece(owner: .white, class: .triangle, index: 2),
      .C1: Piece(owner: .white, class: .triangle, index: 3),
      .A2: Piece(owner: .white, class: .circle, index: 1),
      .B1: Piece(owner: .white, class: .circle, index: 2),
      .A1: Piece(owner: .white, class: .square, index: 1),

      // Create black pieces
      .D6: Piece(owner: .black, class: .triangle, index: 1),
      .E5: Piece(owner: .black, class: .triangle, index: 2),
      .F4: Piece(owner: .black, class: .triangle, index: 3),
      .E6: Piece(owner: .black, class: .circle, index: 1),
      .F5: Piece(owner: .black, class: .circle, index: 2),
      .F6: Piece(owner: .black, class: .square, index: 1),
    ]

    self.pieces = [:]
    self.grid.forEach { position, piece in
      self.pieces[piece] = position
    }
  }

  // MARK: Pieces

  public func whitePieces() -> [Piece] {
    grid.values
      .filter { $0.owner == .white }
  }

  public func blackPieces() -> [Piece] {
    grid.values
      .filter { $0.owner == .black }
  }

  public func pieces(forPlayer player: Player) -> [Piece] {
    switch player {
    case .white:
      return whitePieces()
    case .black:
      return blackPieces()
    }
  }

  public func pieceAt(x: Int, y: Int) -> Piece? {
    guard let position = Board.RankFile(rawValue: y * Board.size + x) else {
      return nil
    }

    return grid[position]
  }

  public func pieceAt(_ rankFile: RankFile) -> Piece? {
    grid[rankFile]
  }

  public func position(ofPiece piece: Piece) -> Board.RankFile? {
    pieces[piece]
  }

  // MARK: Board spaces

  public func isEmptyAt(x: Int, y: Int) -> Bool {
    pieceAt(x: x, y: y) == nil
  }

  public func isEmpty(at rankFile: RankFile) -> Bool {
    pieceAt(rankFile) == nil
  }

  // MARK: Movements

  func move(piece: Piece, from: Board.RankFile, to: Board.RankFile) -> Update {
    let captured = grid[to]
    grid[from] = nil
    grid[to] = piece

    pieces[piece] = to
    if let captured = captured {
      pieces[captured] = nil
    }

    return Update(movement: Movement(piece: piece, to: to), from: from, capture: captured)
  }

  func undo(_ update: Update) {
    grid[update.movement.to] = update.capture
    grid[update.from] = update.movement.piece

    pieces[update.movement.piece] = update.from
    if let captured = update.capture {
      pieces[captured] = update.movement.to
    }
  }

}

// MARK: - Updates

extension Board {

  struct Update {
    let movement: Movement
    let from: Board.RankFile
    let capture: Piece?
  }

}

// MARK: - RankFile

extension Board {

  // swiftlint:disable identifier_name

  public enum RankFile: Int, Hashable, CaseIterable {
    case A6, B6, C6, D6, E6, F6
    case A5, B5, C5, D5, E5, F5
    case A4, B4, C4, D4, E4, F4
    case A3, B3, C3, D3, E3, F3
    case A2, B2, C2, D2, E2, F2
    case A1, B1, C1, D1, E1, F1

    public var toCoord: (x: Int, y: Int) {
      (rawValue % 6, rawValue / 6)
    }

    public func isWithinStartZone(for player: Player) -> Bool {
      switch self {
      case .A1, .B1, .C1, .A2, .B2, .A3: return player == .white
      case .D6, .E6, .F6, .E5, .F5, .F4: return player == .black
      default: return false
      }
    }

    var up: RankFile? {
      return self.subtracting(y: 1)
    }

    var down: RankFile? {
      return self.adding(y: 1)
    }

    var left: RankFile? {
      return self.subtracting(x: 1)
    }

    var right: RankFile? {
      return self.adding(x: 1)
    }

    public func adding(x xd: Int? = nil, y yd: Int? = nil) -> RankFile? {
      let (x, y) = toCoord
      let xx = x + (xd ?? 0)
      let yy = y + (yd ?? 0)
      guard Self.validBoardRange.contains(xx) && Self.validBoardRange.contains(yy) else { return nil }
      return (yy * 6 + xx).toRankFile
    }

    public func subtracting(x xd: Int? = nil, y yd: Int? = nil) -> RankFile? {
      let (x, y) = toCoord
      let xx = x - (xd ?? 0)
      let yy = y - (yd ?? 0)
      guard Self.validBoardRange.contains(xx) && Self.validBoardRange.contains(yy) else { return nil }
      return (yy * 6 + xx).toRankFile
    }

    private static let validBoardRange = (0..<Board.size)
  }

  // swiftlint:enable identifier_name
}
