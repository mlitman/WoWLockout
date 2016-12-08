//
//  DungeonDetailVC.swift
//  WowLockout
//
//  Created by Michael Litman on 12/7/16.
//  Copyright © 2016 awesomefat. All rights reserved.
//

import UIKit

class DungeonDetailVC: UIViewController
{
    @IBOutlet weak var navBar: UINavigationBar!
    var dungeon: Dungeon!
    var bossList: BossList!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navBar.topItem?.title = self.dungeon.name
    }
    
    @IBAction func backButtonPressed()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        self.bossList = segue.destination as! BossList
        self.bossList.dungeon = self.dungeon
    }
    

}
