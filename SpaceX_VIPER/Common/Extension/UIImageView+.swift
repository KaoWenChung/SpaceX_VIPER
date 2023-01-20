//
//  UIImageView.swift
//  SpaceX_VIPER
//
//  Created by wyn on 2023/1/17.
//

import UIKit

extension UIImageView {
    /// Download image by URL
    func downloaded(imageLoader: LaunchImagesRepositoryType,
                    from url: String,
                    placeholderImage: String = "noImage",
                    contentMode mode: ContentMode = .scaleAspectFit) async {
        contentMode = mode
        image = UIImage(named: placeholderImage)
        guard !url.isEmpty else { return }
        if let data = try? await imageLoader.fetchImage(with: url) {
            image = UIImage(data: data)
        }
    }
}
