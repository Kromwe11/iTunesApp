//
//  NetworkManager.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

import Foundation

final class NetworkManager: NetworkManaging {
    
    // MARK: - Public Methods
    func searchSongs(keyword: String, offset: Int = 0, completion: @escaping (Result<[Song], Error>) -> Void) {
        let formattedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? keyword
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(formattedKeyword)&media=music&entity=song&offset=\(offset)") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 204, userInfo: nil)))
                return
            }

            do {
                let songResponse = try JSONDecoder().decode(SongResponse.self, from: data)
                completion(.success(songResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
