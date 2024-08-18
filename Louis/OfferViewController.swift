//
//  SubscriptionView.swift
//  Louis
//
//  Created by Rudiney on 8/17/24.
//

import UIKit

class OfferViewController: UIViewController {
    
    enum Section: Hashable {
       case main // arbitrary
    }
    
    var offers: [Offer] = []
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Offer>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Offer>
    private var collectionView: UICollectionView!
    
    private lazy var dataSource = makeDataSource()
    private let resueIdentifier = "CustomCollectionViewCell"
    var selectedItem: Offer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureCollectionView()
    }
    
    func setup() {
        view.backgroundColor = .white
    }
}

extension OfferViewController {
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
        layout.itemSize = CGSize(
            width: (view.frame.width / 2.0) - (16 * 2),
            height: 160
        )

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.register(
            OfferCollectionViewCell.self,
            forCellWithReuseIdentifier: resueIdentifier
        )
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
            cellProvider: { [weak self] (collectionView, indexPath, offer) ->
                UICollectionViewCell? in
                guard let self = self else {
                    return nil
                }
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: self.resueIdentifier,
                    for: indexPath) as? OfferCollectionViewCell
                cell?.update(offer: offer, selectedOffer: self.selectedItem)
                return cell
            })

        return dataSource
    }
}

extension OfferViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = offers[indexPath.row]
        collectionView.reloadData()
    }
}

