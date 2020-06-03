//
//  ViewController.swift
//  RandomUser
//
//  Created by guowei on 2019/11/1.
//  Copyright © 2019 guowei. All rights reserved.
//

import UIKit
import AudioToolbox

struct User{
    var name:String?
    var email:String?
    var number:String?
    var image:String?
}

struct AllData:Decodable {
    var results: [SingleData]?
}

struct SingleData:Decodable {
    var name: Name?
    var email:String?
    var phone:String?
    var picture:Picture?
}

struct Name:Decodable{
    var first:String?
    var last:String?
}

struct Picture:Decodable {
    var large:String?
}

class ViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    var infoTableViewController:InfoTableViewController?
    let apiAddress = "https://randomuser.me/api/"
    var urlSession = URLSession(configuration: .default)
    var isDownloading = false
    
    @IBAction func makeNewUser(_ sender: UIBarButtonItem) {
        if isDownloading == false{
            downloadInfo(withAddress: apiAddress)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //change navigation bar color
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.67, green: 0.2, blue: 0.157, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        //let aUser = User(name: "Wei Wei", email: "weiwei@yahoo.com", number: "888-8888", image: "http://picture.me")
        //settingInfo(user: aUser)
        
        downloadInfo(withAddress: apiAddress)
    }
    
    func downloadInfo(withAddress webAddress:String){
        if let url = URL(string: webAddress){
            let task = urlSession.dataTask(with: url, completionHandler: {
                (data, response, error) in
                if error != nil{
                    let errorCode = (error! as NSError).code
                    if errorCode == -1009{
                        DispatchQueue.main.async {
                            self.popAlert(withTitle: "No Internet Connection")
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.popAlert(withTitle: "Sorry")
                        }
                    }
                    self.isDownloading = false
                    return
                }
                if let loadedData = data{
                    do{
                        let okData = try JSONDecoder().decode(AllData.self, from: loadedData)
                        let firstName = okData.results?[0].name?.first
                        let lastName = okData.results?[0].name?.last
                        let fullName: String? = {
                            guard let okFirstName = firstName, let okLastName = lastName else{ return nil }
                            return okFirstName + " " + okLastName
                        }()
                        let email = okData.results?[0].email
                        let phone = okData.results?[0].phone
                        let picture = okData.results?[0].picture?.large
                        let aUser = User(name: fullName, email: email, number: phone, image: picture)
                        DispatchQueue.main.async {
                            self.settingInfo(user: aUser)
                        }
                        
                    }catch{
                        DispatchQueue.main.async {
                            self.popAlert(withTitle: "Sorry")
                        }
                        self.isDownloading = false
                    }
                    
                }else{
                    self.isDownloading = false
                }
            })
            task.resume()
            isDownloading = true
        }
    }
    
    func parseJson(json: Any){
        if let okJson = json as? [String:Any]{
            if let infoArray = okJson["results"] as? [[String:Any]]{
                let infoDictionary = infoArray[0]
                let loadedName = userFullName(nameDictionary: infoDictionary["name"])
                let loadedEmail = infoDictionary["email"] as? String
                let loadedPhone = infoDictionary["phone"] as? String
                let imageDictionary = infoDictionary["picture"] as? [String:String]
                let loadedImageAddress = imageDictionary?["large"]
                let loadedUser = User(name: loadedName, email: loadedEmail, number: loadedPhone, image: loadedImageAddress)
                settingInfo(user: loadedUser)
            }
        }
    }
    
    func userFullName(nameDictionary: Any?) -> String?{
        if let okDictionary = nameDictionary as? [String:String]{
            let firstName = okDictionary["first"] ?? ""
            let lastName = okDictionary["last"] ?? ""
            return firstName + " " + lastName
        }else{
            return nil
        }
    }
    
    func popAlert(withTitle title:String){
        let alert = UIAlertController(title: title, message: "Please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func settingInfo(user:User){
        userName.text = user.name
        infoTableViewController?.phoneLabel.text = user.number
        infoTableViewController?.emailLabel.text = user.email
        if let imageAddress = user.image{
            if let imageURL = URL(string: imageAddress){
                let task = urlSession.downloadTask(with: imageURL, completionHandler: {
                    (url, response, error) in
                    if error != nil{
                        DispatchQueue.main.async {
                            self.popAlert(withTitle: "Sorry")
                        }
                        self.isDownloading = false
                        return
                    }
                    
                    if let okURL = url{
                        do{
                            let downloadImage = UIImage(data: try Data(contentsOf: okURL))
                            DispatchQueue.main.async {
                                self.userImage.image = downloadImage
                                AudioServicesPlaySystemSound(1000)
                            }
                            self.isDownloading = false
                        }catch{
                            DispatchQueue.main.async {
                                self.popAlert(withTitle: "Sorry")
                            }
                            self.isDownloading = false
                        }
                        
                    }else{
                        self.isDownloading = false
                    }
                })
                task.resume()
            }else{
                isDownloading = false
            }
        }else{
            isDownloading = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreinfo"{
            infoTableViewController = segue.destination as? InfoTableViewController
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //make user image circle
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

