//
//  ViewController.swift
//  weather_forecast_app
//
//  Created by Nare Hovhannisyan on 10/31/17.
//  Copyright © 2017 Nare Hovhannisyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func checkWeather(_ sender: Any)
    {
        
        var message = ""
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + userTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest")
        {
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest)
            {
                data, response, error in
                
                if error != nil
                {
                    message = "Sorry, there was an error, please try again"
                } else
                {
                    if let unwrappedData = data
                    {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        var stringSeperator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeperator)
                        {
                            if contentArray.count > 1
                            {
                                stringSeperator = "</span>"
                                
                                let newContentArray = contentArray[1].components(separatedBy: stringSeperator)
                                if newContentArray.count > 0
                                {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg", with: "°")
                                }
                            }
                        }
                    }
                    
                    if message == ""
                    {
                        message = "Sorry, the weather there could not be found"
                    }
                    
                    DispatchQueue.main.sync {
                        self.resultLabel.text = message
                    }
                }
            }
            task.resume()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userTextField.resignFirstResponder()
        return true
    }

}

