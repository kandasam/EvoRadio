//
//  LCChannel.swift
//  EvoRadio
//
//  Created by Jarvis on 2019/3/31.
//  Copyright © 2019 JQTech. All rights reserved.
//

import UIKit
import LeanCloud

class LCChannel: LCObject {
    override static func objectClassName() -> String {
        return "Channel"
    }
    
    init(channel: Channel) {
        super.init()
        
        do {
            try set("channel_id", value: channel.channelId)
            try set("channel_name", value: channel.channelName)
            try set("channel_name_shengmu", value: channel.channelNameShengmu)
            try set("radio_id", value: channel.radioId)
            try set("radio_name", value: channel.radioName)
            try set("program_num", value: channel.programNum)
            try set("program_fine", value: channel.programFine)
            try set("pub_time", value: channel.pubTime)
            try set("sort_order", value: channel.sortOrder)
            try set("pic_url", value: channel.picURL)
            try set("status", value: channel.status)
            try set("recommend", value: channel.recommend)
        }catch let error {
            print("Set value error: \(error)")
        }
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let query = LCQuery(className: LCChannel.objectClassName())
    
    func saveIfNeed(_ completion: ((Bool) -> Void)?=nil) {
        guard let id = self.get("channel_id")?.stringValue else {
            print("Not found channel_id from \(LCChannel.objectClassName()) table.")
            if let c = completion {
                c(false)
            }
            return
        }
        
        self.query.whereKey("channel_id", .equalTo(id))
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
