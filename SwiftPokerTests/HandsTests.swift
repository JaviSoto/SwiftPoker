//
//  HandsTests.swift
//  SwiftPoker-SampleApp
//
//  Created by Javier Soto on 9/20/16.
//  Copyright © 2016 Javier Soto. All rights reserved.
//

import Foundation
import XCTest
import SwiftPoker

final class HandsTests: XCTestCase {
    /// MARK: Hand detection

    func testRoyalFlush() {
        let cards: Set<Card> = [
            Card(suit: .clubs, number: .ace),
            Card(suit: .hearts, number: .two),
            Card(suit: .hearts, number: .three),
            Card(suit: .clubs, number: .king),
            Card(suit: .clubs, number: .queen),
            Card(suit: .clubs, number: .jack),
            Card(suit: .clubs, number: .ten)
        ]

        XCTAssertEqual(Hand(cards: cards).kind, .royalFlush)

        let cards2: Set<Card> = [
            Card(suit: .clubs, number: .ace),
            Card(suit: .diamonds, number: .king),
            Card(suit: .clubs, number: .queen),
            Card(suit: .clubs, number: .jack),
            Card(suit: .clubs, number: .ten),
            Card(suit: .hearts, number: .two),
            Card(suit: .clubs, number: .three)
        ]

        XCTAssertNotEqual(Hand(cards: cards2), .royalFlush)
    }

