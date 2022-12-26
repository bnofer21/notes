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
        return tool
    }()
    
    var notesCount: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textColor = .black
        label.textAlignment = .center
        return label
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
        if bounds.height-150 <= notesView.notesTableView.contentSize.height {
            contentSize.height = notesView.notesTableView.contentSize.height*1.13
        } else {
            contentSize.height = bounds.height*0.9
        }
        notesView.frame.size.height = contentSize.height
    }
    
    private func configureToolBar() {
        let toolBarItem = UIBarButtonItem(customView: notesCount)
        bottomToolBar.items = [toolBarItem]
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        notesCount.text = "\(viewModel.notesCount) notes"
        configureToolBar()
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
            notesView.topAnchor.constraint(equalTo: topAnchor),
            notesView.centerXAnchor.constraint(equalTo: centerXAnchor),
            notesView.widthAnchor.constraint(equalTo: widthAnchor),
            
            bottomToolBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomToolBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            bottomToolBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
