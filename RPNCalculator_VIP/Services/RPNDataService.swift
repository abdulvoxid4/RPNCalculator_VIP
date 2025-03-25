//
//  RPNDataService.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

protocol RPNDataServiceProtocol {
    
    func directTo(currentInput: String, title: CalculatorButtonsEnum) -> (String,String?)

}

final class RPNDataService: RPNDataServiceProtocol {
    
    typealias CB = CalculatorButtonsEnum
    
    
    func directTo(currentInput: String, title: CalculatorButtonsEnum) -> (String, String?) {
        if title == .equal {
            
            let better = currentInput.removeUntilLastNumber ?? currentInput
            
            let postfixInput = infinixToPostfix(expression: better)
            let result = (calculate(postfixInput ?? "Error1") ?? "Error2")
            return (formatResult(result: result), better)
        } else {
            return (buttonPressed(currentInput: currentInput, title: title), nil)
        }
    }
    
    private func buttonPressed(currentInput: String, title: CB) -> String {
        
        var newCurrentInput = currentInput
        let operators: Set<Character> = [CB.plus.char, CB.minus.char, CB.multiplyX.char, CB.divide.char]
        let operatorsWithBrackets: Set<Character> = [CB.plus.char, CB.minus.char, CB.multiplyX.char, CB.divide.char, CB.open.char, CB.close.char]
        let lastNumber = newCurrentInput.split(whereSeparator: { operators.contains($0) }).last ?? ""
        let lastNumberWithoutBrackets = newCurrentInput.split(whereSeparator: { operatorsWithBrackets.contains($0) }).last ?? ""
        let lastChar = newCurrentInput.last ?? "E"
        var expression: String = ""
        
        if newCurrentInput == "Error" {
            newCurrentInput = ""
            expression = ""
        }
        
        switch title {
            // Zero case
        case .zero:
            return zeroHandler(
                lastNumber: lastNumber,
                lastChar: lastChar,
                lastNumberWithoutBrackets: lastNumberWithoutBrackets,
                newCurrentInput: newCurrentInput)
            
            // Backspace case
        case .backspace:
            return backspaceHandler(newCurrentInput: newCurrentInput)
            
            // All Clear, AC case
        case .allClear:
            return CB.zero.rawValue
            
            // Dot case
        case .dot:
            return dotHandler(lastNumber: lastNumber,
                              lastChar: lastChar,
                              operators: operators,
                              newCurrentInput: newCurrentInput
            )
            
            // Operators case
        case .plus, .multiplyX, .divide, .minus:
            return operatorsHandler(lastChar: lastChar,
                                    operators: operators,
                                    title: title,
                                    newCurrentInput: newCurrentInput
            )
            
            // Open parenthesis case
        case .open:
            return openParenthesisHandler(newCurrentInput: newCurrentInput)
            
            // Close parenthesis case
        case .close:
            return closeParenthesisHandler(lastChar: lastChar,
                                           operators: operators,
                                           newCurrentInput: newCurrentInput)
            
            // Numbers case
        default:
            return numbersHandler(
                lastNumber: lastNumber,
                lastChar: lastChar,
                title: title,
                operators: operators,
                lastNumberWithoutBrackets: lastNumberWithoutBrackets,
                newCurrentInput: newCurrentInput)
        }
        
    }
    
    // Evaluates and calculates the RPN expression
    private func calculate(_ input: String) -> String? {
        var stack: [Double] = []
        let tokens = input.split(separator: " ")
        print("Tokens: \(tokens)")
                
        for token in tokens {
            
            if token == CB.open.rawValue || token == CB.close.rawValue {
                continue
            }
            
            if let number = Double(token) {
                stack.append(number)
            } else {
                guard stack.count >= 2 else { return nil }
                let b = stack.removeLast()
                let a = stack.removeLast()

                switch token {
                case CB.plus.rawValue: stack.append(a + b)
                case CB.minus.rawValue: stack.append(a - b)
                case CB.multiplyX.rawValue: stack.append(a * b)
                case  CB.divide.rawValue: if b != 0 { stack.append(a / b) } else { return nil }
                default: return nil
                }
            }
        }
        let result = stack.last
     //   print("Result \(String(describing: result))")
        return result?.description
    }
    
    // Converts infix expression to postfix (RPN)
    private func infinixToPostfix(expression: String) -> String? {
       // let precedence: [Character: Int] = ["+": 1, "-": 1, "*": 2, "/": 2] // Level of operator
        let precedence: [Character: Int] = [
            CB.plus.char: 1,
            CB.minus.char: 1,
            CB.multiplyX.char: 2,
            CB.divide.char: 2
        ] // Level of operator
        
        var output: [String] = []
        var operators: [Character] = []
        var numberBuffer = ""
        
        var expressionForTest = expression
        
        print("±\(expressionForTest)")
        
        for (index, char) in expression.enumerated() {
            if char.isNumber || char == CB.dot.char {
                numberBuffer.append(char)
            } else {
                if !numberBuffer.isEmpty {
                    output.append(numberBuffer)
                    numberBuffer = ""
                }
                    
                if char == CB.minus.char && (index == 0 || expression[expression.index(expression.startIndex, offsetBy: index - 1)] == CB.open.char) {
                    numberBuffer.append(char)
                } else if char == CB.open.char {
                    operators.append(char)
                } else if char == CB.close.char {
                    while let lastOp = operators.last, lastOp != CB.open.char {
                        output.append(String(operators.removeLast()))
                    }
                    operators.removeLast()
                } else if let _ = precedence[char] {
                    while let lastOp = operators.last, precedence[lastOp] ?? 0 >= precedence[char] ?? 0 {
                        output.append(String(operators.removeLast()))
                    }
                    operators.append(char)
                }
            }
        }

        if !numberBuffer.isEmpty {
            output.append(numberBuffer)
        }

        while !operators.isEmpty {
            output.append(String(operators.removeLast()))
        }

        print("Output: \(output.joined(separator: " "))")
        return output.joined(separator: " ")
    }
    
