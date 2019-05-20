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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupCollectionView()
        self.getBoardDataFromService()
    }
    
    func getBoardDataFromService() {
        NaNetworking.shared.createRequest(nil, .get
        , .urlEncoding, "http://pastebin.com/raw/wgkJgazE") { (data, response, error) in
            if error == nil {
                if let mData = data, let json = NaNetworking.shared.getJson(from: mData) {
                    print(json)
                    self.dashboardArray = try! JSONDecoder().decode([GetDashboardModel].self, from: mData)
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
        cell.imageUrl = (item.urls?.thumb)!
//        cell.imageView.loadImage(fromUrl: (item.urls?.thumb)!)
        
        return cell
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
