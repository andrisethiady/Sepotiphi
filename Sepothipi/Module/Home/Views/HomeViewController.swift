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
    
    var musicList: [Music]?
    var lastMusicList: [Music]?

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
        setupBinding()
        
        homeViewModel.getMusicList(keyword: "Bruno Mars")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    func setupUI() {
        tableViewHeader.roundCorners(corners: [.topLeft, .topRight], radius: 16)
        
        homeTableView.showsVerticalScrollIndicator = false
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(UINib(nibName: HomeCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: HomeCell.cellIdentifier)
        
        searchBar.delegate = self
    }
    
    func setupBinding() {
        homeViewModel.musicList.subscribe(onNext: { [unowned self] musicList in
            self.musicList = musicList.results
            homeTableView.reloadData()
        }).disposed(by: homeViewModel.bag)
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
        guard let player = player else { return }
        
        if player.isPlaying == true {
            player.stop()
        } else {
            player.play()
            progressBar.maximumValue = Float(player.duration)
        }
    }
    
    @IBAction func onPressAllSong(_ sender: Any) {
        if player != nil { player.stop() }
        
        if lastMusicList != nil {
            musicList = lastMusicList
            homeTableView.reloadData()
        }
        
        btnAllSong.setTitleColor(.black, for: .normal)
        btnPlayableSong.setTitleColor(.grayDisable, for: .normal)
    }
    
    @IBAction func onPressPlayableSong(_ sender: Any) {
        btnPlayableSong.setTitleColor(.black, for: .normal)
        btnAllSong.setTitleColor(.grayDisable, for: .normal)
        
        lastMusicList = musicList
        homeViewModel.getPlayableMusicList()
    }
    
    @IBAction func onProgressBarValueChange(_ sender: Any) {
        player.stop()
        player.currentTime = TimeInterval(progressBar.value)
        player.prepareToPlay()
        player.play()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musicList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: HomeCell.cellIdentifier, for: indexPath) as! HomeCell
        let data = musicList?[indexPath.row] ?? Music()
        
        cell.update(with: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = musicList?[indexPath.row] ?? Music()
        
        if data.path != nil {
            setMusic(path: data.path)
            
            player.stop()
            progressBar.maximumValue = Float(player.duration)
            player.prepareToPlay()
            player.play()
        } else {
            homeTableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty, keyword != "" else { return }
        
        homeViewModel.getMusicList(keyword: keyword)
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
