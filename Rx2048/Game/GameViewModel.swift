//
//  GameViewModel.swift
//  Rx2048
//
//  Created by Cruz on 23/11/2018.
//  Copyright © 2018 Cruz. All rights reserved.
//

import UIKit
import Gradients

struct Tile: Equatable {
    var id: String
    var level: Int
}

extension Tile {
    static let empty = Tile(id: "", level: 0)

    var number: String {
        return "\(2 << max(level - 1, 0))"
    }

    var backgroundLayer: CALayer? {
        return Gradients(rawValue: level)?.layer
    }
}
