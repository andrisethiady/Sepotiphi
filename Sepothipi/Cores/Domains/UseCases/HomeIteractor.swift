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
    func requestMusicList() -> Observable<MusicList>
}

class HomeIteractor: HomeUseCase {
    let homeRepository: HomeRepositoriesProtocol
    
    init(homeRepository: HomeRepositoriesProtocol) {
        self.homeRepository = homeRepository
    }
    
    func requestMusicList() -> RxSwift.Observable<MusicList> {
        homeRepository.requestMusicList()
    }
}
