//
//  UIImageView+URL.swift
//  MarvelApp
//
//  Created by Igor Zarubin on 26.03.2022.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImage(for url: URL?, placeholder: UIImage?) {
        self.kf.setImage(with: url, placeholder: placeholder)
    }

    func cancelImageDownload() {
        self.kf.cancelDownloadTask()
    }
}
