<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Canvas Drawing with Grid</title>
    <style>
        /* Canvas styles */
        canvas {
            border: 1px solid #000;
            background-color: #fff;
        }
    </style>
</head>
<body>
    <h1>Canvas Drawing with Grid</h1>
    
    <!-- Canvas element -->
    <canvas id="myCanvas" width="400" height="300"></canvas>
    
    <script>
        // WebSocket 서버에 연결
/*         const webSocket = new WebSocket("ws://localhost:8080/JSPWEB/websocketendpoint"); */

        // JavaScript를 사용하여 캔버스에 그리드 그리기
        const canvas = document.getElementById("myCanvas");
        const ctx = canvas.getContext("2d");
        const gridSize = 20; // 가로와 세로 줄 간격 설정
        let isDrawing = false; // 그림 그리기 중인지 여부
        let lastX = 0;
        let lastY = 0;

        // 가로 줄 그리기
        for (let x = 0; x < canvas.width; x += gridSize) {
            ctx.beginPath();
            ctx.moveTo(x, 0);
            ctx.lineTo(x, canvas.height);
            ctx.strokeStyle = "#ccc"; // 가로 줄 색상 설정
            ctx.stroke();
        }

        // 세로 줄 그리기
        for (let y = 0; y < canvas.height; y += gridSize) {
            ctx.beginPath();
            ctx.moveTo(0, y);
            ctx.lineTo(canvas.width, y);
            ctx.strokeStyle = "#ccc"; // 세로 줄 색상 설정
            ctx.stroke();
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
            ctx.strokeStyle = "black"; // 그림 색상 설정
            ctx.lineWidth = 2; // 그림 두께 설정
            ctx.stroke();

            // 그림 그리기 이벤트를 WebSocket으로 서버에 전송
            const message = JSON.stringify({ type: 'draw', x: lastX, y: lastY, newX: x, newY: y });
            socket.send(message);

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
        socket.addEventListener('message', (event) => {
            const data = JSON.parse(event.data);
            if (data.type === 'draw') {
                // 다른 클라이언트의 그림 그리기 이벤트를 처리하여 동일한 그림을 그립니다.
                ctx.beginPath();
                ctx.moveTo(data.x, data.y);
                ctx.lineTo(data.newX, data.newY);
                ctx.strokeStyle = "black"; // 그림 색상 설정
                ctx.lineWidth = 2; // 그림 두께 설정
                ctx.stroke();
            }
        });
    </script>
</body>
</html>
