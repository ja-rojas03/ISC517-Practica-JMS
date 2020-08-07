package Utils;

import Controllers.ClientController;
import org.eclipse.jetty.websocket.api.Session;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketClose;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketConnect;
import org.eclipse.jetty.websocket.api.annotations.WebSocket;

@WebSocket
public class WebSocketUtil {
    @OnWebSocketConnect
    public void addSession(Session session) {
        ClientController.sessions.add(session);
    }

    @OnWebSocketClose
    public void removeSession(Session session, int statusCode, String reason) {
        ClientController.sessions.remove(session);
    }
}
