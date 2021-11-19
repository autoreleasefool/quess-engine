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
    case "1": return 0
    case "2": return 1
    case "3": return 2
    case "4": return 3
    case "5": return 4
    case "6": return 5
    default: return nil
    }
  }

}
