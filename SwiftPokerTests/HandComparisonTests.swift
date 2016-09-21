//
//  HandComparisonTests.swift
//  SwiftPoker-SampleApp
//
//  Created by Javier Soto on 9/20/16.
//  Copyright © 2016 Javier Soto. All rights reserved.
//

import Foundation
import XCTest
import SwiftPoker

final class HandKindTests: XCTestCase {
    func testOrdering() {
        let kinds: [Hand.Kind] = [.highCard, .pair, .twoPairs, .threeOfAKind, .straight, .flush, .fullHouse, .fourOfAKind, .straightFlush, .royalFlush]

        let unsortedKinds = Set(kinds)

        let sortedKinds = unsortedKinds.sorted(by: <)

        XCTAssertEqual(sortedKinds, kinds)
    }
}

final class HandComparisonTests: XCTestCase {
    func test2RoyalFlushesAreEqual() {
        let cards1: Set<Card> = [
            Card(suit: .clubs, number: .ace),
            Card(suit: .hearts, number: .two),
            Card(suit: .hearts, number: .three),
            Card(suit: .clubs, number: .king),
            Card(suit: .clubs, number: .queen),
            Card(suit: .clubs, number: .jack),
            Card(suit: .clubs, number: .ten)
        ]

        let cards2: Set<Card> = [
            Card(suit: .diamonds, number: .ace),
            Card(suit: .hearts, number: .two),
            Card(suit: .hearts, number: .three),
            Card(suit: .diamonds, number: .king),
            Card(suit: .diamonds, number: .queen),
            Card(suit: .diamonds, number: .jack),
            Card(suit: .diamonds, number: .ten)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand2)
    }

    func testHighestCardOfStraightFlushWins() {
        let cards1: Set<Card> = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .hearts, number: .two),
            Card(suit: .hearts, number: .three),
            Card(suit: .hearts, number: .four),
            Card(suit: .clubs, number: .jack),
            Card(suit: .diamonds, number: .jack),
            Card(suit: .hearts, number: .five)
        ]

        let cards2: Set<Card> = [
            Card(suit: .hearts, number: .three),
            Card(suit: .hearts, number: .four),
            Card(suit: .hearts, number: .five),
            Card(suit: .hearts, number: .six),
            Card(suit: .diamonds, number: .queen),
            Card(suit: .hearts, number: .seven)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand2, hand1)
    }

    func testHighestCardWins() {
        let cards1: Set<Card> = [
            Card(suit: .hearts, number: .jack),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .four),
            Card(suit: .spades, number: .ten),
            Card(suit: .clubs, number: .queen),
            Card(suit: .clubs, number: .five),
            Card(suit: .clubs, number: .two)
        ]

        let cards2: Set<Card> = [
            Card(suit: .hearts, number: .jack),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .four),
            Card(suit: .spades, number: .ten),
            Card(suit: .clubs, number: .queen),
            Card(suit: .clubs, number: .five),
            Card(suit: .clubs, number: .ace)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand1, hand2)
    }

    func testHighestPairWins() {
        let cards1: Set<Card> = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .eight),
            Card(suit: .hearts, number: .king)
        ]

        let cards2: Set<Card> = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .spades, number: .four),
            Card(suit: .hearts, number: .four),
            Card(suit: .spades, number: .eight),
            Card(suit: .hearts, number: .king)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertLessThan(hand1, hand2)
    }

    func testHighestKickerWithSamePairWins() {
        let cards1: Set<Card> = [
            Card(suit: .hearts, number: .ace),
            Card(suit: .spades, number: .three),
            Card(suit: .diamonds, number: .king),
            Card(suit: .spades, number: .eight),
            Card(suit: .hearts, number: .king)
        ]

        let cards2: Set<Card> = [
            Card(suit: .hearts, number: .jack),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .king),
            Card(suit: .spades, number: .eight),
            Card(suit: .diamonds, number: .king)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(Hand(cards2), Hand(cards1))
    }

    func testHighestTwoPairWins() {
        let cards1: Set<Card> = [
            Card(suit: .hearts, number: .jack),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .ace),
            Card(suit: .clubs, number: .jack)
        ]

        let cards2: Set<Card> = [
            Card(suit: .hearts, number: .king),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .ace),
            Card(suit: .clubs, number: .king)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand1, hand2)
    }

    func testSecondHighestTwoPairWins() {
        let cards1: Set<Card> = [
            Card(suit: .hearts, number: .king),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .ace),
            Card(suit: .clubs, number: .king)
        ]

        let cards2: Set<Card> = [
            Card(suit: .hearts, number: .king),
            Card(suit: .spades, number: .four),
            Card(suit: .hearts, number: .four),
            Card(suit: .spades, number: .ace),
            Card(suit: .clubs, number: .king)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand1, hand2)
    }

    func testSameTwoPairsKickerWins() {
        let cards1: Set<Card> = [
            Card(suit: .hearts, number: .king),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .ten),
            Card(suit: .clubs, number: .king)
        ]

        let cards2: Set<Card> = [
            Card(suit: .hearts, number: .king),
            Card(suit: .spades, number: .three),
            Card(suit: .hearts, number: .three),
            Card(suit: .spades, number: .ace),
            Card(suit: .clubs, number: .king)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand1, hand2)
    }
}
