//
//  Created by Joseph Roque on 2021-11-11.
//

import Foundation

public struct Movement: Hashable {

  public let piece: Piece
  public let to: Board.RankFile

  public init(piece: Piece, to: Board.RankFile) {
    self.piece = piece
    self.to = to
  }

}

public struct QuessMove: Hashable {

  public let from: Board.RankFile
  public let to: Board.RankFile

  public init(from: Board.RankFile, to: Board.RankFile) {
    self.from = from
    self.to = to
  }

}
