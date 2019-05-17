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
    @IBOutlet weak var radioProgress: UIProgressView!
    @IBOutlet weak var channelProgress: UIProgressView!
    @IBOutlet weak var programProgress: UIProgressView!
    @IBOutlet weak var songProgress: UIProgressView!
    
    var allRadios: [Radio] = []
    var allChannels: [Channel] = []
    var allPrograms: [String: [Program]] = [:]
    var allSongs: [String: [Song]] = [:]
    var currentItem: ScanItem?
    
    var channelIndex: Int = 0
    var programIndex: Int = 0
    var songIndex: Int = 0
    
    var isFetch: Bool = false
    var isFinished: Bool = false
    var isPause: Bool = true
    
    var displayLink: CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scannerVC = ScannerViewController()
        contentView.addSubview(scannerVC.view)
        
        loadAllChannels()
        
//        channelIndex = 135
//        programIndex = 0
    }
    
    //MARK: - Update console
    func updateRadioProgress(_ progress: Float=0, text: String) {
        DispatchQueue.main.async {[weak self] in
            self?.radioLabel.text = text
        }
    }
    
    func updateChannelProgress(_ progress: Float=0, text: String) {
        DispatchQueue.main.async {[weak self] in
            self?.channelLabel.text = text
            self?.channelProgress.progress = progress
        }
    }
    
    func updateProgramProgress(_ progress: Float=0, text: String) {
        DispatchQueue.main.async {[weak self] in
            self?.programLabel.text = text
            self?.programProgress.progress = progress
        }
    }
    
    func updateSongProgress(_ progress: Float=0, text: String) {
        DispatchQueue.main.async {[weak self] in
            self?.songLabel.text = text
            self?.songProgress.progress = progress
        }
    }
    
    
    //MARK: - Event Actions
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(onTimer))
            displayLink!.preferredFramesPerSecond = 10
            displayLink!.add(to: RunLoop.main, forMode: .common)
        }
        isPause = false
    }
    
    @IBAction func puaseButtonPressed(_ sender: UIButton) {
        isPause = true
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        isPause = true
        isFetch = false
        
        if let dl = displayLink {
            dl.invalidate()
            displayLink = nil
        }
    }
    
    @objc func onTimer() {
        print("indeies: \(channelIndex) \(programIndex) \(songIndex)")
        loop()
    }
    
    //MARK: - Fetch data from lavaradio
    func loadAllChannels() {
        api.fetch_all_channels({[weak self] (radios) in
            self?.allRadios.removeAll()
            self?.allRadios.append(contentsOf: radios)
            
            DispatchQueue.global().async {
                self?.allChannels.removeAll()
                radios.forEach({ (radio) in
                    if let id = radio.radioId, let name = radio.radioName {
                        self?.updateRadioProgress(text: String(format: "%d %@", id, name))
                    }
                    
                    // save radios
//                    let lcRadio = LCRadio(radio: radio)
//                    lcRadio.saveIfNeed()
                    
                    // channel
                    if let channels = radio.channels {
                        self?.allChannels.append(contentsOf: channels)
                        
//                        channels.forEach({ (channel) in
//                            if let id = channel.channelId, let name = channel.channelName {
//                                self?.updateChannelText(String(format: "%@ %@", id, name))
//                            }
//                            // save channels
//                            let lcChannel = LCChannel(channel: channel)
//                            lcChannel.saveIfNeed()
                        
//                            // program
//                            if let channelId = channel.channelId {
//                                api.fetch_programs(channelId, page: Page(index: 0, size: 500), onSuccess: { (programs) in
//                                    self?.currentPrograms = programs
//                                    programs.forEach({ (program) in
//                                        if let id = channel.channelId, let name = channel.channelName {
//                                            self?.updateProgramText(String(format: "%@ %@", id, name))
//                                        }
//                                        // save programs
//                                        let lcProgram = LCProgram(program: program)
//                                        lcProgram.saveIfNeed()
//                                    })
//
//                                }, onFailed: { (error) in
//                                    print("fetch programs failed: \(error)")
//                                })
//                            }
//                        })
                    }
                })
            }
            
            }, onFailed: nil)
        
    }
    
    func loop() {
        if isFetch || isFinished || isPause {return}
        isFetch = true
        let channel = allChannels[channelIndex]
        if let id = channel.radioId, let name = channel.radioName {
            updateRadioProgress(text: String(format: "%@ %@", id, name))
            
        }
        if let id = channel.channelId, let name = channel.channelName {
            let progress = Float(channelIndex+1) / Float(allChannels.count)
            updateChannelProgress(progress, text: String(format: "%@ %@", id, name))
            
        }
        
        // fetch programs
        if let channelId = channel.channelId {
            loadPrograms(channelId: channelId) {[weak self] (programs) in
                if let programs = programs {
                    if programs.count > 0 {
                        let program = programs[(self?.programIndex)!]
                        if let id = program.programId, let name = program.programName {
                            let progress = Float((self?.programIndex)!+1) / Float(programs.count)
                            let text = String(format: "%@ %@", id, name)
                            self?.updateProgramProgress(progress, text: text)
                        }
                        // save program
                        let lcProgram = LCProgram(program: program)
                        lcProgram.saveIfNeed({ (result) in
                            print("save song task result: isSuccess:\(result)")
                            self?.programIndex += 1
                            if (self?.programIndex)! >= programs.count {
                                self?.programIndex = 0
                                self?.channelIndex += 1
                                if (self?.channelIndex)! >= (self?.allChannels.count)! {
                                    self?.isFinished = true
                                    self?.isFetch = false
                                    return
                                }
                            }
                            self?.isFetch = false
                        })
                        
                        return
                        // fetch songs
                        if let programId = program.programId {
                            self?.loadSongs(programId: programId, completion: { (songs) in
                                if let songs = songs {
                                    if songs.count > 0 {
                                        let song = songs[(self?.songIndex)!]
                                        if let id = song.songId, let name = song.songName {
                                            let progress = Float((self?.songIndex)!+1) / Float(songs.count)
                                            let text = String(format: "%@ %@", id, name)
                                            self?.updateSongProgress(progress, text: text)
                                        }
                                        
                                        // save song
                                        let lcSong = LCSong(song: song)
                                        lcSong.saveIfNeed({ (result) in
                                            print("save song task result: isSuccess:\(result)")
                                            self?.songIndex += 1
                                            if (self?.songIndex)! >= songs.count {
                                                self?.programIndex += 1
                                                self?.songIndex = 0
                                                if (self?.programIndex)! >= programs.count {
                                                    self?.channelIndex += 1
                                                    self?.programIndex = 0
                                                    self?.songIndex = 0
                                                    if (self?.channelIndex)! >= (self?.allChannels.count)! {
                                                        self?.isFinished = true
                                                        self?.isFetch = false
                                                        return
                                                    }
                                                }
                                            }
                                            self?.isFetch = false
                                        })
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func loadPrograms(channelId: String, completion: @escaping ([Program]?) -> Void) {
        if let programs = allPrograms[channelId] {
            completion(programs)
        }else {
            api.fetch_programs(channelId, page: Page(index: 0, size: 500), onSuccess: {[weak self] (programs) in
                self?.allPrograms[channelId] = programs
                completion(programs)
            }, onFailed: { (error) in
                print("fetch programs failed: \(error)")
                completion(nil)
            })
        }
    }
    
    func loadSongs(programId: String, completion: @escaping ([Song]?) -> Void) {
        if let songs = allSongs[programId] {
            completion(songs)
        }else {
            api.fetch_songs(programId, isVIP: true, onSuccess: {[weak self] (songs) in
                self?.allSongs[programId] = songs
                completion(songs)
                }, onFailed: { (error) in
                    print("fetch songs failed: \(error)")
                    completion(nil)
            })
        }
    }
    
}

