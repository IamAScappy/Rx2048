//
//  GameViewReactorSpec.swift
//  Rx2048Tests
//
//  Created by Cruz on 23/11/2018.
//  Copyright © 2018 Cruz. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Deli
import RxSwift
import RxTest
import RxBlocking

@testable import Rx2048
class GameViewReactorSpec: QuickSpec {
    typealias Action = GameViewReactor.Action
    typealias Mutation = GameViewReactor.Mutation

    override func spec() {
        super.spec()
        var sut: GameViewReactor!
        var testSchedule: TestScheduler!
        var disposeBag: DisposeBag!

        beforeEach {
            sut = AppContext.shared.get(GameViewReactor.self)
            testSchedule = TestScheduler(initialClock: 0)
            disposeBag = DisposeBag()
        }

        describe("GameViewReactor") {
            var xs: TestableObservable<Action>!
            var observer: TestableObserver<GameViewReactor.Mutation>!

            beforeEach {
                observer = testSchedule.createObserver(Mutation.self)
            }

            context("when start action") {
                beforeEach {
                    xs = testSchedule.createHotObservable(
                        [next(250, .startGame)]
                    )

                    xs.flatMap { sut.mutate(action: $0) }
                        .bind(to: observer)
                        .disposed(by: disposeBag)
                }

                it("mutate create tile two times") {
                    testSchedule.start()
                    expect(observer.events) == [
                        next(250, .clear),
                        next(250, .create),
                        next(250, .create)
                    ]
                }
            }

            context("when left action once") {
                beforeEach {
                    xs = testSchedule.createHotObservable(
                        [next(250, .swipe(.left))]
                    )

                    xs.flatMap { sut.mutate(action: $0) }
                        .bind(to: observer)
                        .disposed(by: disposeBag)
                }

                it("should move left 2 -> 4 -> 3, merge 2 -> 4 and move left 2 -> 4 -> 3") {
                    testSchedule.start()
                    expect(observer.events) == [
                        next(250, .move(direction: .left, index: 2)),
                        next(250, .move(direction: .left, index: 4)),
                        next(250, .move(direction: .left, index: 3)),
                        next(250, .merge(direction: .left, index: 2)),
                        next(250, .merge(direction: .left, index: 4)),
                        next(250, .move(direction: .left, index: 2)),
                        next(250, .move(direction: .left, index: 4)),
                        next(250, .move(direction: .left, index: 3)),
                    ]
                }
            }

            context("when up action once") {
                beforeEach {
                    xs = testSchedule.createHotObservable(
                        [next(250, .swipe(.up))]
                    )

                    xs.flatMap { sut.mutate(action: $0) }
                        .bind(to: observer)
                        .disposed(by: disposeBag)
                }

                it("should move up 2 -> 4 -> 3, merge 2 -> 4 and move up 2 -> 4 -> 3") {
                    testSchedule.start()
                    expect(observer.events) == [
                        next(250, .move(direction: .up, index: 2)),
                        next(250, .move(direction: .up, index: 4)),
                        next(250, .move(direction: .up, index: 3)),
                        next(250, .merge(direction: .up, index: 2)),
                        next(250, .merge(direction: .up, index: 4)),
                        next(250, .move(direction: .up, index: 2)),
                        next(250, .move(direction: .up, index: 4)),
                        next(250, .move(direction: .up, index: 3)),
                    ]
                }
            }
        }
    }
}
