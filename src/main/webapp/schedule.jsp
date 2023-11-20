<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>KBO 게시판</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="styles.css">
<link rel="stylesheet" href="style.css">
</head>
<body style="text-align: center;">
	<!-- 오른쪽 영역 (경기 일정) -->
	<h3>경기 일정</h3>
	<div class="table-responsive">
		<table class="table table-bordered">
			<thead>
				<tr>
					<th style="text-align: center;">날짜</th>
					<th style="text-align: center;">시간</th>
					<th style="text-align: center;">원정팀</th>
					<th style="text-align: center;">홈 팀</th>
				</tr>
			</thead>
			<tbody>
				<%
				Connection conn = null;
				Statement stmt = null;
				ResultSet rs = null;

				try {
					Class.forName("com.mysql.cj.jdbc.Driver");
					conn = DriverManager.getConnection("jdbc:mysql://35.177.120.128/mydb", "admin", "swvmfhwprxm2023");
					stmt = conn.createStatement();
					String query = "SELECT date, time, team1, team2 FROM kbo_matches ORDER BY date ASC, time ASC";
					rs = stmt.executeQuery(query);

					while (rs.next()) {
				%>
				<tr>
					<td><%=rs.getDate("date")%></td>
					<td><%=rs.getString("time").substring(0, 5)%></td>
					<td><%=rs.getString("team1")%></td>
					<td><%=rs.getString("team2")%></td>
				</tr>
				<%
				}
				} catch (Exception e) {
				out.println("Database error: " + e);
				} finally {
				try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close();
				} catch (Exception e) {
				out.println("Close error: " + e);
				}
				}
				%>
			</tbody>
		</table>
	</div>
</body>
</html>