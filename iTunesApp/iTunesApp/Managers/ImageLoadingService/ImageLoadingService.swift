//
// ImageLoadingService.swift
// iTunesApp
//
// Created by Висент Щепетков on 26.06.2024.
//

import UIKit

/// Протокол для сервиса загрузки изображений
protocol ImageLoadingServiceProtocol {
    /// Загрузка изображения по URL
    /// - Parameters:
    ///   - url: URL изображения
    ///   - completion: Замыкание с результатом загрузки изображения
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

final class ImageLoadingService: ImageLoadingServiceProtocol {
    
    // MARK: - Public Methods
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
