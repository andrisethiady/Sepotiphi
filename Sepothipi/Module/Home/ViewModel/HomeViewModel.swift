//
//  HomeViewModel.swift
//  Sepothipi
//
//  Created by Andri on 10/10/24.
//

import Foundation
import RxSwift
import RxRelay

class HomeViewModel: NSObject {
    var homeUseCase: HomeUseCase
    
    init(homeUseCase: HomeUseCase) {
        self.homeUseCase = homeUseCase
    }
    
    let bag = DisposeBag()
    
    let musicList: BehaviorRelay<MusicList> = BehaviorRelay(value: MusicList())
    let error: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func getMusicList(keyword: String) {
        homeUseCase.requestMusicList(keyword: keyword).subscribe(onNext: { [unowned self] response in
            self.musicList.accept(response)
        },onError: { [unowned self] error in
            self.error.accept(ErrorEnum.connectionError)
        }).disposed(by: self.bag)
    }
    
    func getPlayableMusicList() {
        homeUseCase.requestPlayableMusicList().subscribe(onNext: { [unowned self] response in
            self.musicList.accept(response)
        },onError: { [unowned self] error in
            self.error.accept(ErrorEnum.dataNotFoundError)
        }).disposed(by: self.bag)
    }
    
}
