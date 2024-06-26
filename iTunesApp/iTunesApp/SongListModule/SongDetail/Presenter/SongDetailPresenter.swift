//
//  SongDetailPresenter.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import UIKit

final class SongDetailPresenter: SongDetailPresenterProtocol {
    
    // MARK: - Public properties
    weak var view: SongDetailPresenterOutput?
    private var playerService: PlayerServiceProtocol?
    private var imageLoadingService: ImageLoadingServiceProtocol?

    // MARK: - Private properties
    private var song: Song?

    // MARK: - Configuration
    func configure(
        view: SongDetailPresenterOutput,
        song: Song,
        playerService: PlayerServiceProtocol,
        imageLoadingService: ImageLoadingServiceProtocol
    ) {
        self.view = view
        self.song = song
        self.playerService = playerService
        self.imageLoadingService = imageLoadingService
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        guard let song = song else { return }
        view?.showSongDetail(with: song)
    }

    func updateProgress(currentTime: Double, duration: Double) {
        view?.updateProgress(currentTime: currentTime, duration: duration)
    }

    func play() {
        playerService?.play()
    }

    func pause() {
        playerService?.pause()
    }

    func rewind(by seconds: Double) {
        playerService?.rewind(by: seconds)
    }

    func fastForward(by seconds: Double) {
        playerService?.fastForward(by: seconds)
    }

    func seek(to seconds: Double) {
        playerService?.seek(to: seconds)
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        imageLoadingService?.loadImage(from: url, completion: completion)
    }
}
