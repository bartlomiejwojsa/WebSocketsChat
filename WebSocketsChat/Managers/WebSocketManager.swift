import Foundation
import Starscream


class WebSocketManager: WebSocketDelegate, ObservableObject {
    
    @Published var messages: [String] = []
    @Published var connectionStatus: ConnectionStatus = .disconnected
    
    private var connectionRetriesCount: Int = 0
    private var maxRetriesCount: Int = 10
    private var socket: WebSocket?
    private var url = URL(string: "ws://localhost:8080")!
    private var timeout: TimeInterval = 5.0
    

    init() {
        self.estabilishConnection()
    }
    
    private func estabilishConnection () {
        do {
            print("estabilishing...")
            socket = WebSocket(request: URLRequest(url: self.url))
            socket?.delegate = self
            socket?.connect()
        } catch {
            print("err", error)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + self.timeout) {
            if [.disconnected, .lost].contains(self.connectionStatus)
                && self.connectionRetriesCount < self.maxRetriesCount
            {
                self.estabilishConnection()
                self.connectionRetriesCount += 1
            }
        }
    }

    func disconnect() {
        socket?.disconnect()
    }

    func sendMessage(_ message: String) {
        socket?.write(string: message) {
            print("message sent")
        }
    }

    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected:
            print("WebSocket connected")
            self.connectionStatus = .connected
            self.connectionRetriesCount = 0
        case .disconnected(let reason, let code):
            print("WebSocket disconnected with reason: \(reason) and code: \(code)")
        case .text(let text):
            messages.append(text)
        case .ping, .pong, .binary, .pong, .viabilityChanged, .reconnectSuggested, .cancelled:
            break
        case .error(_):
//            print("some error occured", err)
            break
        case .peerClosed:
            print("connection closed...")
            messages.append("Connection with server lost...")
            self.connectionStatus = .lost
            self.estabilishConnection()
        }
    }
}
