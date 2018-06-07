//
//  LyricsViewController.swift
//  RackSpace
//
//  Created by chirag agarwal on 6/7/18.
//  Copyright © 2018 chirag. All rights reserved.
//

import UIKit

class LyricsViewController: UIViewController {
    
    var artist : String = ""
    var song : String = ""
    @IBOutlet weak var lyricsView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Lyrics"
        DispatchQueue.main.async {
            let spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
            spinnerActivity.label.text = "Loading";
            spinnerActivity.detailsLabel.text = "Please Wait!!";
        }
        self.callApi()
    }
    
    func callApi(){
        let artistUrl = artist.replacingOccurrences(of: " ", with: "%20")
        let songUrl = song.replacingOccurrences(of: " ", with: "%20")
       let url = URL.init(string: "https://api.lyrics.ovh/v1/\(artistUrl)/\(songUrl)")
        if let urlWorking = url{
            ServiceLayer().callBackendApi(url: urlWorking) { [weak self] (data) in
                do{
                    let text = try JSONDecoder().decode(songLyricsStruct.self, from: data)
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self!.view, animated: true)
                        self?.lyricsView.text = text.lyrics
                    }
                }
                catch{
                    self?.showError(error: error.localizedDescription)
                }
            }
        }else{
           showError(error: "Lyrics not found")
        }
    }
    
    func showError(error: String){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.lyricsView.text = error
        }
    }
}
