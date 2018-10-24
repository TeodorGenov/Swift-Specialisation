//
//  ChampionController.swift
//  LeagueInfo
//
//  Created by issd on 16/10/2018.
//  Copyright © 2018 issd. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChampionController: UIViewController {

//    var button = dropDownBtn()
    
    var name: String = ""
    var newName: String = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewController {
            vc.name = newName
        }
    }
    @IBOutlet weak var ivItem1: UIImageView!
    @IBOutlet weak var ivItem2: UIImageView!
    @IBOutlet weak var ivItem3: UIImageView!
    @IBOutlet weak var ivItem4: UIImageView!
    @IBOutlet weak var ivItem5: UIImageView!
    @IBOutlet weak var ivItem6: UIImageView!
    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "ChampController", sender: self)
    }
    @IBOutlet weak var tvTipsFightingHim: UITextView!
    @IBOutlet weak var tvTipsAgains: UITextView!
    @IBOutlet weak var tvLore: UITextView!
    @IBOutlet weak var lblChampName: UILabel!
    @IBOutlet weak var lblChampNick: UILabel!
    @IBOutlet weak var btnDisplayChamp: UIButton!
    @IBOutlet weak var tfChampName: UITextField!
    @IBOutlet weak var imageScroll: UIScrollView!
    var imageArray = [UIImage]()
    var setImageArray = [UIImage]()
    var setArray = [String]()
