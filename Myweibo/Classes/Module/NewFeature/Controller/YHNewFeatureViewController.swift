//
//  YHNewFeatureViewController.swift
//  Myweibo
//
//  Created by mposthh on 15/10/30.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class YHNewFeatureViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

   
   

}
