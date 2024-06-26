//
//  SongDetailInteractor.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import Foundation

final class SongDetailInteractor: SongDetailInteractorInputProtocol {
    
    // MARK: - Public properties
    weak var presenter: SongDetailInteractorOutputProtocol?

    // MARK: - Private properties
    private var song: Song?

    // MARK: - Public Methods
    func configure(song: Song) {
        self.song = song
    }
}
