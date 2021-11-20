//
//  Created by Joseph Roque on 2021-11-19.
//

@testable import QuessEngine
import XCTest

final class MovementTests: XCTestCase {

  let stateProvider = StateProvider(debugging: false)

  func testWhiteInitialValidMoves() {
    let state = stateProvider.buildState(withMoves: [])
    let expectedMoves = stateProvider.validNotation(fromNotation: [
      "wC1B4", "wC1C3",
      "wC2C3", "wC2D2",
      "wT1A4", "wT1B3",
      "wT2B3", "wT2C2",
      "wT3C2", "wT3D1",
    ])

    let possibleMoves = stateProvider.notation(fromMoves: state.allPossibleMoves())

    XCTAssertEqual(possibleMoves, expectedMoves)
  }

  func testBlackInitialValidMoves() {
    let state = stateProvider.buildState(withMoves: ["wT1A4"])

    let expectedMoves = stateProvider.validNotation(fromNotation: [
      "bC1C5", "bC1D4",
      "bC2D4", "bC2E3",
      "bT1C6", "bT1D5",
      "bT2D5", "bT2E4", "bT3E4", "bT3F3",
    ])

    let possibleMoves = stateProvider.notation(fromMoves: state.allPossibleMoves())

    XCTAssertEqual(possibleMoves, expectedMoves)
  }

  func testSquareMoves() {
    let state = stateProvider.buildState(withMoves: [
      "wT1A4", "bT1C6", "wC1C3", "bC1D4", "wT1A5", "bT1B6", "wSA4", "bSC6",
    ])

    let expectedWhiteSquareMoves = stateProvider.validNotation(fromNotation: [
      "wSA1", "wSA2", "wSA3", "wSB4", "wSC4", "wSD4",
    ])

    let possibleWhiteSquareMoves = stateProvider.notation(
      fromMoves: state.allPossibleMoves()
        .filter { $0.piece.class == .square }
    )

    XCTAssertEqual(possibleWhiteSquareMoves, expectedWhiteSquareMoves)

    XCTAssert(state.apply("wSA3"))

    let expectedBlackSquareMoves = stateProvider.validNotation(fromNotation: [
      "bSD6", "bSE6", "bSF6", "bSC5", "bSC4", "bSC3",
    ])

    let possibleBlackSquareMoves = stateProvider.notation(
      fromMoves: state.allPossibleMoves()
        .filter { $0.piece.class == .square }
    )

    XCTAssertEqual(possibleBlackSquareMoves, expectedBlackSquareMoves)
  }

  func testMoves() {
    let state = stateProvider.buildState(withMoves: "wT1A4; bC1C5; wC1C3; bC1D3; wC2D2; bC1C1")

    let expectedMoves = stateProvider.validNotation(fromNotation: [
      "wT1A3", "wT1B4", "wT1A5",
      "wT2A2", "wT2B3", "wT2B1", "wT2C2",
      "wSA2", "wSA3", "wSB1", "wSC1",
      "wC1B5", "wC1D5", "wC1E4", "wC1E2", "wC1D1", "wC1B1", "wC1A2",
      "wC2B1", "wC2B3", "wC2C4", "wC2E4", "wC2F3", "wC2F1",
    ])

    let possibleMoves = stateProvider.notation(fromMoves: state.allPossibleMoves())

    XCTAssertEqual(possibleMoves, expectedMoves)
  }

}
