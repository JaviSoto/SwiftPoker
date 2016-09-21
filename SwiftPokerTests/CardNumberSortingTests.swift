//
//  CardNumberSortingTests.swift
//  SwiftPoker-SampleApp
//
//  Created by Javier Soto on 9/21/16.
//  Copyright © 2016 Javier Soto. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftPoker

final class CardNumberSortingTests: XCTestCase {
    func testAceLowestCard() {
        let numbers: Set<Number> = [.two, .ace, .king, .queen, .jack, .five, .six]
        let sorted = numbers.sorted(by: Number.compare(aceAsLowestCard: true))

        XCTAssertEqual(sorted, [.ace, .two, .five, .six, .jack, .queen, .king])
    }

    func testAceHighestCard() {
        let numbers: Set<Number> = [.two, .ace, .king, .queen, .jack, .five, .six]
        let sorted = numbers.sorted(by: Number.compare(aceAsLowestCard: false))

        XCTAssertEqual(sorted, [.two, .five, .six, .jack, .queen, .king, .ace])
    }
}

