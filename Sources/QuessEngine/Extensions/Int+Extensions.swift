//
//  Created by Joseph Roque on 2021-11-12.
//

import Foundation

extension Int {

  public var toRankFile: Board.RankFile? {
    Board.RankFile(rawValue: self)
  }

  var rankNotation: String {
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
