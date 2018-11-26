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
    typealias State = GameViewReactor.State

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

            describe("mutate") {
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

                    it("should move left 1 -> 3 -> 2, merge 1 -> 3 and move left 1 -> 3 -> 2") {
                        testSchedule.start()
                        expect(observer.events) == [
                            next(250, .move(direction: .left, index: 1)),
                            next(250, .move(direction: .left, index: 3)),
                            next(250, .move(direction: .left, index: 2)),
                            next(250, .merge(direction: .left, index: 1)),
                            next(250, .merge(direction: .left, index: 3)),
                            next(250, .move(direction: .left, index: 1)),
                            next(250, .move(direction: .left, index: 3)),
                            next(250, .move(direction: .left, index: 2))
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

                    it("should move up 1 -> 3 -> 2, merge 1 -> 3 and move up 1 -> 3 -> 2") {
                        testSchedule.start()
                        expect(observer.events) == [
                            next(250, .move(direction: .up, index: 1)),
                            next(250, .move(direction: .up, index: 3)),
                            next(250, .move(direction: .up, index: 2)),
                            next(250, .merge(direction: .up, index: 1)),
                            next(250, .merge(direction: .up, index: 3)),
                            next(250, .move(direction: .up, index: 1)),
                            next(250, .move(direction: .up, index: 3)),
                            next(250, .move(direction: .up, index: 2))
                        ]
                    }
                }

                context("when right action once") {
                    beforeEach {
                        xs = testSchedule.createHotObservable(
                            [next(250, .swipe(.right))]
                        )

                        xs.flatMap { sut.mutate(action: $0) }
                            .bind(to: observer)
                            .disposed(by: disposeBag)
                    }

                    it("should move right 2 -> 0 -> 1, merge 2 -> 0 and move right 2 -> 0 -> 1") {
                        testSchedule.start()
                        expect(observer.events) == [
                            next(250, .move(direction: .right, index: 2)),
                            next(250, .move(direction: .right, index: 0)),
                            next(250, .move(direction: .right, index: 1)),
                            next(250, .merge(direction: .right, index: 2)),
                            next(250, .merge(direction: .right, index: 0)),
                            next(250, .move(direction: .right, index: 2)),
                            next(250, .move(direction: .right, index: 0)),
                            next(250, .move(direction: .right, index: 1))
                        ]
                    }
                }

                context("when right action once") {
                    beforeEach {
                        xs = testSchedule.createHotObservable(
                            [next(250, .swipe(.down))]
                        )

                        xs.flatMap { sut.mutate(action: $0) }
                            .bind(to: observer)
                            .disposed(by: disposeBag)
                    }

                    it("should move down 2 -> 0 -> 1, merge 2 -> 0 and move down 2 -> 0 -> 1") {
                        testSchedule.start()
                        expect(observer.events) == [
                            next(250, .move(direction: .down, index: 2)),
                            next(250, .move(direction: .down, index: 0)),
                            next(250, .move(direction: .down, index: 1)),
                            next(250, .merge(direction: .down, index: 2)),
                            next(250, .merge(direction: .down, index: 0)),
                            next(250, .move(direction: .down, index: 2)),
                            next(250, .move(direction: .down, index: 0)),
                            next(250, .move(direction: .down, index: 1))
                        ]
                    }
                }

                context("when left action before right action") {
                    beforeEach {
                        xs = testSchedule.createHotObservable(
                            [next(250, .swipe(.left)),
                             next(350, .swipe(.right))]
                        )

                        xs.flatMap { sut.mutate(action: $0) }
                            .bind(to: observer)
                            .disposed(by: disposeBag)
                    }

                    it("should move left at 250 and move right at 350") {
                        testSchedule.start()
                        expect(observer.events) == [
                            next(250, .move(direction: .left, index: 1)),
                            next(250, .move(direction: .left, index: 3)),
                            next(250, .move(direction: .left, index: 2)),
                            next(250, .merge(direction: .left, index: 1)),
                            next(250, .merge(direction: .left, index: 3)),
                            next(250, .move(direction: .left, index: 1)),
                            next(250, .move(direction: .left, index: 3)),
                            next(250, .move(direction: .left, index: 2)),

                            next(350, .move(direction: .right, index: 2)),
                            next(350, .move(direction: .right, index: 0)),
                            next(350, .move(direction: .right, index: 1)),
                            next(350, .merge(direction: .right, index: 2)),
                            next(350, .merge(direction: .right, index: 0)),
                            next(350, .move(direction: .right, index: 2)),
                            next(350, .move(direction: .right, index: 0)),
                            next(350, .move(direction: .right, index: 1))
                        ]
                    }
                }
            }

            describe("reduce") {
                var matrix: [Int]!
                var state: State!
                context("given matrix") {
                    beforeEach {
                        matrix = [1, 0, 0, 0,
                                  0, 0, 0, 0,
                                  0, 0, 0, 0,
                                  1, 0, 0, 0]
                        state = State(tiles: matrix.map { $0 == 0 ? .empty : Tile(id: NSUUID().uuidString, level: $0) }, score: 0)
                    }

                    context("when reduce with move right index 0 once") {
                        beforeEach {
                            state = sut.reduce(state: state, mutation: .move(direction: .right, index: 0))
                        }

                        it("result should be moved right once") {
                            expect(state.tiles.map { $0.level })
                                == [0, 1, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 1, 0, 0]
                        }

                        context("when reduce with move right index 1 once") {
                            beforeEach {
                                state = sut.reduce(state: state, mutation: .move(direction: .right, index: 1))
                            }

                            it("result should be moved right once") {
                                expect(state.tiles.map { $0.level })
                                    == [0, 0, 1, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 1, 0]
                            }
                        }

                        context("when reduce with move left index 1 once") {
                            beforeEach {
                                state = sut.reduce(state: state, mutation: .move(direction: .left, index: 1))
                            }

                            it("result should be moved left once") {
                                expect(state.tiles.map { $0.level })
                                    == [1, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        1, 0, 0, 0]
                            }
                        }
                    }

                    context("when reduce with move left index 0 once") {
                        beforeEach {
                            state = sut.reduce(state: state, mutation: .move(direction: .left, index: 0))
                        }

                        it("result should be moved left once") {
                            expect(state.tiles.map { $0.level })
                                == [1, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    1, 0, 0, 0]
                        }
                    }

                    context("when reduce with move up index 3") {
                        beforeEach {
                            state = sut.reduce(state: state, mutation: .move(direction: .up, index: 3))
                        }

                        it("result should be moved up once") {
                            expect(state.tiles.map { $0.level })
                                == [1, 0, 0, 0,
                                    0, 0, 0, 0,
                                    1, 0, 0, 0,
                                    0, 0, 0, 0]
                        }
                    }

                    context("when reduce with move down index 0") {
                        beforeEach {
                            state = sut.reduce(state: state, mutation: .move(direction: .down, index: 0))
                        }

                        it("result should be moved down once") {
                            expect(state.tiles.map { $0.level })
                                == [0, 0, 0, 0,
                                    1, 0, 0, 0,
                                    0, 0, 0, 0,
                                    1, 0, 0, 0]
                        }
                    }

                    context("when reduce clear") {
                        beforeEach {
                            state = sut.reduce(state: state, mutation: .clear)
                        }

                        it("all tiles should be empty") {
                            expect(state.tiles.map { $0.level })
                                == [0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0]
                        }
                    }
                }

                context("given fulfilled matrix with level 1") {
                    beforeEach {
                        matrix = [1, 1, 1, 1,
                                  1, 1, 1, 1,
                                  1, 1, 1, 1,
                                  1, 1, 1, 1]
                        state = State(tiles: matrix.map { $0 == 0 ? .empty : Tile(id: NSUUID().uuidString, level: $0) }, score: 0)
                    }

                    context("when reduce with merge right index 0") {
                        beforeEach {
                            state = sut.reduce(state: state, mutation: .merge(direction: .right, index: 0))
                        }

                        it("result should be merged right once") {
                            expect(state.tiles.map { $0.level })
                                == [0, 2, 1, 1,
                                    0, 2, 1, 1,
                                    0, 2, 1, 1,
                                    0, 2, 1, 1]
                            expect(state.score) == 16
                        }

                        context("and reduce with merge right index 2") {
                            beforeEach {
                                state = sut.reduce(state: state, mutation: .merge(direction: .right, index: 2))
                            }

                            it("result should be merged right once") {
                                expect(state.tiles.map { $0.level })
                                    == [0, 2, 0, 2,
                                        0, 2, 0, 2,
                                        0, 2, 0, 2,
                                        0, 2, 0, 2]
                                expect(state.score) == 32
                            }

                            context("when reduce with merge up index 3") {
                                beforeEach {
                                    state = sut.reduce(state: state, mutation: .merge(direction: .up, index: 3))
                                }

                                it("result should be merged up once") {
                                    expect(state.tiles.map { $0.level })
                                        == [0, 2, 0, 2,
                                            0, 2, 0, 2,
                                            0, 3, 0, 3,
                                            0, 0, 0, 0]
                                    expect(state.score) == 48
                                }

                                context("when reduce with merge down index 0") {
                                    beforeEach {
                                        state = sut.reduce(state: state, mutation: .merge(direction: .down, index: 0))
                                    }

                                    it("result should be merged down once") {
                                        expect(state.tiles.map { $0.level })
                                            == [0, 0, 0, 0,
                                                0, 3, 0, 3,
                                                0, 3, 0, 3,
                                                0, 0, 0, 0]
                                        expect(state.score) == 64
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
