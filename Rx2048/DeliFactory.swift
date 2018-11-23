//
//  DeliFactory.swift
//  Auto generated code.
//

import Deli

final class DeliFactory: ModuleFactory {
    override func load(context: AppContext) {
        register(
            GameViewReactor.self,
            resolver: {
                
                return GameViewReactor()
            },
            qualifier: "",
            scope: .prototype
        )
    }
}