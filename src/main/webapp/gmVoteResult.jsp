<%@page import="java.sql.SQLException"%>
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
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>관리자용</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="styles.css">
</head>
<style>
body {
	font-family: Arial, sans-serif;
}

.navbar {
	margin-bottom: 20px;
}

.container {
	margin-top: 20px;
}

.table {
	width: 100%;
}

.table th, .table td {
	text-align: center;
}

.vote-form {
	display: flex;
	align-items: center;
}

.vote-button {
	margin-left: 10px;
}
</style>
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
	<h1>KBO 투표(관리자용)</h1>
    <table class="table table-bordered">
        <!-- 테이블 헤더 -->
        <tbody>
            <%
            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultSet = null;
            try {
            	String jdbcUrl = "jdbc:mysql://35.177.120.128:3306/mydb";
                String jdbcUser = "admin";
                String jdbcPassword = "1234";

                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);

                String sql = "SELECT * FROM kbo_matches WHERE date > ? ORDER BY date, time";
                preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setDate(1, new java.sql.Date(new java.util.Date().getTime()));
                resultSet = preparedStatement.executeQuery();

                while (resultSet.next()) {
                    // 데이터베이스로부터 읽어온 경기 정보
            %>
            <tr>
                <td><%= resultSet.getString("date") %></td>
                <td><%= resultSet.getString("time") %></td>
                <td><%= resultSet.getString("team1") %></td>
                <td><%= resultSet.getString("team2") %></td>
                <td>
                    <form method="post" action="VoteResult.jsp">
                        <input type="hidden" name="gameId" value="<%= resultSet.getInt("id") %>">
                        <input type="radio" name="selectedTeam" value="<%= resultSet.getString("team1") %>"> <%= resultSet.getString("team1") %>
                        <input type="radio" name="selectedTeam" value="<%= resultSet.getString("team2") %>"> <%= resultSet.getString("team2") %>
                        <input type="submit" value="결과" class="vote-button">
                    </form>
                </td>
            </tr>
            <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { /* ignored */ }
                if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) { /* ignored */ }
                if (connection != null) try { connection.close(); } catch (SQLException e) { /* ignored */ }
            }
            %>
        </tbody>
    </table>


</body>
</html>