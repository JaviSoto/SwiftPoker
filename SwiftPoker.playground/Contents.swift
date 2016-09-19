
//: Playground - noun: a place where people can play

import SwiftPoker

var deck = Deck.sortedDeck

print(deck.description)

deck.shuffle()

print(deck.description)