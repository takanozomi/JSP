<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<%
	String saveFolder = "/uploads"; // "uploads" 디렉토리 내에 파일을 저장
	String realFolder = getServletContext().getRealPath(saveFolder);

    String encType = "utf-8";
    int maxSize = 5 * 1024 * 1024; // 최대 업로드 5MB

    ServletContext context = request.getServletContext();
    realFolder = context.getRealPath(saveFolder);
    out.println("The realpath is: " + realFolder + "<br>");

    try {
        MultipartRequest multi = null;

        multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());

        Enumeration params = multi.getParameterNames();

        while (params.hasMoreElements()) {
            String name = (String) params.nextElement();
            String value = multi.getParameter(name);
            out.println(name + " = " + value + "<br>");
        }

        out.println("-------------------<br>");

        Enumeration files = multi.getFileNames();

        while (files.hasMoreElements()) {
            String name = (String) files.nextElement();
            String filename = multi.getFilesystemName(name);
            String original = multi.getOriginalFileName(name);
            String type = multi.getContentType(name);
            File file = multi.getFile(name);

            out.println("파라미터 이름: " + name + "<br>");
            out.println("실제 파일 이름: " + original + "<br>");
            out.println("저장된 파일 이름: " + filename + "<br>");
            out.println("파일 타입: " + type + "<br>");

            if (file != null) {
                out.println("크기: " + file.length() + "<br>");
            }
        }

    } catch (IOException ioe) {
        out.println(ioe);
    } catch (Exception ex) {
        out.println(ex);
    }
%>
