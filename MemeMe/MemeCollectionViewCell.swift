//
//  CustomMemeCell.swift
//  MemeMe
//
//  Created by Timo Krall on 11/14/15.
//  Copyright © 2015 Timo Krall. All rights reserved.
//

import UIKit

// class for cell in MemeCollectionViewController
class MemeCollectionViewCell: UICollectionViewCell {
        
    // outlet for image view in cell
    @IBOutlet weak var memeImageView: UIImageView!
    
    /// set image for cell
    func setCellImage(image: UIImage) {
        
        memeImageView.image = image

    }
}