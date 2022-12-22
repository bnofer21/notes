//
//  ScrollView.swift
//  notes
//
//  Created by Юрий on 22.12.2022.
//

import UIKit

class ScrollView: UIScrollView {
    
    var viewModel: ScrollViewModel? {
        didSet {
            configure()
        }
    }
    
    var notesView = NotesView()
    
    var bottomToolBar: UIToolbar = {
        let tool = UIToolbar()
        let notesCount = UILabel()
        notesCount.text = "10 notes"
        notesCount.sizeToFit()
        notesCount.textColor = .black
        notesCount.textAlignment = .center
        let toolBarItem = UIBarButtonItem(customView: notesCount)
        tool.items = [toolBarItem]
        return tool
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentSize.height = notesView.notesTableView.contentSize.height*1.08
        notesView.frame.size.height = contentSize.height
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        
    }
    
    private func setupView() {
        addView(notesView)
        addView(bottomToolBar)
        backgroundColor = #colorLiteral(red: 0.8979851604, green: 0.8979851604, blue: 0.8979851604, alpha: 1)
    }
}

extension ScrollView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            notesView.centerXAnchor.constraint(equalTo: centerXAnchor),
            notesView.widthAnchor.constraint(equalTo: widthAnchor),
            
            bottomToolBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomToolBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bottomToolBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
