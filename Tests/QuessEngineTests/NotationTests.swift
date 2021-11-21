//
//  Created by Joseph Roque on 2021-11-20.
//
// Chess
//     -----------------------
//  6 |   |   |   | ▲ | ● | ■ |
//  5 |   |   |   |   | ▲ | ● |
//  4 |   |   |   |   |   | ▲ |
//  3 | △ |   |   |   |   |   |
//  2 | ○ | △ |   |   |   |   |
//  1 | □ | ○ | △ |   |   |   |
//     -----------------------
//      A   B   C   D   E   F
//
// Quess
//     -----------------------
//  A |   |   |   | ▲ | ● | ■ |
//  B |   |   |   |   | ▲ | ● |
//  C |   |   |   |   |   | ▲ |
//  D | △ |   |   |   |   |   |
//  E | ○ | △ |   |   |   |   |
//  F | □ | ○ | △ |   |   |   |
//     -----------------------
//      1   2   3   4   5   6

@testable import QuessEngine
import XCTest

final class NotationTests: XCTestCase {

  func testQuessNotationToChess() {
    XCTAssertEqual(Board.RankFile(qNotation: "A1"), .A6)
    XCTAssertEqual(Board.RankFile(qNotation: "A2"), .B6)
    XCTAssertEqual(Board.RankFile(qNotation: "A3"), .C6)
    XCTAssertEqual(Board.RankFile(qNotation: "A4"), .D6)
    XCTAssertEqual(Board.RankFile(qNotation: "A5"), .E6)
    XCTAssertEqual(Board.RankFile(qNotation: "A6"), .F6)

    XCTAssertEqual(Board.RankFile(qNotation: "B1"), .A5)
    XCTAssertEqual(Board.RankFile(qNotation: "B2"), .B5)
    XCTAssertEqual(Board.RankFile(qNotation: "B3"), .C5)
    XCTAssertEqual(Board.RankFile(qNotation: "B4"), .D5)
    XCTAssertEqual(Board.RankFile(qNotation: "B5"), .E5)
    XCTAssertEqual(Board.RankFile(qNotation: "B6"), .F5)

    XCTAssertEqual(Board.RankFile(qNotation: "C1"), .A4)
    XCTAssertEqual(Board.RankFile(qNotation: "C2"), .B4)
    XCTAssertEqual(Board.RankFile(qNotation: "C3"), .C4)
    XCTAssertEqual(Board.RankFile(qNotation: "C4"), .D4)
    XCTAssertEqual(Board.RankFile(qNotation: "C5"), .E4)
    XCTAssertEqual(Board.RankFile(qNotation: "C6"), .F4)

    XCTAssertEqual(Board.RankFile(qNotation: "D1"), .A3)
    XCTAssertEqual(Board.RankFile(qNotation: "D2"), .B3)
    XCTAssertEqual(Board.RankFile(qNotation: "D3"), .C3)
    XCTAssertEqual(Board.RankFile(qNotation: "D4"), .D3)
    XCTAssertEqual(Board.RankFile(qNotation: "D5"), .E3)
    XCTAssertEqual(Board.RankFile(qNotation: "D6"), .F3)

    XCTAssertEqual(Board.RankFile(qNotation: "E1"), .A2)
    XCTAssertEqual(Board.RankFile(qNotation: "E2"), .B2)
    XCTAssertEqual(Board.RankFile(qNotation: "E3"), .C2)
    XCTAssertEqual(Board.RankFile(qNotation: "E4"), .D2)
    XCTAssertEqual(Board.RankFile(qNotation: "E5"), .E2)
    XCTAssertEqual(Board.RankFile(qNotation: "E6"), .F2)

    XCTAssertEqual(Board.RankFile(qNotation: "F1"), .A1)
    XCTAssertEqual(Board.RankFile(qNotation: "F2"), .B1)
    XCTAssertEqual(Board.RankFile(qNotation: "F3"), .C1)
    XCTAssertEqual(Board.RankFile(qNotation: "F4"), .D1)
    XCTAssertEqual(Board.RankFile(qNotation: "F5"), .E1)
    XCTAssertEqual(Board.RankFile(qNotation: "F6"), .F1)
  }

  func testChessToQuessNotation() {
    XCTAssertEqual(Board.RankFile.A1.qNotation, "F1")
    XCTAssertEqual(Board.RankFile.A2.qNotation, "E1")
    XCTAssertEqual(Board.RankFile.A3.qNotation, "D1")
    XCTAssertEqual(Board.RankFile.A4.qNotation, "C1")
    XCTAssertEqual(Board.RankFile.A5.qNotation, "B1")
    XCTAssertEqual(Board.RankFile.A6.qNotation, "A1")

    XCTAssertEqual(Board.RankFile.B1.qNotation, "F2")
    XCTAssertEqual(Board.RankFile.B2.qNotation, "E2")
    XCTAssertEqual(Board.RankFile.B3.qNotation, "D2")
    XCTAssertEqual(Board.RankFile.B4.qNotation, "C2")
    XCTAssertEqual(Board.RankFile.B5.qNotation, "B2")
    XCTAssertEqual(Board.RankFile.B6.qNotation, "A2")

    XCTAssertEqual(Board.RankFile.C1.qNotation, "F3")
    XCTAssertEqual(Board.RankFile.C2.qNotation, "E3")
    XCTAssertEqual(Board.RankFile.C3.qNotation, "D3")
    XCTAssertEqual(Board.RankFile.C4.qNotation, "C3")
    XCTAssertEqual(Board.RankFile.C5.qNotation, "B3")
    XCTAssertEqual(Board.RankFile.C6.qNotation, "A3")

    XCTAssertEqual(Board.RankFile.D1.qNotation, "F4")
    XCTAssertEqual(Board.RankFile.D2.qNotation, "E4")
    XCTAssertEqual(Board.RankFile.D3.qNotation, "D4")
    XCTAssertEqual(Board.RankFile.D4.qNotation, "C4")
    XCTAssertEqual(Board.RankFile.D5.qNotation, "B4")
    XCTAssertEqual(Board.RankFile.D6.qNotation, "A4")

    XCTAssertEqual(Board.RankFile.E1.qNotation, "F5")
    XCTAssertEqual(Board.RankFile.E2.qNotation, "E5")
    XCTAssertEqual(Board.RankFile.E3.qNotation, "D5")
    XCTAssertEqual(Board.RankFile.E4.qNotation, "C5")
    XCTAssertEqual(Board.RankFile.E5.qNotation, "B5")
    XCTAssertEqual(Board.RankFile.E6.qNotation, "A5")

    XCTAssertEqual(Board.RankFile.F1.qNotation, "F6")
    XCTAssertEqual(Board.RankFile.F2.qNotation, "E6")
    XCTAssertEqual(Board.RankFile.F3.qNotation, "D6")
    XCTAssertEqual(Board.RankFile.F4.qNotation, "C6")
    XCTAssertEqual(Board.RankFile.F5.qNotation, "B6")
    XCTAssertEqual(Board.RankFile.F6.qNotation, "A6")
  }

}
