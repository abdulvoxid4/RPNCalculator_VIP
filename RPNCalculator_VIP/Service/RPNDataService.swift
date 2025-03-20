//
//  RPNDataService.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

protocol RPNDataServiceProtocol {
    
    func directTo(currentInput: String, title: CalculatorButtonsEnum) -> String
    
//    func buttonPressed(currentInput: String, title: CalculatorButtonsEnum)
//    
//    func calculate(_ input: String) -> Double?
    
    
    
}

final class RPNDataService: RPNDataServiceProtocol {
    
    typealias CB = CalculatorButtonsEnum
    
    
    func directTo(currentInput: String, title: CalculatorButtonsEnum) -> String {
        if title == .equal {
            let postfixInput = infinixToPostfix(expression: currentInput)
            return calculate(postfixInput ?? "B") ?? "A"
            
        }else {
            return buttonPressed(currentInput: currentInput, title: title)
        }
    }
    
    
    
    private func buttonPressed(currentInput: String, title: CB) -> String {
        
            var newCurrentInput = currentInput
            let operators: Set<Character> = ["+", "-", "×", "÷"]
            let operatorsWithBrackets: Set<Character> = ["+", "-", "×", "÷", "(", ")"]
            let lastNumber = newCurrentInput.split(whereSeparator: { operators.contains($0) }).last ?? ""
            let lastNumberWithoutBrackets = newCurrentInput.split(whereSeparator: { operatorsWithBrackets.contains($0) }).last ?? ""
            let lastChar = newCurrentInput.last ?? "E"
          //  let newCurrentImput = newCurrentInput
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
                
            // Equal case, =
//            case .equal:
//                equalHandler(operatorsWithBrackets: operatorsWithBrackets, newCurrentInput: newCurrentInput, newExpression: expression)
            
            // Open parenthesis case
            case .openParenthesis:
               return openParenthesisHandler(newCurrentInput: newCurrentInput)

            // Close parenthesis case
            case .closeParenthesis:
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
        return "Error"
       
    }
   
    
    
