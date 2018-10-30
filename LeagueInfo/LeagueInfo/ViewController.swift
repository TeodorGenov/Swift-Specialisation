//
//  ViewController.swift
//  testJsonDecoder
//
//  Created by issd on 17/09/2018.
//  Copyright © 2018 issd. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseDatabase
import KeychainAccess

class Matches: Codable{
    let matches: [Match]
    init(matches: [Match])
    {
        self.matches = matches
    }
}

class Identities: Codable{
    let identities: [ParticipantIdentity]
    init(Identities: [ParticipantIdentity])
    {
        self.identities = Identities
    }
}

struct Summoner {
    let id: Int
    let name: String
    let profileIconId: Int
    let summonerLevel: Int
    
    init(json: [String: Any]){
        id = json["accountId"] as? Int ?? -1
        name = json["name"] as? String ?? ""
        profileIconId = json["profileIconId"] as? Int ?? -1
        summonerLevel = json["summonerLevel"] as? Int ?? -1
    }
}



struct Participant: Codable {
    let platformId: String
    let accountId : Int
    let summonerName: String
    let summonerId: Int
    let currentPlatFormId: String
    let currentAccountId: Int
    let matchHistoryUri: String
    let profileIcon: Int
    
    init(json: [String: Any]){
        platformId = json["platformId"] as? String ?? ""
        accountId = json["accountId"] as? Int ?? -1
        summonerName = json["summonerName"] as? String ?? ""
        summonerId = json["summonerId"] as? Int ?? -1
        currentPlatFormId = json["currentPlatformId"] as? String ?? ""
        currentAccountId = json["currentAccountId"] as? Int ?? -1
        matchHistoryUri = json["matchHistoryUri"] as? String ?? ""
        profileIcon = json["profileIcon"] as? Int ?? -1
    }
}
struct ParticipantIdentity : Codable{
    let _participantIdentity : participantIdentity
    init(json: [String: Any]){
        _participantIdentity = (json["participantIdentities"] as? participantIdentity ?? nil)!
    }
}


struct participantIdentity : Codable{
    let participantId : Int
    let participant : Participant
    init(json: [String: Any])
    {
        participantId = json["participantId"] as? Int ?? -1
        participant = (json["player"] as? Participant ?? nil)!
    }
}

struct Match : Codable{
    let lane: String
    let gameId: Int
    let champion: Int
    let platformId: String
    let timestamp: Int
    let queue: Int
    let role: String
    let season: Int
    
    init(json: [String: Any]){
        lane = json["lane"] as? String ?? ""
        gameId = json["gameId"] as? Int ?? -1
        champion = json["champion"] as? Int ?? -1
        timestamp = json["timestamp"] as? Int ?? -1
        platformId = json["platformId"] as? String ?? ""
        queue = json["queue"] as? Int ?? -1
        role = json["role"] as? String ?? ""
        season = json["season"] as? Int ?? -1
    }
}

