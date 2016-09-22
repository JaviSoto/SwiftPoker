import Foundation
import SwiftPoker

public func handKindPercentages(playerCount: Int, iterations: Int) -> [(Hand.Kind, Double)] {
    var hitsPerWinningHand: [Hand.Kind : Int] = [:]

    for _ in 0..<iterations {
        let round = Deck.sortedDeck.dealIntoGame(playerCount: playerCount)

        let winningHand = round.winningHand.hand

        hitsPerWinningHand[winningHand.kind] = (hitsPerWinningHand[winningHand.kind] ?? 0) + 1
    }

    return hitsPerWinningHand
        .map { ($0.key, 100 * Double($0.value) / Double(iterations)) }
        .sorted { $0.1 > $1.1 }
}

public func preFlopHandKindOdds(pocketCards: Set<Card>, numberOfOtherPlayers: Int, iterations: Int) -> [(Hand.Kind, Double)] {
    precondition(pocketCards.count == TexasHoldemRound.Player.pocketCards)

    var hitsPerHandKind: [Hand.Kind : Int] = [:]

    for _ in 0..<iterations {
        var cards = Set(Deck.sortedDeck.cards)

        pocketCards.forEach { _ = cards.remove($0) }

        let shuffledDeckMinusPocketCards = Deck(cards).shuffled

        let round = shuffledDeckMinusPocketCards.dealIntoGame(playerCount: numberOfOtherPlayers)

        let myHand = Hand(pocketCards.union(round.communityCards))

        hitsPerHandKind[myHand.kind] = (hitsPerHandKind[myHand.kind] ?? 0) + 1
    }

    return hitsPerHandKind
        .map { ($0.key, 100 * Double($0.value) / Double(iterations)) }
        .sorted { $0.1 > $1.1 }
}

public func preFlopOdds(pocketCards: Set<Card>, numberOfOtherPlayers: Int, iterations: Int, debugLog: Bool = false) -> Double {
    precondition(pocketCards.count == TexasHoldemRound.Player.pocketCards)

    let log: (String) -> () = debugLog ? { print($0) } : { _ in () }

    let pocketCardsDescription = Array(pocketCards).map { $0.description }.joined(separator: ", ")
    log("Calculating pre-flop odds for \(pocketCardsDescription)")

    let myPlayer = TexasHoldemRound.Player(cards: pocketCards)

    var cards = Set(Deck.sortedDeck.cards)

    pocketCards.forEach { _ = cards.remove($0) }

    var victories = 0

    for roundIndex in 0..<iterations {
        log("Round \(roundIndex + 1):")

        let shuffledDeckMinusPocketCards = Deck(cards).shuffled

        let round = shuffledDeckMinusPocketCards.dealIntoGame(playerCount: numberOfOtherPlayers)
        round.players.append(myPlayer)

        log("Community cards: \(round.communityCards)")

        let hands = round.hands

        for (index, value) in hands.enumerated() {
            let playerName = value.player === myPlayer ? "Us" : "Player \(index + 1)"

            log("\(playerName) \(value.player.cards) \(value.hand)")
        }

        if round.winningHand.player === myPlayer {
            victories += 1
        }
    }

    let odds = Double(victories) / Double(iterations)

    log("Pre-Flop odds of \(pocketCardsDescription) with \(numberOfOtherPlayers) other players: \(odds * 100)%")

    return odds
}

