//
//  NotesTableView.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import UIKit

class NotesTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        register(NoteCell.self, forCellReuseIdentifier: NoteCell.id)
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 15
        separatorColor = backgroundColor
    }
}
