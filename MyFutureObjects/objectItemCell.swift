//
//  objectItemCell.swift
//  MyFutureObjects
//
//  Created by Bassyouni on 7/8/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit
import CoreData

class objectItemCell: UITableViewCell {

    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!


    func configureCell(item : Item)
    {
        self.title.text = item.title
        self.price.text = "$\(item.price)"
        self.details.text = item.details
        itemImage.image = item.toImage?.image as? UIImage
    }
    
}
