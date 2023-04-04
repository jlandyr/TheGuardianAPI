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
            buttonStar.setTitle("", for: .normal)
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
        setStar()
        animate()
        didSelectSetFavorites?()
    }
    
    var article : Article? {
        didSet{
            guard let _article = article else { return }
            headlineLabel.text = _article.headline
            bodyText.text = _article.body
            imageView.sd_setImage(with: _article.imageURL)
            setStar()
        }
    }
    
    private func setStar(){
        guard let _article = article else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            if _article.isFavorite() {
                self.buttonStar.setImage(UIImage(imageLiteralResourceName: "favourite-on"), for: .normal)
            }else {
                self.buttonStar.setImage(UIImage(imageLiteralResourceName: "favourite-off"), for: .normal)
            }
        }
    }
    
    private func animate(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: [], animations: {
                self.buttonStar.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: {_ in
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 6.0, options: [], animations: {
                    self.buttonStar.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: nil)
            })
        }
    }
    
}
