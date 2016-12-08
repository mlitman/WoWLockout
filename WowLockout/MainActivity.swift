//
//  ViewController.swift
//  WowLockout
//
//  Created by Michael Litman on 11/30/16.
//  Copyright © 2016 awesomefat. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MainActivity: UIViewController
{

    @IBOutlet weak var myLabel: UILabel!
    var dungeonList : DungeonList!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func resetButtonPressed()
    {
        let devID = UIDevice.current.identifierForVendor?.uuidString
        var ref = FIRDatabase.database().reference()
        ref = ref.child("DeviceData").child(devID!)
        ref.removeValue()
        self.dungeonList.loadDungeons()
    }
    
    @IBAction func mythicButtonPressed(_ sender: Any)
    {
        self.dungeonList.showMythicDungeons()
    }
    
    @IBAction func heroicButtonPressed()
    {
        self.dungeonList.showHeroicDungeons()
    }
    
    @IBAction func normalButtonPressed()
    {
        self.dungeonList.showNormalDungeons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        self.dungeonList = segue.destination as! DungeonList
    }


}

