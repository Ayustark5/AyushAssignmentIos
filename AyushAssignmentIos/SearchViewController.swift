//
//  SearchViewController.swift
//  Ayush Assignment
//
//  Created by Ayush Raj on 09/02/23.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextBox: UITextField!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    var a: Int = 1
    @IBOutlet weak var searchType: UISegmentedControl!
    var photoData: [Photo]?
    var videoData: [Video]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLabel.text = "Search \( searchType.titleForSegment(at: searchType.selectedSegmentIndex)!)"
        // API call
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchTypeValueChanged(_ sender: Any) {
        myLabel.text = "Search \( searchType.titleForSegment(at: searchType.selectedSegmentIndex)!)"
    }
    
    @IBAction func pressNext(_ sender: UIButton)
    {
        
        var searchText = searchTextBox.text!
        searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        switch(searchType.selectedSegmentIndex){
        case 0: do{
            self.searchPhotoAPI(query: searchText)
        }
        case 1: do{
            let alert = UIAlertController.init(title: "Not yet implemented", message: "Musics is yet to be implemented", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                
            }))
            self.present(alert, animated: true)
        }
        case 2: do{
            self.searchVideoAPI(query: searchText)
        }
        default: do{
            
        }
            
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch(segue.identifier){
        case "searchToImage": do{
            let destination = segue.destination as? ImageListViewController
            destination?.result = self.photoData
        }
        case "searchToVideo": do{
            let destination = segue.destination as?
            VideoListViewController
            destination?.result = self.videoData
        }
        default: do{
            
        }
        }
    }
    
    func searchPhotoAPI(query: String) {
        guard let path = Bundle.main.path(forResource: "secret", ofType: "plist") else {return}
        let url = URL(fileURLWithPath: path)
        let data = NSDictionary(contentsOf: url)
        if (query == "") {
            let alert = UIAlertController.init(title: "Error", message: "Please Enter Search Query", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                
            }))
            self.present(alert, animated: true)
        }
        else {
            let url: URL = URL.init(string: "\(data!.value(forKey: "api_url")!)v1/search?query=\(query)")!
            let headers = [
                "X-RapidAPI-Key": data!.value(forKey: "api_key")! as! String,
                "X-RapidAPI-Host": data!.value(forKey: "api_host")! as! String,
            ]
            var urlRequest: URLRequest = URLRequest.init(url: url)
            urlRequest.allHTTPHeaderFields = headers
            urlRequest.httpMethod = "GET"
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest) { data, response, error in
                
                if (error != nil)
                {
                        print(error!)
                    
                    }
                else {
                        let httpResponse = response as? HTTPURLResponse
                        print(httpResponse!)
                        let decoder = JSONDecoder()
                        do {
                            let model = try decoder.decode(PhotoDataModel.self, from: data!)
                            if(model.total_results! < 1){
                                DispatchQueue.main.async {
                                    let alert = UIAlertController.init(title: "No Results", message: "Invalid search string, Try Again", preferredStyle: UIAlertController.Style.alert)
                                    
                                    alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                                    }))
                                    self.present(alert, animated: true)
                                }
                                return
                            }
                            self.photoData = model.photos
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "searchToImage", sender: nil)
                            }
                            
                        }
                        catch {
                            print("decode error")
                        }
                    }
               
            }
            
            task.resume()
            
        }
        
        
    }
    
    func searchVideoAPI(query: String) {
        guard let path = Bundle.main.path(forResource: "secret", ofType: "plist") else {return}
        print("path", path)
        let url = URL(fileURLWithPath: path)
        let data = NSDictionary(contentsOf: url)
        if (query == "") {
            let alert = UIAlertController.init(title: "Error", message: "Please Enter Search Query", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                
            }))
            self.present(alert, animated: true)
        }
        else {
            let url: URL = URL.init(string: "\(data!.value(forKey: "api_url")!)videos/search?query=\(query)")!
            let headers = [
                "X-RapidAPI-Key": data!.value(forKey: "api_key")! as! String,
                "X-RapidAPI-Host": data!.value(forKey: "api_host")! as! String,
            ]
            var urlRequest: URLRequest = URLRequest.init(url: url)
            urlRequest.allHTTPHeaderFields = headers
            urlRequest.httpMethod = "GET"
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest) { data, response, error in
                
                if (error != nil)
                {
                        print(error!)
                    
                    }
                else {
                        let httpResponse = response as? HTTPURLResponse
                        print(httpResponse!)
                        let decoder = JSONDecoder()
                        do {
                            let model = try decoder.decode(VideoDataModel.self, from: data!)
                            print("Printing", "\(model) fg")
                            if(model.total_results < 1){
                                DispatchQueue.main.async {
                                    let alert = UIAlertController.init(title: "No Results", message: "Invalid search string, Try Again", preferredStyle: UIAlertController.Style.alert)
                                    
                                    alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                                    }))
                                    self.present(alert, animated: true)
                                }
                                return
                            }
                            self.videoData = model.videos
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "searchToVideo", sender: nil)
                            }
                            
                        }
                    catch {
                            print("decode error \(error)")
                        }
                    }
               
            }
            
            task.resume()
        }
        
        
    }
    
}

