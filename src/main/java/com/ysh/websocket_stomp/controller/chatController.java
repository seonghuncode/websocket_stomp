package com.ysh.websocket_stomp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class chatController {

	@RequestMapping("/startChat")
	public String startChat() {
		return "/chat/chatting";
	}
	
}
