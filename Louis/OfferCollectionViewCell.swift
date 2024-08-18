//
//  OfferCollectionViewCell.swift
//  Louis
//
//  Created by Rudiney on 8/17/24.
//

import UIKit

class OfferCollectionViewCell: UICollectionViewCell {
    
    let price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark.circle")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addViews()
        addConstraints()
    }
    
    func setup() {
        backgroundColor = .white
    }
    
    func update(offer: Offer, selectedOffer: Offer?) {
        price.text = "$\(offer.price)"
        name.text = offer.name
        
        imageView.image = selectedOffer == offer
        ? UIImage(systemName: "checkmark.circle")
        : UIImage(systemName: "circle")
        
    }
    
    func addViews() {
        addSubview(price)
        addSubview(name)
        addSubview(imageView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            price.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            price.leadingAnchor.constraint(equalTo: leadingAnchor),
            price.trailingAnchor.constraint(equalTo: trailingAnchor),
            name.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 8),
            name.leadingAnchor.constraint(equalTo: leadingAnchor),
            name.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
