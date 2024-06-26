//
//  NetworkManagingProtocol.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 26.06.2024.
//

import Foundation

/// Протокол для сетевого менеджера
protocol NetworkManaging {
    /// Ищет песни по ключевому слову
    /// - Parameters:
    ///   - keyword: ключевое слово для поиска песен
    ///   - offset: смещение для пагинации
    ///   - completion: замыкание с результатом поиска
    func searchSongs(keyword: String, offset: Int, completion: @escaping (Result<[Song], Error>) -> Void)
}
