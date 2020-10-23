//
//  Helper.swift
//  Movie
//
//  Created by Oleksandr Karpenko on 23.10.2020.
//

import UIKit
import Foundation

class Helper {
    
    static let shared = Helper()
    
    private init() {}
    
    func setStarts(_ stars: Int, stackView: UIStackView) {
        for i in 0..<stars {
            let button = stackView.subviews[i] as! UIButton
            button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
}
