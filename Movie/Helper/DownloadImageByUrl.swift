//
//  DownloadImageByUrl.swift
//  Movie
//
//  Created by Oleksandr Karpenko on 23.10.2020.
//

import UIKit
import Foundation

extension UIImageView {
    
    func imageByUrl(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = UIImage(data: data)
            }
        }.resume()
    }
}
