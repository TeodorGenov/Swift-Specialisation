//
//  MathInfoController.swift
//  LeagueInfo
//
//  Created by issd on 30/10/2018.
//  Copyright © 2018 issd. All rights reserved.
//

import UIKit

class MathInfoController: UIViewController {
    
    var matchDate: String = ""
    @IBAction func backToMainView(_ sender: Any) {
        performSegue(withIdentifier: "backToMainView", sender: self)
    }
    @IBOutlet weak var labelMatch: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg-default-third"))
        labelMatch.text!.append(": " + matchDate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
