<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>KBO 게시판</title>
<link rel="stylesheet" href="style.css">
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

.ranking-container {
	width: 80%;
	display: flex;
	justify-content: space-between;
	flex-wrap: wrap;
	margin: 0 auto;
	font-family: abster;
	margin-top: 30px;
}

.ranking-container img {
	cursor: url(image/cursormain.png) 15 15, progress;
	
}
.th-1, .th-2, .th-3 {
	width: 30%;
	height: 100px;
}

.flex {
	display: flex;
	justify-content: center;
}

.th-1 img, .th-2 img, .th-3 img {
	width: 100%;
	height: 100%;
}

.img-center {
	width: 100px;
	height: 100px;
}

.solid {
	border: 3px solid black;
	border-radius: 30px;
}

.height {
	height: 500px;
}

.userimg-area {
	margin-top: 30px;
	width: 100%;
	height: 100px;
	display: flex;
	justify-content: center;
}

.rank-user-title {
	margin-top: 30px;
	width: 100%;
	height: 100px;
	display: flex;
	justify-content: center;
	align-items: center;
}

.total-point {
	margin-top: 30px;
	width: 100%;
	height: 50px;;
	display: flex;
	justify-content: center;
	align-items: center;
	font-family: abster-light;
	padding-top: 40px;
}

.total-point-main {
	width: 100%;
	height: 100px;;
	display: flex;
	justify-content: center;
	align-items: center;
}

.marbottom {
	margin-bottom: 10px;
}

</style>

</head>
<body>

	<%
	Connection connection = null;
	Statement statement = null;
	ResultSet resultSet = null;

	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		connection = DriverManager.getConnection("jdbc:mysql://35.177.120.128:3306/mydb", "admin", "swvmfhwprxm2023");
		statement = connection.createStatement();

		String query = "SELECT NAME, point FROM members ORDER BY point DESC LIMIT 3";
		resultSet = statement.executeQuery(query);
	%>

	<div class="bbs-border">
		<div class="bbs-express" style="width: auto;">
			<h1>BATTING RANKING !</h1>
			<br>
			<div class="button-flex">
				<div class="nothing"></div>
				<div class="p">
					<p>이번달 승부예측 랭킹을 확인해 주세요.</p>
				</div>
				<div class="a"></div>
			</div>
		</div>
	</div>
	<div class="ranking-container">
		<div class="th-1 flex marbottom">
			<div class="img-center">
				<img src="rank/1th.png">
			</div>
		</div>
		<div class="th-2 flex">
			<div class="img-center">
				<img src="rank/2th.png">
			</div>
		</div>
		<div class="th-3 flex">
			<div class="img-center">
				<img src="rank/3th.png">
			</div>
		</div>

		<%
		int i = 1;
		while (resultSet.next()) {
			String name = resultSet.getString("NAME");
			int point = resultSet.getInt("point");
			
		%>
		<div class="th-1 solid height">
			<div class="userimg-area">
				<div class="img-center">
					<img src="rank/<%=i%>user.png">
				</div>
			</div>
			<div class="rank-user-title">
				<p><%=name%></p>
			</div>
			<div class="total-point">
				<p>TOTAL POINT</p>
			</div>
			<div class="total-point-main">
				<h1><%=point%></h1>
			</div>
		</div>
		<%
		i++;
		}
		%>
	</div>

	<%
	} catch (Exception e) {
	e.printStackTrace();
	} finally {
	if (resultSet != null) {
		resultSet.close();
	}
	if (statement != null) {
		statement.close();
	}
	if (connection != null) {
		connection.close();
	}
	}
	%>

</body>
</html>
