<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		String id = (String) session.getAttribute("userID");
		String pw = request.getParameter("userPassword");
		
		Connection con;
		PreparedStatement sm;
		ResultSet rs;
		
		boolean pwCheck = false;
		Class.forName("com.mysql.jdbc.Driver");
		
		con = DriverManager.getConnection("jdbc:mysql://35.177.120.128:3306/mydb","admin","swvmfhwprxm2023");
		
		String sql = "SELECT * FROM members WHERE id = ?";
		try {
			sm = con.prepareStatement(sql);
			
			sm.setString(1, id);
			
			rs = sm.executeQuery();
			
			if(rs.next()){
				if(pw.equals(rs.getString(2))) { //만약에 맞을 때
					sql = "DELETE FROM members WHERE id = ?";
					sm = con.prepareStatement(sql);
					
					sm.setString(1, id);
					
					sm.executeUpdate();
					
					pwCheck = true;
					
				}
			}
			
		}catch(Exception ex){
			ex.printStackTrace();
			
		}
		
		if(!pwCheck) { //비밀번호가 일치하지 않는다면
			%>
			<script type="text/javascript">
				alert("비밀번호가 일치하지 않습니다.");
				window.location.replace("dropOut.jsp");
			</script>
		<%
		} else {
			%>
			<script type="text/javascript">
				alert("회원정보가 삭제되었습니다.");
				//response.sendRedirect을 쓰게될경우 alert가 나오기전 바로 이동함.
				window.location.replace("main.jsp");
			</script>
			
			
			<% 
			session.invalidate();
		}
		
	%>
	
</body>
</html>