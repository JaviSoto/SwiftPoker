//
//  Hand.swift
//  SwiftPoker-SampleApp
//
//  Created by Javier Soto on 9/20/16.
//  Copyright © 2016 Javier Soto. All rights reserved.
//

import Foundation

public enum Hand {
    case highCard(numbers: Set<Number>)
    case pair(number: Number, kickerNumbers: Set<Number>)
    case twoPairs(number1: Number, number2: Number, kickerNumber: Number)
    case threeOfAKind(number: Number, kickerNumbers: Set<Number>)
    case straight(numbers: Set<Number>)
    case flush(numbers: Set<Number>)
    case fullHouse(threeOf: Number, pairOf: Number)
    case fourOfAKind(number: Number, kicker: Number)
    case straightFlush(numbers: Set<Number>)
    case royalFlush

    public enum Kind {
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
    }

    public var kind: Kind {
        switch self {
        case .highCard: return .highCard
        case .pair: return .pair
        case .twoPairs: return .twoPairs
        case .threeOfAKind: return .threeOfAKind
        case .straight: return .straight
        case .flush: return .flush
        case .fullHouse: return .fullHouse
        case .fourOfAKind: return .fourOfAKind
        case .straightFlush: return .straightFlush
        case .royalFlush: return .royalFlush
        }
    }

    /// Determine the hand given a set of [2, 7] cards.
    public init<S: Collection>(_ cards: S) where S.Iterator.Element == Card {
        precondition(!cards.isEmpty)
        precondition(cards.count >= Hand.cardsInHand)
        precondition(cards.count <= 7)

        if cards.royalFlush {
            self = .royalFlush
        }
        else if let straightFlush = cards.straightFlush {
            self = .straightFlush(numbers: straightFlush)
        }
        else if let fourOfAKind = cards.fourOfAKind {
            self = .fourOfAKind(number: fourOfAKind.number, kicker: fourOfAKind.kicker)
        }
        else if let fullHouse = cards.fullHouse {
            self = .fullHouse(threeOf: fullHouse.threeOf, pairOf: fullHouse.pairOf)
        }
        else if let flush = cards.flush {
            self = .flush(numbers: flush)
        }
        else if let straight = cards.straight {
            self = .straight(numbers: Set(straight.map { $0.number }))
        }
        else if let threeOfAKind = cards.threeOfAKind {
            self = .threeOfAKind(number: threeOfAKind.number, kickerNumbers: threeOfAKind.kickerNumbers)
        }
        else if let twoPairs = cards.twoPairs {
            self = .twoPairs(number1: twoPairs.number1, number2: twoPairs.number2, kickerNumber: twoPairs.kickerNumber)
        }
        else if let pair = cards.pair {
            self = .pair(number: pair.number, kickerNumbers: pair.kickerNumbers)
        }
        else {
            self = .highCard(numbers: cards.highCard)
        }
    }

    public static let cardsInHand = 5
}

extension Hand: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .highCard(numbers): return "High Card (\(numbers.sorted(by: >))"
        case let .pair(number, kickerNumbers): return "Pair of \(number)s, kicker: \(kickerNumbers.sorted(by: >))"
        case let .twoPairs(number1, number2, kicker): return "Two Pairs of \(number1)s and \(number2)s with \(kicker) kicker"
        case let .threeOfAKind(number, kickerNumbers): return "Three \(number)s with kicker \(kickerNumbers.sorted(by: >))"
        case let .straight(numbers): return "Straight: \(numbers.sorted(by: >))"
        case let .flush(numbers): return "Flush: \(numbers.sorted(by: >))"
        case let .fullHouse(threeOf, pair): return "Full-House \(threeOf)s over \(pair)s"
        case let .fourOfAKind(number, kicker): return "Four of a kind \(number) with \(kicker) kicker"
        case let .straightFlush(numbers): return "Straight-Flush: \(numbers.sorted(by: >))"
        case .royalFlush: return "Royal Flush"
        }
    }
}

