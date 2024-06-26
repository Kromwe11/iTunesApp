//
//  Song.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import Foundation

struct Song: Decodable {
    let trackName: String?
    let artistName: String?
    let artworkUrl100: String?
    let previewUrl: String?
}

struct SongResponse: Decodable {
    let results: [Song]
}
