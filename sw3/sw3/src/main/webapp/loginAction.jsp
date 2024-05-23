<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>KBO 게시판</title>
<%
	// 아이디와 패스워드값 받아옴
	String uId = request.getParameter("userID");
	String upw = request.getParameter("userPassword");
	//jdbc드라이버와 mysql주소및 계정연동 변수 설정
	String dbType = "com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://35.177.120.128:3306/mydb";
    String username = "admin";
    String password = "swvmfhwprxm2023";
    
    //자바와db연동을 위한 connection 객체 생성
    Connection conn = null;
    //db명령에 대한 반환값
    ResultSet rs = null;
    
    
    try {
    	//db와 연동할 jdbc 드라이버 찾아서 로드
    	Class.forName(dbType);
    	//connection 객체에 url, db아이디,db비번 연동
    	conn = DriverManager.getConnection(url, username, password);
    	//db sql문 작성 (여기서 ?은 대입할 변수를 의미)
    	String sql = "SELECT *FROM members WHERE id = ?";
    	//쿼리 전송 구문
    	PreparedStatement pstmt = conn.prepareStatement(sql);
    	//1번째 파라미터에 받아온 아이디값 부여
    	pstmt.setString(1, uId);
    	
    	//resultset객체에 결과값 받음
    	rs=pstmt.executeQuery();
    	
    	
    	//정보가 있다면
    	if (rs.next()) {
    		String dbId = rs.getString(1);
    		String dbPw = rs.getString(2);
    		String dbMail = rs.getString(3);
    		if (upw.equals(dbPw)) {
    		    // 세션에 사용자 ID를 저장하고 다른 페이지로 리디렉션
    		    session.setAttribute("userID", uId);
    		    response.sendRedirect("main.jsp");
    		} else {
    		    // 비밀번호가 일치하지 않을 경우 다른 페이지로 리디렉션
        		%>
    			<script>
    				alert("비밀번호가 일치하지 않습니다 .");
    				window.location.replace("login.jsp");
    			</script>
    		
    		<%
    		}
    	}else{
    		%>
    			<script>
    				alert("회원정보가 존재하지않습니다.");
    				window.location.replace("login.jsp");
    			</script>
    		
    		<% 
    	}
    }catch(Exception e){
    	e.printStackTrace();
    }

%>
</head>
<body>

</body>
</html>