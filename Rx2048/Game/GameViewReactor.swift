//
//  GameViewReactor.swift
//  Rx2048
//
//  Created by Cruz on 23/11/2018.
//  Copyright © 2018 Cruz. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit

class GameViewReactor: Reactor {
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

    enum Mutation {
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
        return Observable.just(.create)
    }

    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}
