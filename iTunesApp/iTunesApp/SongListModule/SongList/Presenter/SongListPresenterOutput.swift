//
//  SongListPresenterOutput.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 26.06.2024.
//

import Foundation

/// Протокол для отображения списка песен
protocol SongListPresenterOutput: AnyObject {
    /// Отображает список песен
    /// - Parameter songs: массив песен для отображения
    func showSongs(_ songs: [Song])
    
    /// Добавляет песни к текущему списку
    /// - Parameter songs: массив песен для добавления
    func appendSongs(_ songs: [Song])
    
    /// Отображает ошибку
    /// - Parameter message: сообщение об ошибке
    func showError(_ message: String)
    
    /// Показывает индикатор загрузки
    func showLoading()
    
    /// Скрывает индикатор загрузки
    func hideLoading()
}
