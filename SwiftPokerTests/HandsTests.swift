//
//  HandsTests.swift
//  SwiftPoker-SampleApp
//
//  Created by Javier Soto on 9/20/16.
//  Copyright © 2016 Javier Soto. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftPoker

class HandsTests: XCTestCase {
    func testDoesntHaveFlush() {
        let cards = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .hearts, number: .two),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .five),
            Card(suit: .hearts, number: .king)
        ]

        XCTAssertFalse(cards.hasFlush)
    }

    func testHasFlush() {
        let cards = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .hearts, number: .two),
            Card(suit: .hearts, number: .three),
            Card(suit: .hearts, number: .five),
            Card(suit: .hearts, number: .king)
        ]

        XCTAssertTrue(cards.hasFlush)

        let cards2 = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .hearts, number: .two),
            Card(suit: .hearts, number: .three),
            Card(suit: .hearts, number: .five),
            Card(suit: .hearts, number: .king),
            Card(suit: .hearts, number: .queen)
        ]

        XCTAssertTrue(cards2.hasFlush)
    }

    func testDoesntHavePair() {
        let cards = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .spades, number: .two),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .five),
            Card(suit: .hearts, number: .king)
        ]

        XCTAssertFalse(cards.hasPair)
    }

    func testHasPair() {
        let cards = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .ace),
            Card(suit: .hearts, number: .king)
        ]

        XCTAssertTrue(cards.hasPair)
    }

    func testDoesntHaveThreeOfAKind() {
        let cards = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .ace),
            Card(suit: .hearts, number: .king)
        ]

        XCTAssertFalse(cards.hasThreeOfAKind)
    }

    func testHasThreeOfAKind() {
        let cards = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .jack),
            Card(suit: .spades, number: .ace),
            Card(suit: .clubs, number: .ace)
        ]

        XCTAssertTrue(cards.hasThreeOfAKind)
    }

    func testDoesntHaveTwoPairs() {
        let cards = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .jack),
            Card(suit: .hearts, number: .king)
        ]

        XCTAssertFalse(cards.hasTwoPairs)
    }

    func testHasTwoPairs() {
        let cards = [
            Card(suit: .hearts, number: .jack),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .ace),
            Card(suit: .clubs, number: .jack)
        ]

        XCTAssertTrue(cards.hasTwoPairs)

        let cards2 = [
            Card(suit: .hearts, number: .jack),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .ace),
            Card(suit: .clubs, number: .jack),
            Card(suit: .clubs, number: .queen),
            Card(suit: .clubs, number: .king)
        ]

        /// TODO: detect highest two-pairs
        XCTAssertTrue(cards2.hasTwoPairs)
    }
}
