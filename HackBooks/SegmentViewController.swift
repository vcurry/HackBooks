//
//  SegmentViewController.swift
//  HackBooks
//
//  Created by Verónica Cordobés on 11/7/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit

class SegmentViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let segment = UISegmentedControl(items: ["favorites", "books"])
        self.navigationItem.titleView = segment
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
