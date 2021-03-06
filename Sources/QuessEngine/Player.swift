//
//  Created by Joseph Roque on 2021-11-10.
//

import Foundation

public enum Player: Hashable {
  case white
  case black

  public var next: Player {
    switch self {
    case .white: return .black
    case .black: return .white
    }
  }

  public var opponent: Player {
    next
  }

}
