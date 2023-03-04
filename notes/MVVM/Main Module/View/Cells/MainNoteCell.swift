//
//  MainNoteCell.swift
//  notes
//
//  Created by Юрий on 28.02.2023.
//

import UIKit

final class MainNoteCell: UITableViewCell {
    
    static let id = "MainNoteCell"
    
    var viewModel: NoteCellViewModelProtocol? {
        didSet {
            configure()
        }
    }
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    var textLab: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    var downSeparator: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addView(nameLabel)
        addView(dateLabel)
        addView(textLab)
        addView(downSeparator)
    }
    
    public func hideSeparator(_ state: Bool) {
        downSeparator.isHidden = state
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        textLab.text = viewModel.text
        dateLabel.text = viewModel.date
    }
}

extension MainNoteCell {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            textLab.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            textLab.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 4),
            
            downSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            downSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            downSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            downSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            downSeparator.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }
}
