//
//  BoardGameViewController.swift
//  Cards
//
//  Created by Dreik on 6/23/22.
//

import UIKit

protocol BoardGameControllerDelegate: AnyObject {
    func didTapMenuButton()
}

//class BoardGameViewController: UIViewController {
//
//    // Menu
//    weak var delegate: BoardGameControllerDelegate?
//
//    let menuVC = SideMenuViewController()
//    let homeVC = BoardGameViewController()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//
//        addChildVCs()
//    }
//
//    private func addChildVCs() {
//        // Menu
//        addChild(menuVC)
//        view.addSubview(menuVC.view)
//        menuVC.didMove(toParent: self)
//
//        // Home
//        homeVC.delegate = self
//        let navVC = UINavigationController(rootViewController: homeVC)
//        addChild(navVC)
//        view.addSubview(navVC.view)
//        navVC.didMove(toParent: self)
//    }
//}
