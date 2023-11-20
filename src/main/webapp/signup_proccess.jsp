<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 결과</title>
</head>


<body>
<%
    String u_id = request.getParameter("userID");
    String u_pw = request.getParameter("userPassword");
    String u_name = request.getParameter("userName");
    String u_mail = request.getParameter("userEmail");

    String sql = "INSERT INTO members(id, pw, NAME, email) VALUES";
    sql += "('" + u_id + "', '" + u_pw + "','" + u_name + "','" + u_mail + "')";

    String driverName = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://35.177.120.128:3306/mydb";
    String username = "admin";
    String password = "swvmfhwprxm2023";
    Connection conn = null;

    Class.forName(driverName);
    conn = DriverManager.getConnection(url, username, password);
    Statement sm = conn.createStatement();

    int count = sm.executeUpdate(sql);
    if (count == 1) {
        // 회원 가입 성공 시 alert 메시지 표시 및 로그인 페이지로 리다이렉트
        %>
        <script>
            alert("회원 가입 성공");
            window.location.replace("login.jsp"); // 로그인 페이지 URL로 리다이렉트
        </script>
        <%
    } else {
        out.println("회원 가입 실패");
    }

    sm.close();
    conn.close();
%>
</body>
</html>
