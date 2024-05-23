<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>관리자용</title>
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="tables.css">

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
<div class="container-mine">
		<div class="painted">
			<div class="header">
				<div class="nav">
					<ul>
						<c:choose>
							<c:when test="${userID == null }">
								<li><a href="login.jsp">로그인</a></li>
								<li><a>|</a></li>
								<li><a href="signup.jsp">회원가입</a></li>
							</c:when>
							<c:otherwise>
								<li><a href="logoutAction.jsp">로그아웃</a></li>
								<li><a>|</a></li>
								<li><a href="dropOut.jsp">회원탈퇴</a></li>
							</c:otherwise>
						</c:choose>
					</ul>
				</div>
			</div>
		</div>
		<div class="border">
			<div class="header-main">
				<h1>
					<a href="main.jsp">KBO</a>
				</h1>
				<div class="nav-bbs">
					<ul>
						<li><a href="bbs.jsp?bbsType=bbsFun">윾머게시판</a></li>
						<li><a href="bbs.jsp?bbsType=bbsMain">일반게시판</a></li>
						<li><a href="bbs.jsp?bbsType=bbsBaseball">야구게시판</a></li>
						<li><a href="vote.jsp">투표하기</a></li>
					</ul>
				</div>
			</div>
		</div>

	</div>
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
                String jdbcPassword = "swvmfhwprxm2023";

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
                        <input type="submit" value="결과" class="btn-custom">
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