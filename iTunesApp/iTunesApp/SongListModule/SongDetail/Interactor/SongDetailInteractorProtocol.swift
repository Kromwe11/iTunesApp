//
//  SongDetailInteractorProtocol.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 26.06.2024.
//

import Foundation

/// Протокол для взаимодействия с интерактором
protocol SongDetailInteractorInputProtocol: AnyObject {
    /// Метод для настройки интерактора с песней
    /// - Parameter song: объект песни для настройки
    func configure(song: Song)
}

/// Протокол для обратного вызова из интерактора
protocol SongDetailInteractorOutputProtocol: AnyObject {
}
