//
//  DataManager.swift
//  notes
//
//  Created by Юрий on 21.12.2022.
//

import CoreData
import UIKit

struct DataManager {
    
    static let shared = DataManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func saveNote(name: String, text: String, image: UIImage, completion: ()->Void) {
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else { return }
        let noteObject = Note(entity: entity, insertInto: context)
//        let img = NSManagedObject(entity: entity, insertInto: context)
//        img.setValue(image, forKey: name)
        noteObject.name = name
        noteObject.text = text
        do {
            try context.save()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        completion()
    }
    
    func loadNotes(completion: @escaping([Note])->Void) {
        let context = appDelegate.persistentContainer.viewContext
        var result = [Note]()
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        do {
          result = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error.localizedDescription)")
        }
        completion(result)
    }
}
