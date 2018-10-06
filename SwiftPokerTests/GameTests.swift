//
//  GameTests.swift
//  SwiftPokerTests
//
//  Created by Thomas Luong on 10/3/18.
//  Copyright © 2018 Javier Soto. All rights reserved.
//

import XCTest
import SwiftPoker

class GameTests: XCTestCase {
    let playerCount = 10
    
    func testNumberPlayers() {
        let round = Deck.sortedDeck.dealIntoGame(playerCount: self.playerCount)
        
        XCTAssertEqual(self.playerCount, round.players.count)
    }

    func testShowFlop() {
        let round = Deck.sortedDeck.dealIntoGame(playerCount: self.playerCount)
        let firstThreeCards = Set(round.communityCards.prefix(3))
        
        let flop1 = round.getFlop()
        let flop2 = round.getFlop()
        
        assert(flop1.count == 3)
        assert(flop2.count == 3)
        
        XCTAssertEqual(flop1, flop2)
        XCTAssertEqual(flop1, firstThreeCards)
    }
    
    func testShowTurnCards() {
        let round = Deck.sortedDeck.dealIntoGame(playerCount: self.playerCount)
        let firstFourCards = Set(round.communityCards.prefix(4))
        
        let turn1 = round.getTurn()
        let turn2 = round.getTurn()
        
        assert(turn1.count == 4)
        assert(turn2.count == 4)
        
        XCTAssertEqual(turn1, turn2)
        XCTAssertEqual(turn1, firstFourCards)
    }
    
    func testShowRiverCards() {
        let round = Deck.sortedDeck.dealIntoGame(playerCount: self.playerCount)
        let firstFiveCards = Set(round.communityCards.prefix(5))
        
        let river1 = round.getRiver()
        let river2 = round.getRiver()
        
        assert(river1.count == 5)
        assert(river2.count == 5)
        
        XCTAssertEqual(river1, river2)
        XCTAssertEqual(river1, firstFiveCards)
    }
    
    func testPositionsForTenPlayerGame() {
        let tenPlayers = 10
        let round = Deck.sortedDeck.dealIntoGame(playerCount: tenPlayers)
        
        var firstPlayerSet = [TexasHoldemRound.Player]()
        var secondPlayerSet = [TexasHoldemRound.Player]()
        
        for (index, player) in round.players.enumerated() {
            let playerHand = player.cards
            let playerPosition = player.position
            print("\(index): \(playerPosition): \(playerHand)")
            firstPlayerSet.append(player)
        }
        
        for (index, player) in round.players.enumerated() {
            let playerHand = player.cards
            let playerPosition = player.position
            print("\(index): \(playerPosition): \(playerHand)")
            secondPlayerSet.append(player)
        }
        
        assert(firstPlayerSet == secondPlayerSet)
    }
    
    func testGetCurrentPlayer() {
        let round = Deck.sortedDeck.dealIntoGame(playerCount: playerCount)
//        print("\(round.currentPlayer)")
//        print("\(round.currentPlayer.cards)")
//        print("\(round.currentPlayer.position)")
        
        round.determinePlayerActions()
    }
}
