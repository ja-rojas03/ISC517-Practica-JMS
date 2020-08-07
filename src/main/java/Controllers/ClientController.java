package Controllers;

import Utils.WebSocketUtil;
import freemarker.template.Configuration;
import jms.Reciever;
import spark.ModelAndView;
import org.eclipse.jetty.websocket.api.Session;
import spark.Spark;
import spark.template.freemarker.FreeMarkerEngine;
import javax.jms.JMSException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static spark.Spark.webSocket;

public class ClientController {


    public static List<Session> sessions = new ArrayList<>();

    public static void main(String[] args) throws JMSException {

        Configuration configuration = new Configuration(Configuration.getVersion());
        configuration.setClassForTemplateLoading(ClientController.class, "/public");
        FreeMarkerEngine freeMarkerEngine = new FreeMarkerEngine(configuration);

        String cola = "notificacion_sensores";
        webSocket("/sensor_read", WebSocketUtil.class);
        Spark.get("/", (request, response) -> {
            Map<String, Object> attributes = new HashMap<>();
            return new ModelAndView(attributes, "index.ftl");
        }, freeMarkerEngine);
        Reciever consumer = new Reciever(cola);
        consumer.connect();

    }

    public static void sendMessage(String message) {

        for (Session session : sessions) {
            try {
                session.getRemote().sendString(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
