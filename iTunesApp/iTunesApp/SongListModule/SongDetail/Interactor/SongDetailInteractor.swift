//  SongDetailInteractor.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
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
    // Методы обратного вызова из интерактора, если необходимы
}

final class SongDetailInteractor: SongDetailInteractorInputProtocol {
    
    // MARK: - Public properties
    weak var presenter: SongDetailInteractorOutputProtocol?

    // MARK: - Private properties
    private var song: Song?

    // MARK: - Public Methods
    func configure(song: Song) {
        self.song = song
    }
}
