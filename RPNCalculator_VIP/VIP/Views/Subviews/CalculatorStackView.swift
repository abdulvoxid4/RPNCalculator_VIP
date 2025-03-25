//
//  CalculatorStackView.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

import UIKit

final class CalculatorStackView: UIStackView {
    init(
            axis: NSLayoutConstraint.Axis = .vertical,
            alignment: UIStackView.Alignment = .fill
        ) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            self.axis = axis
            self.distribution = .fillEqually
            self.alignment = alignment
            self.spacing = 10
        }

        func addArrangedSubviews(_ views: UIView...) {
            views.forEach { addArrangedSubview($0) }
        }
        
        func removeAllArrangedSubviews() {
            arrangedSubviews.forEach { $0.removeFromSuperview() }
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

}
