//
//  SongDetailRouterProtocol.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 26.06.2024.
//

import UIKit

/// Протокол для маршрутизатора деталей песни
protocol SongDetailRouterProtocol: AnyObject {
    /// Создает модуль деталей песни
    /// - Parameter song: объект песни для отображения
    /// - Returns: контроллер представления для деталей песни
    static func createSongDetailModule(with song: Song) -> UIViewController
}
