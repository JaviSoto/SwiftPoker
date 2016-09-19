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

public struct Hand {
    var cards: [Card] {
        didSet {
            precondition(cards.count == 5)
        }
    }

    var kind: HandKind {
        fatalError()
    }
}

public enum HandKind {
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

    /// TODO: Determine the hand given a set of [1, 7] cards.
    init(cards: [Card]) {
        precondition(!cards.isEmpty)
        precondition(cards.count <= 7)

        fatalError()
    }
}

extension HandKind: Comparable { }

/// TODO: Test
public func <(lhs: HandKind, rhs: HandKind) -> Bool {
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
        var hand: Hand

        init(name: String, hand: Hand = Hand(cards: [])) {
            self.name = name
            self.hand = hand
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

    public var winningPlayer: Player {
        return self.players.sorted { HandKind(cards: $0.hand.cards + self.communityCards) < HandKind(cards: $1.hand.cards + self.communityCards) }.first!
    }
}
