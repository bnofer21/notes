//
//  NoteCell.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import UIKit

class NoteCell: UITableViewCell {
    
    static let id = "NoteCell"
    
    var viewModel: NoteViewModel? {
        didSet {
            configure()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
    }
}
