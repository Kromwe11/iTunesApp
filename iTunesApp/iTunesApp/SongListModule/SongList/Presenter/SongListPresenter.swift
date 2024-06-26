//
//  SongListPresenter.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import UIKit

final class SongListPresenter: SongListPresenterProtocol {
    
    // MARK: - Private properties
    private var currentKeyword: String = ""
    private var currentPage: Int = 0
    private weak var view: SongListPresenterOutput?
    private var interactor: SongListInteractorInput?
    private var router: SongListRouterProtocol?
    
    private enum Constants {
        static let minimumKeywordLength: Int = 3
        static let initialPage: Int = 0
        static let keywordLengthError = "Keyword must be longer than 3 characters."
    }
    
    // MARK: - Configuration
    func configure(view: SongListPresenterOutput, interactor: SongListInteractorInput, router: SongListRouterProtocol) {
        self.interactor = interactor
        self.view = view
        self.router = router
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
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        interactor?.loadImage(from: url, completion: completion)
    }
}

// MARK: - SongListInteractorOutput
extension SongListPresenter: SongListInteractorOutput {
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
