//
//  ViewController.swift
//  Louis
//
//  Created by Rudiney on 8/15/24.
//

import UIKit

class ViewController: UIViewController {
    
    let networkManager: NetworkManagerProtocol = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func didTapOnDetails() {
        let detailsViewController = OfferDetailViewController(
            viewModel: OfferDetailViewModel(
                persistentContainer:(UIApplication.shared.delegate as! AppDelegate).persistentContainer)
        )
        navigationController?.present(detailsViewController, animated: true)
    }
}

