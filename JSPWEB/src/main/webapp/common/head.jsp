<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%
String userID = null;
if (session.getAttribute("userID") == null) {
    PrintWriter script = response.getWriter();
    script.println("<script>");
    script.println("alert('PLEASE LOGIN');");
    script.println("location.href = 'login.jsp'");
    script.println("</script>");

}
if (session.getAttribute("userID") != null) {
    userID = (String) session.getAttribute("userID");
}
int pageNumber = 1;
if (request.getParameter("pageNumber") != null) {
    pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
}
%>

<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
        <button type="button" class="navbar-toggler" 
            data-bs-toggle="collapse" 
            data-bs-target="#bs-example-navbar-collapse-1" 
            aria-controls="bs-example-navbar-collapse-1"
            aria-expanded="false"
            aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <a class="navbar-brand" href="index.jsp">Web</a>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="active"><a class="nav-link" href="main.jsp">MAIN</a></li>
                <li class="nav-item"><a class="nav-link" href="bbs.jsp">PAGE</a></li>
                <!-- <li class="nav-item"><a class="nav-link" href="room.jsp">Room</a></li> --> <!-- 아직미구현 -->
            </ul>
            <%
            if(userID == null){
            %>
            <ul class="navbar-nav ml-auto mb-2 mb-lg-0">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
                        role="button" data-bs-toggle="dropdown"
                        aria-expanded="false">CONNECT</a>
                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="login.jsp">LOGIN</a></li>
                        <li><a class="dropdown-item" href="register.jsp">SIGNUP</a></li>
                    </ul>
                </li>
            </ul>
            <%
            } else {
            %>
      
            <ul class="navbar-nav ml-auto mb-2 mb-lg-0">
            <li class="nav-item dropdown">
                <a class a class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
                    role="button" data-bs-toggle="dropdown"
                    aria-expanded="false">USER CONTROL</a>
                <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <li><a class="dropdown-item" href="logoutAction.jsp">LOGOUT</a></li>
                </ul>
            </li>
        </ul>
        <%
            }
        %>
           
        </div>
    </div>
</nav>
