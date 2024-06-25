//
//  SongListPresenter.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import Foundation

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
}

final class SongListPresenter: SongListPresenterProtocol {
    
    // MARK: - Public properties
    weak var view: SongListViewProtocol?
    var interactor: SongListInteractorInputProtocol?
    var router: SongListRouterProtocol?

    // MARK: - Private properties
    private var currentKeyword: String = ""
    private var currentPage: Int = 0

    private enum Constants {
        static let minimumKeywordLength: Int = 3
        static let initialPage: Int = 0
        static let keywordLengthError = "Keyword must be longer than 3 characters."
    }

    // MARK: - Public Methods

    func searchSongs(with keyword: String) {
        guard keyword.count > Constants.minimumKeywordLength else {
            view?.showError(Constants.keywordLengthError)
            return
        }
        currentKeyword = keyword
        currentPage = Constants.initialPage
        view?.showLoading()
        interactor?.searchSongs(with: keyword, page: currentPage, isPagination: false)
    }
    
    func loadMoreSongs() {
        currentPage += 1
        interactor?.searchSongs(with: currentKeyword, page: currentPage, isPagination: true)
    }

    func didSelectSong(_ song: Song) {
        router?.navigateToSongDetail(from: view, with: song)
    }
}

// MARK: - SongListInteractorOutputProtocol
extension SongListPresenter: SongListInteractorOutputProtocol {
    func didRetrieveSongs(_ songs: [Song], isPagination: Bool) {
        if isPagination {
            view?.appendSongs(songs)
        } else {
            view?.showSongs(songs)
        }
        view?.hideLoading()
    }

    func didFailToRetrieveSongs(with error: Error) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
}
