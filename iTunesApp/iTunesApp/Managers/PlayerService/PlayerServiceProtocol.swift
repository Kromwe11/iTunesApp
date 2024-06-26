//
//  PlayerServiceProtocol.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 26.06.2024.
//

import Foundation // player серивс в отдельную папку

/// Протокол для сервиса проигрывателя
protocol PlayerServiceProtocol: AnyObject {
    /// Делегат для получения обновлений состояния проигрывателя
    var delegate: PlayerServiceDelegate? { get set }
    
    /// Продолжительность текущего трека
    var duration: Double { get }
    
    /// Настраивает проигрыватель с заданным URL
    /// - Parameter url: URL трека для воспроизведения
    func configure(with url: URL)
    
    /// Запускает воспроизведение трека
    func play()
    
    /// Приостанавливает воспроизведение трека
    func pause()
    
    /// Перематывает трек назад на указанное количество секунд
    /// - Parameter seconds: Количество секунд для перемотки назад
    func rewind(by seconds: Double)
    
    /// Перематывает трек вперед на указанное количество секунд
    /// - Parameter seconds: Количество секунд для перемотки вперед
    func fastForward(by seconds: Double)
    
    /// Перемещает воспроизведение на указанное время
    /// - Parameter seconds: Время для перемещения в секундах
    func seek(to seconds: Double)
}