    private func formatResult(result: String) -> String {
        guard let doubleResult = Double(result) else {
            return result
        }
        
        if doubleResult == doubleResult.rounded(.down) {
            if doubleResult >= Double(Int.min) && doubleResult <= Double(Int.max) {
                return String(Int(doubleResult))
            } else {
                return String(format: "%g", doubleResult) // Return as Double without decimal places
            }
        } else {
            // Format the double value with 7 decimal places and remove trailing zeros
            let formattedString = String(format: "%.7f", doubleResult)
            return formattedString.replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
        }
    }
    
}

extension RPNDataService {
    func zeroHandler(lastNumber: String.SubSequence, lastChar: Character, lastNumberWithoutBrackets: String.SubSequence, newCurrentInput: String) -> String {
        
        var currentInput = newCurrentInput
        if currentInput == CB.zero.rawValue || (lastNumberWithoutBrackets == CB.zero.rawValue && lastChar == CB.zero.char) {
            return currentInput
        } else if lastChar == CB.close.char {
            currentInput += CB.multiplyX.rawValue + CB.zero.rawValue
        } else {
            currentInput += CB.zero.rawValue
        }
        return currentInput
    }
    
    func numbersHandler(
        lastNumber: String.SubSequence,
        lastChar: Character,
        title: CalculatorButtonsEnum,
        operators: Set<Character>,
        lastNumberWithoutBrackets: String.SubSequence,
        newCurrentInput: String) -> String {
        
        var currentInput = newCurrentInput
        if currentInput == CB.zero.rawValue || lastNumberWithoutBrackets == CB.zero.rawValue{
            if operators.contains(lastChar) {
                currentInput += title.rawValue
            } else {
                if lastChar != CB.open.char {
                    currentInput.removeLast()
                }
                currentInput += title.rawValue
            }
        } else if lastChar == CB.close.char {
          
            currentInput += CB.multiplyX.rawValue + title.rawValue
        } else if lastNumberWithoutBrackets == CB.zero.rawValue && lastChar != CB.dot.char {
            
            currentInput.removeLast()
            currentInput += title.rawValue
        } else {
            currentInput += title.rawValue
        }
        
            return currentInput
    }
    
    func dotHandler(lastNumber:String.SubSequence, lastChar: Character, operators: Set<Character>, newCurrentInput: String) -> String {
        
        var currentInput = newCurrentInput
        if !lastNumber.contains(CB.dot.rawValue) && (currentInput.last?.isNumber ?? false) {
            currentInput += CB.dot.rawValue
        } else if operators.contains(lastChar) || lastChar == CB.open.char {
            currentInput += CB.zero.rawValue + CB.dot.rawValue
        } else if lastChar == CB.close.char {
            currentInput += CB.multiplyX.rawValue + CB.zero.rawValue + CB.dot.rawValue
        }
        
        return currentInput
    }
    
    func operatorsHandler(lastChar: Character, operators: Set<Character>, title: CalculatorButtonsEnum, newCurrentInput: String) -> String {
        
        var currentInput = newCurrentInput
        var beforeLastChar = String(newCurrentInput.dropLast())
        if lastChar == CB.minus.char && beforeLastChar.last == CB.open.char {
            return currentInput
        }
    
        if operators.contains(String(lastChar)) || lastChar == CB.dot.char ||
            (currentInput == CB.zero.rawValue && title.rawValue == CB.minus.rawValue) {
            currentInput.removeLast()
        } else if lastChar == CB.open.char && title.rawValue != CB.minus.rawValue {
            return currentInput
        }
        currentInput += title.rawValue
        return currentInput
    }
    
  
    
    func openParenthesisHandler(newCurrentInput: String) -> String {
        var currentInput = newCurrentInput
        
        if currentInput == CB.zero.rawValue {
            currentInput = CB.open.rawValue
        } else if let lastChar = currentInput.last {
            if lastChar == CB.dot.char {
                currentInput.removeLast()
                currentInput += CB.multiplyX.rawValue + CB.open.rawValue
            } else if lastChar.isNumber || lastChar == CB.close.char {
                currentInput += CB.multiplyX.rawValue + CB.open.rawValue
            } else {
                currentInput += CB.open.rawValue
            }
        } else {
            currentInput += CB.open.rawValue
        }
        return currentInput
    }
    
    func closeParenthesisHandler(lastChar: Character, operators: Set<Character>, newCurrentInput: String) -> String{
        var currentInput = newCurrentInput
        let openCount = currentInput.filter { $0 == CB.open.char }.count
        let closeCount = currentInput.filter { $0 == CB.close.char }.count

        if openCount > closeCount, lastChar.isNumber || lastChar == CB.close.char {
            if operators.contains(currentInput.last ?? "A") {
                currentInput.removeLast()
                currentInput += CB.close.rawValue
            } else  {
                currentInput += CB.close.rawValue
            }
        }
        return currentInput
    }
    
    func backspaceHandler(newCurrentInput: String) -> String {
        var currentInput = newCurrentInput
        
        if currentInput.count == 1 {
            currentInput = CB.zero.rawValue
        } else {
            currentInput.removeLast()
        }
        return currentInput
    }
    
}
