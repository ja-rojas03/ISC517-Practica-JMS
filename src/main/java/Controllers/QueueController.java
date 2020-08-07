package Controllers;

import jms.Sender;
import org.apache.activemq.broker.BrokerService;
import javax.jms.JMSException;

public class QueueController {

    public static void main(String[] args) throws JMSException {

        String cola = "notificacion_sensores";
        BrokerService brokerService = new BrokerService();
        try {
            brokerService.addConnector("tcp://localhost:61616");
            brokerService.start();
        } catch (Exception e) {
            e.printStackTrace();
        }
        new Sender().sendMessage(cola);
    }
}
