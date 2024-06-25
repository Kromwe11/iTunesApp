//
//  SongDetailPresenter.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import Foundation

/// Протокол для презентера деталей песни
protocol SongDetailPresenterProtocol: AnyObject {
    /// Вызывается при загрузке представления
    func viewDidLoad()
    
    /// Обновляет прогресс воспроизведения песни
    /// - Parameters:
    ///   - currentTime: текущее время воспроизведения
    ///   - duration: общая продолжительность песни
    func updateProgress(currentTime: Double, duration: Double)
    
    /// Настраивает презентер с объектом песни
    /// - Parameter song: объект песни для настройки
    func configure(with song: Song)
}

final class SongDetailPresenter: SongDetailPresenterProtocol {
    
    // MARK: - Public properties
    weak var view: SongDetailViewProtocol?

    // MARK: - Private properties
    private var song: Song?

    // MARK: - Configuration
    func configure(with song: Song) {
        self.song = song
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        guard let song = song else { return }
        view?.showSongDetail(with: song)
    }

    func updateProgress(currentTime: Double, duration: Double) {
        view?.updateProgress(currentTime: currentTime, duration: duration)
    }
}
