//
//  Created by Joseph Roque on 2021-11-19.
//

import Foundation

extension Character {

  var file: Int? {
    switch self {
    case "A": return 0
    case "B": return 1
    case "C": return 2
    case "D": return 3
    case "E": return 4
    case "F": return 5
    default: return nil
    }
  }

  var rank: Int? {
    switch self {
    case "6": return 0
    case "5": return 1
    case "4": return 2
    case "3": return 3
    case "2": return 4
    case "1": return 5
    default: return nil
    }
  }

}

extension Int {

  var rankNotation: String {
    switch self {
    case 0: return "6"
    case 1: return "5"
    case 2: return "4"
    case 3: return "3"
    case 4: return "2"
    case 5: return "1"
    default: return ""
    }
  }

  var fileNotation: String {
    switch self {
    case 0: return "A"
    case 1: return "B"
    case 2: return "C"
    case 3: return "D"
    case 4: return "E"
    case 5: return "F"
    default: return ""
    }
  }

}

extension Board.RankFile {

  public var notation: String {
    let (x, y) = self.toCoord
    return "\(x.fileNotation)\(y.rankNotation)"
  }

  public init?(notation: String) {
    guard notation.count == 2,
          let x = notation.first?.file,
          let y = notation.last?.rank
    else {
      return nil
    }

    guard let rankFile = (y * 6 + x).toRankFile else { return nil }
    self = rankFile
  }

}

extension Player {

  public init?(notation: String) {
    switch notation {
    case "w": self = .white
    case "b": self = .black
    default: return nil
    }
  }

  public var notation: String {
    switch self {
    case .white: return "w"
    case .black: return "b"
    }
  }

}

extension Piece {

  public init?(notation: String) {
    guard (2...3).contains(notation.count),
          let owner = Player(notation: String(notation[notation.startIndex])),
          let `class` = Piece.Class(
            notation: String(notation[notation.index(after: notation.startIndex)])
          )
    else {
      return nil
    }

    self.owner = owner
    self.class = `class`

    guard !`class`.isUniquePerPlayer else {
      self.index = 1
      return
    }

    guard let index = Int(String(notation[notation.index(notation.startIndex, offsetBy: 2)])) else { return nil }
    self.index = index
  }

  public var notation: String {
    self.class.isUniquePerPlayer
      ? "\(self.owner.notation)\(self.class.notation)"
      : "\(self.owner.notation)\(self.class.notation)\(self.index)"
  }

}

extension Piece.Class {

  public init?(notation: String) {
    switch notation {
    case "C": self = .circle
    case "S": self = .square
    case "T": self = .triangle
    default: return nil
    }
  }

  public var notation: String {
    switch self {
    case .circle: return "C"
    case .square: return "S"
    case .triangle: return "T"
    }
  }

}

extension Movement {

  public var notation: String {
    "\(piece.notation)\(to.notation)"
  }

  public init?(notation: String) {
    guard (4...5).contains(notation.count),
          let piece = Piece(notation: String(notation.dropLast(2))),
          let to = Board.RankFile(notation: String(notation.suffix(2)))
    else {
      return nil
    }

    self.piece = piece
    self.to = to
  }

}

extension GameState {

  public func apply(_ notation: String) -> Bool {
    guard let movement = Movement(notation: notation) else { return false }
    return self.apply(movement)
  }

  public func historicalNotation() -> [String] {
    history.map(\.notation)
  }

}