extension Hand.Kind: CustomStringConvertible {
    public var description: String {
        switch self {
        case .highCard: return "High Card"
        case .pair: return "Pair"
        case .twoPairs: return "Two Pairs"
        case .threeOfAKind: return "Three of a Kind"
        case .straight: return "Straight"
        case .flush: return "Flush"
        case .fullHouse: return "Full-House"
        case .fourOfAKind: return "Four of a Kind"
        case .straightFlush: return "Straight Flush"
        case .royalFlush: return "Royal Flush"
        }
    }
}

fileprivate extension Collection where Iterator.Element == Card {
    var royalFlush: Bool {
        guard let straight = self.straight(withAceAsLowestCard: false), straight.flush != nil else { return false }

        return straight.last?.number == .ace
    }

    /// Nil if the set of cards doesn't contain a straight flush, the cards in the straight flush if it does.
    var straightFlush: Set<Number>? {
        guard let straight = self.straight, straight.flush != nil else { return nil }

        return Set(straight.map { $0.number })
    }

    /// Nil if the set of cards doesn't contain four of a kind, the details about the cards if it does.
    var fourOfAKind: (number: Number, kicker: Number)? {
        return self.sameNumber(count: 4)
            .map { (number: $0.number, kicker: $0.kickerNumbers.first!) }
    }

    /// Nil if the set of cards doesn't contain a full house, the details about the cards if it does.
    var fullHouse: (threeOf: Number, pairOf: Number)? {
        guard let threeOfAKind = self.sameNumber(count: 3),
            let pair = self.sameNumber(count: 2) else { return nil }

        return (threeOf: threeOfAKind.number, pairOf: pair.number)
    }

    /// Nil if the set of cards doesn't contain a flush, the details about the cards if it does.
    var flush: Set<Number>? {
        guard let flushCards: [Card] = self
            .group(by: { $0.suit })
            .filter({ suit, cards in return cards.count >= Hand.cardsInHand })
            .map({ $1 })
            .first
            else { return nil }

        return flushCards.highestHandNumbers()
    }

    /// Nil if the set of cards doesn't contain three of a kind, the details about the cards if it does.
    var threeOfAKind: (number: Number, kickerNumbers: Set<Number>)? {
        return self.sameNumber(count: 3)
            .map { (number: $0.number, kickerNumbers: $0.kickerNumbers) }
    }

    /// Nil if the set of cards doesn't contain `count` cards of the same number, the details about the cards if it does.
    private func sameNumber(count: Int) -> (number: Number, kickerNumbers: Set<Number>)? {
        guard let groupNumber: Number = self.group(by: { $0.number })
            .filter({ number, cards in return cards.count == count })
            .map({ $0.key })
            .first else { return nil }

        let kickerNumbers = self
            .filter { $0.number != groupNumber }
            .highestHandNumbers(count: Hand.cardsInHand - count)

        return (number: groupNumber, kickerNumbers: kickerNumbers)
    }

    /// Nil if the set of cards doesn't contain two pairs, the details about the cards if it does.
    var twoPairs: (number1: Number, number2: Number, kickerNumber: Number)? {
        let pairGroups = self.group { $0.number }
            .filter { number, cards in return cards.count >= 2 }
            .map { $0.0 }

        guard pairGroups.count >= 2 else { return nil }

        let number1 = pairGroups[0]
        let number2 = pairGroups[1]

        let highestKicker = self
            .filter { $0.number != number1 && $0.number != number2 }
            .highestHandNumbers(count: 1)
            .first!

        return (number1: number1, number2: number2, kickerNumber: highestKicker)
    }

    /// Nil if the set of cards doesn't contain a pair, the details about the cards if it does.
    var pair: (number: Number, kickerNumbers: Set<Number>)? {
        return self.sameNumber(count: 2).map {
            (kind: $0.number, kickerNumbers: $0.kickerNumbers)
        }
    }

    /// The set of cards
    var highCard: Set<Number> {
        return self.highestHandNumbers()
    }
}

