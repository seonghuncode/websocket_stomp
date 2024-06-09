<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Hello WebSocket</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <link href="/main.css" rel="stylesheet">
    <script src="/webjars/jquery/jquery.min.js"></script>
    <script src="/webjars/sockjs-client/sockjs.min.js"></script>
    <script src="/webjars/stomp-websocket/stomp.min.js"></script>
    <script src="/app.js"></script>
</head>
<body>
<noscript><h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websocket relies on Javascript being
    enabled. Please enable
    Javascript and reload this page!</h2></noscript>
<div id="main-content" class="container">
    <div class="row">
        <div class="col-md-6">
            <form class="form-inline">
                <div class="form-group">
                    <label for="connect">WebSocket connection:</label>
                    <button id="connect" class="btn btn-default" type="submit">Connect</button>
                    <button id="disconnect" class="btn btn-default" type="submit" disabled="disabled">Disconnect
                    </button>
                </div>
            </form>
        </div>
        <div class="col-md-6">
            <form class="form-inline">
                <div class="form-group">
                    <label for="name">What is your name?</label>
                    <input type="text" id="name" class="form-control" placeholder="Your name here...">
                </div>
                <button id="send" class="btn btn-default" type="submit">Send</button>
            </form>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <table id="conversation" class="table table-striped">
                <thead>
                <tr>
                    <th>Greetings</th>
                </tr>
                </thead>
                <tbody id="greetings">
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
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
