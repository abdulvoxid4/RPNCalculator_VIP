//
//  Presenter.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 20/03/25.
//

import UIKit

protocol CalculatorPresenterProtocol {
    var portraitStructure: [[CalculatorButtonsEnum]] { get }
    var landscapeStructure: [[CalculatorButtonsEnum]] { get }
    var orentation: UIDeviceOrientation { get }
    func presentResult(value: String, expression: String?)
    func makeCalculatorButtons(sholdRemake: Bool)
}

final class CalculatorPresenter: CalculatorPresenterProtocol {
    var orentation: UIDeviceOrientation { UIDevice.current.orientation }
    
    weak var view: CalculatorViewProtocol?
    var portraitStructure: [[CalculatorButtonsEnum]] = [
        [.backspace, .open, .close , .divide],
        [.seven, .eight, .nine, .multiplyX],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.allClear, .zero, .dot, .equal]
    ]
    
    var landscapeStructure: [[CalculatorButtonsEnum]] = [
        [.seven, .eight, .nine, .allClear, .divide],
        [.four, .five, .six, .open, .multiplyX],
        [.one, .two, .three, .close, .minus],
        [.allClear, .zero, .dot, .equal, .plus]
    ]
    
    func presentResult(value: String, expression: String?) {
        view?.showResult(value: value, expression: expression)
    }
    
    func makeCalculatorButtons(sholdRemake: Bool) {
        let structure = orentation.isLandscape ? landscapeStructure : portraitStructure
        view?.setupStackButtons(from: structure, shouldRemoveAllElements: sholdRemake)
    }
}

