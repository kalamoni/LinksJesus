//
//  ViewController.swift
//  LinksJesus
//
//  Created by Mohamed Saeed on 3/18/19.
//  Copyright © 2019 kalamoni. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var filePathLabel: NSTextField!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var youtubeCountLabel: NSTextField!
    @IBOutlet weak var instagramCountLabel: NSTextField!
    @IBOutlet weak var facebookCountLabel: NSTextField!
    @IBOutlet weak var githubCountLabel: NSTextField!
    @IBOutlet weak var wikipediaCountLabel: NSTextField!
    @IBOutlet weak var mediumCountLabel: NSTextField!
    @IBOutlet weak var totalCountLabel: NSTextField!
    
    private var youtubeList: [String] = []
    private var instagramList: [String] = []
    private var facebookList: [String] = []
    private var githubList: [String] = []
    private var wikipediaList: [String] = []
    private var mediumList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filePathLabel.stringValue = ""
        youtubeCountLabel.stringValue = ""
        instagramCountLabel.stringValue = ""
        facebookCountLabel.stringValue = ""
        githubCountLabel.stringValue = ""
        wikipediaCountLabel.stringValue = ""
        mediumCountLabel.stringValue = ""
        totalCountLabel.stringValue = "Total messages: 0"
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func parseJSON(withPath path: URL) {
        progressIndicator.doubleValue = 50
        if let data = try? Data(contentsOf: path), let conversation = try? JSONDecoder().decode(Conversation.self, from: data), let messages = conversation.messages {
            
            youtubeList.removeAll()
            instagramList.removeAll()
            facebookList.removeAll()
            githubList.removeAll()
            wikipediaList.removeAll()
            mediumList.removeAll()
            
            for message in messages {
                if let link = message.share?.link?.lowercased(), link.contains("youtube.com") {
                    youtubeList.append(link)
                }
                if let link = message.content?.lowercased(), link.contains("youtube.com") {
                    youtubeList.append(link)
                }
                
                
                if let link = message.share?.link?.lowercased(), link.contains("instagram.com") {
                    instagramList.append(link)
                }
                if let link = message.content?.lowercased(), link.contains("instagram.com") {
                    instagramList.append(link)
                }
                
                
                if let link = message.share?.link?.lowercased(), link.contains("facebook.com") {
                    facebookList.append(link)
                }
                if let link = message.content?.lowercased(), link.contains("facebook.com") {
                    facebookList.append(link)
                }
                
                
                if let link = message.share?.link?.lowercased(), link.contains("github.com") {
                    githubList.append(link)
                }
                if let link = message.content?.lowercased(), link.contains("github.com") {
                    githubList.append(link)
                }
                
                
                if let link = message.share?.link?.lowercased(), link.contains("wikipedia.com") {
                    wikipediaList.append(link)
                }
                if let link = message.content?.lowercased(), link.contains("wikipedia.com") {
                    wikipediaList.append(link)
                }
                
                
                if let link = message.share?.link?.lowercased(), link.contains("medium.com") {
                    mediumList.append(link)
                }
                if let link = message.content?.lowercased(), link.contains("medium.com") {
                    mediumList.append(link)
                }
                
            }
            
            let count = messages.count
            
            youtubeCountLabel.stringValue = "\(youtubeList.count)"
            instagramCountLabel.stringValue = "\(instagramList.count)"
            facebookCountLabel.stringValue = "\(facebookList.count)"
            githubCountLabel.stringValue = "\(githubList.count)"
            wikipediaCountLabel.stringValue = "\(wikipediaList.count)"
            mediumCountLabel.stringValue = "\(mediumList.count)"
            totalCountLabel.stringValue = "Total messages: \(count)"
            
            progressIndicator.doubleValue = 100
            
        }
        
    }
    
    @IBAction func didPressLoadFile(_ sender: NSButton) {
        let panel = NSOpenPanel()
        panel.title = ""
        panel.showsResizeIndicator = true
        panel.showsHiddenFiles = false
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["json"]
        panel.resolvesAliases = true
        let launcherLogPathWithTilde = "~/Desktop" as NSString
        let expandedLauncherLogPath = launcherLogPathWithTilde.expandingTildeInPath
        panel.directoryURL = NSURL.fileURL(withPath: expandedLauncherLogPath, isDirectory: true)
        
        panel.beginSheetModal(for: self.view.window!) { num in
            if num == NSApplication.ModalResponse.OK {
                if let fileURL = panel.url {
                    self.filePathLabel.stringValue = fileURL.path
                    self.parseJSON(withPath: fileURL)
                }
            } else {
                print("nothing chosen")
            }
        }
        
    }
    
    
    @IBAction func didPressExport(_ sender: NSButton) {
        var fileName = ""
        var selectedList: [String] = []
        
        switch sender.tag {
            
        /// YouTube
        case 1:
            fileName = "youtube-links"
            selectedList = youtubeList
            
        /// Instagram
        case 2:
            fileName = "instagram-links"
            selectedList = instagramList
            
        /// Facebook
        case 3:
            fileName = "facebook-links"
            selectedList = facebookList
            
        /// Github
        case 4:
            fileName = "github-links"
            selectedList = githubList
            
        /// Wikipedia
        case 5:
            fileName = "wikipedia-links"
            selectedList = wikipediaList
            
        /// Medium
        case 6:
            fileName = "medium-links"
            selectedList = mediumList
            
        default:
            fileName = "links"
        }
        
        let panel = NSSavePanel()
        panel.title = ""
        panel.showsResizeIndicator = true
        panel.showsHiddenFiles = false
        panel.canCreateDirectories = false
        panel.allowedFileTypes = ["txt"]
        let launcherLogPathWithTilde = "~/Desktop" as NSString
        let expandedLauncherLogPath = launcherLogPathWithTilde.expandingTildeInPath
        panel.directoryURL = NSURL.fileURL(withPath: expandedLauncherLogPath, isDirectory: true)
        panel.nameFieldStringValue = fileName
        
        panel.beginSheetModal(for: self.view.window!) { (modalResponse) in
            
            if modalResponse == NSApplication.ModalResponse.OK {
                do {
                    if let fileURL = panel.url {
                        var outputText = ""
                        
                        for link in selectedList {
                            outputText.append(contentsOf: "\(link)\n")
                        }
                        try outputText.write(to: fileURL, atomically: true, encoding: .utf8)
                    }
                } catch {
                    print(error)
                }
            }
        }
        
    }
}

