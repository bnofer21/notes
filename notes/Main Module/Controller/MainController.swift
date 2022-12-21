//
//  MainController.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import UIKit

class MainController: UIViewController {
    
    var notes: [Note] 
    
    var noteTableView = NotesTableView()
    
    init(notes: [Note]) {
        self.notes = notes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = noteTableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        noteTableView.delegate = self
        noteTableView.dataSource = self
    }


}

extension MainController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.id, for: indexPath) as? NoteCell else { return UITableViewCell() }
        cell.viewModel = NoteViewModel(note: notes[indexPath.row])
        return cell
    }
    
    
}

