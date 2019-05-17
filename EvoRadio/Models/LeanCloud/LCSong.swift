//
//  LCSong.swift
//  EvoRadio
//
//  Created by Jarvis on 2019/5/17.
//  Copyright © 2019 JQTech. All rights reserved.
//

import UIKit
import LeanCloud

class LCSong: LCObject {
    override class func objectClassName() -> String {
        return "Song"
    }
    
    init(song: Song) {
        super.init()
        
        do {
            try set("song_id", value: song.songId)
            try set("song_name", value: song.songName)
            try set("jujing_id", value: song.jujingId)
            try set("program_id", value: song.programId)
            try set("artist_id", value: song.artistId)
            try set("artists_name", value: song.artistsName)
            try set("artistCode", value: song.artistCode)
            try set("salbum_id", value: song.salbumId)
            try set("salbums_name", value: song.salbumsName)
            try set("albumAssetCode", value: song.albumAssetCode)
            try set("size_128", value: song.size128)
            try set("size_320", value: song.size320)
            try set("play_num", value: song.playNum)
            try set("share_num", value: song.shareNum)
            try set("audio_url", value: song.audioURL)
            try set("pic_url", value: song.picURL)
            try set("status", value: song.status)
            try set("language", value: song.language)
            try set("duration", value: song.duration)
            
            try set("filesize", value: song.filesize)
            try set("tsid", value: song.tsId)
            try set("copyright_status", value: song.copyrightStatus)
            try set("remove_time", value: song.removeTime)
            
        }catch let error {
            print("Set value error: \(error)")
        }
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let query = LCQuery(className: LCSong.objectClassName())
    
    func saveIfNeed(_ completion: ((Bool) -> Void)?=nil) {
        let primaryKey = "song_id"
        guard let id = self.get(primaryKey)?.stringValue else {
            print("Not found song_id from \(LCSong.objectClassName()) table.")
            if let c = completion {
                c(false)
            }
            return
        }
        
        self.query.whereKey(primaryKey, .equalTo(id))
        let result = self.query.find()
        if result.isSuccess, let objects = result.objects, objects.count > 0 {
            print("Special row is exists of id \(id)")
            if let c = completion {
                c(false)
            }
            return
        }
        
        if let c = completion {
            let _ = save { (result) in
                c(result.isSuccess)
            }
        }else {
            let _ = save()
        }
    }
    
    func saveIfNeed() {
        saveIfNeed(nil)
    }
}
