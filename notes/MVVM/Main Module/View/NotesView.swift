//
//  NotesView.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import UIKit

class NotesView: UIView {
    
    var notesTableView = MainTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .lightGray
        addView(notesTableView)
    }
}

extension NotesView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            notesTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            notesTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            notesTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            notesTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
        ])
    }
}
