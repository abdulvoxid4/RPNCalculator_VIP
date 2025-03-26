//
//  TabelViewCell.swift
//  RPNCalculator_VIP
//
//  Created by Abdulvoxid on 23/03/25.
//

import UIKit

class TableViewCell: UITableViewCell {
    private let expressionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(expressionLabel)
        contentView.addSubview(resultLabel)
        
        expressionLabel.setConstraints(.top, view: contentView, constant: 15)
        expressionLabel.setConstraints(.left, view: contentView, constant: 20)
        
        resultLabel.setConstraints(.topOfBottom, view: expressionLabel, constant: 10)
        resultLabel.setConstraints(.left, view: contentView, constant: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(expression: String, result: String) {
        expressionLabel.text = expression
        resultLabel.text = result
    }
}
