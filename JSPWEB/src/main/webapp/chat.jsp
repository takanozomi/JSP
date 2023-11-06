<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat Application</title>
    <!-- Add your CSS and Bootstrap links here -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
    <style>
        canvas {
            border: 1px solid #000;
            background-color: #fff;
            
            
        }
    </style>
</head>
<body>

<jsp:include page="./common/head.jsp" />

 <div style="display: flex;">
    <div style="padding: 20px; flex: 1;">
        <canvas id="myCanvas" width="1000" height="500"></canvas>
        <div id="colorPicker">
            <input type="file" id="fileInput" accept=".jpg, .jpeg, .png" onchange="uploadImage()">
            <input type="color" id="penColor" value="#000000" onchange="changePenColor()">
            <button onclick="clearCanvas()">Clear</button>
        </div>
    </div>
    <div style="flex: 1; padding: 20px;">
        <div id="chat-container" style="border: 1px solid #000; height: 500px; padding: 10px; overflow-y: scroll;">
            <!-- Chat messages will be displayed here -->
            <div id="chat-content"></div> <!-- 수정: chat-content를 사용하여 채팅 내용을 표시 -->
        </div>
        <input type="text" id="message" style="width: 70%; padding: 5px;"> <!-- 수정: id를 "message"로 변경 -->
        <button onclick="sendMessage()" style="width: 28%; padding: 5px;">전송</button>
    </div>
</div>

<script>
    var chatContent = document.getElementById("chat-content");
    var messageInput = document.getElementById("message");
    var webSocket;
    const MAX_MESSAGE_SIZE = 1048576;
    // loggedInUserId 값을 서버에서 JSP로 가져온다고 가정
    var loggedInUserId = "<%= session.getAttribute("userID") %>";

    function initWebSocket() {
        webSocket = new WebSocket("ws://localhost:8080/JSPWEB/websocketendpoint");

        webSocket.onopen = function(event) { wsOpen(event); };
        webSocket.onmessage = function(event) { wsGetMessage(event); };
        webSocket.onclose = function(event) { wsClose(event); };
        webSocket.onerror = function(event) { wsError(event); };
    }

    // 초기 웹 소켓 연결 설정
    initWebSocket();

    messageInput.addEventListener("keyup", function(event) {
        if (event.key === "Enter") {
            sendMessage();
        }
    });

    function wsOpen(event) {
        chatContent.innerHTML += "Connected ... <br>";
    }

    function sendMessage() {
        var message = messageInput.value;
        if (message.trim() !== "") {
            if (message.length <= MAX_MESSAGE_SIZE) {
                webSocket.send(JSON.stringify({ type: 'chat', user: loggedInUserId, text: message }));
            } else {
                console.log("Message too large, cannot send.");
            }
            messageInput.value = "";
        }
    }

    function wsGetMessage(event) {
        const data = JSON.parse(event.data);

        if (data.type === 'chat') {
            chatContent.innerHTML += data.user + ": " + data.text + "<br>";
        } else if (data.type === 'image') {
            // 이미지 데이터를 받아서 표시
            const image = new Image();
            image.src = data.data;
            chatContent.appendChild(image);
        }
    }

    function wsClose(event) {
        chatContent.innerHTML += "Disconnected ... Reconnecting...<br>";

        // 연결이 닫힌 후, 재연결 시도
        setTimeout(function() {
            initWebSocket();
        }, 5000); // 5초 후 다시 시도 (원하는 시간으로 조정 가능)

        console.log("WebSocket 연결이 끊어졌습니다. 코드: " + event.code + ", 이유: " + event.reason);
    }

    function wsError(event) {
        chatContent.innerHTML += "Error ... <br>";
        console.error("WebSocket 오류 발생: " + event);
    }

    function uploadImage() {
        const fileInput = document.getElementById("fileInput");
        const file = fileInput.files[0];

        if (file) {
            const reader = new FileReader();

            reader.onload = function(event) {
                const image = new Image();
                image.src = event.target.result;

                image.onload = function() {
                    const canvas = document.getElementById("myCanvas");
                    canvas.width = image.width;
                    canvas.height = image.height;
                    const ctx = canvas.getContext("2d");
                    ctx.drawImage(image, 0, 0, canvas.width, canvas.height);
                    const imageDataURL = canvas.toDataURL("image/jpeg");

                    // 이미지 데이터를 WebSocket 서버로 보냅니다.
                    webSocket.send(JSON.stringify({ type: 'image', data: imageDataURL }));
                };
            };

            reader.readAsDataURL(file);
        }
    }
</script>





<!-- Add your Bootstrap JS and other script links here -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>

<script>
const canvas = document.getElementById("myCanvas");
const ctx = canvas.getContext("2d");
let isDrawing = false; // 그림 그리기 중인지 여부
let lastX = 0;
let lastY = 0;
let selectedColor = "black"; // 기본 드로잉 컬러

// 펜촉 스타일 생성
ctx.strokeStyle = selectedColor;

// 캔버스 초기화 함수
function clearCanvas() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    webSocket.send(JSON.stringify({ type: 'clear' }));
    
}

function changePenColor() {
    const colorPicker = document.getElementById("penColor");
    selectedColor = colorPicker.value;
    ctx.strokeStyle = selectedColor;
}

// 마우스 다운 이벤트 처리
canvas.addEventListener("mousedown", (e) => {
    isDrawing = true;
    lastX = e.clientX - canvas.getBoundingClientRect().left;
    lastY = e.clientY - canvas.getBoundingClientRect().top;
});

// 마우스 이동 이벤트 처리
canvas.addEventListener("mousemove", (e) => {
    if (!isDrawing) return;

    const x = e.clientX - canvas.getBoundingClientRect().left;
    const y = e.clientY - canvas.getBoundingClientRect().top;

    ctx.beginPath();
    ctx.moveTo(lastX, lastY);
    ctx.lineTo(x, y);
    ctx.lineWidth = 2; // 그림 두께 설정
    ctx.stroke();

    // 그림 그리기 이벤트를 WebSocket으로 서버에 전송
    const message = JSON.stringify({ type: 'draw', x: lastX, y: lastY, newX: x, newY: y, color: selectedColor });
    webSocket.send(message);

    lastX = x;
    lastY = y;
});

// 마우스 업 이벤트 처리
canvas.addEventListener("mouseup", () => {
    isDrawing = false;
});

// 캔버스를 벗어나면 그림 그리기 중지
canvas.addEventListener("mouseleave", () => {
    isDrawing = false;
});

// WebSocket으로부터 메시지 수신
webSocket.addEventListener('message', (event) => {
    const data = JSON.parse(event.data);
    if (data.type === 'draw') {
        // 좌표 정보가 없는 경우에만 그리기
        if (data.x !== undefined && data.y !== undefined && data.newX !== undefined && data.newY !== undefined) {
            ctx.beginPath();
            ctx.moveTo(data.x, data.y);
            ctx.lineTo(data.newX, data.newY);
            ctx.strokeStyle = data.color; // Set the received color
            ctx.lineWidth = 2; // 그림 두께 설정
            ctx.stroke();
        }
    }
});
</script>

</body>
</html>
