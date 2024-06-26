//
//  PlayerServiceDelegate.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 26.06.2024.
//

import Foundation

/// Протокол делегата для получения обновлений от PlayerService
protocol PlayerServiceDelegate: AnyObject {
    /// Вызывается при обновлении прогресса воспроизведения
    /// - Parameters:
    ///   - currentTime: Текущее время воспроизведения
    ///   - duration: Общая продолжительность трека
    func didUpdateProgress(currentTime: Double, duration: Double)
    
    /// Вызывается при изменении статуса воспроизведения (играет/пауза)
    /// - Parameter isPlaying: Статус воспроизведения
    func didChangePlayStatus(isPlaying: Bool)
}
