//
//  Socket.swift
//  ARTest2
//
//  Created by MetroStar on 1/20/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

import SocketIO
import ARKit

class Socket: NSObject {
    
    static let sharedInstance:Socket = Socket()
    let manager = SocketManager(socketURL: URL(string: "http://server-scavenger-dev.us-east-1.elasticbeanstalk.com/")!, config: [.log(true), .compress])
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) {data, ack in
            print("Log: socket connected")
        }
        socket.connect()
        CFRunLoopRun()
        listenForOtherMessages()
    }
    
    func closeConnection() {
        let socket = manager.defaultSocket
        socket.disconnect()
        print("Disconnected")
    }
    
    func sendMessage(message: String) {
        let socket = manager.defaultSocket
        socket.emit("message", message)
    }
    
    func getUIState() {
        let socket = manager.defaultSocket
        socket.emit("get_ui_state", "")
    }
    
    func checkIfRegistered(phoneNumber: String) {
        let socket = manager.defaultSocket
        socket.emit("user_exist", phoneNumber)
    }
    
    func sendWinEmit() {
        let socket = manager.defaultSocket
        socket.emit("user", UIDevice.current.name)
    }
    
    func sendDeleteEmit(index: Int) {
        let socket = manager.defaultSocket
        socket.emit("index", index)
    }
    
    func addTargetObject(modelNum: Int, x: Float, y: Float, z: Float) {
        let socket = manager.defaultSocket
        var messageJson:[String: Any] = [:]
        messageJson["modelNum"] = modelNum
        messageJson["x"] = x
        messageJson["y"] = y
        messageJson["z"] = z
        
        socket.emit("appendObject", messageJson)
    }
    
    func sendReadyEmit() {
        let socket = manager.defaultSocket
        var readyJson:[String: Any] = [:]
        readyJson["id"] = UIDevice.current.name
        readyJson["ready"] = true
        socket.emit("ready", readyJson)
    }
    
    func getGameMap() {
        let socket = manager.defaultSocket
        socket.emit("getGameMap", "Foo")
    }
    
    func generateGameMap() {
        let socket = manager.defaultSocket
        socket.emit("generateGameMap", "Fuck You")
    }
    
    
    
    private func listenForOtherMessages() {
        let socket = manager.defaultSocket
        
        socket.on("gameMap") { (dataArray, socketAck) -> Void in
            let myJsonArray:Array<[String: Any]> = dataArray[0] as! Array<[String: Any]>
            
            for index in 0...(myJsonArray.count - 1) {
                let myJson: [String: Any] = myJsonArray[index]
                let toAddNode:SCNNode = SCNNode.buildFromJson(jsonObject: myJson)!
                AppData.nodeDict[index] = toAddNode
            }
            let currentView: UIViewController = AppData.CurrentViewController!
            currentView.performSegue(withIdentifier: "startGame", sender: nil)
            
        }
        
        socket.on("hostObject") { (dataArray, socketAck) -> Void in
            let myJson: [String: Any] = dataArray[0] as! [String: Any]
            let toAddNode:SCNNode = SCNNode.buildFromJson(jsonObject: myJson)!
            let counter = AppData.nodeDict.count
            AppData.nodeDict[counter] = toAddNode
        }
        socket.on("deleteObject") {(dataArray, socketAck) -> Void in
            let index:Int = dataArray[0] as! Int
             AppData.nodeDict[index]?.removeFromParentNode()
        }
        
        socket.on("endGame") { (dataArray, socketAck) -> Void in
            let isGameOver: Bool = dataArray[0] as! Bool
            if (isGameOver) {
                AppData.CurrentViewController?.performSegue(withIdentifier: "moveToResultPage", sender: nil)
            }
            
        }
        
        /*socket.on("questions") { (dataArray, socketAck) -> Void in
            let myJson:[String: AnyObject] = dataArray[0] as! [String: AnyObject]
            let questionsJson:[[String: String]] = myJson["Questions"] as! [[String: String]]
            for i in 0...(questionsJson.count - 1) {
                let currQuestionSet:QuestionSet = QuestionSet.buildFromJson(json: questionsJson[i])
                AppData.questions.append(currQuestionSet)
            }
            
        }
        
        socket.on("ui_state") { (dataArray, socketAck) -> Void in
            
            let myJson:[String: AnyObject] = dataArray[0] as! [String: AnyObject]
            let myState: State = State(rawValue: myJson.keys.first!)!
            
            switch(myState) {
            case .HOME:
                print("Log: We are at Home")
            case .COUNTDOWN:
                print("Log: We are counting down")
            case .HOST:
                print("Log: We are viewing the host")
            case .QUESTION_OPEN:
                print("Log: We are opening the question")
                AppData.CurrentViewController?.performSegue(withIdentifier: "moveToGame", sender: nil)
            case .REWARD:
                print("Log: We are getting our reward")
            }
        }
        
        socket.on("time") { (dataArray, socketAck) -> Void in
            let timeJson: [String: AnyObject] = dataArray[0] as! [String: AnyObject]
            let time: Int64 = timeJson["time"] as! Int64
            print("Log: Time Left: \(time) seconds")
            
        }*/
        
    }
    
}
