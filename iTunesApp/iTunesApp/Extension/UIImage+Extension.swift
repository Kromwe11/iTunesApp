//
//  UIImage+Extension.swift
//  iTunesApp
//
//  Created by Висент Щепетков on 25.06.2024.
//

// UIImageView+Extension.swift
import UIKit

extension UIImageView {
    func load(url: URL, placeholder: UIImage?) {
        self.image = placeholder
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
