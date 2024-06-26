//
//  SongListRouter.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import UIKit

final class SongListRouter: SongListRouterProtocol {
    
    // MARK: - Public Methods
    static func createSongListModule() -> UIViewController {
        let view = SongListViewController()
        let interactor = SongListInteractor()
        let presenter = SongListPresenter()
        let router = SongListRouter()
        let imageLoadingService = ImageLoadingService()
        let networkManager = NetworkManager()
        
        view.configure(presenter: presenter)
        presenter.configure(view: view, interactor: interactor, router: router)
        interactor.configure(
            networkManager: networkManager,
            presenter: presenter,
            imageLoadingService: imageLoadingService
        )
        
        return view
    }
    
    func navigateToSongDetail(from view: SongListPresenterOutput?, with song: Song) {
        let songDetailViewController = SongDetailRouter.createSongDetailModule(with: song)
        guard let viewController = view as? UIViewController else { return }
        viewController.navigationController?.pushViewController(songDetailViewController, animated: true)
    }
}
