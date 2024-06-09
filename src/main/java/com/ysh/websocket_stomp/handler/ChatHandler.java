package com.ysh.websocket_stomp.handler;

import java.util.ArrayList;
import java.util.List;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Component
@Configuration //웹 소켓 브로커를 사용하기 위해
@EnableWebSocketMessageBroker // 메시지 브러커가 지원하는 websocket메시지 처리 활성화
public class ChatHandler extends TextWebSocketHandler implements WebSocketMessageBrokerConfigurer {

	private static List<WebSocketSession> list = new ArrayList<WebSocketSession>();

	// 사용자가 접속 했을 때 호출되는 메소드
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.println(" ### 사용자 접속 ");
		list.add(session);
	}

	// 사용자가 메세지를 보냈을 때 호출되는 메소드
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		// 전송된 메세지를 List의 모든 세션에 전송
		String msg = message.getPayload();
		for (WebSocketSession s : list) {
			s.sendMessage(new TextMessage(session.getAcceptedProtocol() + msg));
		}
	}

	// 사용자 접속 해제했을 때 호출되는 메소드
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		System.out.println(" ### 사용자 접속 해제");
		list.remove(session);
	}

	
	//기존 웹 소켓 사용시
//	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
//		registry.addHandler(this, "/chat-ws").setAllowedOrigins("*");
//	}

	
	//websocket stomp설정을 위해 필요
	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) { // hamdshake와 통신을 담당할 endpoint지정
		registry.addEndpoint("/chattings") // websocket연결시 요청을 보낼 endpoint지정
				.setAllowedOrigins("*");
	}

	//websocket stomp설정을 위해 필요
	@Override
	public void configureMessageBroker(MessageBrokerRegistry registry) { //메모리 기반의 simple message broker활성화
		registry.enableSimpleBroker("/subscription"); // subscriber들에게 메시지를 전달할 url
		registry.setApplicationDestinationPrefixes("/publication"); // 클라이언트가 서버로 메시지 보낼때 url 접두사 지정
	}

}
