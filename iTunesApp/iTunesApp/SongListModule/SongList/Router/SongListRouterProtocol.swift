//
//  SongListRouterProtocol.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 26.06.2024.
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
    func navigateToSongDetail(from view: SongListPresenterOutput?, with song: Song)
}
