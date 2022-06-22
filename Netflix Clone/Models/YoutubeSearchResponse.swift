//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Amin  Bagheri  on 2022-06-21.
//

import Foundation
//items =     (
//            {
//        etag = "ZL83K-82x1HtSMVou_zqaRTo5aU";
//        id =             {
//            kind = "youtube#video";
//            videoId = "z4K2F_OALPQ";
//        };
//        kind = "youtube#searchResult";
//    },

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IDVideoElement
}


struct IDVideoElement: Codable {
    let kind: String
    let videoId: String
}
