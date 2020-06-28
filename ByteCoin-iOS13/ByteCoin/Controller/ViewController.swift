//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UIPickerViewDataSource,UIPickerViewDelegate, coinManagerDelegate{
    func didUpdatePrice(price: String, currency: String) {
        <#code#>
    }
    
    func didFailWithError(error: Error) {
        <#code#>
    }
    
    
    
    var coinManager=CoinManager()
    
    //設定有幾列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //設定列裡面有多少數量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return coinManager.currencyArray.count
     }
    //設定列裡面標題要顯示什麼
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    //挑選選中的
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectCurrency=coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectCurrency)
    }
    

    
    @IBOutlet weak var bitcoinLabel: UILabel!
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //使用代理使viewController可以使用dataSouce
        currencyPicker.dataSource=self
        currencyPicker.delegate=self
        coinManager.delegate=self
      
    }
  
   
   

}

