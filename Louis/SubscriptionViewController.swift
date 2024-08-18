//
//  SubscriptionView.swift
//  Louis
//
//  Created by Rudiney on 8/17/24.
//

import UIKit

class SubscriptionViewController: UIViewController {
    
    enum Section: Hashable {
       case main // arbitrary
    }
    
    var offers: [Offer] = []
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Offer>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Offer>
    private var collectionView: UICollectionView!
    
    private lazy var dataSource = makeDataSource()
    private let resueIdentifier = "CustomCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
}

extension SubscriptionViewController {
    private func configureCollectionView() {
        let itemSpacing: CGFloat = 10.0

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(
            top: itemSpacing,
            left: itemSpacing,
            bottom: itemSpacing,
            right: itemSpacing
        )
        layout.itemSize = CGSize(width: 100.0, height: 100.0)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .red
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot() // reusing typealias
        snapshot.appendSections([.main])
        snapshot.appendItems(offers)

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func makeDataSource() -> DataSource { // reusing typealias
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: self.resueIdentifier,
                    for: indexPath)
                cell.largeContentTitle = "\(String(describing: item.name))"// from items
                return cell
            })

        return dataSource
    }
}


