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
}
