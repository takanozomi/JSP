<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page session="true"%>
 	
<!DOCTYPE html>
<html>
<head>
    <title>채팅</title>
</head>
<body>
    <div id="_chatbox">
        <div id="messageWindow" style="border: 1px solid #ccc; padding: 10px; height: 300px; overflow-y: auto;"></div>
        <div>
            <input id="inputMessage" type="text" onkeyup="enterkey()" style="width: 70%; padding: 5px;">
            <input type="submit" value="전송" onclick="send()" style="width: 28%; padding: 5px;">
        </div>
    </div>
</body>
<script type="text/javascript">
    var messageWindow = document.getElementById("messageWindow");
    var webSocket = new WebSocket('ws://localhost:8080/JSPWEB/websocketendpoint');
    var inputMessage = document.getElementById('inputMessage');
    webSocket.onerror = function(event) {
        onError(event);
    };
    webSocket.onopen = function(event) {
        onOpen(event);
    };
    webSocket.onmessage = function(event) {
        onMessage(event);
    };
    function onMessage(event) {
        var message = event.data.split("|");
        var sender = message[0];
        var content = message[1];
        if (content !== "") {
            if (content.startsWith("/" + $("#chat_id").val())) {
                var temp = content.replace("/" + $("#chat_id").val(), "(귓속말) :").split(":");
                if (temp[1].trim() !== "") {
                    messageWindow.innerHTML += "<p class='whisper'>" + sender + temp[0] + "</p>";
                }
            } else {
                var cssClass = content.match("!") ? "impress" : "chat_content";
                messageWindow.innerHTML += `<p class='${cssClass}'>${sender} : ${content}</p>`;
            }
        }
    }
    function onOpen(event) {
        messageWindow.innerHTML = "<p class='chat_content'>채팅에 참여하였습니다.</p>";
    }
    function onError(event) {
        alert(event.data);
    }
    function send() {
        if (inputMessage.value !== "") {
            messageWindow.innerHTML += `<p class='chat_content'>나 : ${inputMessage.value}</p>`;
            webSocket.send($("#chat_id").val() + "|" + inputMessage.value);
            inputMessage.value = "";
        }
    }
    // 엔터키를 통해 send 함수 호출
    function enterkey() {
        if (event.keyCode === 13) {
            send();
        }
    }
    // 채팅이 많아져 스크롤바가 넘어가더라도 자동으로 스크롤바가 내려가도록 함
    setInterval(function() {
        messageWindow.scrollTop = messageWindow.scrollHeight;
    }, 0);
</script>
</html>