class EntryViewController: UIViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewController{
            DispatchQueue.global().async{
                do {
                    let userName = try self.keychain
                        .authenticationPrompt("Authentication to log in")
                        .get("userName")
                    print(userName)
                    vc.name = "\(userName!)"
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
    @IBOutlet weak var btnRememberName: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBAction func rememberLogin(_ sender: Any) {
        DispatchQueue.global().async{
            do{
                try self.keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .set(self.tfName.text!, key: "userName")
                print(self.tfName.text!)
                
            } catch let error {
                print(error)
            }
        }
    }
    @IBOutlet weak var imgLolLoo: UIImageView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBAction func newLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "ViewController", sender: self)
    }
    @IBAction func action(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "League Info"
        content.subtitle = "Daily Missions"
        content.body = "Hey! Don't forget to do your daily missions!"
        content.badge = 1
        var date = DateComponents()
        date.hour = 9
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        
        let request = UNNotificationRequest(identifier: "timer done", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    @IBOutlet weak var tfName: UITextField!
//    func onButtonPressed(_ sender: Any) {
//        self.performSegue(withIdentifier: "ViewController", sender: self)
//    }
    let keychain = Keychain(service: "issd.LeagueInfo")
        
    
    
    override func viewDidLoad() {
        let backGroundImage = #imageLiteral(resourceName: "bg-default")
        self.view.backgroundColor = UIColor(patternImage: backGroundImage)
//        let lolUrl = "https://eun1.api.riotgames.com/lol/summoner/v3/summoners/by-name/" + thisName + "?api_key=RGAPI-608890c2-ee6a-4960-b606-fec7952b6843"
        imgLolLoo.image = #imageLiteral(resourceName: "kisspng-league-of-legends-logo-riot-games-font-brand-23-super-cool-facts-you-may-not-know-about-league-5b67bc6ecaae10.8393910715335251028302")
        
        if(biometricType == .touchID)
        {
            self.btnLogin.setBackgroundImage(#imageLiteral(resourceName: "TouchID"), for: .normal)
        }
        else if(biometricType == .faceID)
        {
            self.btnLogin.setBackgroundImage(#imageLiteral(resourceName: "faceid-1"), for: .normal)
        }
        else if(biometricType == .none)
        {
            btnLogin.isHidden = true
            btnRememberName.isHidden = true
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        
        
        
    
    }
    
}


//class TableViewController: UITableViewController,{
//    var name = ""
//    @IBOutlet var tableViewChampions: UITableView!
//    override func viewDidLoad() {
//
//
//}



class ViewController: UIViewController, UITableViewDataSource {
    
    @IBAction func showMatchInfo(_ sender: Any) {
        performSegue(withIdentifier: "showMatchInfo", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    var strDate: String = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MathInfoController{
            vc.matchDate = strDate
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell()
        myCell.backgroundColor = UIColor.init(red: 3, green: 32, blue: 52, alpha: 0)
        myCell.textLabel?.font = UIFont (name: "Beaufort-Regular", size: 17)
        myCell.textLabel?.textColor = UIColor.init(red: 212, green: 184, blue: 132, alpha: 1)
        var myPicture = UIImage(named: "coming_soon")
        myCell.imageView?.image = myPicture
        myCell.selectionStyle = UITableViewCellSelectionStyle.gray
//        let lolUrlHistory = "https://eun1.api.riotgames.com/lol/match/v3/matchlists/by-account/" + somename + "?api_key=RGAPI-28eb2c5d-10b2-4c06-a692-5bfddb46c423"
        let lolUrlHistory = "https://eun1.api.riotgames.com/lol/match/v3/matchlists/by-account/33248469?api_key=RGAPI-1e20eb4f-0ea3-4266-99b2-17d7647f3f37"
        let urlHistory = URL(string: lolUrlHistory)
        //        guard let url = URL(string: lolUrl) else {return}
        
        URLSession.shared.dataTask(with: urlHistory!){(data, response, error) in
            guard let data = data else {return}
            do
            {
                //                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
                let decoder = JSONDecoder()
                let matches = try decoder.decode(Matches.self, from: data)
                let timestamp = matches.matches[indexPath.row].timestamp
                let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
                self.strDate = dateFormatter.string(from: date)
                DispatchQueue.main.async{
                    myCell.textLabel?.text = self.strDate
                }
//                let urlPicture = URL(string: "https://eun1.api.riotgames.com/lol/match/v3/matches/" + String(matches.matches[indexPath.row].gameId) + "?api_key=RGAPI-1e20eb4f-0ea3-4266-99b2-17d7647f3f37")
//                URLSession.shared.dataTask(with:urlPicture!){(data, response, error) in
//                    guard let data = data else {return}
//                    do
//                    {
//                        guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
//                        let match = Match(json: json)
//                        let champion = match.champion
//                    }
//                    catch let jsonErr
//                    {
//                        print(jsonErr)
//                    }
//                }
                
            } catch let jsonErr{
                print(jsonErr)
            }
            }.resume()
//        myCell.textLabel?.text = "does it work now?"
        return myCell
    }
    
    func tableView(_ tableViewl: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("click")
        performSegue(withIdentifier: "showMatchInfo", sender: self)
    }
    
    
    var name: String = ""
    var thisName: String = ""
    @IBAction func showChamps(_ sender: Any) {
//        self.performSegue(withIdentifier: "ChampName", sender: self)
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? ChampionController {
//            vc.newName = name
//        }
//    }
    @IBOutlet var viewController: UIView!
    @IBOutlet weak var profileIMage: UIImageView!
    @IBOutlet weak var tableViewChampions: UITableView!
    @IBOutlet weak var tvName: UITextView!
    @IBOutlet weak var tvLevel: UITextView!
    @IBAction func showHistory(_ sender: Any) {
        self.performSegue(withIdentifier: "TableViewController", sender: self)
        
    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "TableViewController"){
//            let vc = segue.destination as! TableViewController
//            vc.name = self.name
//        }
//
//    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let backGroundImage = #imageLiteral(resourceName: "bg-default-Second-Scree")
        self.view.backgroundColor = UIColor(patternImage: backGroundImage)
//        self.viewController.backgroundColor = UIColor(displayP3Red: 8, green: 23, blue: 70, alpha: 0)
        _ = String(33248469)
        let lolUrl = "https://eun1.api.riotgames.com/lol/summoner/v3/summoners/by-name/xXRamseyXx?api_key=RGAPI-1e20eb4f-0ea3-4266-99b2-17d7647f3f37"
        guard let url = URL(string: lolUrl) else {return}
        
 
    
        
        //Api request for displaying the name, picture and level
        let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) {
            timer in
            let dataTask = URLSession.shared.dataTask(with: url) { ( data, response, error) in
                guard let data = data else {return}
    
                //            let dataAsString = String(data: data, encoding: .utf8)
                //            print(dataAsString)
    
                do{
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return}
                    let summoner = Summoner(json: json)
                    let summonerIcon = "https://ddragon.leagueoflegends.com/cdn/6.24.1/img/profileicon/" + String(summoner.profileIconId) + ".png"
                    DispatchQueue.main.async {
                    self.load_image(image_url_string:summonerIcon)
                    self.tvName.text = summoner.name
                    self.tvLevel.text = String(summoner.summonerLevel)
                }

            } catch let jsonErr{
                print("something went wrong")
            }
            }
            dataTask.resume()
        }
        timer.fire()
        // Do any additional setup after loading the view, typically from a ni
}
    
    
    
    
    func load_image(image_url_string: String)
    {
        if let url = NSURL(string: image_url_string)
        {
            if let data = NSData(contentsOf: url as URL)
            {
                profileIMage.contentMode = UIViewContentMode.scaleAspectFit
                profileIMage.image = UIImage(data: data as Data)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getChampion(gameId: Int)
    {
        let gameId = gameId
        
    }
    
}


