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
    func requestMusicList() -> Observable<MusicList>
}

class HomeRepositories: NSObject {
        
    let service: MusicListProtocol
    
    static let sharedInstance = {
        let service = MusicService.sharedInstance
        return HomeRepositories(service: service)
    }()
    
    init(service: MusicListProtocol) {
        self.service = service
    }
}

extension HomeRepositories: HomeRepositoriesProtocol {
    func requestMusicList() -> RxSwift.Observable<MusicList> {
        return service.requestMusicList()
    }
}
