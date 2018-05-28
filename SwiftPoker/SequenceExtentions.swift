//
//  SequenceExtensions.swift
//  SwiftPoker
//
//  Created by Thomas Luong on 5/28/18.
//  Copyright © 2018 Javier Soto. All rights reserved.
//

import Foundation

// https://stackoverflow.com/questions/45469194/check-whether-integers-in-array-are-consecutive-or-in-sequence
// To determine if a sequence has values that are consecutive in value
extension Sequence {
    func pairwise() -> AnyIterator<(Element, Element)> {
        var it = makeIterator()
        guard var last_value = it.next() else { return AnyIterator{ return nil } }
        
        return AnyIterator {
            guard let value = it.next() else { return nil }
            defer { last_value = value }
            return (last_value, value)
        }
    }
}

extension Sequence {
    func all(pass predicate: (Element) -> Bool) -> Bool {
        // If nothing is false, everything is true
        return !self.contains(where: { !predicate($0) })
    }
}

extension Sequence {
    func passesForConsecutiveValues(_ predicate:(Element, Element) -> Bool) -> Bool {
        return pairwise().all(pass: predicate)
    }
}
