//
//  ImageListViewController.swift
//  GifOrJif
//
//  Created by Ross Barbish on 11/15/18.
//  Copyright © 2018 Ross Barbish. All rights reserved.
//

import UIKit
import RevealingSplashView

class ImageListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ListCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var timerSearch: Timer?
    private var style:UIStatusBarStyle = .lightContent
    private var searchController: UISearchController?
    private var arrImageInfo = [ImageInfo]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchData()
    }

    //MARK: - Layout
    
    private func setupView() {
        setupBackground()
        setupRevealingView()
        setupTable()
        setupNavBar()
        setupSearchController()
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController?.searchBar.text = "Ramen"
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTable() {
        tableView.separatorStyle = .none
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .white
        tableView.refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)
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
        revealingSplashView.startAnimation { [weak self] in
            guard let tvc = self else { return }
            tvc.style = .default
            tvc.setNeedsStatusBarAppearanceUpdate()
        }
        window.addSubview(revealingSplashView)
    }
    
    //MARK: - ListCellDelegate
    
    func didSelectImage(imgView: UIImageView) {
        let configuration = ImageViewerConfiguration { config in
            config.imageView = imgView
        }
        let imageViewerController = ImageViewerController(configuration: configuration)
        present(imageViewerController, animated: true)
    }
    
    //MARK: - UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrImageInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell else { return UITableViewCell() }
        let idx = indexPath.row
        let info = arrImageInfo[idx]
        cell.setupCell(imageInfo: info, idx: indexPath.row)
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    //MARK: - Fetch Data
    
    @objc func fetchData() {
        guard let sc = searchController, let searchText = sc.searchBar.text else { return }
        showSpinnerWithText(text: "Loading")
        ImageStore.instance.fetchImages(searchWord: searchText) { [weak self] (data, response, success) in
            guard let tvc = self else { return }
            DispatchQueue.main.async {
                guard let data = data, success else {
                    tvc.showErrorHUD(text: "Something went wrong")
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    let results = json["results"] as? [[String: Any]] ?? []
                    tvc.arrImageInfo.removeAll(keepingCapacity: false)
                    for item in results {
                        let imageInfo = ImageInfo(dataDict: item)
                        tvc.arrImageInfo.append(imageInfo)
                    }
                    tvc.hideSpinnerIfVisible()
                    tvc.tableView.reloadData()
                } catch _ {
                    tvc.showErrorHUD(text: "Something went wrong")
                    return
                }
                
            }
        }
    }
    
    //MARK: - SearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !(searchBar.text?.isEmpty ?? true) else { return }
        timerSearch = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ImageListViewController.fetchData), userInfo: nil, repeats: false)
    }
    
}
