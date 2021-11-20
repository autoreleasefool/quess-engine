//
//  Created by Joseph Roque on 2021-11-19.
//

@testable import QuessEngine
import XCTest

final class MovementTests: XCTestCase {

  func testWhiteInitialValidMoves() {
    let state = GameState()
    let expectedMoves = [
      Movement(notation: "wC1B4"),
      Movement(notation: "wC1C3"),
      Movement(notation: "wC2C3"),
      Movement(notation: "wC2D2"),
      Movement(notation: "wT1A4"),
      Movement(notation: "wT1B3"),
      Movement(notation: "wT2B3"),
      Movement(notation: "wT2C2"),
      Movement(notation: "wT3C2"),
      Movement(notation: "wT3D1"),
    ].compactMap { $0 }
      .map(\.notation)
      .sorted()

    let possibleMoves = state.allPossibleMoves()
      .map(\.notation)
      .sorted()

    XCTAssertEqual(possibleMoves, expectedMoves)
  }

  func testBlackInitialValidMoves() {
    let state = GameState()
    _ = state.apply("wT1A4")

    let expectedMoves = [
      Movement(notation: "bC1C5"),
      Movement(notation: "bC1D4"),
      Movement(notation: "bC2D4"),
      Movement(notation: "bC2E3"),
      Movement(notation: "bT1C6"),
      Movement(notation: "bT1D5"),
      Movement(notation: "bT2D5"),
      Movement(notation: "bT2E4"),
      Movement(notation: "bT3E4"),
      Movement(notation: "bT3F3"),
    ].compactMap { $0 }
      .map(\.notation)
      .sorted()

    let possibleMoves = state.allPossibleMoves()
      .map(\.notation)
      .sorted()

    XCTAssertEqual(possibleMoves, expectedMoves)
  }

  func testSquareMoves() {
    let state = GameState()
    XCTAssert(state.apply("wT1A4"))
    XCTAssert(state.apply("bT1C6"))
    XCTAssert(state.apply("wC1C3"))
    XCTAssert(state.apply("bC1D4"))
    XCTAssert(state.apply("wT1A5"))
    XCTAssert(state.apply("bT1B6"))
    XCTAssert(state.apply("wSA4"))
    XCTAssert(state.apply("bSC6"))

    let expectedWhiteSquareMoves = [
      Movement(notation: "wSA1"),
      Movement(notation: "wSA2"),
      Movement(notation: "wSA3"),
      Movement(notation: "wSB4"),
      Movement(notation: "wSC4"),
      Movement(notation: "wSD4"),
    ].compactMap { $0 }
      .map(\.notation)
      .sorted()

    let possibleWhiteSquareMoves = state.allPossibleMoves()
      .filter { $0.piece.class == .square }
      .map(\.notation)
      .sorted()

    XCTAssertEqual(possibleWhiteSquareMoves, expectedWhiteSquareMoves)

    XCTAssert(state.apply("wSA3"))

    let expectedBlackSquareMoves = [
      Movement(notation: "bSD6"),
      Movement(notation: "bSE6"),
      Movement(notation: "bSF6"),
      Movement(notation: "bSC5"),
      Movement(notation: "bSC4"),
      Movement(notation: "bSC3"),
    ].compactMap { $0 }
      .map(\.notation)
      .sorted()

    let possibleBlackSquareMoves = state.allPossibleMoves()
      .filter { $0.piece.class == .square }
      .map(\.notation)
      .sorted()

    XCTAssertEqual(possibleBlackSquareMoves, expectedBlackSquareMoves)
  }

}
