//
//  Created by Joseph Roque on 2021-11-20.
//

import QuessEngine
import XCTest

struct StateProvider {

  let debugging: Bool

  init(debugging: Bool = false) {
    self.debugging = debugging
  }

  func buildState(withMoves moves: [String]) -> GameState {
    let state = GameState()
    moves.forEach {
      if debugging { print("Playing move \($0)") }
      XCTAssert(state.apply($0))
    }
    return state
  }

  func buildState(withMoves moves: String) -> GameState {
    let separatedMoves = moves
      .split(separator: ";")
      .map { $0.trimmingCharacters(in: .whitespaces) }
    return buildState(withMoves: separatedMoves)
  }

  func validMoves(fromNotation notation: [String]) -> [Movement] {
    notation
      .compactMap { Movement(cNotation: $0) }
  }

  func validNotation(fromNotation notation: [String]) -> [String] {
    validMoves(fromNotation: notation)
      .map(\.cNotation)
      .sorted()
  }

  func notation(fromMoves moves: [Movement]) -> [String] {
    moves.map(\.cNotation)
      .sorted()
  }

}
