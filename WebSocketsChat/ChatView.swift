import SwiftUI

enum ConnectionStatus {
    case disconnected
    case connected
    case lost
    
    func getColor() -> Color {
        switch self {
        case .connected:
            return Color.green
        case .disconnected:
            return Color.red
        case .lost:
            return Color.yellow
        }
    }
    
    func getDescription() -> String {
        switch self {
        case .connected:
            return "Connected"
        case .disconnected:
            return "Disconnected"
        case .lost:
            return "Reconnecting..."
        }
    }
}

struct ChatView: View {
    @State private var messageText = ""
    @ObservedObject var webSocketManager: WebSocketManager

    var body: some View {
        VStack {
            HStack {
                Text("Status: \(webSocketManager.connectionStatus.getDescription())")
                Spacer()
                Circle()
                    .frame(width: 25, height: 25)
                    .foregroundColor(webSocketManager.connectionStatus.getColor())
            }.padding()
            
            List(webSocketManager.messages, id: \.self, rowContent: Text.init)
                .padding()

            HStack {
                TextField("Type your message...", text: $messageText)
                    .padding()

                Button(action: sendMessage) {
                    Text("Send")
                }
            }
            .padding()
        }
    }

    func sendMessage() {
        let message = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty else {
            return
        }

        webSocketManager.sendMessage(message)
        messageText = ""
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(webSocketManager: WebSocketManager())
    }
}