fileprivate extension Collection where Iterator.Element == Card {
    /// - returns: nil if the set of cards doesn't have a straight, or the array of cards that has a straight if it does.
    var straight: [Card]? {
        return self.straight(withAceAsLowestCard: true) ?? self.straight(withAceAsLowestCard: false)
    }

    func sorted(withAceAsLowestCard aceAsLowestCard: Bool) -> [Card] {
        let compare = Number.compare(aceAsLowestCard: aceAsLowestCard)

        return self.sorted { card1, card2 in
            return compare(card1.number, card2.number)
        }
    }


    /// - returns: nil if the set of cards doesn't have a straight, or the array of cards that has a straight if it does.
    func straight(withAceAsLowestCard aceAsLowestCard: Bool) -> [Card]? {
        guard self.count >= Hand.cardsInHand else { return nil }

        let sortedCards = self.sorted(withAceAsLowestCard: aceAsLowestCard)

        let possibleStraightHands = sortedCards.slice(groupsOf: Hand.cardsInHand)

        for possibleStraightHand in possibleStraightHands {
            func cardsAreConsecutive() -> Bool {
                let numericValueSum = Set(possibleStraightHand
                    .map { $0.number })
                    .map { $0.numericValue(aceAsLowestCard: aceAsLowestCard) }
                    .reduce(0, +)

                let firstNumericValue = possibleStraightHand.first!.number.numericValue(aceAsLowestCard: aceAsLowestCard)
                let lastNumericValue = possibleStraightHand.last!.number.numericValue(aceAsLowestCard: aceAsLowestCard)

                let expectedSum = (firstNumericValue + lastNumericValue) * possibleStraightHand.count / 2

                return numericValueSum == expectedSum
            }

            if cardsAreConsecutive() {
                return Array(possibleStraightHand)
            }
        }

        return nil
    }
}

// MARK: Comparing two sets of hand values
func <(lhs: Set<Number>, rhs: Set<Number>) -> Bool {
    
    var numericValuesLeft = lhs.map { $0.numericValue() }
    var numericValuesRight = rhs.map { $0.numericValue() }
    
    let isLeftLowAceConsecutive = isSetLowAceConsecutive(set: lhs)
    let isRightLowAceConsecutive = isSetLowAceConsecutive(set: rhs)
    
    if isLeftLowAceConsecutive == true {
        numericValuesLeft = lhs.map { $0.numericValue(aceAsLowestCard: true) }
    }
    
    if isRightLowAceConsecutive == true {
        numericValuesRight = rhs.map { $0.numericValue(aceAsLowestCard: true) }
    }
    
    let sortedNumericLeft = numericValuesLeft.sorted(by: >)
    let sortedNumericRight = numericValuesRight.sorted(by: >)
    
    let zippedValues = zip(sortedNumericLeft, sortedNumericRight)
    
    for (leftValue, rightValue) in zippedValues {
        if leftValue == rightValue {
            continue
        }
        
        return leftValue < rightValue
    }
    
    return false
}

func isSetLowAceConsecutive(set: Set<Number>) -> Bool {
    let sortedByLowAce = set.sorted(by: Number.compare(aceAsLowestCard: true))
    let isLowAceConsecutive = sortedByLowAce.passesForConsecutiveValues { (num1, num2) -> Bool in
        let num1 = num1.numericValue(aceAsLowestCard: true)
        let num2 = num2.numericValue(aceAsLowestCard: true)
        
        if num1 == num2 - 1 {
            return true
        }
        
        return false
    }
    
    if isLowAceConsecutive == true {
        return true
    } else {
        return false
    }
}

extension Collection where Iterator.Element == Card {
    func highestHandNumbers(count: Int = Hand.cardsInHand) -> Set<Number> {
        return Set(self.map { $0.number }
            .sorted(by: { $0.numericValue() < $1.numericValue() })
            .suffix(count))
    }
}

