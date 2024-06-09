package com.ysh.websocket_stomp.controller;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ysh.websocket_stomp.dto.ChattingRequest;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class chatController {

	private final SimpMessagingTemplate simpMessagingTemplate; // @EnableWebSocketMessageBroker를 통해 등록되는 Bean으로, Broker로
																// 메시지 전달
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	// 웹 소켓
	@RequestMapping("/startChat")
	public String startChat() {
		return "/chat/chatting";
	}

	// stomp적용
	@MessageMapping("/chattings/{chattingRoomId}/messages") // (2) 클라이언트가 전송할 수 있는 경로
	public String chat(@DestinationVariable Long chattingRoomId, ChattingRequest chattingRequest) { 
		// (3) messgemapping url로 메시지를 보내면 해당 챙팅방을 구동중인 사용자들에게 메시지를 전달
		simpMessagingTemplate.convertAndSend("/subscription/chattings/" + chattingRoomId, chattingRequest.getContent());
		//log.info("Message [ {} ] send by member: {} to chatting room: {}", chattingRequest.getContent(), chattingRequest.getSenderId(), chattingRoomId);
		System.out.println("Message [ " + chattingRequest.getContent() + 
				"] send by member: {" + chattingRequest.getSenderId() +  
				"} to chatting room: {" + chattingRoomId +
				"}");
		
		return "/chat/stomp";
	}

}
