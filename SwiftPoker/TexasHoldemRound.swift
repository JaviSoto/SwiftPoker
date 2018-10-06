//
//  TexasHoldemRound.swift
//  SwiftPoker-SampleApp
//
//  Created by Javier Soto on 9/20/16.
//  Copyright © 2016 Javier Soto. All rights reserved.
//

import Foundation

public final class TexasHoldemRound {
    
    public var numberOfRaises = 0

    public let mainPlayer: Player
    
    public var players: [Player]

    public init(players: [Player], communityCards: Set<Card>) {
        precondition(!players.isEmpty)

        self.players = players
        self.communityCards = communityCards
        
        precondition(players.count > 1)
        currentPlayer = self.players.randomElement()!
    }

    public var communityCards: Set<Card> {
        didSet {
            precondition(communityCards.count <= 5)
        }
    }

    public var hands: [(player: Player, hand: Hand)] {
        return self.players
            .map { ($0, Hand($0.cards.union(self.communityCards))) }
    }

    /// FIX-ME: 2 players could have the same hand
    public var winningHand: (player: Player, hand: Hand) {
        return self.hands
            .sorted { $0.hand > $1.hand }
            .first!
    }
    
    public func getFlop() -> Set<Card> {
        return Set(communityCards.prefix(3))
    }
    
    public func getTurn() -> Set<Card> {
        return Set(communityCards.prefix(4))
    }
    
    public func getRiver() -> Set<Card> {
        return Set(communityCards.prefix(5))
    }
    
    public func determinePlayerActions() {
        for player in players {
            print("\(player.position)")
        }
    }
}

extension Deck {
    public func dealIntoGame(playerCount: Int) -> TexasHoldemRound {
        precondition(playerCount > 0)
        precondition(playerCount <= 10)

        var cards = self.shuffled.cards

        let cardsPerPlayer = Player.pocketCards

        var players: [Player] = []

        var positions: [Position] = [.underTheGunOne,
                                     .underTheGunTwo,
                                     .underTheGunThree,
                                     .middlePositionOne,
                                     .middlePositionTwo,
                                     .middlePositionThree,
                                     .cutoff,
                                     .button,
                                     .smallBlind,
                                     .bigBlind ]
        
        for index in 0..<playerCount {
            let playerCards = cards.pop(first: cardsPerPlayer)
            let playerPosition = positions[index]
            players.append(Player(cards: Set(playerCards), position: playerPosition))
        }

        let communityCards = cards.pop(first: 5)

        return TexasHoldemRound(players: players, communityCards: Set(communityCards))
    }
}
