//
//  SongListTableViewCellProtocol.swift
//  EvoRadio
//
//  Created by Jarvis on 2019/5/16.
//  Copyright © 2019 JQTech. All rights reserved.
//

import Foundation

protocol SongListTableViewCellDelegate {
    func openToolPanelOfSong(_ song: Song)
}
