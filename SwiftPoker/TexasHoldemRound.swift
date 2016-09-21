//
//  TexasHoldemRound.swift
//  SwiftPoker-SampleApp
//
//  Created by Javier Soto on 9/20/16.
//  Copyright © 2016 Javier Soto. All rights reserved.
//

import Foundation

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
        return self.players
            .map { ($0, Hand($0.cards + self.communityCards)) }
            .sorted { $0.1 < $1.1 }
            .first!.0
    }
}
