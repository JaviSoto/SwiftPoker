//
//  CollectionExtensions.swift
//  SwiftPoker-SampleApp
//
//  Created by Javier Soto on 9/22/16.
//  Copyright © 2016 Javier Soto. All rights reserved.
//

import Foundation

extension Collection {
    func all(f: (Iterator.Element) -> Bool) -> Bool {
        for element in self {
            guard f(element) else { return false }
        }

        return true
    }
}

extension Array {
    /// Returns all possible subarrays of size `groupSize` starting from the left
    func slice(groupsOf groupSize: Int) -> [ArraySlice<Iterator.Element>] {
        guard self.count >= groupSize else { return [] }

        let startIndices = (0...(self.count - groupSize))

        return startIndices.map { startIndex in
            let range = (startIndex..<(startIndex + groupSize))

            return self[range]
        }
    }
}

extension Collection {
    func group<Key: Hashable>(by f: (Iterator.Element) -> Key) -> [Key : [Iterator.Element]] {
        var dictionary: [Key : [Self.Iterator.Element]] = [:]

        for element in self {
            let key = f(element)

            dictionary[key] = (dictionary[key] ?? []) + [element]
        }

        return dictionary
    }
}

extension RangeReplaceableCollection where SubSequence.Iterator.Element == Iterator.Element, Index == Int {
    mutating func pop(first count: Int) -> [Iterator.Element] {
        let elements = Array(self[0..<count])

        self.removeFirst(count)

        return elements
    }
}
