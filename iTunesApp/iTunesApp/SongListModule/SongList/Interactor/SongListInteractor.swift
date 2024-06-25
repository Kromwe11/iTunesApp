//  SongListInteractor.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import Foundation

/// Протокол для обратного вызова из интерактора
protocol SongListInteractorOutputProtocol: AnyObject {
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
protocol SongListInteractorInputProtocol: AnyObject {
    /// Ищет песни по ключевому слову
    /// - Parameters:
    ///   - keyword: ключевое слово для поиска песен
    ///   - page: номер страницы для пагинации
    ///   - isPagination: флаг пагинации
    func searchSongs(with keyword: String, page: Int, isPagination: Bool)
}

final class SongListInteractor: SongListInteractorInputProtocol {
    
    // MARK: - Public properties

    weak var presenter: SongListInteractorOutputProtocol?
    
    // MARK: - Private properties

    private var networkManager: NetworkManaging?

    private enum Constants {
        static let minimumKeywordLength: Int = 3
        static let songsPerPage: Int = 20
        static let keywordLengthError = "Keyword must be longer than 3 characters."
    }

    // MARK: - Configuration
    func configure(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    // MARK: - Public Methods
    func searchSongs(with keyword: String, page: Int, isPagination: Bool) {
        guard keyword.count > Constants.minimumKeywordLength else {
            presenter?.didFailToRetrieveSongs(
                with: NSError(
                    domain: "",
                    code: 400,
                    userInfo: [NSLocalizedDescriptionKey: Constants.keywordLengthError]
                )
            )
            return
        }
        
        networkManager?.searchSongs(keyword: keyword, offset: page * Constants.songsPerPage) { [weak self] result in
            switch result {
            case .success(let songs):
                self?.presenter?.didRetrieveSongs(songs, isPagination: isPagination)
            case .failure(let error):
                self?.presenter?.didFailToRetrieveSongs(with: error)
            }
        }
    }
}
