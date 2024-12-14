//
//  VolumeButtonVC.swift
//  InstaCash_Diagnostics
//
//  Created by Sameer Khan on 23/07/24.
//

import UIKit
import SwiftyJSON
import SwiftGifOrigin
import AVFoundation

import os

class VolumeButtonVC: UIViewController {
    
    @IBOutlet weak var volumeUpImgVW: UIImageView!
    @IBOutlet weak var volumeDownImgVW: UIImageView!
    
    @IBOutlet weak var volumeUpImgGif: UIImageView!
    @IBOutlet weak var volumeDownImgGif: UIImageView!

    var resultJSON = JSON()
    
    var volDown = false
    var volUp = false
    private var audioLevel : Float = 0.0
    var audioSession : AVAudioSession?
    
    var retryIndex = -1
    var isComingFromTestResult = false
    var volumeRetryDiagnosis: ((_ testJSON: JSON) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setStatusBarColor(themeColor: GlobalUtility().AppThemeColor)
        
        self.volumeUpImgGif.loadGif(name: "ring_loader")
        self.volumeDownImgGif.loadGif(name: "ring_loader")
        
        self.listenVolumeButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appDelegate_Obj.orientationLock = .portrait
        
        self.setCustomNavigationBar()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.audioSession?.removeObserver(self, forKeyPath: "outputVolume", context: nil)
        
    }
    
    //MARK: Volume Button Method
    func listenVolumeButton() {
        
        self.audioSession = AVAudioSession.sharedInstance()
        
        do {
            try self.audioSession?.setActive(true, options: [])
            
            //self.audioSession?.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
            
            self.audioSession?.addObserver(self, forKeyPath: "outputVolume", context: nil)
            self.audioLevel = (self.audioSession?.outputVolume ?? 0.0)
            
        } catch {
            print("Error")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
                
        if keyPath == "outputVolume" {
            
            if (self.audioSession?.outputVolume ?? 0.0) > self.audioLevel {
                
                print("Volume up pressed")
                
                self.volumeUpImgVW.image = UIImage(named: "volume_up_green")
                self.volumeUpImgGif.isHidden = true
                self.volUp = true
                
                if (self.volDown == true) {
                    
                    print("Volume test passed")
                    
                    if (AppUserDefaults.value(forKey: "AppResultJSON_Data") != nil) {
                        let resultJson = JSON.init(parseJSON: AppUserDefaults.value(forKey: "AppResultJSON_Data") as! String)
                        self.resultJSON = resultJson
                    }
                    
                    if self.isComingFromTestResult {
                        arrTestsResultJSONInSDK.remove(at: retryIndex)
                        arrTestsResultJSONInSDK.insert(1, at: retryIndex)
                    }
                    else {
                        arrTestsResultJSONInSDK.append(1)
                    }
                    
                    UserDefaults.standard.set(true, forKey: "volume")
                    self.resultJSON["Hardware Buttons"].int = 1
                    
                    AppUserDefaults.setValue(self.resultJSON.rawString(), forKey: "AppResultJSON_Data")
                    DispatchQueue.main.async {
                    if (AppUserDefaults.value(forKey: "AppResultJSON_Data") != nil) {
                        let resultJson = JSON.init(parseJSON: AppUserDefaults.value(forKey: "AppResultJSON_Data") as! String)
                        self.resultJSON = resultJson
                        NSLog("%@%@", "39220iOS@warehouse: ", "\(self.resultJSON)")
                    }
                    else {
                        NSLog("%@%@", "39220iOS@warehouse: ", "\(self.resultJSON)")
                    }
                }
                    
                    if self.isComingFromTestResult {
                        self.navToSummaryPage()
                    }
                    else {
                        self.dismissThisPage()
                    }
                    
                }
                
            }
            
            if (self.audioSession?.outputVolume ?? 0.0) < self.audioLevel {
                
                print("Volume down pressed")
                
                self.volumeDownImgVW.image = UIImage(named: "volume_down_green")
                self.volumeDownImgGif.isHidden = true
                self.volDown = true
                
                if (self.volUp == true) {
                    
                    print("Volume test passed")
                    
                    if (AppUserDefaults.value(forKey: "AppResultJSON_Data") != nil) {
                        let resultJson = JSON.init(parseJSON: AppUserDefaults.value(forKey: "AppResultJSON_Data") as! String)
                        self.resultJSON = resultJson
                    }
                    
                    if self.isComingFromTestResult {
                        arrTestsResultJSONInSDK.remove(at: retryIndex)
                        arrTestsResultJSONInSDK.insert(1, at: retryIndex)
                    }
                    else {
                        arrTestsResultJSONInSDK.append(1)
                    }
                                        
                    UserDefaults.standard.set(true, forKey: "volume")
                    self.resultJSON["Hardware Buttons"].int = 1
                    
                    AppUserDefaults.setValue(self.resultJSON.rawString(), forKey: "AppResultJSON_Data")
                    DispatchQueue.main.async {
                    if (AppUserDefaults.value(forKey: "AppResultJSON_Data") != nil) {
                        let resultJson = JSON.init(parseJSON: AppUserDefaults.value(forKey: "AppResultJSON_Data") as! String)
                        self.resultJSON = resultJson
                        NSLog("%@%@", "39220iOS@warehouse: ", "\(self.resultJSON)")
                    }
                    else {
                        NSLog("%@%@", "39220iOS@warehouse: ", "\(self.resultJSON)")
                    }
                }
                    
                    if self.isComingFromTestResult {
                        self.navToSummaryPage()
                    }
                    else {
                        self.dismissThisPage()
                    }
                }
                
            }
            
            self.audioLevel = (self.audioSession?.outputVolume ?? 0.0)
            print("self.audioSession.outputVolume is:", self.audioSession?.outputVolume ?? 0.0)
            
        }
        
    }
    
    // MARK: IBActions
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        //self.ShowGlobalPopUp()
        
        if (AppUserDefaults.value(forKey: "AppResultJSON_Data") != nil) {
            let resultJson = JSON.init(parseJSON: AppUserDefaults.value(forKey: "AppResultJSON_Data") as! String)
            self.resultJSON = resultJson
        }
        
        if self.isComingFromTestResult {
            arrTestsResultJSONInSDK.remove(at: retryIndex)
            arrTestsResultJSONInSDK.insert(-1, at: retryIndex)
        }
        else {
            arrTestsResultJSONInSDK.append(-1)
        }
        
        UserDefaults.standard.set(false, forKey: "volume")
        self.resultJSON["Hardware Buttons"].int = -1
        
        AppUserDefaults.setValue(self.resultJSON.rawString(), forKey: "AppResultJSON_Data")
        DispatchQueue.main.async {
                    if (AppUserDefaults.value(forKey: "AppResultJSON_Data") != nil) {
                        let resultJson = JSON.init(parseJSON: AppUserDefaults.value(forKey: "AppResultJSON_Data") as! String)
                        self.resultJSON = resultJson
                        NSLog("%@%@", "39220iOS@warehouse: ", "\(self.resultJSON)")
                    }
                    else {
                        NSLog("%@%@", "39220iOS@warehouse: ", "\(self.resultJSON)")
                    }
                }
        
        if self.isComingFromTestResult {
            self.navToSummaryPage()
        }
        else {
            self.dismissThisPage()
        }
        
    }
    
