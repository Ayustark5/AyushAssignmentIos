//
//  ImageViewController.swift
//  Ayush Assignment
//
//  Created by Ayush Raj on 09/02/23.
//

import UIKit

class ImageViewController: UIViewController {
    var singleImage: Photo?
    var tinyImage: UIImage?
    @IBOutlet weak var completeImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(result1!)
        self.completeImage.image = self.tinyImage
        //self.downloadImage()
        // Do any additional setup after loading the view.
    }
    
    func downloadImage() {
        let url: URL = URL.init(string: (singleImage?.src?.original)!)!
    
        let session = URLSession.shared
        
        let task = session.downloadTask(with: url) { url, response, error in
            do {
                let data = try Data.init(contentsOf: url!)
                print(data)
                DispatchQueue.main.async
                {
                    self.completeImage.image = UIImage.init(data: data)
                }
            }
            catch {
                
            }
        }
        
        task.resume()
    }

}
