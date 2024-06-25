//
//  SongDetailRouter.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import UIKit

/// Протокол для маршрутизатора деталей песни
protocol SongDetailRouterProtocol: AnyObject {
    /// Создает модуль деталей песни
    /// - Parameter song: объект песни для отображения
    /// - Returns: контроллер представления для деталей песни
    static func createSongDetailModule(with song: Song) -> UIViewController
}

final class SongDetailRouter: SongDetailRouterProtocol {
    
    // MARK: - Public Methods
    static func createSongDetailModule(with song: Song) -> UIViewController {
        let view = SongDetailViewController()
        let presenter = SongDetailPresenter()
        view.presenter = presenter
        presenter.view = view
        presenter.configure(with: song)
        return view
    }
}
