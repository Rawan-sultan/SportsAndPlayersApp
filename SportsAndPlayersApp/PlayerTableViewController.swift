//
//  PlayerTableViewController.swift
//  SportsAndPlayersApp
//
//  Created by 라완 💕 on 19/05/1444 AH.
//

import UIKit
import CoreData

class PlayerTableViewController: UITableViewController {

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var sportName : String?
    var sportObj:Sports?
    var listPlayersInfo :[Players] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = sportObj?.name
        fetchData()

    }

   
    @IBAction func addPlayer(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController.init(title: "New Player ", message: "Add a new player", preferredStyle: .alert)
        
        alertVC.addTextField { (textName) in
            textName.placeholder = "Enter First and Last Name"
        }
        alertVC.addTextField { (textAge) in
            textAge.placeholder = "Enter Age"
            
        }
        alertVC.addTextField { (textHeight) in
            textHeight.placeholder = "Enter Height"
            
        }
        alertVC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "Save", style: .default, handler:{ [self, weak alertVC] (_) in
            
            let nameText = alertVC?.textFields![0]
            let ageText = alertVC?.textFields![1]
            let heightText = alertVC?.textFields![2]

            let player = Players(context: self.managedObjectContext)
            player.name = nameText!.text!
            player.age = ageText!.text!
            player.hieght = heightText!.text!
            
            sportObj?.addToPlayer(player)
            do {
                try managedObjectContext.save()
                fetchData()
            } catch {
                print(error.localizedDescription)
            }
            
            
            
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    func fetchData() {
        
        let request = NSFetchRequest<Players>.init(entityName: "Players")

        do {
            let result = try managedObjectContext.fetch(request)
            listPlayersInfo = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let playerArray = sportObj?.player {
            return playerArray.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell", for: indexPath)
      
        let playerArray = sportObj?.player![indexPath.row] as? Players
        cell.textLabel?.text = "\(playerArray?.name ?? "") - Age: \(playerArray?.age ?? ""), Height: \(playerArray?.hieght ?? "")"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alertVC = UIAlertController.init(title: "Edit Sport", message: "Edit Sport", preferredStyle: .alert)
        alertVC.addTextField { [self] (textName) in
             let playerArray = sportObj?.player![indexPath.row] as? Players
             textName.text = playerArray?.name
        }
        alertVC.addTextField { [self] (textName) in
             let playerArray = sportObj?.player![indexPath.row] as? Players
             textName.text = playerArray?.age
        }
        alertVC.addTextField { [self] (textName) in
            let playerArray = sportObj?.player![indexPath.row] as? Players
            textName.text = playerArray?.hieght
        }
        alertVC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction.init(title: "Save", style: .default, handler:{ [self, weak alertVC] (_) in

            let textname = alertVC?.textFields![0]
            let textage = alertVC?.textFields![1]
            let texthight = alertVC?.textFields![2]

            let playerArray = sportObj?.player![indexPath.row] as? Players

            playerArray?.name = textname!.text!
            playerArray?.age = textage!.text!
            playerArray?.hieght = texthight!.text!

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

        let playerArray = sportObj?.player![indexPath.row] as? Players

        managedObjectContext.delete(playerArray!)
        
        do {
            try managedObjectContext.save()
            fetchData()
        } catch {
            print(error.localizedDescription)
        }
    }


    }

