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
        var tiles: [Tile] = Array<Tile>(repeating: .empty, count: 16)
    }

    var initialState: State = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startGame:
            return Observable.of(.clear, .create, .create)
        case .swipe(let direction):
            switch direction {
            case .down, .right:
                let move = [2, 0, 1].map { Mutation.move(direction: direction, index: $0) }
                let merge = [2, 0].map { Mutation.merge(direction: direction, index: $0) }
                return Observable.from(move + merge + move)
            case .up, .left:
                let move = [1, 3, 2].map { Mutation.move(direction: direction, index: $0) }
                let merge = [1, 3].map { Mutation.merge(direction: direction, index: $0) }
                return Observable.from(move + merge + move)
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .create:
            break
        case .clear:
            break
        case .move(let direction, let index):
            switch direction {
            case .right:
                for row in 0...3 {
                    if newState.tiles[row * 4 + index + 1] == .empty, newState.tiles[row * 4 + index] != .empty {
                        newState.tiles[row * 4 + index + 1] = newState.tiles[row * 4 + index]
                        newState.tiles[row * 4 + index] = .empty
                    }
                }
            case .left where index > 0:
                for row in 0...3 {
                    if newState.tiles[row * 4 + index - 1] == .empty, newState.tiles[row * 4 + index] != .empty {
                        newState.tiles[row * 4 + index - 1] = newState.tiles[row * 4 + index]
                        newState.tiles[row * 4 + index] = .empty
                    }
                }
            case .up where index > 0:
                for column in 0...3 {
                    if newState.tiles[column + (index - 1) * 4] == .empty, newState.tiles[column + index * 4] != .empty {
                        newState.tiles[column + (index - 1) * 4] = newState.tiles[column + index * 4]
                        newState.tiles[column + index * 4] = .empty
                    }
                }
            case .down:
                for column in 0...3 {
                    if newState.tiles[column + (index + 1) * 4] == .empty, newState.tiles[column + index * 4] != .empty {
                        newState.tiles[column + (index + 1) * 4] = newState.tiles[column + index * 4]
                        newState.tiles[column + index * 4] = .empty
                    }
                }
                break
            default:
                break
            }
        case .merge(let direction, let index):
            break
        }
        return newState
    }

    required init() {

    }
}
