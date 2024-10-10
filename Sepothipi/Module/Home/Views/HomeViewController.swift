//
//  HomeViewController.swift
//  Sepothipi
//
//  Created by Andri on 10/10/24.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    
    var homeViewModel: HomeViewModel! = nil
    
    var player: AVAudioPlayer!
    var timer: Timer? = nil

    @IBOutlet weak var tableViewHeader: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnAllSong: UIButton!
    @IBOutlet weak var btnPlayableSong: UIButton!
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setMusic(path: PlayableSongEnum.enchanted)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    func setupUI() {
        tableViewHeader.roundCorners(corners: [.topLeft, .topRight], radius: 16)
    }
    
    func setupBinding() {
        
    }
    
    func setMusic(path: String?) {
        guard path != nil else { return }
        
        let url = Bundle.main.url(forResource: path, withExtension: "mp3")
        
        do {
            player = try AVAudioPlayer(contentsOf: url!)
        } catch {
            print(error.localizedDescription)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    @objc func updateSlider() {
        progressBar.value = Float(player?.currentTime ?? 0)
        
        if player.isPlaying == true {
            btnPlay.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            btnPlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    @IBAction func onPressBtnPrev(_ sender: Any) {
        
    }
    
    @IBAction func onPressBtnNext(_ sender: Any) {
        
    }
    
    @IBAction func onPressBtnPlay(_ sender: Any) {
        if player.isPlaying == true {
            player.stop()
        } else {
            player.play()
            progressBar.maximumValue = Float(player.duration)
        }
    }
    
    @IBAction func onPressAllSong(_ sender: Any) {
        
    }
    
    @IBAction func onPressPlayableSong(_ sender: Any) {
        
    }
    
    @IBAction func onProgressBarValueChange(_ sender: Any) {
        player.stop()
        player.currentTime = TimeInterval(progressBar.value)
        player.prepareToPlay()
        player.play()
    }
    
    
}
