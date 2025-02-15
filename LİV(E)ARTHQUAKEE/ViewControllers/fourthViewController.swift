//
//  fourthViewController.swift
//  LİV(E)ARTHQUAKEE
//
//  Created by Mehmet Dora on 22.05.2023.
//

import UIKit

class fourthViewController: UIViewController {

    
    @IBOutlet weak var selectButtonn: UIButton!
    @IBOutlet var days: [UIButton]!
    var CountofDays = 2
    
    @IBOutlet weak var soru1Label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        selectButtonn.titleLabel?.text = "         \(CountofDays)"
        selectButtonn.layer.cornerRadius = 15
        days.forEach { btn in
            btn.layer.cornerRadius = 15
            btn.isHidden = true
            btn.alpha = 0
            
        }

        soru1Label.layer.backgroundColor = CGColor(red: 115.0/255.0, green: 175.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        soru1Label.layer.cornerRadius = 10
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CountofDays != 2{
            selectButtonn.titleLabel?.text = "         \(CountofDays)"
        }else{
            selectButtonn.titleLabel?.text = "Default(2)"
        }
        

    }
    
    @IBAction func İnfoButton(_ sender: Any) {
        let alert = UIAlertController(title:"Chose count of days", message: "How many days of data do you want to get ? \nYou can change it.", preferredStyle: .alert)
        let ok  = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        let vc1 = self.tabBarController?.viewControllers![0] as! FirstViewController
        vc1.kaçGünlükVeriÇekilecek = CountofDays
        let vc2 = self.tabBarController?.viewControllers![1] as! secondVC
        vc2.kaçGünlükVeriÇekilecek = CountofDays
        
        print(CountofDays)
        
    }
    
    func selectBarOpenClose(){
        days.forEach{ btn in
            UIView.animate(withDuration: 0.5){
                btn.isHidden = !btn.isHidden
                btn.alpha = btn.alpha == 0 ? 1 : 0
                btn.layoutIfNeeded()
            }
            
        }
    }
  
    
    @IBAction func selectButton(_ sender: Any) {
        selectBarOpenClose()
    }
    
    
    @IBAction func DAYS(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case "1":
            selectButtonn.titleLabel?.text = "1"
            CountofDays = Int((sender.titleLabel?.text)!)!
            selectBarOpenClose()
            
        case "2":
            selectButtonn.titleLabel?.text = "2"
            CountofDays = Int((sender.titleLabel?.text)!)!
            selectBarOpenClose()
            
        case "3":
            selectButtonn.titleLabel?.text = "3"
            CountofDays = Int((sender.titleLabel?.text)!)!
            selectBarOpenClose()
        case "4":
            selectButtonn.titleLabel?.text = "4"
            CountofDays = Int((sender.titleLabel?.text)!)!
            selectBarOpenClose()
            
        case "5":
            selectButtonn.titleLabel?.text = "5"
            CountofDays = Int((sender.titleLabel?.text)!)!
            selectBarOpenClose()
            
        case "6":
            selectButtonn.titleLabel?.text = "6"
            CountofDays = Int((sender.titleLabel?.text)!)!
            selectBarOpenClose()
            
        default:
            selectButtonn.titleLabel?.text = "7"
            CountofDays = Int((sender.titleLabel?.text)!)!
            selectBarOpenClose()
            
        }
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        
        
    }
    

}
