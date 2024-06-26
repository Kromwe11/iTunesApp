//
//  SongDetailRouter.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import UIKit

final class SongDetailRouter: SongDetailRouterProtocol {
    
    // MARK: - Public Methods
    static func createSongDetailModule(with song: Song) -> UIViewController {
        let view = SongDetailViewController()
        let presenter = SongDetailPresenter()
        let playerService = PlayerService.shared
        let imageLoadingService = ImageLoadingService()
        view.configure(presenter: presenter)
        presenter.configure(view: view, song: song, playerService: playerService, imageLoadingService: imageLoadingService)
        
        return view
    }
}
