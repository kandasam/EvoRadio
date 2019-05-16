//
//  ViewController.swift
//  LavaCrawler
//
//  Created by Jarvis on 2019/5/16.
//  Copyright © 2019 JQTech. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var radioLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    var dataSource = [ScanItem]()
    
    var currentRadios: [Radio]?
    var currentChannels: [Channel]?
    var currentPrograms: [Program]?
    var currentSongs: [Song]?
    var currentItem: ScanItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scannerVC = ScannerViewController()
        contentView.addSubview(scannerVC.view)
    }
    
    //MARK: - Event Actions
    @IBAction func startButtonPressed(_ sender: UIButton) {
        present(ScannerViewController(), animated: true, completion: nil)
    }
    
    @IBAction func puaseButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
    }

    
    //MARK: - Fetch data from lavaradio
    func loadDataSource() {
        api.fetch_all_channels({[weak self] (radios) in
            self?.currentRadios = radios
            
            self?.dataSource.removeAll()
            let items = radios.map{ (radio) -> ScanItem in
                return ScanItem(type: .radio, id: "\(radio.radioId!)", name: radio.radioName!, desc: nil)
            }
            self?.dataSource.append(contentsOf: items)
            
            DispatchQueue.global().async {
                radios.forEach({ (radio) in
                    // save radio
                    let lcRadio = LCRadio(radio: radio)
                    //                    lcRadio.saveIfNeed()
                    
                    // save channels
                    if let channels = radio.channels {
                        channels.forEach({ (channel) in
                            let lcChannel = LCChannel(channel: channel)
                            //                            lcChannel.saveIfNeed()
                        })
                        
                        
                    }
                    
                })
            }
            
            }, onFailed: nil)
        
    }
}

