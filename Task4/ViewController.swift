//
//  ViewController.swift
//  Task4
//
//  Created by neoviso on 8/9/21.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var countriesNames: [String] = []
    var countriesFlagsUrl: [String] = []
    var searchUrl =  "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages&indexpageids&titles="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "CountryCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "countryCell")
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        countriesNames.removeAll()
        countriesFlagsUrl.removeAll()
        
        for localeCode in NSLocale.isoCountryCodes {
            let countryNameTemp = getCountryName(countryCode: localeCode)
            let stringUrl = searchUrl + countryNameTemp.replacingOccurrences(of: " ", with: "_")
            countriesNames.append(countryNameTemp)
            takeImageUrl(countryUrl: stringUrl)
            countriesFlagsUrl.append(takeImageUrl(countryUrl: stringUrl))
        }
        
        tableView.reloadData()
    }
    
    func takeImageUrl(countryUrl: String) -> String {
        var imageUrl = String()
        
        let request = AF.request(countryUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        request.responseJSON { response in
            switch response.result {
                case .success(let JSONString):
                    //let data = XMLMapper<SearchSuggestion>().map(XMLString: xmlString)
                    //print(type(of: response.data))
                    let resp = JSONString as! NSDictionary
                    let pageid = (resp.object(forKey: "query")! as! NSDictionary).object(forKey: "pageids")
                    imageUrl = ""
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    imageUrl = ""
            }
        }
        return imageUrl
    }
    
    func getCountryName(countryCode: String) -> String {
        let current = NSLocale.current as NSLocale
        let countryName = current.displayName(forKey: NSLocale.Key.countryCode, value: countryCode)!
        return countryName
    }
    /*
    func getCountryFlag (countryCode: String) -> String {
        return String(String.UnicodeScalarView(
            countryCode.unicodeScalars.compactMap(
                {   UnicodeScalar(127397 + $0.value)    })))
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryCell
        
        cell.countryNameLabel.text = countriesNames[indexPath.row]
        
        //let url = URL(string: countriesFlagsUrl[indexPath.row])!
        //if let data = try? Data(contentsOf: url) {
        //    cell.countryFlagImageView.image = UIImage(data: data)
        //}
        //cell.countryFlagLabel.text = getCountryFlag(countryCode: countriesCodes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCountryInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CountryInfoViewController {
            destination.countryName = countriesNames[(tableView.indexPathForSelectedRow?.row)!]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
}
