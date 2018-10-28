//
//  ChampionCollectionViewController.swift
//  LeagueInfo
//
//  Created by issd on 27/10/2018.
//  Copyright © 2018 issd. All rights reserved.
//

import UIKit

class ChampionCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBAction func orderByName(_ sender: Any) {
        self.sortedArray = arrayURLs.sorted{$0.absoluteString < $1.absoluteString}
    }
    @IBOutlet weak var lableCharName: UILabel!
    @IBAction func showChampion(_ sender: Any) {
        self.performSegue(withIdentifier: "ChampionController", sender: self)
    }
    let path = Bundle.main.resourcePath
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChampionController {
            vc.name = lableCharName.text!
        }
    }
    @IBOutlet weak var myCollectionView: UICollectionView!
    var sortedArray: [URL] = []
    var array: [UIImage] = []
    var arrayURLs: [URL] = []
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! myCell
        cell.myImageView.image = array[indexPath.row]
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        cell.accessibilityLabel = arrayURLs[indexPath.row].absoluteString
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChampionController") as? ChampionController
        vc?.name = arrayURLs[indexPath.row].absoluteString
        self.navigationController?.pushViewController(vc!, animated: true)
        print("not working")
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer)
    {
        let location = sender.location(in: self.myCollectionView)
        let indexPath = self.myCollectionView.indexPathForItem(at: location)
        let something = self.myCollectionView.cellForItem(at: indexPath!)
        
        let string = arrayURLs[indexPath!.row].absoluteString
        
        let urlofstring = arrayURLs[indexPath!.row].absoluteString
        let replacedString = urlofstring.replacingOccurrences(of: self.path!, with: "")
        let replacedStringSecond = replacedString.replacingOccurrences(of: "file:///championImages/", with: "")
        let finalString = replacedStringSecond.replacingOccurrences(of: ".png", with: "")
        self.lableCharName.text! = finalString
        print(finalString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg-default-third"))
        myCollectionView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        
        let itemSize = UIScreen.main.bounds.width/6 - 6
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(5,0,5,0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 3
        
        myCollectionView.collectionViewLayout = layout
        if path == Bundle.main.resourcePath {
            let imagePath = path! + "/championImages"
            let url = URL(fileURLWithPath: imagePath)
            let fileManager = FileManager.default
            
            let properties = [URLResourceKey.localizedNameKey,
                              URLResourceKey.creationDateKey,
                              URLResourceKey.localizedTypeDescriptionKey]
            do {
                let imageURLs = try fileManager.contentsOfDirectory(at: url as URL, includingPropertiesForKeys: properties, options:FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                //                print("imageURLs: \(imageURLs)")
                arrayURLs = imageURLs

                for image in imageURLs
                {
                    let data = NSData(contentsOf: image)
                    let uiImage = UIImage(data: data! as Data)
                    array.append(uiImage!)
                }
//                for i in 0..<imageArray.count
//                {
//
//                    let uiImageView = UIImageView()
//                    uiImageView.image = self.imageArray[i]
//                    let xPosition = self.view.frame.width * CGFloat(i)
//                    let width = self.imageScroll.frame.width
//                    let height = self.imageScroll.frame.height
//                    uiImageView.frame = CGRect(x: xPosition, y: 0, width: width, height: height)
//                    self.imageScroll.contentSize.width = self.imageScroll.frame.width * CGFloat(i+1)
//                    uiImageView.contentMode = .scaleToFill
//                    DispatchQueue.main.async {
//                        self.imageScroll.addSubview(uiImageView)
//                    }
//
//                }
                
            }
            catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
