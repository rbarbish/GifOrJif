//
//  ImageListViewController.swift
//  GifOrJif
//
//  Created by Ross Barbish on 11/15/18.
//  Copyright © 2018 Ross Barbish. All rights reserved.
//

import UIKit

class ImageListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ListCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoResults: UILabel!
    private var timerSearch: Timer?
    private var style:UIStatusBarStyle = .lightContent
    private var searchController: UISearchController?
    private var arrImageInfo = [ImageInfo]()
    private var currentPage = 1
    private var totalPages = 1
    private var isFetching = false
    private let perPage = 10
    
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
        searchController?.searchBar.returnKeyType = .done
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTable() {
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 215
        tableView.separatorStyle = .none
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .white
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
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
    
    func didSelectUser(username: String) {
        guard !username.isEmpty else { return }
        guard let iURL = URL(string: "instagram://user?username=\(username)") else {
            showGenericError()
            return
        }
        guard UIApplication.shared.canOpenURL(iURL) else {
            presentAlert(message: "Instagram is not installed")
            return
        }
        UIApplication.shared.open(iURL, options: [:], completionHandler: nil)
    }
    
    //MARK: - UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arrCount = arrImageInfo.count
        lblNoResults.isHidden = arrCount > 0
        return arrCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell else { return UITableViewCell() }
        let idx = indexPath.row
        let info = arrImageInfo[idx]
        cell.setupCell(imageInfo: info, idx: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let idx = indexPath.row
        if arrImageInfo.count >= perPage, !isFetching, perPage * currentPage == idx + 1 {
            currentPage = currentPage + 1
            fetchData(shouldAppend: true)
        }
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
    //MARK: - Fetch Data
    
    @objc func refreshData() {
        tableView.refreshControl?.endRefreshing()
        currentPage = 1
        fetchData()
    }
    
    @objc func fetchData(shouldAppend:Bool = false) {
        guard let sc = searchController, let searchText = sc.searchBar.text else { return }
        isFetching = true
        showSpinnerWithText(text: "Loading")
        ImageStore.instance.fetchImages(searchWord: searchText, perPage: perPage, pageNum: currentPage) { [weak self] (data, response, success) in
            guard let tvc = self else { return }
            DispatchQueue.main.async {
                guard let data = data, success else {
                    tvc.isFetching = false
                    tvc.showErrorHUD(text: "Something went wrong")
                    return
                }
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {
                        tvc.isFetching = false
                        tvc.hideSpinnerIfVisible()
                        return
                    }
                    tvc.isFetching = false
                    tvc.hideSpinnerIfVisible()
                    let results = json["results"] as? [[String: Any]] ?? []
                    tvc.totalPages = json["results"] as? Int ?? 1
                    if !shouldAppend {
                        tvc.arrImageInfo.removeAll(keepingCapacity: false)
                    }
                    for item in results {
                        guard let itemData = try? JSONSerialization.data(withJSONObject: item, options: []) else { continue }
                        guard let imageInfo = try? JSONDecoder().decode(ImageInfo.self, from: itemData) else { continue }
                        tvc.arrImageInfo.append(imageInfo)
                    }
                    if !shouldAppend {
                        tvc.tableView.reloadData()
                    }
                    else {
                        tvc.tableView.insertRows(at: tvc.indexPathsOfNewImages, with: .automatic)
                    }
                } catch _ {
                    tvc.isFetching = false
                    tvc.showErrorHUD(text: "Something went wrong")
                    return
                }
            }
        }
    }
    
    //MARK: - SearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timerSearch?.invalidate()
        guard !(searchBar.text?.isEmpty ?? true) else {
            arrImageInfo.removeAll(keepingCapacity: false)
            tableView.reloadData()
            return
        }
        timerSearch = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(ImageListViewController.refreshData), userInfo: nil, repeats: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Utilities
    
    private var indexPathsOfNewImages: [IndexPath] {
        get {
            var ips = [IndexPath]()
            for i in 0..<perPage {
                let newIP = IndexPath(row: perPage * (currentPage - 1) + i, section: 0)
                ips.append(newIP)
            }
            return ips
        }
    }
    
}
