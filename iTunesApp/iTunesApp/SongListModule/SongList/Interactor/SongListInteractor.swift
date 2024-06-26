//
// SongListInteractor.swift
// iTunesApp
//
// Created by Висент Щепетков on 25.06.2024.
//

import UIKit

final class SongListInteractor: SongListInteractorInput {
    
    // MARK: - Private properties
    private var networkManager: NetworkManaging?
    private weak var presenter: SongListInteractorOutput?
    private var imageLoadingService: ImageLoadingServiceProtocol?
    
    private enum Constants {
        static let minimumKeywordLength: Int = 3
        static let songsPerPage: Int = 20
        static let keywordLengthError = "Keyword must be longer than 3 characters."
    }
    
    // MARK: - Configuration
    func configure(networkManager: NetworkManaging, presenter: SongListInteractorOutput, imageLoadingService: ImageLoadingServiceProtocol) {
        self.networkManager = networkManager
        self.presenter = presenter
        self.imageLoadingService = imageLoadingService
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
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        imageLoadingService?.loadImage(from: url, completion: completion)
    }
}
