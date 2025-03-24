//
//  CalculatorButton.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

import UIKit

final class CalculatorButton: UIButton {
    init(title: CalculatorButtonsEnum) {
        super.init(frame: .zero)
        setTitle(title.rawValue, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        setTitleColor(.white, for: .normal)
        backgroundColor = setBackgroundColorToEachButton(label: title)
        layer.cornerRadius = (UIScreen.main.bounds.height / 2 - 60) / 10
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setBackgroundColorToEachButton(label: CalculatorButtonsEnum) -> UIColor {
        var color = UIColor.darkGray
        switch label {
        case .openParenthesis, .closeParenthesis, .backspace :
            color = .lightGray
        case .divide, .multiplyX, .minus, .plus, .equal:
            color = .orange
        default: break
        }
        return color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
