//
//  Song.swift
//  EvoRadio
//
//  Created by Jarvis on 16/4/18.
//  Copyright © 2016年 JQTech. All rights reserved.
//

import UIKit
import ObjectMapper

class Song : NSObject, Mappable {

    var songId: String!
    var songName: String!
    var programId: String?
    var jujingId: String?
    var artistId: String?
    var artistsName: String?
    var artistCode: String?
    var salbumId: String?
    var salbumsName: String?
    var albumAssetCode: String?
    var language: String?
    var playNum: String?
    var shareNum: String?
    var duration: String?
    var filesize: String?
    var audioURL: String?
    var picURL: String?
    var status: String?
    var copyrightStatus: String?
    var removeTime: String?
    
    var size128: String?
    var size320: String?
    var tsId: String?
    
    var assetURL: URL?
    var albumImage: UIImage?
    
    override init() {
        super.init()
    }
    
    convenience init(songName: String) {
        self.init()
        
        self.songName = songName
    }

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        songId    <- map["song_id"]
        songName   <- map["song_name"]
        jujingId   <- map["jujing_id"]
        programId    <- map["program_id"]
        artistId    <- map["artist_id"]
        artistsName   <- map["artists_name"]
        artistCode   <- map["artistCode"]
        salbumId   <- map["salbum_id"]
        salbumsName    <- map["salbums_name"]
        albumAssetCode    <- map["albumAssetCode"]
        size128    <- map["size_128"]
        size320    <- map["size_320"]
        playNum    <- map["play_num"]
        shareNum   <- map["share_num"]
        audioURL   <- map["audio_url"]
        picURL   <- map["pic_url"]
        status   <- map["status"]
        language   <- map["language"]
        duration   <- map["duration"]
        filesize   <- map["filesize"]
        tsId   <- map["tsid"]
        copyrightStatus   <- map["copyright_status"]
        removeTime   <- map["remove_time"]
    }

}
