//
//  ViewController.swift
//  RackSpace
//
//  Created by chirag agarwal on 6/6/18.
//  Copyright © 2018 chirag. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var titleNameArray = [String]()
    var artistArray = [String]()
    var tableViewDataArray = [String]()
    var count = 1

    @IBOutlet weak var tblView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Latest songs"
        let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        spinnerActivity.label.text = "Loading";
        spinnerActivity.detailsLabel.text = "Please Wait!!";
        
        self.callApi()
    }

    func callApi(){
        let url = URL.init(string: "https://itunes.apple.com/us/rss/topsongs/limit=200/json")
        ServiceLayer().callBackendApi(url: url!) { [weak self] (data) in
            do{
                let data = try JSONDecoder().decode(FeedStruct.self, from: data)
                self?.titleNameArray = data.feed.entry.map({$0.title.label})
                self?.artistArray = data.feed.entry.map({$0.artist.label})
                self?.adjustTableViewData()
            }
            catch{
                print(error)
            }
        }
    }
    
    func adjustTableViewData(){
        self.tableViewDataArray = Array(self.titleNameArray.prefix(10 * self.count))
        self.count += 1
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}

//MARK : Table view methods
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return tableViewDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        MBProgressHUD.hide(for: self.view, animated: true);
        cell.textLabel?.text = tableViewDataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableViewDataArray.count - 1 == indexPath.row && count < 100{
            self.adjustTableViewData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = self.storyboard
        let lyricsVC = storyboard?.instantiateViewController(withIdentifier: "LyricsViewController") as! LyricsViewController
        lyricsVC.artist = artistArray[indexPath.row]
        lyricsVC.song = titleNameArray[indexPath.row]
        self.navigationController!.pushViewController(lyricsVC, animated: false)
    }
}

