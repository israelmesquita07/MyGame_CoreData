//
//  GameViewController.swift
//  MyGames_CoreData
//
//  Created by Israel3D on 17/01/2019.
//  Copyright © 2019 Israel3D. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblConsole: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var ivCover: UIImageView!
    
    var game: Game!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblTitle.text = game.title
        lblConsole.text = game.console?.name
        if let releaseDate = game.releaseDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "pt-BR")
            lblReleaseDate.text = "Lançamento: " + formatter.string(from: releaseDate)
        }
        if let image = game.cover as? UIImage {
            ivCover.image = image
        }else{
            ivCover.image = UIImage(named: "noCoverFull")
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.game = game
    }
 

}
