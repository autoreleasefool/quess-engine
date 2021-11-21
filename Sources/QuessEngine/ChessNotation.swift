//
//  Created by Joseph Roque on 2021-11-19.
//

import Foundation

private extension Character {

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

private extension Int {

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

  public var cNotation: String {
    let (x, y) = self.toCoord
    return "\(x.fileNotation)\(y.rankNotation)"
  }

  public init?(cNotation: String) {
    guard cNotation.count == 2,
          let x = cNotation.first?.file,
          let y = cNotation.last?.rank
    else {
      return nil
    }

    guard let rankFile = (y * 6 + x).toRankFile else { return nil }
    self = rankFile
  }

}

extension Player {

  public init?(cNotation: String) {
    switch cNotation {
    case "w": self = .white
    case "b": self = .black
    default: return nil
    }
  }

  public var cNotation: String {
    switch self {
    case .white: return "w"
    case .black: return "b"
    }
  }

}

extension Piece {

  public init?(cNotation: String) {
    guard (2...3).contains(cNotation.count),
          let owner = Player(cNotation: String(cNotation[cNotation.startIndex])),
          let `class` = Piece.Class(
            cNotation: String(cNotation[cNotation.index(after: cNotation.startIndex)])
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

    guard let index = Int(String(cNotation[cNotation.index(cNotation.startIndex, offsetBy: 2)])) else { return nil }
    self.index = index
  }

  public var cNotation: String {
    self.class.isUniquePerPlayer
      ? "\(self.owner.cNotation)\(self.class.cNotation)"
      : "\(self.owner.cNotation)\(self.class.cNotation)\(self.index)"
  }

}

extension Piece.Class {

  public init?(cNotation: String) {
    switch cNotation {
    case "C": self = .circle
    case "S": self = .square
    case "T": self = .triangle
    default: return nil
    }
  }

  public var cNotation: String {
    switch self {
    case .circle: return "C"
    case .square: return "S"
    case .triangle: return "T"
    }
  }

}

extension Movement {

  public var cNotation: String {
    "\(piece.cNotation)\(to.cNotation)"
  }

  public init?(cNotation: String) {
    guard (4...5).contains(cNotation.count),
          let piece = Piece(cNotation: String(cNotation.dropLast(2))),
          let to = Board.RankFile(cNotation: String(cNotation.suffix(2)))
    else {
      return nil
    }

    self.piece = piece
    self.to = to
  }

}

extension GameState {

  public func apply(_ cNotation: String) -> Bool {
    guard let movement = Movement(cNotation: cNotation) else { return false }
    return self.apply(movement)
  }

  public func historicalCNotation() -> [String] {
    history.map(\.cNotation)
  }

}
