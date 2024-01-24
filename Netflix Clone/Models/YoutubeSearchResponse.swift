//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Fırat AKBULUT on 12.11.2023.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