//    var item1: String = ""
//    var item2: String = ""
//    var item3: String = ""
//    var item4: String = ""
//    var item5: String = ""
//    var item6: String = ""
    @IBAction func onButtonPressed(_ sender: Any) {
        imageArray.removeAll()
        if let path = Bundle.main.resourcePath {
            let imagePath = path + "/loading"
            let url = URL(fileURLWithPath: imagePath)
            let fileManager = FileManager.default
            
            let properties = [URLResourceKey.localizedNameKey,
                              URLResourceKey.creationDateKey,
                              URLResourceKey.localizedTypeDescriptionKey]
            do {
                let imageURLs = try fileManager.contentsOfDirectory(at: url as URL, includingPropertiesForKeys: properties, options:FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                //                print("imageURLs: \(imageURLs)")
                for image in imageURLs
                {
                    if(image.absoluteString.range(of: tfChampName.text!) != nil)
                    {
                        let data = NSData(contentsOf: image)
                        let uiImage = UIImage(data: data! as Data)
                        imageArray.append(uiImage!)
                    }
                }
                for i in 0..<imageArray.count
                {
                    
                    let uiImageView = UIImageView()
                    uiImageView.image = self.imageArray[i]
                    let xPosition = self.view.frame.width * CGFloat(i)
                    let width = self.imageScroll.frame.width
                    let height = self.imageScroll.frame.height
                    uiImageView.frame = CGRect(x: xPosition, y: 0, width: width, height: height)
                    self.imageScroll.contentSize.width = self.imageScroll.frame.width * CGFloat(i+1)
                    uiImageView.contentMode = .scaleToFill
                    DispatchQueue.main.async {
                        self.imageScroll.addSubview(uiImageView)
                    }
                    
                }
                
                
                let url = Bundle.main.url(forResource: "championFull", withExtension: "json")!
                do {
                    let jsonData = try Data(contentsOf: url)
                    let json = try JSONSerialization.jsonObject(with: jsonData) as! [String:Any]
                    
                    
                    let champions = json["data"] as! [String: [String:Any]]
                    
                    for (key, champion) in champions {
                        let champPassive = champion["passive"] as! NSDictionary
                        if(tfChampName.text! == champion["name"] as! String){
                            let championName = champion["name"] as! String
                            lblChampName.text! = championName
                            lblChampNick.text! = champion["title"] as! String
                            tvLore.text! = champion["lore"] as! String
                            tvLore.text.replacingOccurrences(of: "<br>", with: " ")
                            let tipsPlaying = champion["allytips"] as! NSArray
                            let tipsFighting = champion["enemytips"] as! NSArray
                            tvTipsAgains.text = ""
                            for i in 0..<tipsPlaying.count
                            {
                                tvTipsAgains.text.append(tipsPlaying[i] as! String + " ")
                            }
                            tvTipsFightingHim.text = ""
                            for i in 0..<tipsFighting.count
                            {
                                tvTipsFightingHim.text.append(tipsFighting[i] as! String + " ")
                            }
                        }
                    }
                    if(tfChampName.text! == "Aatrox")
                    {
                        let ref = Database.database().reference()
                        ref.child("aatrox/item1").observeSingleEvent(of: .value){(item1) in
                            self.setArray.append((item1.value as? String)!)
                            print(item1.value)
                        }
                        ref.child("aatrox/item2").observeSingleEvent(of: .value){(item2) in
                            self.setArray.append((item2.value as? String)!)
                            print(item2.value)
                        }
                        ref.child("aatrox/item3").observeSingleEvent(of: .value){(item3) in
                            self.setArray.append((item3.value as? String)!)
                            print(item3.value)
                        }
                        ref.child("aatrox/item4").observeSingleEvent(of: .value){(item4) in
                            self.setArray.append((item4.value as? String)!)
                            print(item4.value)
                        }
                        ref.child("aatrox/item5").observeSingleEvent(of: .value){(item5) in
                            self.setArray.append((item5.value as? String)!)
                            print(item5.value)
                        }
                        ref.child("aatrox/item6").observeSingleEvent(of: .value){(item6) in
                            self.setArray.append((item6.value as? String)!)
                            print(item6.value)
                        }
                        if let path = Bundle.main.resourcePath {
                            let imagePath = path + "/item"
                            let url = URL(fileURLWithPath: imagePath)
                            let fileManager = FileManager.default
                            
                            let properties = [URLResourceKey.localizedNameKey,
                                              URLResourceKey.creationDateKey,
                                              URLResourceKey.localizedTypeDescriptionKey]
                            do {
                                
                                let imageSetURLs = try fileManager.contentsOfDirectory(at: url as URL, includingPropertiesForKeys: properties, options:FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                                print(setArray)
                                for imageSet in imageSetURLs
                                {
                                    for i in 0..<setArray.count{
                                        print("This is the first item: " + setArray[i])
                                        if(imageSet.absoluteString.range(of: setArray[i]) != nil)
                                        {
                                            let dataSet = NSData(contentsOf: imageSet)
                                            let uiImageSet = UIImage(data: dataSet! as Data)
                                            print(uiImageSet)
                                            setImageArray.append(uiImageSet!)
                                            
                                        }
                                    }
                                }
//                                print(setImageArray)
//                                DispatchQueue.main.async
//                                    {
//                                        self.ivItem1.image = self.setImageArray[0]
//                                        self.ivItem2.image = self.setImageArray[1]
//                                        self.ivItem3.image = self.setImageArray[2]
//                                        self.ivItem4.image = self.setImageArray[3]
//                                        self.ivItem5.image = self.setImageArray[4]
//                                        self.ivItem6.image = self.setImageArray[5]
//                                }
                            }
                        }
                        else{
                            print("no return path working")
                        }
                    }
                }
                catch {
                    print(error)
                }
                
                
            } catch let error as NSError {
                print(error.description)
            }
            
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("The Name is " + newName)
        let background = #imageLiteral(resourceName: "bg-default-third")
        self.view.backgroundColor = UIColor(patternImage: background)
        
        
        let ref = Database.database().reference()
        ref.child("aatrox/item1").observeSingleEvent(of: .value){(snapshot) in
            print(snapshot.value)
        }
//        button = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        button.setTitle("Champions", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        self.view.addSubview(button)
//
//        print(button.frame)
//
////        button.centerYAnchor.constraint(equalTo: btnDisplayChamp.centerYAnchor).isActive = true
//        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
////
//        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        
//        // Do any additional setup after loading the view.
//
//        button.dropView.dropDownOptions = ["Amumu", "Rengar"]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//protocol dropDownProtocol {
//    func dropDownPressed(string: String)
//}
//
//class dropDownBtn: UIButton, dropDownProtocol{
//    func dropDownPressed(string: String) {
//        self.setTitle(string, for: .normal)
//        self.dismissDropDown()
//    }
//
//    var dropView = dropDownView()
//
//    var height = NSLayoutConstraint()
//
//    func dismissDropDown() {
//        isOpen = false
//
//        NSLayoutConstraint.deactivate([self.height])
//        self.height.constant = 0
//        NSLayoutConstraint.activate([self.height])
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations:
//            {
//                self.dropView.center.y -= self.dropView.frame.height / 2
//                self.dropView.layoutIfNeeded()
//
//        }, completion: nil)
//    }
//
//
//    override init(frame: CGRect)
//    {
//        super.init(frame:frame)
//        self.backgroundColor = UIColor.darkGray
////        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
//        dropView.delegate = self
//
//        dropView.translatesAutoresizingMaskIntoConstraints = false
//
//
//
//
//    }
//
//    override func didMoveToSuperview() {
//        self.superview?.addSubview(dropView)
//        self.superview?.bringSubview(toFront: dropView)
//        dropView.topAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
//        dropView.centerXAnchor.constraint(equalTo:self.centerXAnchor).isActive = true
//        dropView.widthAnchor.constraint(equalTo:self.widthAnchor).isActive = true
//        height = dropView.heightAnchor.constraint(equalToConstant: 0)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    var isOpen = false
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if isOpen == false{
//
//            isOpen = true
//
//            NSLayoutConstraint.deactivate([self.height])
//
//
//            if self.dropView.tableView.contentSize.height > 150 {
//                self.height.constant = 150
//            } else {
//                self.height.constant = self.dropView.tableView.contentSize.height
//            }
//
//
//
//            NSLayoutConstraint.activate([self.height])
//
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations:
//            {
//                self.dropView.layoutIfNeeded()
//                self.dropView.center.y += self.dropView.frame.height / 2
//
//            }, completion: nil)
//            self.dropView.layoutIfNeeded()
//            self.dropView.center.y += self.dropView.frame.height / 2
//
//        } else {
//            isOpen = false
//
//            NSLayoutConstraint.deactivate([self.height])
//            self.height.constant = 0
//            NSLayoutConstraint.activate([self.height])
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations:
//                {
//                    self.dropView.center.y -= self.dropView.frame.height / 2
//                    self.dropView.layoutIfNeeded()
//
//            }, completion: nil)
//    }
//
//}
//
//
//
//class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource
//{
//
//    var tableView = UITableView()
//
//    var delegate: dropDownProtocol!
//
//    var dropDownOptions = [String]()
//    override init(frame: CGRect) {
//        super.init(frame:frame)
//
//        tableView.backgroundColor = UIColor.darkGray
//        self.backgroundColor = UIColor.darkGray
//
//
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//
//        self.addSubview(tableView)
//        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
//        return dropDownOptions.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = UITableViewCell()
//        cell.textLabel?.text = dropDownOptions[indexPath.row]
//        cell.backgroundColor = UIColor.darkGray
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
//        self.tableView.deselectRow(at: indexPath, animated: true)
//        ChampionController().onButtonPressed((Any).self, name: dropDownOptions[indexPath.row])
//    }
//}
//
//}

//}

