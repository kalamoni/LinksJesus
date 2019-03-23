//
//  Message.swift
//  LinksJesus
//
//  Created by Mohamed Saeed on 3/18/19.
//  Copyright © 2019 kalamoni. All rights reserved.
//

import AppKit

struct Conversation: Codable {
    let participants: [Participant]?
    let messages: [Message]?
    let title: String?
    let isStillParticipant: Bool?
    let threadType: String?
    let threadPath: String?
    
    enum CodingKeys: String, CodingKey {
        case participants = "participants"
        case messages = "messages"
        case title = "title"
        case isStillParticipant = "is_still_participant"
        case threadType = "thread_type"
        case threadPath = "thread_path"
    }
}

struct Message: Codable {
    let senderName: String?
    let timestampMS: Int?
    let content: String?
    let type: String?
    let share: Share?
    
    enum CodingKeys: String, CodingKey {
        case senderName = "sender_name"
        case timestampMS = "timestamp_ms"
        case content = "content"
        case type = "type"
        case share = "share"
    }
}

struct Share: Codable {
    let link: String?
    
    enum CodingKeys: String, CodingKey {
        case link = "link"
    }
}

struct Participant: Codable {
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}
