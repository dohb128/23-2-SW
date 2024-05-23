<%@page import="java.io.PrintWriter"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>KBO 게시판</title>
</head>
<body>
<%
	//gameId와 이긴 팀 이름 받음 .
	int gameId = Integer.parseInt(request.getParameter("gameId"));
	String winnerTeam = request.getParameter("selectedTeam");
	
	Connection con;
	PreparedStatement psmt;
	ResultSet rs;
	
	
	try{
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://35.177.120.128:3306/mydb","admin","swvmfhwprxm2023");
		
		String sql = "SELECT userId FROM vote WHERE voteRec = ? AND gameId = ?";
		
		psmt = con.prepareStatement(sql);
		
		psmt.setString(1, winnerTeam);
		psmt.setInt(2, gameId);
		
		rs = psmt.executeQuery();
		
		while (rs.next()){
			sql = "UPDATE members SET point = point + 10 WHERE id = ? ";
			
			psmt = con.prepareStatement(sql);
			
			psmt.setString(1, rs.getString("userId"));
			
			psmt.executeUpdate();
		}
		
	}catch(Exception ex){
		
		ex.printStackTrace();
	}
	
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('완료')");
	script.println("history.back()");
	script.println("</script>");	
%>




</body>
</html>