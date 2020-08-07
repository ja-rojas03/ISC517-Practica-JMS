package jms;

import Controllers.ClientController;
import org.apache.activemq.ActiveMQConnectionFactory;
import javax.jms.*;

public class Reciever {
    ActiveMQConnectionFactory factory;
    Connection connection;
    Session session;
    Topic topic;
    MessageConsumer consumer;
    String topicName;

    public Reciever(String topicName) {
        this.topicName = topicName;
    }

    public void connect() throws JMSException {
        factory = new ActiveMQConnectionFactory("admin", "admin", "failover:tcp://localhost:61616");
        connection = factory.createConnection();
        connection.start();
        session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);

        topic = session.createTopic(topicName);
        consumer = session.createConsumer(topic);
        consumer.setMessageListener(message -> {
            TextMessage textMessage = (TextMessage) message;
            try {
                ClientController.sendMessage(textMessage.getText());
                System.out.println(textMessage.getText());
            } catch (JMSException e) {
                e.printStackTrace();
            }
        });
    }
}
