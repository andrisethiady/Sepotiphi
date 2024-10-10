//
//  PlayableSongService.swift
//  Sepothipi
//
//  Created by Andri on 10/10/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol PlayableMusicProtocol {
    func requestPlayableMusicList() -> Observable<MusicList>
}

class PlayableMusicService: NSObject {
    static let sharedInstance = PlayableMusicService()
}

extension PlayableMusicService: PlayableMusicProtocol {
    func requestPlayableMusicList() -> RxSwift.Observable<MusicList> {
        return Observable.create { observer in
            var musicList: [Music] = []
            
            musicList.append(
                Music(artistName: "The 1975",
                      trackName: "About You",
                      artworkUrl100: "",
                      collectionName: "Being Funny In A Foreign Language",
                      path: PlayableSongEnum.aboutYou,
                      imageLocalPath: "AboutYou"))
            
            musicList.append(
                Music(artistName: "Taylor Swift",
                      trackName: "Enchanted",
                      artworkUrl100: "",
                      collectionName: "Speak Now",
                      path: PlayableSongEnum.enchanted,
                      imageLocalPath: "Enchanted"))
            
            musicList.append(
                Music(artistName: "Djo",
                      trackName: "End Of Beginning",
                      artworkUrl100: "",
                      collectionName: "DECIDE",
                      path: PlayableSongEnum.endOfBegining,
                      imageLocalPath: "EndOfBeginning"))
            
            musicList.append(
                Music(artistName: "Gregorian",
                      trackName: "Forever Young",
                      artworkUrl100: "",
                      collectionName: "Best of (1990-2010)",
                      path: PlayableSongEnum.foreverYoung,
                      imageLocalPath: "ForeverYoung"))
            
            musicList.append(
                Music(artistName: "Bernadya",
                      trackName: "Sialnya, Hidup Harus Tetap Berjalan",
                      artworkUrl100: "",
                      collectionName: "Sialnya, Hidup Harus Tetap Berjalan",
                      path: PlayableSongEnum.HidupHarusTetapBerjalan,
                      imageLocalPath: "Bernadya"))
            
            observer.onNext(MusicList(resultCount: 5, results: musicList))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
