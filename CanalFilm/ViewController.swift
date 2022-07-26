//
//  ViewController.swift
//  CanalFilm
//
//  Created by Ines BOKRI on 23/07/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBAction
    @IBAction func didTapListMovie(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ListMoviesViewController", bundle: nil)
        let listVC = storyboard.instantiateViewController(withIdentifier: "ListMoviesViewController") as? ListMoviesViewController
        let viewModel = SwinjectProvider.shared.container.resolve(ListMoviesModeling.self)
        listVC?.viewModel = viewModel
                
        if let listVC = listVC {
            self.navigationController?.pushViewController(listVC, animated: true)
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            tabBarController?.tabBar.barTintColor = UIColor.red
        }
    }

}

