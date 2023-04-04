//
//  NewsCollectionViewCell.swift
//  Headlines
//
//  Created by Juan Landy on 4/4/23.
//  Copyright © 2023 Example. All rights reserved.
//

import UIKit
import SDWebImage

class NewsCollectionViewCell: UICollectionViewCell {

    static var reuseIdentifier = "cell"
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var headlineLabel: UILabel!
    @IBOutlet weak var bodyText: UITextView!
    
    //MARK: - CALLBACKS
    var didSelectOpenFavorites : (() -> Void)?
    var didSelectSetFavorites : (() -> Void)?
    
    @IBOutlet weak var buttonStar: UIButton!{
        didSet{
            buttonStar.titleLabel?.text = ""
        }
    }
    @IBOutlet weak var buttonFavorite: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func buttonFavorite(_ sender: UIButton) {
        didSelectOpenFavorites?()
    }
    
    @IBAction func buttonStar(_ sender: UIButton) {
        didSelectSetFavorites?()
    }
    
    var article : Article? {
        didSet{
            guard let _article = article else { return }
            headlineLabel.text = _article.headline
            bodyText.text = _article.body
            imageView.sd_setImage(with: _article.imageURL)
        }
    }
}
