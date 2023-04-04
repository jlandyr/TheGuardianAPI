//
//  ViewController.swift
//  Headlines
//
//  Created by Joshua Garnham on 09/05/2017.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var articles : [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionView()
        reload()
        Article.fetchArticles { _, _ in
            self.reload()
        }
    }
    
    private func registerCollectionView(){
        collectionView.register(UINib(nibName: String(describing: NewsCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: NewsCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func reload() {
        articles.removeAll()
        articles = Article.all
        collectionView.reloadData()
    }

    private func showFavourites() {
        let vc = FavouritesViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    private func saveFavorite(_ article:Article) {
        Article.save(article)
    }
}

//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.reuseIdentifier, for: indexPath) as? NewsCollectionViewCell else {return UICollectionViewCell()}
        cell.article = articles[indexPath.row]
        cell.didSelectSetFavorites = { [weak self] in
            guard let self = self else {return}
            self.saveFavorite(self.articles[indexPath.row])
        }
        cell.didSelectOpenFavorites = { [weak self] in
            guard let self = self else {return}
            self.showFavourites()
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension ViewController : UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
