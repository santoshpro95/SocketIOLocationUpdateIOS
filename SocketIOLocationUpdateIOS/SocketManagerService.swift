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
        manager = SocketManager(socketURL: URL(string: "http://192.168.1.103:3003")!, config: [
            .log(true),
            .reconnects(true),
            .reconnectWait(10),
            .reconnectAttempts(5)
        ])
        socket = manager.defaultSocket
    }
    
    func connect() {
        socket.on(clientEvent: .connect) { (data, ack) in
            print("Socket connected!")
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("Socket disconnected, trying to reconnect...")
            self.reconnect()
        }
        
        // Add other event listeners if needed.
        socket.on("message") { (data, ack) in
            print("Received event: \(data)")
        }
        
        socket.connect()
    }
    
    func reconnect() {
          if socket.status != .connected {
              socket.connect()
          }
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

