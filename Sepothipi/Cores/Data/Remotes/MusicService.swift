//
//  MusicService.swift
//  Sepothipi
//
//  Created by Andri on 10/10/24.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

protocol MusicListProtocol {
    func requestMusicList(keyword: String) -> Observable<MusicList>
}

class MusicService: NSObject {
    static let sharedInstance = MusicService()
}

extension MusicService: MusicListProtocol {
    func requestMusicList(keyword: String) -> Observable<MusicList> {
        return Observable.create { observer in
            
            var processedKeyword = keyword.replacingOccurrences(of: " ", with: "+")
            var urls = "https://itunes.apple.com/search"
            urls.append("?term=\(processedKeyword)&entity=song&limit=20")
            
            var urlRequest = URLRequest(url: URL(string: urls)!)
            urlRequest.httpMethod = "GET"
            
            AF.request(urlRequest).responseDecodable(
                of: MusicList.self
            ) { response in
                switch response.result {
                case .success(let result):
                    observer.onNext(result)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
