//
//  VideoListViewController.swift
//  Ayush Assignment
//
//  Created by Ayush Raj on 09/02/23.
//

import UIKit
import AVKit
import AVFoundation

class VideoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    var result: [Video]? = []
    @IBOutlet weak var mytable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Videos"
        mytable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func saveLocal(lastSelectedIndex: Int) {
        let conext = UserDefaults.standard
        conext.set(lastSelectedIndex, forKey: "selectedIndex")
        
        if (conext.value(forKey: "selectedIndex") != nil )
        {
            print(conext.value(forKey: "selectedIndex")!)
        }
    }
    
    func getImageData(urlString: String) -> UIImage {
        
        let url = URL.init(string: urlString)
        do {
            
            let imageData = try Data.init(contentsOf: url!)
            let image = UIImage.init(data: imageData)
            return image!
            
        }
        catch {
            return  UIImage.init(named: "image")!
        }
        
    }
    
    
    // MARK: - UITableView
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as? PhotoTableViewCell
        
        let obj = self.result![indexPath.row]
        
        cell?.photoName.text = obj.user.name
        cell?.photoDetail.text = "\(obj.duration) secs"
        print(Thread.current)
        DispatchQueue.global(qos: .utility).async
        {
            let image = self.getImageData(urlString: (obj.image))
            
            DispatchQueue.main.async
            {
                cell?.photoImage.image = image
                
                print(Thread.current)
            }
        }
       
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let url = URL(string: self.result![indexPath.row].video_files.last!.link)!
        playVideo(url: url)
    }
    
    func playVideo(url: URL) {
            let player = AVPlayer(url: url)
            
            let vc = AVPlayerViewController()
            vc.player = player
            
            self.present(vc, animated: true) { vc.player?.play() }
        }
        
}
