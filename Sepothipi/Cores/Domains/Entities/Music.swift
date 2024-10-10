//
//  Music.swift
//  Sepothipi
//
//  Created by Andri on 10/10/24.
//

import Foundation

struct MusicList: Decodable {
    var resultCount: Int?
    var results: [Music]?
}

struct Music: Decodable {
    var artistName: String?
    var trackName: String?
    var artworkUrl100: String?
    var collectionName: String?
    var path: String?
}
