//
//  SongDetailPresenterProtocol.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 26.06.2024.
//

import UIKit

/// Протокол для презентера деталей песни
protocol SongDetailPresenterProtocol: AnyObject {
    /// Вызывается при загрузке представления
    func viewDidLoad()
    
    /// Обновляет прогресс воспроизведения песни
    /// - Parameters:
    ///   - currentTime: текущее время воспроизведения
    ///   - duration: общая продолжительность песни
    func updateProgress(currentTime: Double, duration: Double)
    
    /// Настраивает презентер с объектом песни и сервисом воспроизведения
    /// - Parameters:
    ///   - view: представление для презентера
    ///   - song: объект песни для настройки
    ///   - playerService: сервис для управления воспроизведением
    func configure(
        view: SongDetailPresenterOutput,
        song: Song,
        playerService: PlayerServiceProtocol,
        imageLoadingService: ImageLoadingServiceProtocol
    )
    
    /// Начинает воспроизведение песни
    func play()
    
    /// Приостанавливает воспроизведение песни
    func pause()
    
    /// Перематывает воспроизведение назад на указанное количество секунд
    /// - Parameter seconds: количество секунд для перемотки назад
    func rewind(by seconds: Double)
    
    /// Перематывает воспроизведение вперед на указанное количество секунд
    /// - Parameter seconds: количество секунд для перемотки вперед
    func fastForward(by seconds: Double)
    
    /// Устанавливает позицию воспроизведения на указанное время
    /// - Parameter seconds: время для установки позиции воспроизведения
    func seek(to seconds: Double)
    
    /// Загрузить изображение по URL
    /// - Parameters:
    ///   - url: URL изображения
    ///   - completion: Замыкание с результатом загрузки изображения
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}
