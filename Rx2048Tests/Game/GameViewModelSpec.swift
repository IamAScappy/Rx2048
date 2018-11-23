//
//  GameViewModelSpec.swift
//  Rx2048Tests
//
//  Created by Cruz on 23/11/2018.
//  Copyright © 2018 Cruz. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import Rx2048
class GameViewModelSpec: QuickSpec {

    override func spec() {
        super.spec()

        describe("Tile") {
            var sut: Tile!

            beforeEach {
                sut = Tile(id: NSUUID().uuidString, level: 1)
            }

            it("number should be 2") {
                expect(sut.number) == "2"
            }

            context("has level 2") {
                beforeEach {
                    sut.level = 2
                }

                it("number should be 4") {
                    expect(sut.number) == "4"
                }
            }

            context("has level 10") {
                beforeEach {
                    sut.level = 10
                }

                it("number should be 1024") {
                    expect(sut.number) == "1024"
                }
            }
        }
    }
}
