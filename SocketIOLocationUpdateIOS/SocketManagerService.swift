//
//  SocketManagerService.swift
//  SocketIOLocationUpdateIOS
//
//  Created by Santosh Kumar on 18/01/25.
//

import Foundation
import SocketIO

class SocketManagerService {
    static let shared = SocketManagerService()
    
    private var manager: SocketManager
    private var socket: SocketIOClient

    private init() {
        manager = SocketManager(socketURL: URL(string: "http://192.168.1.103:3003")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }
    
    func connect() {
        socket.on(clientEvent: .connect) { (data, ack) in
            print("Socket connected!")
        }
        
        socket.on(clientEvent: .disconnect) { (data, ack) in
            print("Socket disconnected!")
        }
        
        // Add other event listeners if needed.
        socket.on("customEvent") { (data, ack) in
            print("Received event: \(data)")
        }
        
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func emit(event: String, data: String) {
        socket.emit(event, data)
    }
    
    func on(event: String, completion: @escaping ([Any], SocketAckEmitter) -> Void) {
        socket.on(event, callback: completion)
    }
}

