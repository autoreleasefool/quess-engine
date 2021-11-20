//
//  Created by Joseph Roque on 2021-11-19.
//
//    -----------------------------
// 6 |    |    |    | ▲1 | ●1 | ■  |
// 5 |    |    |    |    | ▲2 | ●2 |
// 4 |    |    |    |    |    | ▲3 |
// 3 | △1 |    |    |    |    |    |
// 2 | ○1 | △2 |    |    |    |    |
// 1 | □  | ○2 | △3 |    |    |    |
//    -----------------------------
//     A    B    C    D    E    F

@testable import QuessEngine
import XCTest

final class BoardTests: XCTestCase {

  func testRankFile() {
    XCTAssertEqual(Board.RankFile.A1.left, nil)
    XCTAssertEqual(Board.RankFile.A1.up, .A2)
    XCTAssertEqual(Board.RankFile.A1.right, .B1)
    XCTAssertEqual(Board.RankFile.A1.down, nil)

    XCTAssertEqual(Board.RankFile.F6.left, .E6)
    XCTAssertEqual(Board.RankFile.F6.up, nil)
    XCTAssertEqual(Board.RankFile.F6.right, nil)
    XCTAssertEqual(Board.RankFile.F6.down, .F5)
  }

}
