//
//  AppModel.swift
//  TikTokDemo
//
//  Created by Anjali Pawar on 11/07/24.
//

import Foundation

// MARK: - Welcome
struct VideoJSON: Codable {
    let categories: [Category]
}

// MARK: - Category
struct Category: Codable {
    let name: String
    let videos: [Video]
}

// MARK: - Video
struct Video: Codable {
    let description: String
    let sources: String
    let subtitle: Subtitle
    let thumb: String
    let title: String
}

enum Subtitle: String, Codable {
    case byBlenderFoundation = "By Blender Foundation"
    case byGarage419 = "By Garage419"
    case byGoogle = "By Google"
}
