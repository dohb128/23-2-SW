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
 //현재 세션 빼앗음.
 session.invalidate();
%>
<script>
	location.href='main.jsp';
</script>
</body>
</html>