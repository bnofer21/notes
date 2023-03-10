//
//  SceneDelegate.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        DataManager.shared.loadNotes { notes in
            var nav = UINavigationController()
            let note = Note(entity: Note.entity(), insertInto: nil)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM HH:mm"
            note.name = "First Note"
            note.text = NSAttributedString(string: "Some text", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            note.date = dateFormatter.date(from: "9 Jan 9:41")
            if notes.count == 0 {
                DataManager.shared.saveNote(isNew: true, note: note) {
                    nav = UINavigationController(rootViewController: MainController(notes: [note]))
                }
            } else {
                nav = UINavigationController(rootViewController: MainController(notes: notes))
            }
            self.window = UIWindow(windowScene: windowScene)
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

