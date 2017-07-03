//
//  RootSplitViewController.swift
//  Challenge
//
//  Created by Zsolt Kovacs on 6/23/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit
import CoreData

class RootViewController: UISplitViewController {
    var dataProvider: DataProvider?
    var context: NSManagedObjectContext?

    private let errorView = ErrorView()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigation = viewControllers.first as! UINavigationController
        let main = navigation.viewControllers.first as! MasterViewController
        main.selectionDelegate = self
        main.context = context

        preferredDisplayMode = .allVisible
        minimumPrimaryColumnWidth = 320
        maximumPrimaryColumnWidth = 320

        NotificationCenter.default.addObserver(forName: .UIApplicationDidBecomeActive, object: nil, queue: nil) { [weak self] _ in
            self?.reloadData()
        }

        errorView.delegate = self
        view.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }

    fileprivate func reloadData() {
        DispatchQueue.main.async {
            self.hideError()
        }

        dataProvider?.reloadData { response in
            DispatchQueue.main.async {
                switch response {
                case .failed(let error): self.display(error: error)
                default: break
                }
            }
        }
    }

    // MARK: - Error view

    private func display(error: NSError) {
        errorView.errorMessage = error.localizedDescription
        errorView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func hideError() {
        errorView.errorMessage = nil

        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            self.errorView.isHidden = true
        }
    }
}

extension RootViewController: MasterViewControllerDelegate {
    func masterViewController(_ masterViewController: MasterViewController, didSelect post: Post?) {
        let detail = viewControllers.last as! DetailViewController
        detail.context = context
        detail.post = post
    }
}

extension RootViewController: ErrorViewDelegate {
    func retryButtonTapped() {
        reloadData()
    }
}
