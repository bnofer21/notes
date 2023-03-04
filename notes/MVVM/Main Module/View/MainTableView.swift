//
//  MainTableView.swift
//  notes
//
//  Created by Юрий on 28.02.2023.
//

import UIKit

final class MainTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame.size.height = contentSize.height
    }
    
    func setup() {
        register(MainNoteCell.self, forCellReuseIdentifier: MainNoteCell.id)
        reloadData()
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 15
        separatorStyle = .none
        isScrollEnabled = false
        backgroundColor = .systemBackground
    }
}

