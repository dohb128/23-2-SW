<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
@font-face {
	font-family: abster;
	src: url(font/KBO-Dia-Gothic_bold.woff) format('woff');
}

@font-face {
	font-family: abster-lite;
	src: url(font/KBO-Dia-Gothic_medium.woff) format('woff');
}

@font-face {
	font-family: abster-light;
	src: url(font/KBO-Dia-Gothic_light.woff) format('woff');
}


.container {
	margin: 0 auto;
	width: 80%;
	display: flex;
	justify-content: space-around;
	flex-wrap: wrap;
}

.vote-main {
	border: 1px solid black;
	margin-top: 30px; border-radius : 10px;
	width: 29%;
	height: 250px;
	padding: 20px;
	border-radius: 10px;
}

.vote-plan {
	padding: 10px;
	border: 1px solid black;
	border-radius: 10px;
	width: 80%;
	height: 100px;
	margin: 0 auto;
	text-align: center;

}

.vote-choose {
	width: 80%;
	height: 60px;
	margin: 0 auto;
	margin-top: 10px;
	padding: 10px;
	display: flex;
	justify-content: center;
}

.vote-win {
	border: 1px solid black;
	width: 33%;
	height: 50px;
	text-align: center;
}

.vote-false {
	border: 1px solid black;
	width: 33%;
	height: 50px;
	text-align: center;
}

.submit {
	border: 1px solid black;
	width: 33%;
	height: 50px;
	text-align: center;
}

.submit button {
	width: 100%;
	height: 100%;
}

.vote-form {
	width: 100%;
	display: flex;
	justify-content: center;
	align-items: center;
}

.vote-form input {
	display: none;
}

.vote-form label {
	display: inline-block;
	width: 100%;
	height: 100%;
}

.hi {
	margin-top: 13px;
}

.vote-form input:checked+label {
	background-color: #5CD1E5;
}
.flex {
	width: 100%;
	height: 80%;
	display: flex;
	justify-content: center;
	
}
.left-img {
	width:25%;
}

.left-img img{
	width: 100%;
	height: 100%;
}

.center-h1 {
	width:50%;
	display: flex;
  	flex-direction: column;
  	justify-content: center;
  	align-items: center;
}





.right-img {
	width:25%;
}

.right-img img{
	width: 100%;
	height: 100%;
}

@media only screen and (max-width: 1050px) {
  .center-h1 h1 {
    font-size: 14px; /* 적절한 크기로 조절 */
  }
}

@media only screen and (min-width: 1051px) {
  .center-h1 h1 {
    font-size: 30px; /* 적절한 크기로 조절 */
  }
}
</style>
</head>
<body>
	<div class="container">
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
				
				int i = 0;
				while (resultSet.next()) {
					// 데이터베이스로부터 읽어온 경기 정보
			%>
		<div class="vote-main">
			<div class="vote-plan">
				<%=resultSet.getString("date")%>/<%=resultSet.getString("time")%>
				<div class="flex">
					<div class="left-img">
						<img src="image/home.png">
					</div>
					<div class="center-h1">
						<p><h1><%=resultSet.getString("team2")%> VS <%=resultSet.getString("team1")%></h1></p>
					</div>
					<div class="right-img">
						<img src="image/won.png">
					</div>
				</div>
			</div>

			<div class="vote-choose">
				<form class="vote-form" action="voteProccess.jsp">
					<input type="hidden" value="<%=resultSet.getInt("id")%>" name="gameId">
					<div class="vote-win">

						<input type="radio" value="<%=resultSet.getString("team2")%>" id="<%=i%>" name="selectedTeam"><label
							for="<%=i%>"><div class="hi">승</div></label>
					</div>
					<div class="vote-false">
						<input type="radio" value="<%=resultSet.getString("team1")%>" id="<%=i+1 %>" name="selectedTeam"><label
							for="<%=i+1%>"><div class="hi">패</div></label>
					</div>
					<div class="submit">
						<button type="submit">투표</button>
					</div>
				</form>
			</div>
		</div>
		<%
			i += 2;
			}
			} catch (Exception e) {
			e.printStackTrace();
			} finally {
			if (resultSet != null)
			try {
				resultSet.close();
			} catch (SQLException e) {
				/* ignored */ }
			if (preparedStatement != null)
			try {
				preparedStatement.close();
			} catch (SQLException e) {
				/* ignored */ }
			if (connection != null)
			try {
				connection.close();
			} catch (SQLException e) {
				/* ignored */ }
			}
			%>
	</div>
</body>
</html>