//
//  LCRadio.swift
//  EvoRadio
//
//  Created by Jarvis on 2019/3/31.
//  Copyright © 2019 JQTech. All rights reserved.
//

import UIKit
import LeanCloud

class LCRadio: LCObject {
    override static func objectClassName() -> String {
        return "Radio"
    }
    
    init(radio: Radio) {
        super.init()
        
        do {
            try set("radio_id", value: radio.radioId)
            try set("radio_name", value: radio.radioName)
        }catch let error {
            print("Set value error: \(error)")
        }
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    let query = LCQuery(className: LCRadio.objectClassName())

    func saveIfNeed() {
        guard let id = self.get("radio_id")?.intValue else {
            print("Not found radio_id from \(LCRadio.objectClassName()) table.")
            return
        }
        
        self.query.whereKey("radio_id", .equalTo(id))
        let result = self.query.find()
        if result.isSuccess, let objects = result.objects, objects.count > 0 {
            print("Special row is exists of id \(id)")
            return
        }
        let _ = save()
    }
}
