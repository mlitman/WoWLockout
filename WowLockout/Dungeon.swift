//
//  Dungeon.swift
//  WowLockout
//
//  Created by Michael Litman on 12/7/16.
//  Copyright © 2016 awesomefat. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Dungeon: NSObject
{
    var name = ""
    var type = ""
    var bossList = [String]()
    var bossKills = [Bool]()
    
    init(data: [String: AnyObject], type: String)
    {
        super.init()
        self.name = data.first!.key
        self.type = type
        self.name = self.name.replacingOccurrences(of: "_M", with: "")
        self.name = self.name.replacingOccurrences(of: "_", with: " ")
        let short_name_objects = data.first?.value as! [String: AnyObject]
        for short_name_obj in short_name_objects
        {
            var bossName = short_name_obj.value["Name"] as! String
            bossName = bossName.replacingOccurrences(of: "_M", with: "")
            bossName = bossName.replacingOccurrences(of: "_", with: " ")
            self.bossList.append(bossName)
            self.bossKills.append(false)
            self.processKills(type: type)
        }
    }
    
    func processKills(type: String)
    {
        let devID = UIDevice.current.identifierForVendor?.uuidString
        var ref = FIRDatabase.database().reference()
        ref = ref.child("DeviceData").child(devID!).child(type).child(name)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.debugDescription)
            if(snapshot.value is NSNull)
            {
                //user does not have data, so fill it with default data
                for bossName in self.bossList
                {
                    ref.child(bossName).setValue(false)
                }
            }
            else
            {
                //update boss kills here
                let bossCollection = snapshot.value as! [String: AnyObject]
                
                for bossName in bossCollection.keys
                {
                    if(bossCollection[bossName] as! Bool)
                    {
                        self.killBoss(name: bossName, shouldUpdate: false)
                    }
                    else
                    {
                        self.unkillBoss(name: bossName, shouldUpdate: false)
                    }
                }
            }
        })
    }
    
    func isKilled(name: String) -> Bool
    {
        for i in 0..<bossList.count
        {
            if(self.bossList[i] == name)
            {
                return self.bossKills[i]
            }
        }
        return false
    }
    
    func killBoss(name: String, shouldUpdate: Bool)
    {
        for i in 0..<bossList.count
        {
            if(self.bossList[i] == name)
            {
                self.bossKills[i] = true
            }
        }
        
        if(shouldUpdate)
        {
            let devID = UIDevice.current.identifierForVendor?.uuidString
            var ref = FIRDatabase.database().reference()
            ref = ref.child("DeviceData").child(devID!).child(self.type).child(self.name).child(name)
            ref.setValue(true)
        }
    }
    
    func unkillBoss(name: String, shouldUpdate: Bool)
    {
        for i in 0..<bossList.count
        {
            if(self.bossList[i] == name)
            {
                self.bossKills[i] = false
            }
        }
        if(shouldUpdate)
        {
            let devID = UIDevice.current.identifierForVendor?.uuidString
            var ref = FIRDatabase.database().reference()
            ref = ref.child("DeviceData").child(devID!).child(self.type).child(self.name).child(name)
            ref.setValue(false)
        }
    }
}
