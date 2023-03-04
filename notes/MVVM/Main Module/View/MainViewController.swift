//
//  MainViewController.swift
//  notes
//
//  Created by Юрий on 28.02.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    var newNoteButton: UIButton = {
        let butt = UIButton(type: .system)
        butt.setTitle("New", for: .normal)
        return butt
    }()
    
    var viewModel: MainViewModelType?
    var scrollView = ScrollView()
    
    override func loadView() {
        view = scrollView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
        setupView()
        targets()
        delegates()
        title = "Main"
    }
    
    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: newNoteButton)
    }
    
    private func delegates() {
        scrollView.notesView.notesTableView.delegate = self
        scrollView.notesView.notesTableView.dataSource = self
    }
    
    private func setupTableView() {
        scrollView.notesView.notesTableView.setup()
    }
    
    private func show(_ error: String) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController()
            alertController.title = "Error"
            alertController.message = error
            
            let ok = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(ok)
            
            self?.present(alertController, animated: true)
        }
    }
    
    func loadNotes() {
        viewModel?.loadNotes { [weak self] error in
            if let error = error {
                self?.show(error)
            } else {
                self?.setupTableView()
            }
        }
    }
    
    private func targets() {
        newNoteButton.addTarget(self, action: #selector(newNotePressed), for: .touchUpInside)
    }
    
    @objc private func newNotePressed() {
        viewModel?.didTapNew()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.sections.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.sections[section].cells?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModel?.sections[indexPath.section].cells?[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainNoteCell.id, for: indexPath) as? MainNoteCell else { return UITableViewCell() }
        cell.viewModel = viewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.didSelect(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.deleteAt(at: indexPath.row, completion: { [weak self] error in
                if let error = error {
                    self?.show(error)
                } else {
                    self?.loadNotes()
                }
            })
        }
    }
}
