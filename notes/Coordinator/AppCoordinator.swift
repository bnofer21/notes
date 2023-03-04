//
//  AppCoordinator.swift
//  notes
//
//  Created by Юрий on 28.02.2023.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func eventOccured(event: Resources.Event, note: Note?)
    func start()
}

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MainViewController()
        let vm = MainViewModel()
        vm.coordinator = self
        vm.dataManager = DataManager()
        vc.viewModel = vm
        navigationController.viewControllers = [vc]
    }
    
    func eventOccured(event: Resources.Event, note: Note?) {
        switch event {
        case .edit:
            let vc = EditViewController()
            let viewModel = EditViewModel(note: note)
            viewModel.coordinator = self
            vc.viewmodel = viewModel
            viewModel.dataManager = DataManager()
            navigationController.pushViewController(vc, animated: true)
        default:
            guard let mainVC = navigationController.viewControllers.first as? MainViewController else { return }
            mainVC.loadNotes()
        }
    }
    
}
