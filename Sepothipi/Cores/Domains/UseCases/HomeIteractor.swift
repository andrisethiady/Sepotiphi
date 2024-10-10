//
//  MainIteractor.swift
//  Sepothipi
//
//  Created by Andri on 10/10/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeUseCase {
    func requestMusicList(keyword: String) -> Observable<MusicList>
    func requestPlayableMusicList() -> Observable<MusicList>
}

class HomeIteractor: HomeUseCase {
    let homeRepository: HomeRepositoriesProtocol
    
    init(homeRepository: HomeRepositoriesProtocol) {
        self.homeRepository = homeRepository
    }
    
    func requestMusicList(keyword: String) -> RxSwift.Observable<MusicList> {
        homeRepository.requestMusicList(keyword: keyword)
    }
    
    func requestPlayableMusicList() -> RxSwift.Observable<MusicList> {
        homeRepository.requestPlayableMusicList()
    }
}
