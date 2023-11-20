<%@page import="java.sql.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=divice-width" , initial-scale="1">
<title>KBO 게시판</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="styles.css">
</head>
<body>

	<%
	String userID = (String) session.getAttribute("userID");
	%>
	<!-- 웹사이트 공통메뉴 -->
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<!-- 홈페이지의 로고 -->
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expand="false">
				<span class="icon-bar"></span>
				<!-- 줄였을때 옆에 짝대기 -->
				<span class="icon-bar"></span> <span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">KBO 게시판</a>
		</div>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="main.jsp">메인</a></li>
				<!-- 현재의 게시판 화면이라는 것을 사용자에게 보여주는 부분 -->
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown"><a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">게시판<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="bbsFun.jsp">유머게시판</a></li>
							<li><a href="bbs.jsp">일반게시판</a></li>
							<li><a href="bbsBaseball.jsp">야구게시판</a></li>
						</ul></li>
				</ul>
			</ul>
			<%
			if (userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="signup.jsp">회원가입</a></li>
					</ul></li>
			</ul>
			<%
			} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul></li>
			</ul>
			<%
			}
			%>
		</div>
	</nav>
	<!-- 화면 공통메뉴 끝 -->

	<h2>회원 탈퇴</h2>
	<%
	// MySQL 연결
	String jdbcUrl = "jdbc:mysql://35.177.120.128:3306/mydb";
	String jdbcUser = "admin";
	String jdbcPassword = "1234";

	Connection connection = null;
	PreparedStatement preparedStatement = null;
	ResultSet resultSet = null;

	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);

		// 
		String sql = "SELECT * FROM members WHERE id = ?";
		preparedStatement = connection.prepareStatement(sql);
		preparedStatement.setString(1, userID);
		resultSet = preparedStatement.executeQuery();

		if (resultSet.next()) {
			String id = resultSet.getString("id");
			String pw = resultSet.getString("pw");
			String name = resultSet.getString("NAME");
			String email = resultSet.getString("email");
			int point = resultSet.getInt("point");

			// 회원 정보 출력
	%>
	<table>
		<tr>
			<th>Name :</th>
			<td><%=name%></td>
		</tr>
		<tr>
			<th>Email :</th>
			<td><%=email%></td>
		</tr>
		<tr>
			<th>Point :</th>
			<td><%=point%></td>
		</tr>
	</table>
	회원 탈퇴를 진행하시겠습니까?
	<form action="deleteUser.jsp" method="post">
		<label for="password">비밀번호 : </label> <input type="password"
			id="password" name="password" required> <input type="submit"
			value="계정 삭제" id="deleteButton" disabled>
	</form>

	<script>
	document.getElementById("password").addEventListener("input", function() {
    	var password = this.value;
    	var pw = "<%=pw%>"; // 비밀번호가 저장된 변수

		var deleteButton = document.getElementById("deleteButton");
		if (password === pw) {
			deleteButton.removeAttribute("disabled");
		} else {
			deleteButton.setAttribute("disabled", "disabled");
		}
	});
	</script>


	<%
	}
	} catch (Exception e) {
	e.printStackTrace();
	} finally {
	if (resultSet != null)
	resultSet.close();
	if (preparedStatement != null)
	preparedStatement.close();
	if (connection != null)
	connection.close();
	}
	%>
</body>
</html>