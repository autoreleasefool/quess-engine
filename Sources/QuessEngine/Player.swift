//
//  Created by Joseph Roque on 2021-11-10.
//

import Foundation

public enum Player: Hashable {
  case white
  case black

  var next: Player {
    switch self {
    case .white: return .black
    case .black: return .white
    }
  }

  var opponent: Player {
    next
  }

}
