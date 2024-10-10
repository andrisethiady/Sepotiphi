//
//  HomeCell.swift
//  Sepothipi
//
//  Created by Andri on 10/10/24.
//

import UIKit
import Kingfisher

class HomeCell: UITableViewCell {
    static let cellIdentifier = "HomeCell"

    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblAlbumName: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .white

        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .greenPrimary
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with data: Music) {
        lblSongName.text = data.trackName
        lblArtistName.text = data.artistName
        lblAlbumName.text = data.trackName
        
        if let data = data.imageLocalPath {
            albumImage.image = UIImage(named: data)
        }
        else if let data = data.artworkUrl100, let urls = URL(string: data) {
            albumImage.kf.setImage(with: urls)
        } else {
            //default
        }
    }
    
}
