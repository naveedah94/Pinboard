//
//  HomeViewController.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 19/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private var dashboardArray: [GetDashboardModel] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupRefreshControl()
        self.setupCollectionView()
        self.getBoardDataFromService()
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(self.getBoardDataFromService), for: .valueChanged)
    }
    
    @objc func getBoardDataFromService() {
        NaNetworking.shared.createRequest(nil, .get
        , .urlEncoding, "http://pastebin.com/raw/wgkJgazE") { (data, response, error) in
            if error == nil {
                if let mData = data, let json = NaNetworking.shared.getJson(from: mData) {
                    print(json)
                    self.dashboardArray = try! JSONDecoder().decode([GetDashboardModel].self, from: mData)
                    
                    self.refreshControl.endRefreshing()
                    self.collectionView.reloadData()
                } else {
                    print("Failed")
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func readjson(fileName: String) -> Data {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        let jsonData = try? Data.init(contentsOf: URL.init(fileURLWithPath: path!))
        
        return jsonData!
    }
    
    func setupCollectionView() {
        if let layout =  self.collectionView.collectionViewLayout as? PinboardCollectionViewLayout {
            layout.delegate = self
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.refreshControl = self.refreshControl
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PinboardLayoutDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dashboardArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PinBoardCollectionViewCell
        
        let item = dashboardArray[indexPath.row]
        
        cell.backgroundColor = UIColor.init(hexString: item.color!)
        NaImageDownloader.init().loadImage(fromUrl: (item.urls?.thumb)!, atIndexPath: indexPath) { (image, url, error, indexPath) in
            if image != nil {
                if let cell = collectionView.cellForItem(at: indexPath!) as? PinBoardCollectionViewCell {
                    cell.imageView.image = image
                }
            }
        }
        
        return cell
    }
    
    //#LOADMORE FUNCTIONALITY *** COMMENTED OUT *** //
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //UN COMMENT THIS TO ADD LOAD MORE FUNCTIONALITY
        //JUST NEED TO ADJUST API URL
        //ALONG WITH OFFSET VARIABLE OF SOME THING OF THAT SORT
        //I AM LEAVING IT TO THIS FOR NOW ON ASSUMPTION THAT WHEN THE URL WILL BE GIVEN IT CAN BE IMPLEMENTED EASILY
        
//        if self.dashboardArray.count >= 10 {
//            if indexPath.row == self.dashboardArray.count - 2 {
//                self.getBoardDataFromService()
//            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let width = (self.collectionView.frame.size.width / 2) - 4
        
        let item = dashboardArray[indexPath.row]
        let itemWidth = Double(item.width!)
        let itemHeight = Double(item.height!)
        
        let height = CGFloat((itemHeight / itemWidth)) * width
        
        
        return height
    }

}
