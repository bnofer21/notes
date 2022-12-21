//
//  NotesTableView.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import UIKit

class NotesTableView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        register(NoteCell.self, forCellReuseIdentifier: NoteCell.id)
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 15
        separatorStyle = .none
        bounces = false
        alwaysBounceVertical = false
        alwaysBounceHorizontal = false
    }
}