extension Hand: Comparable {
    public static func ==(lhs: Hand, rhs: Hand) -> Bool {
        guard lhs.kind == rhs.kind else { return false }

        switch (lhs, rhs) {
        case let (.highCard(numbers1), .highCard(numbers2)) where numbers1 == numbers2: return true
        case let (.pair(number1, kickerNumbers1), .pair(number2, kickerNumbers2)) where number1 == number2 && kickerNumbers1 == kickerNumbers2: return true
        case let (.twoPairs(number1, secondNumber1, kickerNumber1), .twoPairs(number2, secondNumber2, kickerNumber2)) where number1 == number2 && secondNumber1 == secondNumber2 && kickerNumber1 == kickerNumber2: return true
        case let (.threeOfAKind(number1, kickerNumbers1), .threeOfAKind(number2, kickerNumbers2)) where number1 == number2 && kickerNumbers1 == kickerNumbers2: return true
        case let (.straight(numbers1), .straight(numbers2)) where numbers1 == numbers2: return true
        case let (.flush(numbers1), .flush(numbers2)) where numbers1 == numbers2: return true
        case let (.fullHouse(threeOf1, pairOf1), .fullHouse(threeOf2, pairOf2)) where threeOf1 == threeOf2 && pairOf1 == pairOf2: return true
        case let (.fourOfAKind(card1, kicker1), .fourOfAKind(card2, kicker2)) where card1 == card2 && kicker1 == kicker2: return true
        case let (.straightFlush(numbers1), .straightFlush(numbers2)) where numbers1 == numbers2: return true
        case (.royalFlush, .royalFlush): return true

        default: return false
        }
    }

    public static func <(lhs: Hand, rhs: Hand) -> Bool {
        guard lhs.kind == rhs.kind else {
            /// If it's an inferior type of hand, no need to do the nitty-gritty comparison, just compare the type
            /// Simplifies the comparison below to just hands of the same type
            return lhs.kind < rhs.kind
        }

        switch (lhs, rhs) {
        case let (.highCard(numbers1), .highCard(numbers2)): return numbers1 < numbers2
        case let (.pair(number1, kickerNumbers1), .pair(number2, kickerNumbers2)): return number1 < number2 || kickerNumbers1 < kickerNumbers2
        case let (.twoPairs(number1, secondNumber1, kickerNumber1), .twoPairs(number2, secondNumber2, kickerNumber2)): return number1 < number2 || secondNumber1 < secondNumber2 || kickerNumber1 < kickerNumber2
        case let (.threeOfAKind(number1, kickers1), .threeOfAKind(number2, kickers2)): return number1 < number2 || kickers1 < kickers2
        case let (.straight(numbers1), .straight(numbers2)): return numbers1 < numbers2
        case let (.flush(numbers1), .flush(numbers2)): return numbers1 < numbers2
        case let (.fullHouse(three1, pair1), .fullHouse(three2, pair2)): return three1 < three2 || pair1 < pair2
        case let (.fourOfAKind(number1, kicker1), .fourOfAKind(number2, kicker2)): return number1 < number2 || kicker1 < kicker2
        case let (.straightFlush(numbers1), .straightFlush(numbers2)): return numbers1 < numbers2
        case (.royalFlush, .royalFlush): return false

        default: fatalError("Switch should be exhaustive: \(lhs) < \(rhs)")
        }
    }
}

extension Hand.Kind: Comparable {
    private static let kindsByStrength: [Hand.Kind] = [.highCard, .pair, .twoPairs, .threeOfAKind, .straight, .flush, .fullHouse, .fourOfAKind, .straightFlush, .royalFlush]

    public static func <(lhs: Hand.Kind, rhs: Hand.Kind) -> Bool {
        guard lhs != rhs else { return false }

        return Hand.Kind.kindsByStrength.index(of: lhs)! < Hand.Kind.kindsByStrength.index(of: rhs)!
    }
}
