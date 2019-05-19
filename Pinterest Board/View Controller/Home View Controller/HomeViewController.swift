//
//  HomeViewController.swift
//  Pinterest Board
//
//  Created by Naveed Ahmed on 19/05/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private var dataArray: NSArray = NSMutableArray()
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos:[PhotoModel] = []
    var photoReference: [String] = []
    var completedReference: [String] = []
    
    lazy var fetcher = ImagePreFetcher.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getBoardDataFromService()
    }
    
    func getBoardDataFromService() {
        let jsonData = self.readjson(fileName: "data")
        let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)
        if let jsonResult = jsonResult as? NSArray {
           print(jsonResult)
            self.dataArray = jsonResult
            self.loadCollectionView()
        }
        print("Oops failed")
    }
    
    func readjson(fileName: String) -> Data {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        let jsonData = try? Data.init(contentsOf: URL.init(fileURLWithPath: path!))
        
        return jsonData!
    }
    
    func loadCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PinBoardCollectionViewCell
        
        cell.backgroundColor = UIColor.darkGray
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.collectionView.frame.size.width / 2) - 4, height: (self.collectionView.frame.size.width / 2) - 4)
    }

}
