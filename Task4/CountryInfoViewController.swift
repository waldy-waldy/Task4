//
//  CountryInfoViewController.swift
//  Task4
//
//  Created by neoviso on 8/9/21.
//

import UIKit
import WebKit

class CountryInfoViewController: UIViewController {
    
    var countryName: String = "Empty"
    @IBOutlet weak var countryWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let countryNameForRequest = "https://en.wikipedia.org/wiki/" + countryName.replacingOccurrences(of: " ", with: "_")
        countryWebView.load(URLRequest(url: URL(string: countryNameForRequest)!))
    }
}
