//
//  Types.swift
//  SwiftPoker-SampleApp
//
//  Created by Javier Soto on 9/19/16.
//  Copyright © 2016 Javier Soto. All rights reserved.
//

import Swift

public enum Suit {
    case hearts
    case spades
    case diamonds
    case clubs

    public enum Color {
        case black
        case red
    }

    public var color: Color {
        switch self {
        case .hearts, .diamonds: return .red
        case .spades, .clubs: return .black
        }
    }

    public static var allSuits: Set<Suit> {
        return [.hearts, .spades, .diamonds, .clubs]
    }
}

extension Suit: CustomStringConvertible {
    public var description: String {
        switch self {
        case .hearts: return "♥️"
        case .spades: return "♠️"
        case .diamonds: return "♦️"
        case .clubs: return "♣️"
        }
    }
}

public enum Number {
    case ace
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king

    public static var allNumbers: [Number] {
        return [.ace, .two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king]
    }
}

extension Number: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ace: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .ten: return "10"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        }
    }
}

public struct Card {
    public let suit: Suit
    public let number: Number

    public init(suit: Suit, number: Number) {
        self.suit = suit
        self.number = number
    }
}

extension Card: Hashable {
    public var hashValue: Int {
        return self.suit.hashValue ^ self.number.hashValue
    }
}

public func ==(lhs: Card, rhs: Card) -> Bool {
    return lhs.suit == rhs.suit && lhs.number == rhs.number
}

extension Card: CustomStringConvertible {
    public var description: String {
        return "\(self.number)\(self.suit)"
    }
}

public struct Deck {
    public var cards: [Card]

    public static var sortedDeck: Deck {
        var cards: [Card] = []

        for suit in Suit.allSuits {
            for number in Number.allNumbers {
                cards.append(Card(suit: suit, number: number))
            }
        }

        return Deck(cards: cards)
    }

    public mutating func shuffle() {
        var cards = self.cards

        for index in cards.indices {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count - 1)))

            if index == randomIndex {
                continue
            }

            swap(&cards[index], &cards[randomIndex])
        }

        self.cards = cards
    }

    public var shuffled: Deck {
        var deck = self
        deck.shuffle()
        
        return deck
    }
}

extension Deck: CustomStringConvertible {
    public var description: String {
        return self.cards
            .map { $0.description }
            .joined(separator: ", ")
    }
}

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

extension Hand: Comparable { }

/// TODO: Test
public func <(lhs: Hand, rhs: Hand) -> Bool {
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

final class TexasHoldemRound {
    final class Player {
        let name: String
        let cards: [Card]

        init(name: String, cards: [Card]) {
            self.name = name

            precondition(cards.count == 2)
            self.cards = cards
        }
    }

    public let players: [Player]

    init(players: [Player]) {
        precondition(!players.isEmpty)

        self.players = players
    }

    public var communityCards: [Card] = [] {
        didSet {
            precondition(communityCards.count <= 5)
        }
    }

    /// FIX-ME: 2 players could have the same hand
    public var winningPlayer: Player {
        return self.players.sorted { Hand(cards: $0.cards + self.communityCards) < Hand(cards: $1.cards + self.communityCards) }.first!
    }
}
