//
//  NoteCell.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import UIKit

class NoteCell: UITableViewCell {
    
    static let id = "NoteCell"
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    var textLab: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "16:54"
        return label
    }()
    
    var downSeparator: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    var viewModel: NoteViewModel? {
        didSet {
            configure()
        }
    }
    
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
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        textLab.text = viewModel.text
        dateLabel.text = viewModel.date
        
    }
    
    public func hideSeparator(_ state: Bool) {
        downSeparator.isHidden = state
    }
}

extension NoteCell {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            textLab.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            textLab.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 4),
            
            downSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            downSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            downSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            downSeparator.heightAnchor.constraint(equalToConstant: 0.5),
            downSeparator.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }
}
