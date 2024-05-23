<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>KBO 승리 예측 투표</title>

<link rel="stylesheet" href="style.css">

</head>
<style type="text/css">
@font-face {
	font-family: abster;
	src:url(font/KBO-Dia-Gothic_bold.woff) format('woff');
}
@font-face {
	font-family: abster-lite;
	src:url(font/KBO-Dia-Gothic_medium.woff) format('woff');
}

@font-face {
	font-family: abster-light;
	src:url(font/KBO-Dia-Gothic_light.woff) format('woff');
}
	.container {
    margin: 0 auto;
    width: 80%;
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
}

.vote-main {
    border: 1px solid black;
    margin-top: 30px;
    width: 29%;
    padding: 20px;
    border-radius: 10px;
    text-align: center;
    
    font-family: abster;
}

.vote-title {
    text-align: center;
}

.vote-battle {
    width: 90%;
    height: 120px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    margin-bottom: 5px;
}

.vote-team1,
.vote-team2 {
    width: 30%;
    height: 100%;
}

.vote-vs {
    width: 30%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;	
}

.percent-bar {
    width: 100%;
    height: 30px;
    display: flex;
    justify-content: space-between;
}

.percent1 {
    width: 8%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
}

.percent-main {
    width: 80%;
    height: 100%;
    border: 1px solid black;
    border-radius: 20px;
    overflow: hidden; /* 이 부분을 추가해서 내부의 백그라운드 색상이 외부로 침범하지 않도록 합니다. */
}
.percent-bar input{
	display: none;
}

.percent-bar input:checked+label .hi {
	border: 1px solid black;
	border-radius: 50px;
	padding: 7px;
}
/* 퍼센트 바를 나타내는 색상 */
.percent-main .percent-bar {
    border-radius: 20px;
    background-color: rgba(255,0,0,0.5);
}



.right {
	float: right;
}
.record-percent{
	width: 82%;
	margin: auto;
	
	display: flex;
	justify-content: space-between;
}

.vote-team-name{
	align-items: center;
	font-family: abster;
	font-size: 20px;
    width: 90%;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px;
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
	<div class="bbs-border">
		<div class="bbs-express">
			<h1>투표참여</h1><br>
						<div class="button-flex">
						<div class="nothing">
						
						</div>
						<div class="p">
							<p>투표에 참여하여 포인트를 받으세요 !</p>
						</div>
						<div class="a">
							
						</div>
						</div>
		</div>
	</div>
	
<%
	
	java.sql.Date currentDate = new java.sql.Date(System.currentTimeMillis());

	// 데이터베이스 연결 설정
	ArrayList<Integer> teamScoreList = new ArrayList<>();
	%>
	<div class="container">
	<%
			Connection connection = null;
			PreparedStatement preparedStatement = null;
			ResultSet resultSet = null;
			
			ResultSet rs = null;
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
				
				String sql2 = "SELECT m.date, m.time, m.team1, m.team2, "
						+ "(SELECT COUNT(*) FROM vote WHERE voteRec = m.team1 AND gameId = m.id) AS team1_votes, "
						+ "(SELECT COUNT(*) FROM vote WHERE voteRec = m.team2 AND gameId = m.id) AS team2_votes "
						+ "FROM kbo_matches m WHERE m.date >= ? ORDER BY m.date, m.time";
				
				PreparedStatement sm = connection.prepareStatement(sql2);
				
				sm.setDate(1, currentDate);
				
				rs = sm.executeQuery();
				
				while(rs.next()){
					teamScoreList.add(rs.getInt("team2_votes"));
					teamScoreList.add(rs.getInt("team1_votes"));						
				}
				
				
						
						
				int i = 0;
				int voteCount = 1;
				while (resultSet.next()) {
					// 데이터베이스로부터 읽어온 경기 정보
					
				int team1 = teamScoreList.get(i);
				int team2 = teamScoreList.get(i+1);	
				double precent = (double)team1/((double)team1+(double)team2)*100;
				
				int showPercent = (int)precent;
				
			%>
			

		<div class="vote-main">
			<p><%=resultSet.getString("date")%>/<%=resultSet.getString("time")%></p>
			<form class="vote-form" action="voteProccess.jsp" name="vote<%=voteCount %>" onsubmit="return votecheck('<%=voteCount%>');">
			<input type="hidden" value="<%=resultSet.getInt("id")%>" name="gameId">
			<input type="submit" value="투표"class="btn-custom">
			<div class="vote-battle">
				<div class="vote-team1">
					<label for="<%=i%>">
					<img src="kbo/<%=resultSet.getString("team2")%>.png" style="width:100%; height: 100%;">
					</label>
				</div>
				<div class="vote-vs">
					<h1>VS</h1>
				</div>
				<div class="vote-team2">
					<label for="<%=i+1%>">
					<img src="kbo/<%=resultSet.getString("team1")%>.png" style="width:100%; height: 100%;">
					</label>
				</div>
			</div>
			<div class="vote-team-name">
				<div class="vote-team1">	
					<p><%=resultSet.getString("team2")%></p>
				</div>
				<div class="vote-vs">
				</div>
				
				<div class="vote-team2">
					<p><%=resultSet.getString("team1")%></p>
				</div>
			</div>
			<div class="percent-bar">
				<div class="percent1">
					<input type="radio" value="<%=resultSet.getString("team2")%>" id="<%=i %>" name="selectedTeam"><label
							for="<%=i%>"><div class="hi">승</div></label>
				</div>
			<%
				if(team1 < team2) //만약 홈팀보다 원정팀의 투표가 높다면
				{
			%>	

				<div class="percent-main">
					<div class="percent-bar right" style="width: <%= 100-showPercent %>%;"></div>
				</div>
			<%}else {%>

				<div class="percent-main">
					<div class="percent-bar" style="width: <%= showPercent %>%;"></div>
				</div>
				<%} %>
				<div class="percent1">
					<input type="radio" value="<%=resultSet.getString("team1")%>" id="<%=i+1 %>" name="selectedTeam"><label
							for="<%=i+1%>"><div class="hi">승</div></label>
				</div>
				
				
			</div>
			<div class="record-percent">
					<div>
						<p><%= showPercent %>%</p>
					</div>
					<div>
					<%if (team1 == 0 && team2 == 0) {%>
						<p>0%</p>
						<%}else{ %>
						<p><%= 100-showPercent %>%</p>
						<%} %>
					</div>
				</div>
			</form>
		</div>
		<%
			i += 2;
			voteCount ++;
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
	<script>
		function votecheck(formNumber){
			console.log("함수 호출됨 .");
			var f = document["vote" + formNumber];
			if (!f.selectedTeam.value) {
				alert("승부예측을 위한 팀을 선택해주세요! (팀 로고이미지를 누르면 선택됨)");
				return false;
			}
		}
	</script>
</body>
</html>