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
            Card(number: .ace, suit: .clubs),
            Card(number: .two, suit: .hearts),
            Card(number: .three, suit: .hearts),
            Card(number: .king, suit: .clubs),
            Card(number: .queen, suit: .clubs),
            Card(number: .jack, suit: .clubs),
            Card(number: .ten, suit: .clubs)
        ]

        XCTAssertEqual(Hand(cards).kind, .royalFlush)

        let cards2: Set<Card> = [
            Card(number: .ace, suit: .clubs),
            Card(number: .king, suit: .diamonds),
            Card(number: .queen, suit: .clubs),
            Card(number: .jack, suit: .clubs),
            Card(number: .ten, suit: .clubs),
            Card(number: .two, suit: .hearts),
            Card(number: .three, suit: .clubs)
        ]

        XCTAssertNotEqual(Hand(cards2), .royalFlush)
    }

    func testStraightFlush() {
        let cards: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .two, suit: .hearts),
            Card(number: .three, suit: .hearts),
            Card(number: .four, suit: .hearts),
            Card(number: .jack, suit: .clubs),
            Card(number: .jack, suit: .diamonds),
            Card(number: .five, suit: .hearts)
        ]

        XCTAssertEqual(Hand(cards).kind, .straightFlush)

        let cards2: Set<Card> = [
            Card(number: .three, suit: .hearts),
            Card(number: .four, suit: .hearts),
            Card(number: .five, suit: .hearts),
            Card(number: .six, suit: .hearts),
            Card(number: .queen, suit: .diamonds),
            Card(number: .seven, suit: .hearts)
        ]

        XCTAssertEqual(Hand(cards2).kind, .straightFlush)
    }

    func testFourOfAKind() {
        let cards: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .ace, suit: .spades),
            Card(number: .ace, suit: .diamonds),
            Card(number: .ace, suit: .clubs),
            Card(number: .four, suit: .clubs)
        ]

        XCTAssertEqual(Hand(cards).kind, .fourOfAKind)
    }

    func testFullHouse() {
        let cards: Set<Card> = [
            Card(number: .three, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .diamonds),
            Card(number: .six, suit: .spades),
            Card(number: .ace, suit: .clubs),
            Card(number: .ace, suit: .hearts),
            Card(number: .two, suit: .clubs)
        ]

        XCTAssertEqual(Hand(cards).kind, .fullHouse)
    }

    func testFlush() {
        let cards: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .two, suit: .hearts),
            Card(number: .three, suit: .hearts),
            Card(number: .five, suit: .hearts),
            Card(number: .king, suit: .hearts)
        ]

        XCTAssertEqual(Hand(cards).kind, .flush)

        let cards2: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .two, suit: .hearts),
            Card(number: .three, suit: .hearts),
            Card(number: .five, suit: .hearts),
            Card(number: .king, suit: .hearts),
            Card(number: .king, suit: .hearts)
        ]

        XCTAssertEqual(Hand(cards2).kind, .flush)
    }

    func testStraight() {
        let cards: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .two, suit: .clubs),
            Card(number: .three, suit: .diamonds),
            Card(number: .four, suit: .hearts),
            Card(number: .jack, suit: .clubs),
            Card(number: .jack, suit: .hearts),
            Card(number: .five, suit: .hearts)
        ]

        XCTAssertEqual(Hand(cards).kind, .straight)

        let cards2: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .king, suit: .clubs),
            Card(number: .queen, suit: .diamonds),
            Card(number: .jack, suit: .hearts),
            Card(number: .ten, suit: .clubs),
            Card(number: .five, suit: .hearts)
        ]

        XCTAssertEqual(Hand(cards2).kind, .straight)
    }

    func testThreeOfAKind() {
        let cards: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .jack, suit: .hearts),
            Card(number: .ace, suit: .spades),
            Card(number: .ace, suit: .clubs)
        ]

        XCTAssertEqual(Hand(cards).kind, .threeOfAKind)
    }

    func testTwoPairs() {
        let cards: Set<Card> = [
            Card(number: .jack, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .ace, suit: .spades),
            Card(number: .jack, suit: .clubs)
        ]

        XCTAssertEqual(Hand(cards).kind, .twoPairs)

        let cards2: Set<Card> = [
            Card(number: .jack, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .ace, suit: .spades),
            Card(number: .jack, suit: .clubs),
            Card(number: .queen, suit: .clubs),
            Card(number: .king, suit: .clubs)
        ]

        /// TODO: detect highest two-pairs
        XCTAssertEqual(Hand(cards2).kind, .twoPairs)
    }

    func testPair() {
        let cards: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .eight, suit: .spades),
            Card(number: .king, suit: .hearts)
        ]

        XCTAssertEqual(Hand(cards).kind, .pair)
    }

    func testHasHighCard() {
        let cards: Set<Card> = [
            Card(number: .jack, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .four, suit: .hearts),
            Card(number: .ten, suit: .spades),
            Card(number: .queen, suit: .clubs),
            Card(number: .five, suit: .clubs),
            Card(number: .two, suit: .clubs)
        ]

        XCTAssertEqual(Hand(cards).kind, .highCard)
    }

    /// MARK: Hand priority

    func testFourOfAKind_HasPriority_OverFullHouse() {
        let cards: Set<Card> = [
            Card(number: .three, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .diamonds),
            Card(number: .three, suit: .clubs),
            Card(number: .ace, suit: .clubs),
            Card(number: .ace, suit: .diamonds),
            Card(number: .ace, suit: .hearts)
        ]

        XCTAssertNotEqual(Hand(cards).kind, .fullHouse)
        XCTAssertEqual(Hand(cards).kind, .fourOfAKind)
    }

    func testFullHouse_HasPriority_OverFlush() {
        let cards: Set<Card> = [
            Card(number: .three, suit: .hearts),
            Card(number: .three, suit: .diamonds),
            Card(number: .three, suit: .clubs),
            Card(number: .ace, suit: .hearts),
            Card(number: .ace, suit: .diamonds),
            Card(number: .jack, suit: .hearts),
            Card(number: .jack, suit: .clubs)
        ]

        XCTAssertNotEqual(Hand(cards).kind, .flush)
        XCTAssertEqual(Hand(cards).kind, .fullHouse)
    }

    func testFullHouse_HasPriority_OverTwoPairs() {
        let cards: Set<Card> = [
            Card(number: .three, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .clubs),
            Card(number: .ace, suit: .spades),
            Card(number: .ace, suit: .clubs),
            Card(number: .jack, suit: .clubs),
            Card(number: .jack, suit: .diamonds)
        ]

        XCTAssertNotEqual(Hand(cards).kind, .twoPairs)
        XCTAssertEqual(Hand(cards).kind, .fullHouse)
    }

    func testFlush_HasPriority_OverStraight() {
        let cards: Set<Card> = [
            Card(number: .two, suit: .spades),
            Card(number: .three, suit: .spades),
            Card(number: .four, suit: .hearts),
            Card(number: .five, suit: .hearts),
            Card(number: .six, suit: .hearts),
            Card(number: .jack, suit: .hearts),
            Card(number: .queen, suit: .hearts)
        ]

        XCTAssertNotEqual(Hand(cards).kind, .straight)
        XCTAssertEqual(Hand(cards).kind, .flush)
    }

    func testStraight_HasPriority_OverThreeOfAKind() {
        let cards: Set<Card> = [
            Card(number: .three, suit: .hearts),
            Card(number: .four, suit: .spades),
            Card(number: .five, suit: .hearts),
            Card(number: .six, suit: .spades),
            Card(number: .seven, suit: .clubs),
            Card(number: .seven, suit: .clubs),
            Card(number: .seven, suit: .clubs)
        ]

        XCTAssertNotEqual(Hand(cards).kind, .threeOfAKind)
        XCTAssertEqual(Hand(cards).kind, .straight)
    }
}
