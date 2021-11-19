//
//  Created by Joseph Roque on 2021-11-12.
//

import Foundation

extension Int {

  public var toRankFile: Board.RankFile? {
    Board.RankFile(rawValue: self)
  }

}
