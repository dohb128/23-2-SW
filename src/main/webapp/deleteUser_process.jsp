<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.servlet.*"%>

<%
String userID = (String) session.getAttribute("userID");

if (userID == null) {
	response.sendRedirect("deleteUser.jsp");
	return;
}

Connection conn = null;
ResultSet rs = null;

try {
    String jdbcUrl = "jdbc:mysql://35.177.120.128:3306/mydb";
    String jdbcUser = "admin";
    String jdbcPassword = "1234";

    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);
    
    String deleteSql = "";	//회원 삭제 쿼리문
} catch (SQLException e) {
    response.sendRedirect("error.jsp?error=sqlException&message=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
} catch (Exception e) {
    response.sendRedirect("error.jsp?error=generalException&message=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
}
%>