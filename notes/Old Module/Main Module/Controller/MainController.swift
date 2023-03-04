//
//  MainController.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import UIKit
import CoreData

class MainController: UIViewController {
    
    var notes: [Note]
    var scrollView = ScrollView()
    
    var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        return button
    }()
    
    override func loadView() {
        scrollView.viewModel = ScrollViewModel(count: notes.count)
        view = scrollView
    }
    
    
    init(notes: [Note]) {
        self.notes = notes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setTargets()
    }
    
    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Notes"
        scrollView.notesView.notesTableView.delegate = self
        scrollView.notesView.notesTableView.dataSource = self
        scrollView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    private func setTargets() {
        addButton.addTarget(self, action: #selector(newNote), for: .touchUpInside)
    }
    
    public func updateData() {
        scrollView.viewModel = ScrollViewModel(count: notes.count)
        scrollView.notesView.notesTableView.reloadData()
    }
    
    @objc func newNote() {
        let editVC = EditController(note: Note(entity: Note.entity(), insertInto: nil))
        navigationController?.pushViewController(editVC, animated: true)
    }


}

extension MainController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.id, for: indexPath) as? NoteCell else { return UITableViewCell() }
        cell.viewModel = NoteViewModel(note: notes[indexPath.row])
        cell.selectionStyle = .gray
        cell.hideSeparator(indexPath.row == notes.count-1 ? true : false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let editVC = EditController(note: notes[indexPath.row])
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            DataManager.shared.deleteNote(note: notes[indexPath.row]) {
//                notes.remove(at: indexPath.row)
//                updateData()
//            }
        }
    }
    
    
}

extension MainController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
        }
    }
}

