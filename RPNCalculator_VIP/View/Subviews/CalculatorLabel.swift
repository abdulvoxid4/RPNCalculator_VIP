//
//  CalculatorLabel.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

import UIKit

final class CalculatorLabel: UILabel {
    
    init(text: String,
         textColor: UIColor,
         font: UIFont
    ) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = .right
        self.numberOfLines = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
