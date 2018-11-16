//
//  ImageListViewController.swift
//  GifOrJif
//
//  Created by Ross Barbish on 11/15/18.
//  Copyright © 2018 Ross Barbish. All rights reserved.
//

import UIKit
import RevealingSplashView

class ImageListViewController: BaseViewController, UITableViewDataSource, ListCellDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    var style:UIStatusBarStyle = .lightContent
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    //MARK: - Layout
    
    private func setupView() {
        setupBackground()
        setupRevealingView()
        setupTable()
    }
    
    private func setupTable() {
        tableView.separatorStyle = .none
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .white
        tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
    }
    
    private func setupBackground() {
        guard let imgBG = UIImage(named: "background") else { return }
        UIGraphicsBeginImageContext(view.frame.size)
        imgBG.draw(in: view.bounds)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            view.backgroundColor = UIColor(patternImage: image)
        }
    }
    
    private func setupRevealingView() {
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let imgIcon = UIImage(named: "splashLogo") else { return }
        let revealingSplashView = RevealingSplashView(iconImage: imgIcon,iconInitialSize: CGSize(width: 150, height: 150), backgroundColor: .rbDarkBlue)
        revealingSplashView.animationType = .popAndZoomOut
        revealingSplashView.startAnimation { [weak self] in
            guard let tvc = self else { return }
            tvc.style = .default
            tvc.setNeedsStatusBarAppearanceUpdate()
        }
        window.addSubview(revealingSplashView)
    }
    
    //MARK: - ListCellDelegate
    
    func didSelectImage(idx: Int) {
        
    }
    
    //MARK: - UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell else { return UITableViewCell() }
        cell.setupCell(idx: indexPath.row)
        return cell
    }
    
    //MARK: - Fetch Data
    
    @objc func refreshHandler() {
        fetchData()
    }
    
    func fetchData() {
        
    }
}

