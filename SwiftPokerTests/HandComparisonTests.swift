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
    func testHighestCardOfStraightFlushWins() {
        let cards1: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .two, suit: .hearts),
            Card(number: .three, suit: .hearts),
            Card(number: .four, suit: .hearts),
            Card(number: .jack, suit: .clubs),
            Card(number: .jack, suit: .diamonds),
            Card(number: .five, suit: .hearts)
        ]

        let cards2: Set<Card> = [
            Card(number: .three, suit: .hearts),
            Card(number: .four, suit: .hearts),
            Card(number: .five, suit: .hearts),
            Card(number: .six, suit: .hearts),
            Card(number: .queen, suit: .diamonds),
            Card(number: .seven, suit: .hearts)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand1, hand2)
    }

    func testHighestCardWins() {
        let cards1: Set<Card> = [
            Card(number: .jack, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .four, suit: .hearts),
            Card(number: .ten, suit: .spades),
            Card(number: .queen, suit: .clubs),
            Card(number: .five, suit: .clubs),
            Card(number: .two, suit: .clubs)
        ]

        let cards2: Set<Card> = [
            Card(number: .jack, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .four, suit: .hearts),
            Card(number: .ten, suit: .spades),
            Card(number: .queen, suit: .clubs),
            Card(number: .five, suit: .clubs),
            Card(number: .ace, suit: .clubs)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand1, hand2)
    }

    func testHighestPairWins() {
        let cards1: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .eight, suit: .spades),
            Card(number: .king, suit: .hearts)
        ]

        let cards2: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .four, suit: .spades),
            Card(number: .four, suit: .hearts),
            Card(number: .eight, suit: .spades),
            Card(number: .king, suit: .hearts)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertLessThan(hand1, hand2)
    }

    func testHighestKickerWithSamePairWins() {
        let cards1: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .king, suit: .diamonds),
            Card(number: .eight, suit: .spades),
            Card(number: .king, suit: .hearts)
        ]

        let cards2: Set<Card> = [
            Card(number: .jack, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .king, suit: .hearts),
            Card(number: .eight, suit: .spades),
            Card(number: .king, suit: .diamonds)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(Hand(cards2), Hand(cards1))
    }

    func testHighestTwoPairWins() {
        let cards1: Set<Card> = [
            Card(number: .jack, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .ace, suit: .spades),
            Card(number: .jack, suit: .clubs)
        ]

        let cards2: Set<Card> = [
            Card(number: .king, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .ace, suit: .spades),
            Card(number: .king, suit: .clubs)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand1, hand2)
    }

    func testSecondHighestTwoPairWins() {
        let cards1: Set<Card> = [
            Card(number: .king, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .ace, suit: .spades),
            Card(number: .king, suit: .clubs)
        ]

        let cards2: Set<Card> = [
            Card(number: .king, suit: .hearts),
            Card(number: .four, suit: .spades),
            Card(number: .four, suit: .hearts),
            Card(number: .ace, suit: .spades),
            Card(number: .king, suit: .clubs)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand1, hand2)
    }

    func testSameTwoPairsKickerWins() {
        let cards1: Set<Card> = [
            Card(number: .king, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .ten, suit: .spades),
            Card(number: .king, suit: .clubs)
        ]

        let cards2: Set<Card> = [
            Card(number: .king, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .ace, suit: .spades),
            Card(number: .king, suit: .clubs)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand1, hand2)
    }

    func testHighestThreeOfAKindWins() {
        let cards1: Set<Card> = [
            Card(number: .king, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .three, suit: .diamonds),
            Card(number: .jack, suit: .clubs)
        ]

        let cards2: Set<Card> = [
            Card(number: .king, suit: .hearts),
            Card(number: .five, suit: .spades),
            Card(number: .five, suit: .hearts),
            Card(number: .five, suit: .diamonds),
            Card(number: .jack, suit: .clubs)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand1, hand2)
    }

    func testHighestThreeOfAKindKickerWins() {
        let cards1: Set<Card> = [
            Card(number: .king, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .three, suit: .diamonds),
            Card(number: .jack, suit: .clubs)
        ]

        let cards2: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .three, suit: .diamonds),
            Card(number: .jack, suit: .clubs)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand1, hand2)
    }

    func testSecondHighestThreeOfAKindKickerWins() {
        let cards1: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .three, suit: .diamonds),
            Card(number: .jack, suit: .clubs)
        ]

        let cards2: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .three, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .three, suit: .diamonds),
            Card(number: .ten, suit: .clubs)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand2, hand1)
    }

    func testHighestStraightCardWins() {
        let cards1: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .king, suit: .spades),
            Card(number: .queen, suit: .hearts),
            Card(number: .jack, suit: .diamonds),
            Card(number: .ten, suit: .clubs),
            Card(number: .seven, suit: .clubs)
        ]

        let cards2: Set<Card> = [
            Card(number: .five, suit: .hearts),
            Card(number: .king, suit: .spades),
            Card(number: .queen, suit: .hearts),
            Card(number: .jack, suit: .diamonds),
            Card(number: .ten, suit: .clubs),
            Card(number: .nine, suit: .clubs)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand2, hand1)
    }

    func testHighestStraightCardWithAceLowestCardWins() {
        let cards1: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .two, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .four, suit: .diamonds),
            Card(number: .five, suit: .clubs),
            Card(number: .seven, suit: .clubs)
        ]

        let cards2: Set<Card> = [
            Card(number: .two, suit: .spades),
            Card(number: .three, suit: .hearts),
            Card(number: .four, suit: .diamonds),
            Card(number: .five, suit: .clubs),
            Card(number: .six, suit: .clubs),
            Card(number: .ten, suit: .clubs)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand1, hand2)
    }

    func testHighestFlushCardWins() {
        let cards1: Set<Card> = [
            Card(number: .three, suit: .hearts),
            Card(number: .ace, suit: .hearts),
            Card(number: .queen, suit: .hearts),
            Card(number: .jack, suit: .hearts),
            Card(number: .ten, suit: .hearts)
        ]

        let cards2: Set<Card> = [
            Card(number: .seven, suit: .diamonds),
            Card(number: .king, suit: .diamonds),
            Card(number: .queen, suit: .diamonds),
            Card(number: .jack, suit: .diamonds),
            Card(number: .ten, suit: .diamonds)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand2, hand1)
    }

    func testHighestFlushLastCardWins() {
        let cards1: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .king, suit: .hearts),
            Card(number: .queen, suit: .hearts),
            Card(number: .jack, suit: .hearts),
            Card(number: .ten, suit: .hearts)
        ]

        let cards2: Set<Card> = [
            Card(number: .ace, suit: .diamonds),
            Card(number: .seven, suit: .diamonds),
            Card(number: .queen, suit: .diamonds),
            Card(number: .jack, suit: .diamonds),
            Card(number: .ten, suit: .diamonds)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand2, hand1)
    }

    func testHighestFullHouseThreeOfAKindWins() {
        let cards1: Set<Card> = [
            Card(number: .king, suit: .hearts),
            Card(number: .king, suit: .diamonds),
            Card(number: .king, suit: .spades),
            Card(number: .jack, suit: .diamonds),
            Card(number: .jack, suit: .hearts)
        ]

        let cards2: Set<Card> = [
            Card(number: .queen, suit: .hearts),
            Card(number: .queen, suit: .diamonds),
            Card(number: .queen, suit: .spades),
            Card(number: .jack, suit: .diamonds),
            Card(number: .jack, suit: .hearts)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand2, hand1)
    }

    func testFullHouseWithSameThreeOfAKindHighestPairWins() {
        let cards1: Set<Card> = [
            Card(number: .king, suit: .hearts),
            Card(number: .king, suit: .diamonds),
            Card(number: .king, suit: .spades),
            Card(number: .jack, suit: .diamonds),
            Card(number: .jack, suit: .hearts)
        ]

        let cards2: Set<Card> = [
            Card(number: .king, suit: .hearts),
            Card(number: .king, suit: .diamonds),
            Card(number: .king, suit: .spades),
            Card(number: .ten, suit: .diamonds),
            Card(number: .ten, suit: .hearts)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand2, hand1)
    }

    func testHigherFourOfAKindWins() {
        let cards1: Set<Card> = [
            Card(number: .king, suit: .hearts),
            Card(number: .king, suit: .diamonds),
            Card(number: .king, suit: .spades),
            Card(number: .king, suit: .clubs),
            Card(number: .jack, suit: .hearts)
        ]

        let cards2: Set<Card> = [
            Card(number: .queen, suit: .hearts),
            Card(number: .queen, suit: .diamonds),
            Card(number: .queen, suit: .spades),
            Card(number: .queen, suit: .clubs),
            Card(number: .jack, suit: .hearts)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand2, hand1)
    }

    func testFourOfAKindWithHigherKickerWins() {
        let cards1: Set<Card> = [
            Card(number: .seven, suit: .hearts),
            Card(number: .seven, suit: .diamonds),
            Card(number: .seven, suit: .spades),
            Card(number: .seven, suit: .clubs),
            Card(number: .jack, suit: .hearts)
        ]

        let cards2: Set<Card> = [
            Card(number: .seven, suit: .hearts),
            Card(number: .seven, suit: .diamonds),
            Card(number: .seven, suit: .spades),
            Card(number: .seven, suit: .clubs),
            Card(number: .ace, suit: .hearts)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand1, hand2)
    }

    func testStraightFlushWithHighestCardWins() {
        let cards1: Set<Card> = [
            Card(number: .ace, suit: .hearts),
            Card(number: .king, suit: .hearts),
            Card(number: .queen, suit: .hearts),
            Card(number: .jack, suit: .hearts),
            Card(number: .ten, suit: .hearts),
            Card(number: .seven, suit: .clubs)
        ]

        let cards2: Set<Card> = [
            Card(number: .five, suit: .hearts),
            Card(number: .king, suit: .spades),
            Card(number: .queen, suit: .spades),
            Card(number: .jack, suit: .spades),
            Card(number: .ten, suit: .spades),
            Card(number: .nine, suit: .spades)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        XCTAssertLessThan(hand2, hand1)
    }

    func testStraightFlushWithHighestCardAceLowestCardWins() {
        let cards1: Set<Card> = [
            Card(number: .ace, suit: .spades),
            Card(number: .two, suit: .spades),
            Card(number: .three, suit: .spades),
            Card(number: .four, suit: .spades),
            Card(number: .five, suit: .spades),
            Card(number: .seven, suit: .clubs)
        ]

        let cards2: Set<Card> = [
            Card(number: .two, suit: .spades),
            Card(number: .three, suit: .spades),
            Card(number: .four, suit: .spades),
            Card(number: .five, suit: .spades),
            Card(number: .six, suit: .spades),
            Card(number: .ten, suit: .clubs)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand1)
        XCTAssertEqual(hand2, hand2)
        /// FIX-ME: Broken test: the number comparison here is only done with Ace being the highest card
        XCTAssertLessThan(hand1, hand2)
    }

    func test2RoyalFlushesAreEqual() {
        let cards1: Set<Card> = [
            Card(number: .ace, suit: .clubs),
            Card(number: .two, suit: .hearts),
            Card(number: .three, suit: .hearts),
            Card(number: .king, suit: .clubs),
            Card(number: .queen, suit: .clubs),
            Card(number: .jack, suit: .clubs),
            Card(number: .ten, suit: .clubs)
        ]

        let cards2: Set<Card> = [
            Card(number: .ace, suit: .diamonds),
            Card(number: .two, suit: .hearts),
            Card(number: .three, suit: .hearts),
            Card(number: .king, suit: .diamonds),
            Card(number: .queen, suit: .diamonds),
            Card(number: .jack, suit: .diamonds),
            Card(number: .ten, suit: .diamonds)
        ]

        let hand1 = Hand(cards1)
        let hand2 = Hand(cards2)

        XCTAssertEqual(hand1, hand2)
        XCTAssertFalse(hand1 < hand2)
        XCTAssertFalse(hand2 < hand1)
    }
}
