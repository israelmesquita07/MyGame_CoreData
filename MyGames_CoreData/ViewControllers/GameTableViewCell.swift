//
//  GameTableViewCell.swift
//  MyGames_CoreData
//
//  Created by Israel3D on 17/01/2019.
//  Copyright © 2019 Israel3D. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblConsole: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with game:Game){
        lblTitle.text = game.title ?? ""
        lblConsole.text = game.console?.name ?? ""
        if let image = game.cover as? UIImage {
            ivCover.image = image
        }else{
            ivCover.image = UIImage(named: "noCover")
        }
    }

}
