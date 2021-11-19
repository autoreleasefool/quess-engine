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
      .C1: Piece(owner: .white, class: .triangle, index: 0),
      .B2: Piece(owner: .white, class: .triangle, index: 1),
      .A3: Piece(owner: .white, class: .triangle, index: 2),
      .B1: Piece(owner: .white, class: .circle, index: 0),
      .A2: Piece(owner: .white, class: .circle, index: 1),
      .A1: Piece(owner: .white, class: .square, index: 0),

      // Create black pieces
      .F4: Piece(owner: .black, class: .triangle, index: 0),
      .E5: Piece(owner: .black, class: .triangle, index: 1),
      .D6: Piece(owner: .black, class: .triangle, index: 2),
      .F5: Piece(owner: .black, class: .circle, index: 0),
      .E6: Piece(owner: .black, class: .circle, index: 1),
      .F6: Piece(owner: .black, class: .square, index: 0),
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

  public enum RankFile: Int, Hashable {
    case A1, A2, A3, A4, A5, A6
    case B1, B2, B3, B4, B5, B6
    case C1, C2, C3, C4, C5, C6
    case D1, D2, D3, D4, D5, D6
    case E1, E2, E3, E4, E5, E6
    case F1, F2, F3, F4, F5, F6

    public var toCoord: (x: Int, y: Int) {
      (rawValue % 6, rawValue / 6)
    }

    public func isWithinStartZone(for player: Player) -> Bool {
      switch self {
      case .F1, .E1, .F2, .D1, .E2, .F3: return player == .white
      case .A6, .A5, .B6, .A4, .B5, .C6: return player == .black
      default: return false
      }
    }

    var up: RankFile? {
      RankFile(rawValue: rawValue - 6)
    }

    var down: RankFile? {
      RankFile(rawValue: rawValue + 6)
    }

    var left: RankFile? {
      let (x, y) = toCoord
      return ((y - 1) * 6 + x).toRankFile
    }

    var right: RankFile? {
      let (x, y) = toCoord
      return ((y + 1) * 6 + x).toRankFile
    }

    public func adding(x xd: Int? = nil, y yd: Int? = nil) -> RankFile? {
      let (x, y) = toCoord
      return ((y + (yd ?? 0)) * 6 + x + (xd ?? 0)).toRankFile
    }

    public func subtracting(x xd: Int? = nil, y yd: Int? = nil) -> RankFile? {
      let (x, y) = toCoord
      return ((y - (yd ?? 0)) * 6 + x - (xd ?? 0)).toRankFile
    }
  }

  // swiftlint:enable identifier_name
}
