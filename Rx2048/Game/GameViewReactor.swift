//
//  GameViewReactor.swift
//  Rx2048
//
//  Created by Cruz on 23/11/2018.
//  Copyright © 2018 Cruz. All rights reserved.
//

import UIKit
import Deli
import RxCocoa
import RxSwift
import ReactorKit

class GameViewReactor: Reactor, Autowired {

    // MARK: - Deli

    var scope: Scope = .prototype

    enum Direction {
        case up
        case down
        case left
        case right
    }

    enum Action {
        case startGame
        case swipe(Direction)
    }

    enum Mutation: Equatable {
        case create
        case clear
        case move(direction: Direction, index: Int)
        case merge(direction: Direction, index: Int)
    }

    struct State {
        var tiles: [Tile?] = Array<Tile?>(repeating: nil, count: 16)
    }

    var initialState: State = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startGame:
            return Observable.of(.clear, .create, .create)
        case .swipe(let direction):
            switch direction {
            case .down, .right:
                let move = [3,1,2].map { Mutation.move(direction: direction, index: $0) }
                let merge = [3,1].map { Mutation.merge(direction: direction, index: $0) }
                return Observable.from(move + merge + move)
            case .up, .left:
                let move = [2,4,3].map { Mutation.move(direction: direction, index: $0) }
                let merge = [2,4].map { Mutation.merge(direction: direction, index: $0) }
                return Observable.from(move + merge + move)
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }

    required init() {

    }
}
