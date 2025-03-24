//
//  StringExt.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 21/03/25.
//

extension String {
    
    typealias CB = CalculatorButtonsEnum
    
    var removeUntilLastNumber: String? {
        
        var str = self
        var opearators =  [
            CB.plus.char,
            CB.minus.char,
            CB.multiplyX.char,
            CB.divide.char
        ]
        
        while let lastChar = str.last, opearators.contains(lastChar) {
            if str.isEmpty {return nil}
            str.removeLast()
        }
        return str
    }
    
}
