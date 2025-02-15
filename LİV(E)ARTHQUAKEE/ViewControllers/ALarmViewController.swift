//
//  ALarmViewController.swift
//  LİV(E)ARTHQUAKEE
//
//  Created by Mehmet Dora on 22.05.2023.
//

import UIKit
import AVFoundation

class ALarmViewController: UIViewController {

    @IBOutlet weak var alarm: UILabel!
    @IBOutlet weak var elfeneriLabel: UILabel!
    @IBOutlet weak var başlıkLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.alarm.textColor = .white
        self.elfeneriLabel.textColor = .white
        self.başlıkLabel.textColor = .white


    }
    
    @IBAction func flash_button(_ sender: Any) {
      toggleFlash()
    }
    @IBAction func AlarmButton(_ sender: Any) {
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    func toggleFlash(){
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                
                self.elfeneriLabel.textColor = .white
                device.torchMode = AVCaptureDevice.TorchMode.off
                alarm.textColor = .white
                self.elfeneriLabel.textColor = .white
                self.başlıkLabel.textColor = .white


                self.view.backgroundColor = UIColor(cgColor: CGColor(red: 80.0/255.0, green: 9.0/255.0, blue: 1.0/255.0, alpha: 1.0))
                
            } else {
                do {
                    
                    try device.setTorchModeOn(level: 1.0)
                    self.elfeneriLabel.textColor = .white
                    self.view.backgroundColor = .white
                    alarm.textColor = .black
                    self.elfeneriLabel.textColor = .black
                    self.başlıkLabel.textColor = .black


                    
                } catch {
                    print(error)
                }
            }

            device.unlockForConfiguration()
        } catch {
            print(error)
        }
        
    }
    
}
