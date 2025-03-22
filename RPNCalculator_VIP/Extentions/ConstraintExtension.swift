//
//  ConstraintExtension.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 21/03/25.
//

import UIKit

extension UIView {
    enum Anchor {
        case top
        case left
        case right
        case bottom
        case height
        case width
        case centerX
        case centerY
        case bottomLessThan
        case bottomSafe
        case leftGreaterThan
        case widthGreaterThan
        case bottomToTop
    }
    
    func setConstraints(_ anchor: Anchor, view: UIView? = nil, constant: CGFloat = 0,gr: Bool? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        guard let superview = self.superview else {
            print("Error")
            return
        }
        
        let targetView = view ?? superview
        
        switch anchor {
        case .top:
            self.topAnchor.constraint(equalTo: targetView.topAnchor, constant: constant).isActive = true
        
        case .left:
            self.leadingAnchor.constraint(equalTo: targetView.leadingAnchor, constant: constant).isActive = true
        
        case .right:
            self.trailingAnchor.constraint(equalTo: targetView.trailingAnchor, constant: -constant).isActive = true
       
        case .bottom:
            self.bottomAnchor.constraint(equalTo: targetView.bottomAnchor, constant: -constant).isActive = true
       
        case .height:
            self.heightAnchor.constraint(equalToConstant: constant).isActive = true
        
        case .width:
            self.widthAnchor.constraint(equalToConstant: constant).isActive = true
        
        case .centerX:
            self.centerXAnchor.constraint(equalTo: targetView.centerXAnchor, constant: constant).isActive = true
        
        case .centerY:
            self.centerYAnchor.constraint(equalTo: targetView.centerYAnchor, constant: constant).isActive = true
       
        case .bottomLessThan:
            self.bottomAnchor.constraint(lessThanOrEqualTo: targetView.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
        
        case .leftGreaterThan:
            self.leadingAnchor.constraint(greaterThanOrEqualTo: targetView.leadingAnchor).isActive = true
       
        case .widthGreaterThan:
            self.widthAnchor.constraint(greaterThanOrEqualTo: targetView.widthAnchor).isActive = true
        
        case .bottomSafe:
            self.bottomAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.bottomAnchor, constant: constant).isActive = true
        
        case .bottomToTop:
            self.bottomAnchor.constraint(equalTo: targetView.topAnchor, constant: -constant).isActive = true
        }
    }
}


