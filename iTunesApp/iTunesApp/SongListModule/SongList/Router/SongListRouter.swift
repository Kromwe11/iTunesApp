//
//  SongListRouter.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import UIKit

/// Протокол для маршрутизатора списка песен
protocol SongListRouterProtocol: AnyObject {
    /// Создает модуль списка песен
    /// - Returns: контроллер представления для списка песен
    static func createSongListModule() -> UIViewController
    
    /// Навигация к деталям песни
    /// - Parameters:
    ///   - view: текущее представление списка песен
    ///   - song: объект песни для отображения
    func navigateToSongDetail(from view: SongListViewProtocol?, with song: Song)
}

final class SongListRouter: SongListRouterProtocol {
    
    // MARK: - Public Methods
    static func createSongListModule() -> UIViewController {
        let view = SongListViewController()
        let interactor = SongListInteractor()
        let presenter = SongListPresenter()
        let router = SongListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.configure(networkManager: NetworkManager())
        
        return view
    }
    
    func navigateToSongDetail(from view: SongListViewProtocol?, with song: Song) {
        let songDetailViewController = SongDetailRouter.createSongDetailModule(with: song)
        if let viewController = view as? UIViewController {
            viewController.navigationController?.pushViewController(songDetailViewController, animated: true)
        }
    }
}
