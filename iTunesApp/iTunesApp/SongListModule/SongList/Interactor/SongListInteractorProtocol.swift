//
//  SongListInteractorProtocol.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 26.06.2024.
//

import UIKit

/// Протокол для обратного вызова из интерактора
protocol SongListInteractorOutput: AnyObject {
    /// Вызывается при успешном получении песен
    /// - Parameters:
    ///   - songs: массив песен
    ///   - isPagination: флаг пагинации
    func didRetrieveSongs(_ songs: [Song], isPagination: Bool)
    
    /// Вызывается при ошибке получения песен
    /// - Parameter error: ошибка
    func didFailToRetrieveSongs(with error: Error)
}

/// Протокол для взаимодействия с интерактором
protocol SongListInteractorInput: AnyObject {
    /// Ищет песни по ключевому слову
    /// - Parameters:
    ///   - keyword: ключевое слово для поиска песен
    ///   - page: номер страницы для пагинации
    ///   - isPagination: флаг пагинации
    func searchSongs(with keyword: String, page: Int, isPagination: Bool)
    
    /// Загрузить изображение по URL
    /// - Parameters:
    ///   - url: URL изображения
    ///   - completion: Замыкание с результатом загрузки изображения
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}
