//
//  Types.swift
//  SwiftPoker-SampleApp
//
//  Created by Javier Soto on 9/19/16.
//  Copyright © 2016 Javier Soto. All rights reserved.
//

import Swift

public enum Position {
    case button
    case bigBlind
    case smallBlind
    case underTheGunOne
    case underTheGunTwo
    case underTheGunThree
    case middlePositionOne
    case middlePositionTwo
    case middlePositionThree
    case cutoff
}

public enum Suit {
    case hearts
    case spades
    case diamonds
    case clubs

    public init?(_ string: String) {
        switch string {
        case "♥️": self = .hearts
        case "♠️": self = .spades
        case "♦️": self = .diamonds
        case "♣️": self = .clubs
        default: return nil
        }
    }

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

    init?(_ string: String) {
        switch string.lowercased() {
        case "a", "ace", "1": self = .ace
        case "two", "2": self = .two
        case "three", "3": self = .three
        case "four", "4": self = .four
        case "five", "5": self = .five
        case "six", "6": self = .six
        case "seven", "7": self = .seven
        case "eight", "8": self = .eight
        case "nine", "9": self = .nine
        case "ten", "10": self = .ten
        case "jack", "j": self = .jack
        case "queen", "q": self = .queen
        case "king", "k": self = .king
        default: return nil
        }
    }

    fileprivate static let allNumbers: [Number] = [.two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .jack, .queen, .king, .ace]
}

extension Number: Comparable {
    public static func <(lhs: Number, rhs: Number) -> Bool {
        return Number.compare(aceAsLowestCard: false)(lhs, rhs)
    }

    static func compare(aceAsLowestCard: Bool) -> (Number, Number) -> Bool  {
        return { lhs, rhs in
            return lhs.numericValue(aceAsLowestCard: aceAsLowestCard) < rhs.numericValue(aceAsLowestCard: aceAsLowestCard)
        }
    }
}

extension Number {
    func numericValue(aceAsLowestCard: Bool = false) -> Int {
        switch self {
        case .ace: return aceAsLowestCard ? 1 : 14
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .ten: return 10
        case .jack: return 11
        case .queen: return 12
        case .king: return 13
        }
    }
}

extension Number: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ace: return "A"
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
    public let number: Number
    public let suit: Suit

    public init(number: Number, suit: Suit) {
        self.number = number
        self.suit = suit
    }

    public init?(_ numberAndSuitString: String) {
        guard numberAndSuitString.count == 2 else {
            return nil
        }

        guard let number = Number(String(numberAndSuitString.first!)),
            let suit = Suit(String(numberAndSuitString.last!))
            else {
                return nil
        }

        self = Card(number: number, suit: suit)
    }
}

extension Card: ExpressibleByStringLiteral {
    public typealias UnicodeScalarLiteralType = String
    public typealias ExtendedGraphemeClusterLiteralType = String

    public init(stringLiteral value: String) {
        self.init(value)!
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)!
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(value)!
    }
}

extension Card: Hashable {
    public var hashValue: Int {
        return self.suit.hashValue ^ self.number.hashValue
    }

    public static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.suit == rhs.suit && lhs.number == rhs.number
    }
}

extension Card: CustomStringConvertible {
    public var description: String {
        return "\(self.number)\(self.suit)"
    }
}

public struct Deck {
    public var cards: [Card]

    public init<C: Collection>(_ cards: C) where C.Iterator.Element == Card {
        self.cards = Array(cards)
    }

    public static var sortedDeck: Deck {
        var cards: [Card] = []

        for suit in Suit.allSuits {
            for number in Number.allNumbers {
                cards.append(Card(number: number, suit: suit))
            }
        }

        return Deck(cards)
    }

    public mutating func shuffle() {
        var cards = self.cards

        for index in cards.indices {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count - 1)))

            if index == randomIndex {
                continue
            }

            cards.swapAt(index, randomIndex)
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
