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
            context("when start action") {
                var xs: TestableObservable<Action>!
                var observer: TestableObserver<GameViewReactor.Mutation>!
                var correctMessages: [Recorded<Event<Mutation>>] = []

                beforeEach {
                    xs = testSchedule.createHotObservable(
                        [next(250, .startGame)]
                    )

                    correctMessages = [
                        next(250, .clear),
                        next(250, .create),
                        next(250, .create)
                    ]

                    observer = testSchedule.createObserver(Mutation.self)
                    xs.flatMap { sut.mutate(action: $0) }
                        .bind(to: observer)
                        .disposed(by: disposeBag)
                }

                it("mutate create tile two times") {
                    testSchedule.start()
                    expect(observer.events) == correctMessages
                }
            }
        }
    }
}
