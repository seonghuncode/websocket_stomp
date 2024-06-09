<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>채팅방</div>
	<input type="hidden" id="id" value="사용자">
	<div>
		<div id="chatarea" style="width: 300px; height: 300px; border: 1px solid black;"></div>
		<input type="text" id="message" />
		<input type="button" id="send" value="보내기" />
		<input type="button" id="exit" value="나가기" />
	</div>
</body>
<script type="text/javascript">
	// ##### 입장~~~!!
	let websocket;
	connect();
	function connect(){
// 		websocket = new WebSocket("ws://본인 아이 피주소/www/chat-ws");
		websocket = new WebSocket("ws://localhost:8081/websocket_stomp/chat-ws");
			//웹 소켓에 이벤트가 발생했을 때 호출될 함수 등록
			websocket.onopen = onOpen;
			websocket.onmessage = onMessage;
	}
	
	// ##### 연결 되었습니다!
	function onOpen(){
		id = document.getElementById("id").value;
		websocket.send(id + "님 입장하셨습니다.");
	}
	
	// ##### 메세지 보내기 버튼 클릭!
	document.getElementById("send").addEventListener("click", function() {
		send();
	});
	
	function send(){
		id = document.getElementById("id").value;
		msg = document.getElementById("message").value;
		websocket.send(id + ":"+ msg);
		document.getElementById("message").value = "";
	}
	
	function onMessage(evt){
		data= evt.data;
		chatarea = document.getElementById("chatarea");
		chatarea.innerHTML = chatarea.innerHTML + "<br/>" + data
	}
	
	// ##### 연결을 해제합니다!
	document.getElementById("exit").addEventListener("click", function() {
		disconnect();
	});

	function disconnect(){
		id = document.getElementById("id").value;
		websocket.send(id+"님이 퇴장하셨습니다");
		websocket.close();
	}
	
	</script>
	
</html>
