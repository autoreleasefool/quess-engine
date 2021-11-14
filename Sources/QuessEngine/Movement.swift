//
//  Created by Joseph Roque on 2021-11-11.
//

import Foundation

public struct Movement: Hashable {

  public let piece: Piece
  public let from: Board.Notation
  public let to: Board.Notation

  public init(piece: Piece, from: Board.Notation, to: Board.Notation) {
    self.piece = piece
    self.from = from
    self.to = to
  }

}
