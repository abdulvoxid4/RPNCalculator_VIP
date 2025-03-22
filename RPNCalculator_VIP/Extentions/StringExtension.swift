//
//  StringExt.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 21/03/25.
//

extension String {
    var removeUntilLastNumber: String? {
        
        var str = self
        
        while let lastChar = str.last, ["+", "-", "×", "÷", "("].contains(lastChar) {
            if str.isEmpty {return nil}
            str.removeLast()
        }
        return str
    }
    
}
