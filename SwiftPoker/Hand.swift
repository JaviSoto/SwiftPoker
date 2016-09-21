//
//  Hand.swift
//  SwiftPoker-SampleApp
//
//  Created by Javier Soto on 9/20/16.
//  Copyright © 2016 Javier Soto. All rights reserved.
//

import Foundation

public enum Hand {
    case highCard
    case pair
    case twoPairs
    case threeOfAKind
    case straight
    case flush
    case fullHouse
    case fourOfAKind
    case straightFlush
    case royalFlush

    /// Determine the hand given a set of [2, 7] cards.
    public init<S: Collection>(cards: S) where S.Iterator.Element == Card, S.IndexDistance == Int {
        precondition(!cards.isEmpty)
        precondition(cards.count <= 7)

        if cards.hasRoyalFlush {
            self = .royalFlush
        } else if cards.hasStraightFlush {
            self = .straightFlush
        } else if cards.hasFourOfAKind {
            self = .fourOfAKind
        } else if cards.hasFullHouse {
            self = .fullHouse
        } else if cards.hasFlush {
            self = .flush
        } else if cards.hasStraight {
            self = .straight
        } else if cards.hasThreeOfAKind {
            self = .threeOfAKind
        } else if cards.hasTwoPairs {
            self = .twoPairs
        } else if cards.hasPair {
            self = .pair
        } else if cards.hasHighCard {
            self = .highCard
        } else {
            fatalError("A hand must at least have high card")
        }
    }

    public static let cardsInHand = 5
}

fileprivate extension Collection where Iterator.Element == Card, IndexDistance == Int {
    var hasRoyalFlush: Bool {
        return false
    }

    var hasStraightFlush: Bool {
        return false
    }

    var hasFourOfAKind: Bool {
        return self.hasSameKind(count: 4)
    }

    var hasFullHouse: Bool {
        return self.hasSameKind(count: 3) && self.hasSameKind(count: 2)
    }

    var hasFlush: Bool {
        return !self.group { $0.suit }
            .filter { suit, cards in return cards.count >= Hand.cardsInHand }
            .isEmpty
    }

    var hasStraight: Bool {
        guard self.count >= Hand.cardsInHand else { return false }

        return Array(self).containsStraight
    }

    var hasThreeOfAKind: Bool {
        return self.hasSameKind(count: 3)
    }

    func hasSameKind(count: Int) -> Bool {
        return !self.group { $0.number }
            .filter { number, cards in return cards.count == count }
            .isEmpty
    }

    var hasTwoPairs: Bool {
        return self.group { $0.number }
            .filter { number, cards in return cards.count >= 2 }
            .count >= 2
    }

    var hasPair: Bool {
        return self.hasSameKind(count: 2)
    }

    /// FIX-ME: This is always true, but Hands will have to be parametrized by the details, in this case the cards in sorted order
    var hasHighCard: Bool {
        return true
    }
}

fileprivate extension Collection where Iterator.Element == Card, SubSequence.Iterator.Element == Card, IndexDistance == Int, Index == Int {
    var containsStraight: Bool {
        return self.containsStraight(withAceAsLowestCard: true) || containsStraight(withAceAsLowestCard: false)
    }

    func sorted(withAceAsLowestCard aceAsLowestCard: Bool) -> [Card] {
        let compare = Number.compare(aceAsLowestCard: aceAsLowestCard)

        return self.sorted { card1, card2 in
            return compare(card1.number, card2.number)
        }
    }

    func containsStraight(withAceAsLowestCard aceAsLowestCard: Bool) -> Bool {
        guard self.count >= Hand.cardsInHand else { return false }

        let sortedCards = self.sorted(withAceAsLowestCard: aceAsLowestCard)

        let possibleStraightHands = sortedCards.slice(groupsOf: Hand.cardsInHand)

        print(sortedCards)
        print(aceAsLowestCard)

        for possibleStraightHand in possibleStraightHands {
            func cardsAreConsecutive() -> Bool {
                let numericValueSum = Set(possibleStraightHand
                    .map { $0.number })
                    .map { $0.numericValue(aceAsLowestCard: aceAsLowestCard) }
                    .reduce(0, +)

                let firstNumericValue = possibleStraightHand.first!.number.numericValue(aceAsLowestCard: aceAsLowestCard)
                let lastNumericValue = possibleStraightHand.last!.number.numericValue(aceAsLowestCard: aceAsLowestCard)

                let expectedSum = (firstNumericValue + lastNumericValue) * possibleStraightHand.count / 2

                return numericValueSum == expectedSum
            }

            if cardsAreConsecutive() {
                return true
            }
        }

        return false
    }
}

extension Array {
    /// Returns all possible subarrays of size `groupSize` starting from the left
    fileprivate func slice(groupsOf groupSize: Int) -> [ArraySlice<Iterator.Element>] {
        guard self.count >= groupSize else { return [] }

        let startIndices = (0...(self.count - groupSize))

        return startIndices.map { startIndex in
            let range = (startIndex..<(startIndex + groupSize))

            return self[range]
        }
    }
}

extension Collection {
    fileprivate func group<Key: Hashable>(by f: (Iterator.Element) -> Key) -> [Key : [Iterator.Element]] {
        var dictionary: [Key : [Self.Iterator.Element]] = [:]

        for element in self {
            let key = f(element)

            dictionary[key] = (dictionary[key] ?? []) + [element]
        }

        return dictionary
    }
}

extension Hand: Comparable {
    public static func <(lhs: Hand, rhs: Hand) -> Bool {
        guard lhs != rhs else { return false }

        switch (lhs, rhs) {
        case (.highCard, _): return true
        case (.pair, _): return true
        case (.twoPairs, _): return true
        case (.threeOfAKind, _): return true
        case (.straight, _): return true
        case (.flush, _): return true
        case (.fullHouse, _): return true
        case (.fourOfAKind, _): return true
        case (.straightFlush, _): return true
        case (.royalFlush, _): return true
        }
    }
}
