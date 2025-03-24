//
//  HistoryButton.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 21/03/25.
//

import UIKit

final class HistoryButton: UIButton {
    init(imageName: String) {
        super.init(frame: .zero)
        setImage(UIImage(systemName: imageName), for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

