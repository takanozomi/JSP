package ws;
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/websocketendpoint")
public class WsServer {

    private static Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("Open Connection ...");
        sessions.add(session);
    }

    @OnClose
    public void onClose(Session session) {
        System.out.println("Close Connection ...");
        sessions.remove(session);
    }

    @OnMessage
    public void onTextMessage(String message, Session clientSession) {
        System.out.println("Message from the client: " + message);

        // Broadcast the message to all connected clients
        for (Session session : sessions) {
            try {
                session.getBasicRemote().sendText(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @OnError
    public void onError(Throwable e) {
        e.printStackTrace();
    }
}

