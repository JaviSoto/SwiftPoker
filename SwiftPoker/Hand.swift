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
    public init<S: Collection>(cards: S) where S.Iterator.Element == Card {
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
        }
        else {
            fatalError("A hand must at least have high card")
        }
    }
}

fileprivate extension Collection where Iterator.Element == Card {
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
        print(self.group { $0.suit })
        return !self.group { $0.suit }
            .filter { suit, cards in return cards.count >= 5 }
            .isEmpty
    }

    var hasStraight: Bool {
        return false
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

extension Collection {
    func group<U: Hashable>(by f: (Iterator.Element) -> U) -> [U : [Iterator.Element]] {
        var dictionary: [U : [Self.Iterator.Element]] = [:]

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
