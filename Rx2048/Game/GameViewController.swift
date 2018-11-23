//
//  GameViewController.swift
//  Rx2048
//
//  Created by Cruz on 23/11/2018.
//  Copyright © 2018 Cruz. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa
import RxGesture
import RxSwift
import RxOptional
import Gradients

class GameViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        reactor = GameViewReactor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func bind(reactor: GameViewReactor) {

    }
}