    // Evaluates and calculates the RPN expression
    private func calculate(_ input: String) -> String? {
        var stack: [Double] = []
        let tokens = input.split(separator: " ")
        print("Tokens: \(tokens)")
                
        for token in tokens {
            
            if token == CB.openParenthesis.rawValue || token == CB.closeParenthesis.rawValue {
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
                case  CB.divideDrop.rawValue: if b != 0 { stack.append(a / b) } else { return nil }
                default: return nil
                }
            }
        }
        var result = stack.last
        return result?.description
    }
    
    // Converts infix expression to postfix (RPN)
    private func infinixToPostfix(expression: String) -> String? {
        //let precedence: [Character: Int] = ["+": 1, "-": 1, "*": 2, "/": 2] // Level of operator
        let precedence: [Character: Int] = ["+": 1, "-": 1, "×": 2, "/": 2] // Level of operator
        var output: [String] = []
        var operators: [Character] = []
        var numberBuffer = ""
        
        for (index, char) in expression.enumerated() {
            if char.isNumber || char == "." {
                numberBuffer.append(char)
            } else {
                if !numberBuffer.isEmpty {
                    output.append(numberBuffer)
                    numberBuffer = ""
                }
                
                if char == "-" && (index == 0 || expression[expression.index(expression.startIndex, offsetBy: index - 1)] == "(") {
                    numberBuffer.append(char)
                } else if char == "(" {
                    operators.append(char)
                } else if char == ")" {
                    while let lastOp = operators.last, lastOp != "(" {
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
    
    private func formatResult(result: Double) -> String {
    
        if result == result.rounded(.down) {
            if result >= Double(Int.min) && result <= Double(Int.max) {
                return String(Int(result))
            } else {
                return String(format: "%g", result)
            }
        } else {
           return String(format: "%.\(7)f", result)
                .replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
        }

        
//        if let intResult = Int(exactly: result) {
//            return String(intResult)
//        }
//
//        return String(result)
        
    }
}

extension RPNDataService {
    func zeroHandler(lastNumber: String.SubSequence, lastChar: Character, lastNumberWithoutBrackets: String.SubSequence, newCurrentInput: String) -> String {
        
        var currentInput = newCurrentInput
        if currentInput == "0" || (lastNumberWithoutBrackets == "0" && lastChar == "0") {
            return currentInput
        } else if lastChar == ")" {
            currentInput += "×0"
        } else {
            currentInput += "0"
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
        if currentInput == "0" || lastNumberWithoutBrackets == "0"{
            if operators.contains(lastChar) {
                currentInput += title.rawValue
            } else {
                currentInput.removeLast()
                currentInput += title.rawValue
            }
        } else if lastChar == ")" {
          
            currentInput += "×" + title.rawValue
        } else if lastNumberWithoutBrackets == "0" && lastChar != "." {
            
            currentInput.removeLast()
            currentInput += title.rawValue
        } else {
            currentInput += title.rawValue
        }
        
            return currentInput
    }
    
    func dotHandler(lastNumber:String.SubSequence, lastChar: Character, operators: Set<Character>, newCurrentInput: String) -> String {
        
        var currentInput = newCurrentInput
        if !lastNumber.contains(".") && (currentInput.last?.isNumber ?? false) {
            currentInput += "."
        } else if operators.contains(lastChar) || lastChar == "(" {
            currentInput += "0."
        } else if lastChar == ")" {
            currentInput += "×0."
        }
        
        return currentInput
    }
    
    func operatorsHandler(lastChar: Character, operators: Set<Character>, title: CalculatorButtonsEnum, newCurrentInput: String) -> String {
        
        var currentInput = newCurrentInput
        if lastChar == "-" && currentInput.first == "("{
            return currentInput
        }
        
        if let lastChar = currentInput.last {
            if operators.contains(String(lastChar)) || lastChar == "." ||
                (currentInput == "0" && title.rawValue == "-") {
                currentInput.removeLast()
            } else if lastChar == "(" && title.rawValue != "-" {
                return currentInput
            }
        }
        currentInput += title.rawValue
        print(currentInput)
        return currentInput
    }
    
    func equalHandler(operatorsWithBrackets: Set<Character>, newCurrentInput: String, newExpression: String) -> String {
        var currentInput = newCurrentInput
        var expression = newExpression
        expression = currentInput
        
        while let lastChar = currentInput.last, operatorsWithBrackets.contains(lastChar) {
            currentInput.removeLast()
        }
        
        
        let infixExpression = currentInput
//            .replacingOccurrences(of: "×", with: "*")
//            .replacingOccurrences(of: "÷", with: "/")
        
        
        print("Current Input: \(currentInput)")
        if
            let postfix = infinixToPostfix(expression: infixExpression),
            let result = calculate(postfix)
        {
            currentInput = formatResult(result: Double(result) ?? 0.0)
        } else {
            currentInput = "Error"
        }
        return currentInput
    }
    
    func openParenthesisHandler(newCurrentInput: String) -> String {
        var currentInput = newCurrentInput
        
        if currentInput == "0" {
            currentInput = "("
        } else if let lastChar = currentInput.last {
            if lastChar == "." {
                currentInput.removeLast()
                currentInput += "×("
            } else if lastChar.isNumber || lastChar == ")" {
                currentInput += "×("
            } else {
                currentInput += "("
            }
        } else {
            currentInput += "("
        }
        return currentInput
    }
    
    func closeParenthesisHandler(lastChar: Character, operators: Set<Character>, newCurrentInput: String) -> String{
        var currentInput = newCurrentInput
        let openCount = currentInput.filter { $0 == "(" }.count
        let closeCount = currentInput.filter { $0 == ")" }.count

        if openCount > closeCount, lastChar.isNumber || lastChar == ")" {
            if operators.contains(currentInput.last ?? "A") {
                currentInput.removeLast()
                currentInput += ")"
            } else {
                currentInput += ")"
            }
            
        }
        return currentInput
    }
    
    func backspaceHandler(newCurrentInput: String) -> String {
        var currentInput = newCurrentInput
        //  if currentInput.isEmpty ? "0" : String(currentInput.removeLast())
        if currentInput.isEmpty {
            currentInput = "0"
        } else {
            currentInput.removeLast()
        }
        return currentInput
    }
    
    func allClearHandler(newCurrentInput: String, newExpression: String) -> (String, String) {
        var currentInput = newCurrentInput
        var expression = newExpression
       // return (currentInput = "0", expression = "")
    }
    
}
