//
//  HomeCell.swift
//  Sepothipi
//
//  Created by Andri on 10/10/24.
//

import UIKit

class HomeCell: UITableViewCell {
    static let cellIdentifier = "HomeCell"

    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblAlbumName: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
