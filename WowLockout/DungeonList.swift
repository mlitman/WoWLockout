//
//  DungeonList.swift
//  WowLockout
//
//  Created by Michael Litman on 11/30/16.
//  Copyright © 2016 awesomefat. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DungeonList: UITableViewController
{
    var normalDungeons = [Dungeon]()
    var heroicDungeons = [Dungeon]()
    var mythicDungeons = [Dungeon]()
    var currList : [Dungeon]!
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        self.loadDungeons()
        self.currList = self.normalDungeons
    }
    
    func loadDungeons()
    {
        self.normalDungeons.removeAll()
        self.heroicDungeons.removeAll()
        self.mythicDungeons.removeAll()
        
        //asynchronous call
        self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as? [String : AnyObject]
            let zones = data?["Zones"] as! [String: AnyObject]
            let dungeons = zones["Dungeons"] as! [String: AnyObject]
            let normal = dungeons["Normal"] as! [String: AnyObject]
            let heroic = dungeons["Heroic"] as! [String: AnyObject]
            let mythic = dungeons["Mythic"] as! [String: AnyObject]
            
            //get normal dungeon names
            for name in normal.keys
            {
                let obj = normal[name] as! [String: AnyObject]
                //self.normalDungeons.append(obj.first!.key)
                self.normalDungeons.append(Dungeon(data: obj, type: "normal"))
            }
            
            //get heroic dungeon names
            for name in heroic.keys
            {
                let obj = heroic[name] as! [String: AnyObject]
                self.heroicDungeons.append(Dungeon(data: obj, type: "heroic"))
            }
            
            //get mythic dungeon names
            for name in mythic.keys
            {
                let obj = mythic[name] as! [String: AnyObject]
                self.mythicDungeons.append(Dungeon(data: obj, type: "mythic"))
            }
            
            //notify that the table should be reloaded
            DispatchQueue.main.async
                {
                    self.currList = self.normalDungeons
                    self.tableView.reloadData()
            }
            
        })
    }
    
    func showNormalDungeons()
    {
        self.currList = self.normalDungeons
        self.tableView.reloadData()
    }
    
    func showHeroicDungeons()
    {
        self.currList = self.heroicDungeons
        self.tableView.reloadData()

    }
    
    func showMythicDungeons()
    {
        self.currList = self.mythicDungeons
        self.tableView.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.currList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.currList[indexPath.row].name
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DungeonDetailVC") as! DungeonDetailVC
        
        let selectedDungeon = self.currList[indexPath.row]
        vc.dungeon = selectedDungeon
        self.present(vc, animated: true, completion: nil)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
