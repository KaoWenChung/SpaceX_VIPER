//
//  SpaceXPresenter.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import Foundation

final class SpaceXListPresenter {
    private let interactor: SpaceXListInteractorType
    init(interactor: SpaceXListInteractorType) {
        self.interactor = interactor
    }
}

extension SpaceXListPresenter: SpaceXListInteractorToPresenter {
    func didLoadLaunches() {
        
    }

    func loadLaunchesFailed() {
        
    }
}
