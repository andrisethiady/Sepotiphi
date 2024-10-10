//
//  MainRepositories.swift
//  Sepothipi
//
//  Created by Andri on 10/10/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeRepositoriesProtocol {
    func requestMusicList(keyword: String) -> Observable<MusicList>
    
    func requestPlayableMusicList() -> Observable<MusicList>
}

class HomeRepositories: NSObject {
        
    let musicListServie: MusicListProtocol
    let musicPlayableService: PlayableMusicProtocol
    
    static let sharedInstance = {
        let musicListServie = MusicService.sharedInstance
        let musicPlayableService = PlayableMusicService.sharedInstance
        return HomeRepositories(musicListService: musicListServie, musicPlayableService: musicPlayableService)
    }()
    
    init(musicListService: MusicListProtocol, musicPlayableService: PlayableMusicProtocol) {
        self.musicListServie = musicListService
        self.musicPlayableService = musicPlayableService
    }
}

extension HomeRepositories: HomeRepositoriesProtocol {
    func requestPlayableMusicList() -> RxSwift.Observable<MusicList> {
        return musicPlayableService.requestPlayableMusicList()
    }
    
    func requestMusicList(keyword: String) -> RxSwift.Observable<MusicList> {
        return musicListServie.requestMusicList(keyword: keyword)
    }
}
