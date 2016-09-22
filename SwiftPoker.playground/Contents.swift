
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
 */

//let odds = preFlopOdds(pocketCards: ["2♥️", "6♥️"], numberOfOtherPlayers: 2, iterations: 5000, debugLog: false)

let odds2 = preFlopHandKindOdds(pocketCards: ["A♥️", "A♠️"], numberOfOtherPlayers: 10, iterations: 40000)

for (kind, percentage) in odds2 {
    print("\(kind): \(percentage)%")
}

/**
 preFlopHandKindOdds(pocketCards: ["A♥️", "K♥️"], numberOfOtherPlayers: 2, iterations: 400000):

 Pair: 35.253%
 Straight: 21.80875%
 Two Pairs: 20.5685%
 High Card: 9.47075%
 Flush: 6.43125%
 Three of a Kind: 3.96475%
 Full-House: 2.229%
 Four of a Kind: 0.12225%
 Royal Flush: 0.09%
 Straight Flush: 0.06175%

 */
