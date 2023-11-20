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
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="styles.css">
<link rel="stylesheet" href="style.css">
<link rel="stylesheet" href="tables.css">
<style>
table {
	width: 100%;
	border-collapse: collapse;
	font-size: 16px; /* 폰트 크기를 조절하세요 */
}

th, td {
	border: 1px solid #ddd;
	text-align: left;
	padding: 8px;
}

th {
	background-color: #f2f2f2;
}
</style>
</head>
<body>
	<h2>포인트 랭킹</h2>
	<%
	Connection connection = null;
	Statement statement = null;
	ResultSet resultSet = null;

	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		connection = DriverManager.getConnection("jdbc:mysql://35.177.120.128:3306/mydb", "admin", "swvmfhwprxm2023");
		statement = connection.createStatement();

		String query = "SELECT NAME, point FROM members ORDER BY point DESC";
		resultSet = statement.executeQuery(query);
	%>
	<table>
		<tr>
			<th>이름</th>
			<th>포인트</th>
		</tr>
		<%
		while (resultSet.next()) {
			String name = resultSet.getString("NAME");
			int point = resultSet.getInt("point");
		%>
		<tr>
			<td><%=name%></td>
			<td><%=point%></td>
		</tr>
		<%
		}
		%>
	</table>
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
