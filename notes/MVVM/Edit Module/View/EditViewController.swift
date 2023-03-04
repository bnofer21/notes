//
//  EditViewController.swift
//  notes
//
//  Created by Юрий on 28.02.2023.
//

import UIKit

final class EditViewController: UIViewController {
    
    var viewmodel: EditViewModelProtocol? {
        didSet {
            configureView()
        }
    }
    
    var doneButton: UIButton = {
        let but = UIButton(type: .system)
        but.setTitle("Done", for: .normal)
        return but
    }()
    
    var editView = EditNoteView()
    
    override func loadView() {
        view = editView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegates()
        setupView()
    }
    
    private func configureView() {
        guard let viewmodel = viewmodel else { return }
        editView.viewModel = viewmodel
    }
    
    private func setupView() {
        doneButton.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
    
    private func delegates() {
        editView.textView.delegate = self
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
    
    @objc func hideKeyboard() {
        editView.endEditing(true)
    }
    
}

extension EditViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard viewmodel?.text != textView.attributedText else { return }
        viewmodel?.saveNote(text: textView.attributedText) { [weak self] error in
            if let error = error {
                self?.show(error)
            }
        }
    }
}
