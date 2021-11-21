//
//  Created by Joseph Roque on 2021-11-20.
//

import Foundation

private extension Character {

  var file: Int? {
    switch self {
    case "1": return 0
    case "2": return 1
    case "3": return 2
    case "4": return 3
    case "5": return 4
    case "6": return 5
    default: return nil
    }
  }

  var rank: Int? {
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

}

private extension Int {

  var rankNotation: String {
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

  var fileNotation: String {
    switch self {
    case 0: return "1"
    case 1: return "2"
    case 2: return "3"
    case 3: return "4"
    case 4: return "5"
    case 5: return "6"
    default: return ""
    }
  }

}

extension Board.RankFile {

  public var qNotation: String {
    let (x, y) = self.toCoord
    return "\(y.rankNotation)\(x.fileNotation)"
  }

  public init?(qNotation: String) {
    guard qNotation.count == 2,
          let y = qNotation.first?.rank,
          let x = qNotation.last?.file
    else {
      return nil
    }

    guard let rankFile = (y * 6 + x).toRankFile else { return nil }
    self = rankFile
  }

}

extension QuessMove {

  public var qNotation: String {
    "\(from.qNotation)\(to.qNotation)"
  }

  public init?(qNotation: String) {
    guard qNotation.count == 4,
          let from = Board.RankFile(qNotation: String(qNotation.prefix(2))),
          let to = Board.RankFile(qNotation: String(qNotation.suffix(2)))
    else {
      return nil
    }

    self.from = from
    self.to = to
  }

}

extension GameState {

  public func apply(qNotation: String) -> Bool {
    guard let move = QuessMove(qNotation: qNotation) else { return false }
    return self.apply(move)
  }

  public func historicalQNotation() -> [String] {
    updates.map { "\($0.from.qNotation)\($0.movement.to.qNotation)" }
  }

}
