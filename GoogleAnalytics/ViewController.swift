//
//  ViewController.swift
//  GoogleAnalytics
//
//  Created by kidnapper on 10/04/2018.
//  Copyright © 2018 25sprout.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var startTiming: UIButton!
    @IBOutlet var stopTiming: UIButton!
    @IBOutlet var sendEvent: UIButton!
    
    @IBAction func startTimingAction(_ sender: Any) {
        startReadingTime = Date()
    }
    @IBAction func stopTimingAction(_ sender: Any) {
        recordReadingTime()
    }
    @IBAction func sendEventAction(_ sender: Any) {
        sendEventToGA()
    }
    
    // info for Google analytics
    let name = "testing name"
    let label = "testing label"
    
    // Google analytics
    var startReadingTime: Date!
    var finishReadingTime: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // handle GA when app entering background and active
        NotificationCenter.default.addObserver(self, selector: #selector(recordReadingTime), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recordReadingTime), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc func recordReadingTime() {
        if startReadingTime != nil {
            finishReadingTime = Date()
            let readingTime = (finishReadingTime.timeIntervalSinceNow - startReadingTime.timeIntervalSinceNow) * 1000
            let GAIDic = GAIDictionaryBuilder.createTiming(withCategory: "Reading time for example", interval: Int(readingTime) as NSNumber, name: name, label: label).build() as! [AnyHashable : Any]!
            GAI.sharedInstance().defaultTracker.send(GAIDic)
            startReadingTime = nil
        }
        else {
            startReadingTime = Date()
        }
    }
    
    func sendEventToGA() {
        let GAIDic = GAIDictionaryBuilder.createEvent(withCategory: name, action: "Send", label: label, value: nil).build() as! [AnyHashable : Any]!
        GAI.sharedInstance().defaultTracker.send(GAIDic)
    }


}

