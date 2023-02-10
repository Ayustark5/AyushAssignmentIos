//
//  ImageListViewController.swift
//  Ayush Assignment
//
//  Created by Ayush Raj on 09/02/23.
//

import UIKit

class ImageListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    var result: [Photo]? = []
    @IBOutlet weak var mytable: UITableView!
    var imageArray: [UIImage?]? = [nil,nil]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkdata()
        self.title = "Images"
        mytable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func checkdata() {
        guard let data = result else {
            return
        }
        print(data)
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
        
        cell?.photoName.text = obj.photographer
        cell?.photoDetail.text = obj.alt
        print(Thread.current)
        DispatchQueue.global(qos: .utility).async
        {
            let image = self.getImageData(urlString: (obj.src?.tiny)!)
            
            DispatchQueue.main.async
            {
                cell?.photoImage.image = image
               
                if self.imageArray!.count > indexPath.row {
                    self.imageArray?[indexPath.row] = image
                }
                else {
                    self.imageArray?.append(image)
                }
                
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
        let obj = self.result![indexPath.row]
        let image = self.imageArray?[indexPath.row]
        self.saveLocal(lastSelectedIndex: indexPath.row)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "imageViewer") as? ImageViewController
        nextVC?.singleImage = obj
        nextVC?.tinyImage = image
        self.navigationController?.pushViewController(nextVC!, animated: true)
    } 
        
}
