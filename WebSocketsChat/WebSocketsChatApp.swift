//
//  WebSocketsChatApp.swift
//  WebSocketsChat
//
//  Created by Bartłomiej Wojsa on 05/10/2023.
//

import SwiftUI

// this app requires to run ws server (look for websocket-host project and run it before running this app !)
@main
struct WebSocketsChatApp: App {
    let webSocketManager = WebSocketManager()

    var body: some Scene {
        WindowGroup {
            ChatView(webSocketManager: webSocketManager)
        }
    }
}
