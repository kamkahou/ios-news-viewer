//
//  TableViewCell.swift
//  FinalHomework
//
//  Created by JoeJoe on 06/06/2021.
//

import UIKit

class  FavNewsTableViewCell: UITableViewCell
{

    @IBOutlet weak var favTitleLable: UILabel!
    
    @IBOutlet weak var favNewsImage: UIImageView!
    
    @IBOutlet weak var favPasstimeLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
