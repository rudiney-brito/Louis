//
//  DetailViewController.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//

import Foundation
import UIKit
import Combine

class OfferDetailViewController: UIViewController {
    
    let scrollView = UIScrollView()
    
    let activityView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    let headerLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray.withAlphaComponent(0.5)
        return imageView
    }()
    
    let subscribeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let subscribeSubtitle: UILabel = {
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
    
    let subscriptionViewController = SubscriptionViewController()
    
    let whatIsNews: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("What is \"News +*?\"", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(.checkmark, for: .normal)
        button.contentMode = .center
        return button
    }()
    
    var benefits = UIStackView()
    
    let subscribeNow: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Subscribe Now", for: .normal)
        button.backgroundColor = .gray
        button.isEnabled = false
        return button
    }()
    
    let disclaimer: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let headerLogoHeight = 94.0
    let coverImageHeightMultiplier = 0.3
    let subscriptionHeight = 160.0
    let subscribeNowHeight = 60.0
    let whatIsNewsHeight = 60.0
    
    private var viewModel: OfferDetailViewModelProtocol
    
    var subscription = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupHeaderLogo()
        setupCoverImage()
        setupSubscribeTitle()
        //        setupSubscribeSubtitle()
        setupBenefits()
        setupSubscribeNow()
        //        setupDisclaimer()
        subscribe()
    }
    
    func subscribe() {
        viewModel.state.sink(receiveValue: { [weak self] state in
            switch state {
            case .idle:
                print("idle")
            case .loading:
                self?.activityView.startAnimating()
            case .loaded(let offer):
                self?.activityView.stopAnimating()
                self?.update(offer: offer)
            case .error(let error):
                print("error \(error)")
                print(error)
            }
        }).store(in: &subscription)
        
        viewModel.headerLogo.sink { [weak self] data in
            self?.headerLogo.image = UIImage(data: data)
        }.store(in: &subscription)
        
        viewModel.coverImage.sink { [weak self] data in
            self?.coverImage.image = UIImage(data: data)
        }.store(in: &subscription)
        
        viewModel.getOffer()
    }
    
    func update(offer: Record) {
        if let data = offer.headerLogoData {
            headerLogo.image = UIImage(data: data)
        }
        update(subscription: offer.subscription)
    }
    
    func update(subscription: Subscription?) {
        if let data = subscription?.coverImageData {
            coverImage.image = UIImage(data: data)
        }
        subscribeTitle.text = subscription?.subscribeTitle
        subscribeSubtitle.text = subscription?.subscribeSubtitle
        disclaimer.text = subscription?.disclaimer
        subscribeNow.backgroundColor = .systemBlue
        subscribeNow.isEnabled = true
        
        if let offers = subscription?.offers {
            for offer in offers {
                subscriptionViewController.offers.append(offer)
            }
            subscriptionViewController.applySnapshot() 
        }
        
        if let benefits = subscription?.benefits {
            for benefit in benefits {
                self.benefits.addArrangedSubview(makeBenefitLabel(from: benefit))
            }
        }
    }
    
    private func makeAttributedString(text: String, paragraphStyle: NSParagraphStyle) -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        return  NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    func makeBenefitLabel(from benefit: Benefit) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = true
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        label.textColor = .black
        label.text = benefit.name
        return label
    }
    
    func setup() {
        view.backgroundColor = .white
        view.addSubview(activityView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let secundary = UIStackView()
        secundary.translatesAutoresizingMaskIntoConstraints = false
        secundary.axis = .vertical
        secundary.spacing = 16
        secundary.layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        secundary.isLayoutMarginsRelativeArrangement = true
        
        subscriptionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        subscriptionViewController.view.backgroundColor = .red
        
        addChild(subscriptionViewController)
        view.addSubview(subscriptionViewController.view)
        subscriptionViewController.didMove(toParent: self)
    
        secundary.addArrangedSubview(subscribeTitle)
        secundary.addArrangedSubview(subscribeSubtitle)
        secundary.addArrangedSubview(subscriptionViewController.view)
        secundary.addArrangedSubview(whatIsNews)
        secundary.addArrangedSubview(benefits)
        secundary.addArrangedSubview(subscribeNow)
        secundary.addArrangedSubview(disclaimer)

        let stack = UIStackView(arrangedSubviews: [
            headerLogo,
            coverImage
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.addArrangedSubview(secundary)

        scrollView.addSubview(stack)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            secundary.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            secundary.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            subscriptionViewController.view.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            subscriptionViewController.view.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            subscriptionViewController.view.heightAnchor.constraint(equalToConstant: subscriptionHeight)
        ])
        
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    init(viewModel: OfferDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OfferDetailViewController {
    func setupHeaderLogo() {
//        view.addSubview(headerLogo)
        addHeaderLogoConstraints()
    }
    
    func addHeaderLogoConstraints() {
        NSLayoutConstraint.activate([
//                headerLogo.topAnchor.constraint(equalTo: view.topAnchor),
//                headerLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                headerLogo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                headerLogo.heightAnchor.constraint(equalToConstant: headerLogoHeight)
            ])
    }
}

extension OfferDetailViewController {
    func setupCoverImage() {
//        view.addSubview(coverImage)
        addCoverImageConstraints()
    }
    
    func addCoverImageConstraints() {
        NSLayoutConstraint.activate([
//                coverImage.topAnchor.constraint(equalTo: headerLogo.bottomAnchor),
//                coverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                coverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                coverImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: coverImageHeightMultiplier)
        ])
    }
}

extension OfferDetailViewController {
    func setupSubscribeTitle() {
//        view.addSubview(subscribeTitle)
//        addSubscribeTitleConstraints()
    }
    
    func addSubscribeTitleConstraints() {
        NSLayoutConstraint.activate([
                subscribeTitle.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 16),
                subscribeTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
                subscribeTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36)
            ])
    }
}

extension OfferDetailViewController {
    func setupSubscribeSubtitle() {
        view.addSubview(subscribeSubtitle)
        addSubscribesubtitleConstraints()
    }
    
    func addSubscribesubtitleConstraints() {
        NSLayoutConstraint.activate([
                subscribeSubtitle.topAnchor.constraint(equalTo: subscribeTitle.bottomAnchor, constant: 16),
                subscribeSubtitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                subscribeSubtitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
            ])
    }
}

extension OfferDetailViewController {
    func setupBenefits() {
        benefits.isHidden = true
        benefits.axis = .vertical
        benefits.distribution = .fill
        benefits.translatesAutoresizingMaskIntoConstraints = false
        whatIsNews.addTarget(self, action: #selector(didTapOnBenefits), for: .touchUpInside)
    }
    
    @objc 
    func didTapOnBenefits() {
        print(#function)
        benefits.isHidden.toggle()
    }
    
    func addBenefitsConstraints() {
        NSLayoutConstraint.activate([
                whatIsNews.topAnchor.constraint(equalTo: subscribeSubtitle.bottomAnchor, constant: 16),
                whatIsNews.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                whatIsNews.heightAnchor.constraint(equalToConstant: whatIsNewsHeight)
            ])
    }
}

extension OfferDetailViewController {
    func setupSubscribeNow() {
//        view.addSubview(subscribeNow)
        addSubscdribeNowConstraints()
    }
    
    func addSubscdribeNowConstraints() {
        NSLayoutConstraint.activate([
//                subscribeNow.topAnchor.constraint(equalTo: benefits.bottomAnchor, constant: 16),
//                subscribeNow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
//                subscribeNow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                subscribeNow.heightAnchor.constraint(equalToConstant: subscribeNowHeight)
            ])
    }
}

extension OfferDetailViewController {
    func setupDisclaimer() {
        view.addSubview(disclaimer)
        addDisclaimerConstraints()
    }
    
    func addDisclaimerConstraints() {
        NSLayoutConstraint.activate([
                disclaimer.topAnchor.constraint(equalTo: subscribeNow.bottomAnchor, constant: 16),
                disclaimer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
                disclaimer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            ])
    }
}
