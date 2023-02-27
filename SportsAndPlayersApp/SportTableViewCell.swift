//
//  SportTableViewCell.swift
//  SportsAndPlayersApp
//
//  Created by 라완 💕 on 19/05/1444 AH.
//

import UIKit
import CoreData

class SportTableViewCell: UITableViewCell {

    @IBOutlet weak var addImage: UIButton!
    @IBOutlet weak var sportName: UILabel!
    @IBOutlet weak var sportImage: UIImageView!
    
    var delegate:ImageDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func sendData(imageData : Data?){
        if let imageData = imageData {
            sportImage.image = UIImage(data: imageData)
            
        }
    }
    
    @IBAction func addImageAction(_ sender: UIButton) {
        delegate?.addImage(sportCellControl: self)
    }
    

}