    func testStraightFlush() {
        let cards: Set<Card> = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .hearts, number: .two),
            Card(suit: .hearts, number: .three),
            Card(suit: .hearts, number: .four),
            Card(suit: .clubs, number: .jack),
            Card(suit: .diamonds, number: .jack),
            Card(suit: .hearts, number: .five)
        ]

        XCTAssertEqual(Hand(cards: cards).kind, .straightFlush)

        let cards2: Set<Card> = [
            Card(suit: .hearts, number: .three),
            Card(suit: .hearts, number: .four),
            Card(suit: .hearts, number: .five),
            Card(suit: .hearts, number: .six),
            Card(suit: .diamonds, number: .queen),
            Card(suit: .hearts, number: .seven)
        ]

        XCTAssertEqual(Hand(cards: cards2).kind, .straightFlush)
    }

    func testFourOfAKind() {
        let cards: Set<Card> = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .spades, number: .three),
            Card(suit: .spades, number: .ace),
            Card(suit: .diamonds, number: .ace),
            Card(suit: .clubs, number: .ace),
            Card(suit: .clubs, number: .four)
        ]

        XCTAssertEqual(Hand(cards: cards).kind, .fourOfAKind)
    }

    func testFullHouse() {
        let cards: Set<Card> = [
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .three),
            Card(suit: .diamonds, number: .three),
            Card(suit: .spades, number: .six),
            Card(suit: .clubs, number: .ace),
            Card(suit: .hearts, number: .ace),
            Card(suit: .clubs, number: .two)
        ]

        XCTAssertEqual(Hand(cards: cards).kind, .fullHouse)
    }

    func testFlush() {
        let cards: Set<Card> = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .hearts, number: .two),
            Card(suit: .hearts, number: .three),
            Card(suit: .hearts, number: .five),
            Card(suit: .hearts, number: .king)
        ]

        XCTAssertEqual(Hand(cards: cards).kind, .flush)

        let cards2: Set<Card> = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .hearts, number: .two),
            Card(suit: .hearts, number: .three),
            Card(suit: .hearts, number: .five),
            Card(suit: .hearts, number: .king),
            Card(suit: .hearts, number: .king)
        ]

        XCTAssertEqual(Hand(cards: cards2).kind, .flush)
    }

    func testStraight() {
        let cards: Set<Card> = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .clubs, number: .two),
            Card(suit: .diamonds, number: .three),
            Card(suit: .hearts, number: .four),
            Card(suit: .clubs, number: .jack),
            Card(suit: .hearts, number: .jack),
            Card(suit: .hearts, number: .five)
        ]

        XCTAssertEqual(Hand(cards: cards).kind, .straight)

        let cards2: Set<Card> = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .clubs, number: .king),
            Card(suit: .diamonds, number: .queen),
            Card(suit: .hearts, number: .jack),
            Card(suit: .clubs, number: .ten),
            Card(suit: .hearts, number: .five)
        ]

        XCTAssertEqual(Hand(cards: cards2).kind, .straight)
    }

    func testThreeOfAKind() {
        let cards: Set<Card> = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .jack),
            Card(suit: .spades, number: .ace),
            Card(suit: .clubs, number: .ace)
        ]

        XCTAssertEqual(Hand(cards: cards).kind, .threeOfAKind)
    }

    func testTwoPairs() {
        let cards: Set<Card> = [
            Card(suit: .hearts, number: .jack),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .ace),
            Card(suit: .clubs, number: .jack)
        ]

        XCTAssertEqual(Hand(cards: cards).kind, .twoPairs)

        let cards2: Set<Card> = [
            Card(suit: .hearts, number: .jack),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .ace),
            Card(suit: .clubs, number: .jack),
            Card(suit: .clubs, number: .queen),
            Card(suit: .clubs, number: .king)
        ]

        /// TODO: detect highest two-pairs
        XCTAssertEqual(Hand(cards: cards2).kind, .twoPairs)
    }

    func testPair() {
        let cards: Set<Card> = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .eight),
            Card(suit: .hearts, number: .king)
        ]

        XCTAssertEqual(Hand(cards: cards).kind, .pair)
    }

    func testHasHighCard() {
        let cards: Set<Card> = [
            Card(suit: .hearts, number: .jack),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .four),
            Card(suit: .spades, number: .ten),
            Card(suit: .clubs, number: .queen),
            Card(suit: .clubs, number: .five),
            Card(suit: .clubs, number: .two)
        ]

        XCTAssertEqual(Hand(cards: cards).kind, .highCard)
    }

    /// MARK: Hand priority

    func testFourOfAKind_HasPriority_OverFullHouse() {
        let cards: Set<Card> = [
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .three),
            Card(suit: .diamonds, number: .three),
            Card(suit: .clubs, number: .three),
            Card(suit: .clubs, number: .ace),
            Card(suit: .diamonds, number: .ace),
            Card(suit: .hearts, number: .ace)
        ]

        XCTAssertNotEqual(Hand(cards: cards).kind, .fullHouse)
        XCTAssertEqual(Hand(cards: cards).kind, .fourOfAKind)
    }

    func testFullHouse_HasPriority_OverFlush() {
        let cards: Set<Card> = [
            Card(suit: .hearts, number: .three),
            Card(suit: .diamonds, number: .three),
            Card(suit: .clubs, number: .three),
            Card(suit: .hearts, number: .ace),
            Card(suit: .diamonds, number: .ace),
            Card(suit: .hearts, number: .jack),
            Card(suit: .clubs, number: .jack)
        ]

        XCTAssertNotEqual(Hand(cards: cards).kind, .flush)
        XCTAssertEqual(Hand(cards: cards).kind, .fullHouse)
    }

    func testFullHouse_HasPriority_OverTwoPairs() {
        let cards: Set<Card> = [
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .three),
            Card(suit: .clubs, number: .three),
            Card(suit: .spades, number: .ace),
            Card(suit: .clubs, number: .ace),
            Card(suit: .clubs, number: .jack),
            Card(suit: .diamonds, number: .jack)
        ]

        XCTAssertNotEqual(Hand(cards: cards).kind, .twoPairs)
        XCTAssertEqual(Hand(cards: cards).kind, .fullHouse)
    }

    func testFlush_HasPriority_OverStraight() {
        let cards: Set<Card> = [
            Card(suit: .spades, number: .two),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .four),
            Card(suit: .hearts, number: .five),
            Card(suit: .hearts, number: .six),
            Card(suit: .hearts, number: .jack),
            Card(suit: .hearts, number: .queen)
        ]

        XCTAssertNotEqual(Hand(cards: cards).kind, .straight)
        XCTAssertEqual(Hand(cards: cards).kind, .flush)
    }

    func testStraight_HasPriority_OverThreeOfAKind() {
        let cards: Set<Card> = [
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .four),
            Card(suit: .hearts, number: .five),
            Card(suit: .spades, number: .six),
            Card(suit: .clubs, number: .seven),
            Card(suit: .clubs, number: .seven),
            Card(suit: .clubs, number: .seven)
        ]

        XCTAssertNotEqual(Hand(cards: cards).kind, .threeOfAKind)
        XCTAssertEqual(Hand(cards: cards).kind, .straight)
    }
}
