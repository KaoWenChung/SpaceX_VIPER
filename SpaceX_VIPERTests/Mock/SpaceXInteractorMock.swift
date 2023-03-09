//
//  SpaceXInteractorMock.swift
//  SpaceX_VIPERTests
//
//  Created by wyn on 2023/3/9.
//

@testable import SpaceX_VIPER

final class MockSpaceXInteractor: SpaceXInteractorType {
    var launches: [LaunchCell]
    var sortOptions: [AlertAction.Button]
    var presenter: SpaceXListInteractorToPresenterProtocol?

    init(launches: [LaunchCell],
         sortOptions: [AlertAction.Button],
         presenter: SpaceXListInteractorToPresenterProtocol? = nil) {
        self.launches = launches
        self.sortOptions = sortOptions
        self.presenter = presenter
    }

    func loadNextPage() async {
    }

    func didConfirmFilter(_ model: FilterDialog) async {

    }
}
