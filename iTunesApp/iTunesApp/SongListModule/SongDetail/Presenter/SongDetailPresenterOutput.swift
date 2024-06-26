//
//  SongDetailPresenterOutput.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 26.06.2024.
//

import Foundation

/// Протокол для отображения деталей песни
protocol SongDetailPresenterOutput: AnyObject {
    /// Отображает детали песни
    /// - Parameter song: объект песни для отображения
    func showSongDetail(with song: Song)
    
    /// Обновляет заголовок кнопки воспроизведения
    /// - Parameter isPlaying:  флаг, указывающий, воспроизводится ли в данный момент песня
    func updatePlayButtonTitle(isPlaying: Bool)
    
    /// Обновляет прогресс воспроизведения
    /// - Parameters:
    ///   - currentTime: текущее время воспроизведения
    ///   - duration: общая продолжительность песни
    func updateProgress(currentTime: Double, duration: Double)
}
