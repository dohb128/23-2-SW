<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<title>투표 결과</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="styles.css">
<style>
body { .table-container { margin-left:10px; /* 테이블 양 옆에 여백 설정*/
	margin-right: 10px;
}

.table {
	width: 100%;
	margin: 0% /* 기본 마진 제거 */
}

}
table {
	width: 100%;
	border-collapse: collapse;
}

th, td {
	border: 1px solid #ddd;
	padding: 8px;
	text-align: center;
}

th {
	background-color: #f2f2f2;
}
</style>
</head>
<body>
	<h1> 현재 투표 현황</h1>
	<%
	SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdfTime = new SimpleDateFormat("HH:mm");
	java.sql.Date currentDate = new java.sql.Date(System.currentTimeMillis());

	// 데이터베이스 연결 설정
	String jdbcUrl = "jdbc:mysql://35.177.120.128:3306/mydb?useUnicode=true&characterEncoding=UTF-8";
	String jdbcUser = "admin";
	String jdbcPassword = "1234";

	try (Connection conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);
			PreparedStatement pstmt = conn.prepareStatement("SELECT m.date, m.time, m.team1, m.team2, "
			+ "(SELECT COUNT(*) FROM vote WHERE voteRec = m.team1 AND gameId = m.id) AS team1_votes, "
			+ "(SELECT COUNT(*) FROM vote WHERE voteRec = m.team2 AND gameId = m.id) AS team2_votes "
			+ "FROM kbo_matches m WHERE m.date >= ? ORDER BY m.date, m.time")) {

		pstmt.setDate(1, currentDate);

		try (ResultSet rs = pstmt.executeQuery()) {
	%>
	<div class="table-container">
		<table style="text-align: center;">
			<thead>
				<tr>
					<th>경기 날짜</th>
					<th>경기 시간</th>
					<th>원정팀</th>
					<th>투표 수</th>
					<th>홈팀</th>
					<th>투표 수</th>
				</tr>
			</thead>
			<tbody>
				<%
				while (rs.next()) {
					String formattedDate = sdfDate.format(rs.getTimestamp("date"));
					String formattedTime = sdfTime.format(rs.getTimestamp("time"));
				%>
				<tr>
					<td><%=formattedDate%></td>
					<td><%=formattedTime%></td>
					<td><%=rs.getString("team1")%></td>
					<td><%=rs.getInt("team1_votes")%></td>
					<td><%=rs.getString("team2")%></td>
					<td><%=rs.getInt("team2_votes")%></td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>
	</div>
	<%
	}
	} catch (SQLException e) {
	out.println("<p>데이터베이스 오류가 발생했습니다: " + e.getMessage() + "</p>");
	}
	%>
</body>
</html>