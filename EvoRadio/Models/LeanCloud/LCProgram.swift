//
//  LCProgram.swift
//  EvoRadio
//
//  Created by Jarvis on 2019/5/16.
//  Copyright © 2019 JQTech. All rights reserved.
//

import UIKit
import LeanCloud

class LCProgram: LCObject {
    override class func objectClassName() -> String {
        return "Program"
    }
    
    init(program: Program) {
        super.init()
        
        do {
            try set("program_id", value: program.programId)
            try set("program_name", value: program.programName)
            try set("program_desc", value: program.programDesc)
            try set("pic_url", value: program.picURL)
            try set("create_time", value: program.createTime)
            try set("modify_time", value: program.modifyTime)
            try set("pub_time", value: program.pubTime)
            try set("apply_time", value: program.applyTime)
            try set("subscribe_num", value: program.subscribeNum)
            try set("song_num", value: program.songNum)
            try set("play_num", value: program.playNum)
            try set("share_num", value: program.shareNum)
            try set("ref_link", value: program.refLink)
            try set("vip_level", value: program.vipLevel)
            try set("audit_status", value: program.auditStatus)
            try set("sort_order", value: program.sortOrder)
            try set("uid", value: program.uid)
            try set("lavadj", value: program.lavadj)
            try set("recommend", value: program.recommend)
            
        }catch let error {
            print("Set value error: \(error)")
        }
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let query = LCQuery(className: LCProgram.objectClassName())
    
    func saveIfNeed(_ completion: ((Bool) -> Void)?=nil) {
        let primaryKey = "program_id"
        guard let id = self.get(primaryKey)?.stringValue else {
            print("Not found program_id from \(LCProgram.objectClassName()) table.")
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
