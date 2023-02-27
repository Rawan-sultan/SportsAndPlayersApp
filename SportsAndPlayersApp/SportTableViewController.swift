//
//  SportTableViewController.swift
//  SportsAndPlayersApp
//
//  Created by 라완 💕 on 19/05/1444 AH.
//

import UIKit
import CoreData

class SportTableViewController: UITableViewController,ImageDelegate{
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var listSportsName:[Sports] = []
    var imageCell:SportTableViewCell?
    var sportSelect : Sports?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        fetchData()
    }

    @IBAction func addSports(_ sender: Any) {
        let alertVC = UIAlertController.init(title: "New Sport ", message: "Add a new sport", preferredStyle: .alert)
        alertVC.addTextField { (textName) in
            
        }
        alertVC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "Save", style: .default, handler:{ [self, weak alertVC] (_) in
            let textField = alertVC?.textFields![0]
            
            let sport = Sports(context: managedObjectContext)
            sport.name = textField!.text!
            listSportsName.append(sport)
            
            do {
                try managedObjectContext.save()
                fetchData()
            } catch {
                print(error.localizedDescription)
            }
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    func addImage(sportCellControl: SportTableViewCell) {
        let sportIndexPath = tableView.indexPath(for: sportCellControl)?.row ?? 0
        sportSelect = listSportsName[sportIndexPath]
        importPoto()
    }
    func importPoto(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func fetchData() {
        let request = NSFetchRequest<Sports>.init(entityName: "Sports")
        
        do {
            let result = try managedObjectContext.fetch(request)
            listSportsName = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSportsName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportTableViewCell", for: indexPath) as! SportTableViewCell
        let sport = listSportsName[indexPath.row]
        cell.sportName.text = sport.name
        cell.sendData(imageData: sport.image)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alertVC = UIAlertController.init(title: "Edit Sport", message: "Edit Sport", preferredStyle: .alert)
        alertVC.addTextField { [self] (textName) in
            textName.text = listSportsName[indexPath.row].name
        }
        alertVC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "Save", style: .default, handler:{ [self, weak alertVC] (_) in
            
            let textField = alertVC?.textFields![0]
            
            listSportsName[indexPath.row].name = textField!.text!
            
            do {
                try managedObjectContext.save()
                fetchData()
            } catch {
                print(error.localizedDescription)
            }
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        managedObjectContext.delete(listSportsName[indexPath.row])
        do {
            try managedObjectContext.save()
            fetchData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playersDetalise = self.storyboard!.instantiateViewController(withIdentifier:"PlayerTableViewController") as! PlayerTableViewController
        playersDetalise.sportObj = listSportsName[indexPath.row]
        
        self.navigationController?.pushViewController(playersDetalise, animated: true)
    }
}

extension SportTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        if  (image != nil) {
            sportSelect?.image = image!.pngData()
            
            do {
                try managedObjectContext.save()
                fetchData()
            } catch {
                print(error.localizedDescription)
            }
        }
        imageCell?.addImage.setTitle("Change Photo", for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
}