    //MARK: Custom Method
    func setCustomNavigationBar() {
        
        self.navigationController?.navigationBar.barStyle = .default
        //self.navigationController?.navigationBar.barTintColor = UIColor.lightGray
        self.navigationController?.view.tintColor = .black
                
        //self.navigationController?.hidesBarsOnSwipe = true
                
        if self.isComingFromTestResult {
            
        }
        else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backWhite"), style: .plain, target: self, action: #selector(backBtnPressed))
            
            self.title = "\(currentTestIndex)/\(totalTestsCount)"
        }
        
    }
    
    @objc func backBtnPressed() {
        self.dismiss(animated: true, completion: {
            performDiagnostics = nil
        })
    }
    
    func dismissThisPage() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {
            
            self.dismiss(animated: false, completion: {
                guard let didFinishTestDiagnosis = performDiagnostics else { return }
                didFinishTestDiagnosis(self.resultJSON)
            })
            
        })
        
    }
    
    func navToSummaryPage() {
        
        self.dismiss(animated: false, completion: {
            guard let didFinishRetryDiagnosis = self.volumeRetryDiagnosis else { return }
            didFinishRetryDiagnosis(self.resultJSON)
        })
        
    }
    
    func ShowGlobalPopUp() {
        
        let popUpVC = self.storyboard?.instantiateViewController(withIdentifier: "GlobalSkipPopUpVC") as! GlobalSkipPopUpVC
        
        popUpVC.strTitle = "Are you sure?"
        popUpVC.strMessage = "If you skip this test there would be a substantial decline in the price offered."
        popUpVC.strBtnYesTitle = "Skip Test"
        popUpVC.strBtnNoTitle = "Don't Skip"
        popUpVC.strBtnRetryTitle = ""
        popUpVC.isShowThirdBtn = false
        
        popUpVC.userConsent = { btnTag in
            switch btnTag {
            case 1:
                
                print("Hardware Buttons Skipped!")
                
                if (AppUserDefaults.value(forKey: "AppResultJSON_Data") != nil) {
                    let resultJson = JSON.init(parseJSON: AppUserDefaults.value(forKey: "AppResultJSON_Data") as! String)
                    self.resultJSON = resultJson
                }
                
                if self.isComingFromTestResult {
                    arrTestsResultJSONInSDK.remove(at: self.retryIndex)
                    arrTestsResultJSONInSDK.insert(-1, at: self.retryIndex)
                }
                else {
                    arrTestsResultJSONInSDK.append(-1)
                }
                
                UserDefaults.standard.set(false, forKey: "volume")
                self.resultJSON["Hardware Buttons"].int = -1
                
                AppUserDefaults.setValue(self.resultJSON.rawString(), forKey: "AppResultJSON_Data")
                DispatchQueue.main.async {
                    if (AppUserDefaults.value(forKey: "AppResultJSON_Data") != nil) {
                        let resultJson = JSON.init(parseJSON: AppUserDefaults.value(forKey: "AppResultJSON_Data") as! String)
                        self.resultJSON = resultJson
                        NSLog("%@%@", "39220iOS@warehouse: ", "\(self.resultJSON)")
                    }
                    else {
                        NSLog("%@%@", "39220iOS@warehouse: ", "\(self.resultJSON)")
                    }
                }
                
                if self.isComingFromTestResult {
                    self.navToSummaryPage()
                }
                else {
                    self.dismissThisPage()
                }
                
            case 2:
                
                break
                
            default:
                
                break
            }
        }
        
        popUpVC.modalPresentationStyle = .overFullScreen
        self.present(popUpVC, animated: false) { }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
