//
//  SongListPresenterProtocol.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 26.06.2024.
//

import UIKit

/// Протокол для презентера списка песен
protocol SongListPresenterProtocol: AnyObject {
    
    /// Ищет песни по ключевому слову
    /// - Parameter keyword: ключевое слово для поиска песен
    func searchSongs(with keyword: String)
    
    /// Загружает больше песен для пагинации
    func loadMoreSongs()
    
    /// Вызывается при выборе песни
    /// - Parameter song: выбранная песня
    func didSelectSong(_ song: Song)
    
    /// Загрузить изображение по URL
    /// - Parameters:
    ///   - url: URL изображения
    ///   - completion: Замыкание с результатом загрузки изображения
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}
