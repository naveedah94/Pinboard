//
//  PinBoardCollectionViewCell.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 19/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit

class PinBoardCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.layer.cornerRadius = 0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var imageUrl: String? {
        didSet {
            imageView.loadImage(fromUrl: imageUrl!)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        imageView.frame = self.frame
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
