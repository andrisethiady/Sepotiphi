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
    
    var loading: LoadingView?
    var popUp: PopUpModalViewController?
    
    var player: AVAudioPlayer!
    var timer: Timer? = nil
    
    var musicList: [Music]?
    var lastMusicList: [Music]?
    var selectedMusicIndex: IndexPath = IndexPath(row: 0, section: 0)

    @IBOutlet weak var tableViewHeader: UIView!
    
    @IBOutlet weak var lblErrorNoSongFound: UILabel!
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
        
        lblErrorNoSongFound.isHidden = true
    }
    
    func setupBinding() {
        homeViewModel.musicList.subscribe(onNext: { [unowned self] musicList in
            self.musicList = musicList.results
            homeTableView.reloadData()
        }).disposed(by: homeViewModel.bag)
        
        homeViewModel.loading.subscribe(onNext: { [unowned self] loading in
            if loading == true {
                showLoading()
            } else {
                removeLoading()
            }
        }).disposed(by: homeViewModel.bag)
        
        homeViewModel.error.subscribe(onNext: { [unowned self] error in
            showErrorPopUp(errorMsg: error)
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
    
    func showLoading() {
        guard loading == nil else { return }
        
        loading = LoadingView()
        self.view.addSubview(loading!)
        loading?.translatesAutoresizingMaskIntoConstraints = false
        loading?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        loading?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        loading?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        loading?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        loading?.indicator.startAnimating()
    }
    
    func removeLoading() {
        loading?.indicator.stopAnimating()
        loading?.removeFromSuperview()
        loading = nil
    }
    
    func playNextMusic(path: String?, selectedMusicIndex: IndexPath) {
        self.selectedMusicIndex = selectedMusicIndex
        setMusic(path: path)
        
        player.stop()
        progressBar.maximumValue = Float(player.duration)
        player.prepareToPlay()
        player.play()
    }
    
    func showErrorPopUp(errorMsg: String?) {
        guard let error = errorMsg else { return }
        
        popUp = PopUpModalViewController()
        popUp?.errorMsg = error
        popUp?.delegate = self
        popUp?.modalPresentationStyle = .overCurrentContext
        self.present(popUp!, animated: true, completion: nil)
    }
    
    @objc func updateSlider() {
        guard player != nil else {
            progressBar.value = 0
            return
        }
        
        progressBar.value = Float(player?.currentTime ?? 0)
        
        if player.isPlaying == true {
            btnPlay.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            btnPlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    @IBAction func onPressBtnPrev(_ sender: Any) {
        guard player != nil else {
            showToast(message: ErrorEnum.noQueueSong, font: .systemFont(ofSize: 12.0))
            return
        }
        
        if musicList?[selectedMusicIndex.row].path == nil {
            showErrorPopUp(errorMsg: ErrorEnum.cannotPlaySong)
            return
        }

        if (selectedMusicIndex.row) > 0 {
            let newIndex = IndexPath(row: selectedMusicIndex.row - 1, section: 0)
            homeTableView.cellForRow(at: selectedMusicIndex)?.setSelected(false, animated: false)
            homeTableView.cellForRow(at: newIndex)?.setSelected(true, animated: false)
            
            playNextMusic(path: musicList?[newIndex.row].path, selectedMusicIndex: newIndex)
        } else if (selectedMusicIndex.row) <= 0 {
            let newIndex = IndexPath(row: (musicList?.count ?? 0) - 1, section: 0)
            homeTableView.cellForRow(at: selectedMusicIndex)?.setSelected(false, animated: false)
            homeTableView.cellForRow(at: newIndex)?.setSelected(true, animated: false)
            
            playNextMusic(path: musicList?[newIndex.row].path, selectedMusicIndex: newIndex)
        } else {
            return
        }
    }
    
    @IBAction func onPressBtnNext(_ sender: Any) {
        guard player != nil else {
            showToast(message: ErrorEnum.noQueueSong, font: .systemFont(ofSize: 12.0))
            return
        }
        
        if musicList?[selectedMusicIndex.row].path == nil {
            showErrorPopUp(errorMsg: ErrorEnum.cannotPlaySong)
            return
        }

        if (selectedMusicIndex.row + 1) < musicList?.count ?? 0 {
            let newIndex = IndexPath(row: selectedMusicIndex.row + 1, section: 0)
            homeTableView.cellForRow(at: selectedMusicIndex)?.setSelected(false, animated: false)
            homeTableView.cellForRow(at: newIndex)?.setSelected(true, animated: false)
            
            playNextMusic(path: musicList?[newIndex.row].path, selectedMusicIndex: newIndex)
        } else if (selectedMusicIndex.row + 1) == musicList?.count ?? 0 {
            let newIndex = IndexPath(row: 0, section: 0)
            homeTableView.cellForRow(at: selectedMusicIndex)?.setSelected(false, animated: false)
            homeTableView.cellForRow(at: newIndex)?.setSelected(true, animated: false)
            
            playNextMusic(path: musicList?[newIndex.row].path, selectedMusicIndex: newIndex)
        } else {
            return
        }
    }
    
    @IBAction func onPressBtnPlay(_ sender: Any) {
        guard let player = player else {
            showToast(message: ErrorEnum.noQueueSong, font: .systemFont(ofSize: 12.0))
            return
        }
        
        if player.isPlaying == true {
            player.stop()
        } else {
            player.play()
            progressBar.maximumValue = Float(player.duration)
        }
    }
    
    @IBAction func onPressAllSong(_ sender: Any) {
        if player != nil {
            player.stop()
            player = nil
        }
        
        if lastMusicList != nil {
            musicList = lastMusicList
            homeTableView.reloadData()
        }
        
        btnPlay.setImage(UIImage(systemName: "play.fill"), for: .normal)
        searchBar.isHidden = false
        
        btnAllSong.setTitleColor(.greenPrimary, for: .normal)
        btnPlayableSong.setTitleColor(.grayDisable, for: .normal)
    }
    
    @IBAction func onPressPlayableSong(_ sender: Any) {
        btnPlayableSong.setTitleColor(.greenPrimary, for: .normal)
        btnAllSong.setTitleColor(.grayDisable, for: .normal)
        
        searchBar.isHidden = true
        
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

// MARK: TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if musicList?.count == 0 {
            lblErrorNoSongFound.isHidden = false
        } else {
            lblErrorNoSongFound.isHidden = true
        }
        
        return musicList?.count ?? 0
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
            homeTableView.cellForRow(at: selectedMusicIndex)?.setSelected(false, animated: false)
            homeTableView.cellForRow(at: indexPath)?.setSelected(true, animated: false)
     
            playNextMusic(path: data.path, selectedMusicIndex: indexPath)
        } else {
            homeTableView.deselectRow(at: indexPath, animated: false)
            showErrorPopUp(errorMsg: ErrorEnum.cannotPlaySong)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}

// MARK: SearchBar

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

// MARK: Popup

extension HomeViewController: PopUpModalDelegate {
    func onPressBottomBtn() {
        self.popUp?.dismiss(animated: false)
    }
}
