//
//  TexasHoldemRound.swift
//  SwiftPoker-SampleApp
//
//  Created by Javier Soto on 9/20/16.
//  Copyright © 2016 Javier Soto. All rights reserved.
//

import Foundation

public final class TexasHoldemRound {
    public final class Player {
        public static let pocketCards = 2

        public let cards: Set<Card>

        public init(cards: Set<Card>) {
            precondition(cards.count == Player.pocketCards)
            self.cards = cards
        }
    }

    public var players: [Player]

    public init(players: [Player], communityCards: Set<Card>) {
        precondition(!players.isEmpty)

        self.players = players
        self.communityCards = communityCards
    }

    public var communityCards: Set<Card> {
        didSet {
            precondition(communityCards.count <= 5)
        }
    }

    public var hands: [(player: Player, hand: Hand)] {
        return self.players
            .map { ($0, Hand(Array($0.cards) + Array(self.communityCards))) }
    }

    /// FIX-ME: 2 players could have the same hand
    public var winningPlayer: (Player, Hand) {
        return self.hands
            .sorted { $0.hand > $1.hand }
            .first!
    }
}

extension Deck {
    public func dealIntoGame(playerCount: Int) -> TexasHoldemRound {
        precondition(playerCount > 0)
        precondition(playerCount <= 10)

        var cards = self.shuffled.cards

        let cardsPerPlayer = TexasHoldemRound.Player.pocketCards

        var players: [TexasHoldemRound.Player] = []

        for _ in 0..<playerCount {
            let playerCards = cards.pop(first: cardsPerPlayer)

            players.append(TexasHoldemRound.Player(cards: Set(playerCards)))
        }

        let communityCards = cards.pop(first: 5)

        return TexasHoldemRound(players: players, communityCards: Set(communityCards))
    }
}
