//
//  HomeViewController.swift
//  Sepothipi
//
//  Created by Andri on 10/10/24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableViewHeader: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnAllSong: UIButton!
    @IBOutlet weak var btnPlayableSong: UIButton!
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onPressBtnPrev(_ sender: Any) {
    }
    
    @IBAction func onPressBtnNext(_ sender: Any) {
    }
    
    @IBAction func onPressBtnPlay(_ sender: Any) {
    }
    
    @IBAction func onPressAllSong(_ sender: Any) {
    }
    
    @IBAction func onPressPlayableSong(_ sender: Any) {
    }
    
    
}
