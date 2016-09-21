
//: Playground - noun: a place where people can play

import SwiftPoker

//let percentages = handKindPercentages(playerCount: 2, iterations: 500000)
//
//for (kind, percentage) in percentages {
//    print("\(kind): \(percentage)%")
//}

/*
 Two players, 500000 iterations:

 Pair: 52.3554%
 Two Pairs: 19.5756%
 High Card: 15.9374%
 Straight: 7.6006%
 Three of a Kind: 3.1184%
 Flush: 0.9332%
 Full-House: 0.4498%
 Four of a Kind: 0.0262%
 Straight Flush: 0.0034%
 
 // No royal flush??

 */

let odds = preFlopOdds(pocketCards: ["2♥️", "6♦️"], numberOfOtherPlayers: 2, iterations: 5000, debugLog: false)

"\(odds * 100)%"
