<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>KBO 웹사이트</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
	<%
	String userID = null;

	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	%>
	<script type="text/javascript">
	<!-- 선수 생일 팝업을 위한 스크립트 -->
		//생일인 선수가 있을 때만 팝업 나타내는 함수
		function checkBirthdayAndOpenPopup(hasBirthday) {
			if (hasBirthday) {
				openBirthdayPopup();
			}
		}

		function openBirthdayPopup() {
			// 팝업 창을 중앙에 위치하도록 조정
			var left = (screen.width - 500) / 2;
			var top = (screen.height - 400) / 2;
			window.open('birthday.jsp', 'BirthdayPopup',
					'width=500, height=400, top=' + top + ', left=' + left);
		}
	</script>
</head>
<body>
	<%
	boolean hasBirthday = false;
	Connection connection = null;
	PreparedStatement preparedStatement = null;
	ResultSet resultSet = null;

	try {
		// 데이터베이스 연결 설정
		String jdbcUrl = "jdbc:mysql://35.177.120.128:3306/mydb";
		String dbUser = "admin";
		String dbPassword = "swvmfhwprxm2023";
		Class.forName("com.mysql.cj.jdbc.Driver");
		connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

		// 현재 날짜를 MM-dd 형식으로 가져오기
		SimpleDateFormat dateFormat = new SimpleDateFormat("MM-dd");
		String today = dateFormat.format(new Date());

		// 생일인 선수가 있는지 확인하는 쿼리 실행
		String sql = "SELECT COUNT(*) FROM playerInfo WHERE DATE_FORMAT(birth, '%m-%d') = ?";
		preparedStatement = connection.prepareStatement(sql);
		preparedStatement.setString(1, today);
		resultSet = preparedStatement.executeQuery();

		// 결과가 1개 이상이면 생일인 선수가 존재하는 것
		if (resultSet.next() && resultSet.getInt(1) > 0) {
			hasBirthday = true;
		}
	} catch (Exception e) {
		// 오류 처리
		e.printStackTrace();
	} finally {
		// 자원 해제
		if (resultSet != null)
			try {
		resultSet.close();
			} catch (SQLException e) {
		e.printStackTrace();
			}
		if (preparedStatement != null)
			try {
		preparedStatement.close();
			} catch (SQLException e) {
		e.printStackTrace();
			}
		if (connection != null)
			try {
		connection.close();
			} catch (SQLException e) {
		e.printStackTrace();
			}
	}
	%>

	<script type="text/javascript">
		// 페이지 로딩 시 생일 확인 후 팝업 실행
		window.onload = function() {
			checkBirthdayAndOpenPopup(
	<%=hasBirthday%>
		);
		};
	</script>
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
	<br>
	<div class="section">
		<input type="radio" name="slide" id="slide01" checked> <input
			type="radio" name="slide" id="slide02"> <input type="radio"
			name="slide" id="slide03"> <input type="radio" name="slide"
			id="slide04">

		<div class="slidewrap">
			<ul class="slidelist">
				<li><a href="vote.jsp"> <label for="slide04" class="left"></label>
						<img src="image/vote.png"> <label for="slide02"
						class="right"></label>
				</a></li>
				<li><a href="bbs.jsp?bbsType=bbsFun"> <label for="slide01"
						class="left"></label> <img src="image/funnyBbs.png"> <label
						for="slide03" class="right"></label>
				</a></li>
				<li><a href="bbs.jsp?bbsType=bbsMain"> <label for="slide02"
						class="left"></label> <img src="image/normalBbs.png"> <label
						for="slide04" class="right"></label>
				</a></li>
				<li><a href="bbs.jsp?bbsType=bbsBaseball"> <label
						for="slide03" class="left"></label> <img
						src="image/baseballBbs.png"> <label for="slide01"
						class="right"></label>
				</a></li>
			</ul>
		</div>
	</div>

	<br>

	<div class="team-plan-container" style='width: 1543px;'>
		<img src="https://www.ppomppu.co.kr/images/baseball_pro5.gif"
			usemap='#Map' alt='야구 중계' style='width: 100%; height: 120px' />
	</div>
	<map name='Map' id='Map'>
		<area shape='rect' coords='128,0,269,120'
			href="https://www.doosanbears.com/season/sche/R" target="_blank"
			alt='두산' />
		<area shape='rect' coords='270,0,410,120'
			href="http://www.giantsclub.com/html/?pcode=257" target="_blank"
			alt='롯데' />
		<area shape='rect' coords='411,0,552,120'
			href="http://www.samsunglions.com/score/score_index.asp"
			target="_blank" alt='삼성' />
		<area shape='rect' coords='553,0,693,120'
			href="http://www.heroesbaseball.co.kr/games/schedule/list.do"
			target="_blank" alt='키움' />
		<area shape='rect' coords='694,0,835,120'
			href="https://www.hanwhaeagles.co.kr/GA/GE/PCFAGE01.do"
			target="_blank" alt='한화' />
		<area shape='rect' coords='836,0,976,120'
			href="https://tigers.co.kr/game/schedule/major/202007"
			target="_blank" alt='kia' />
		<area shape='rect' coords='977,0,1118,120'
			href="http://www.lgtwins.com/service/html.ncd?view=%2Fpc_twins%2Ftwins_game%2Ftwins_planner&baRq=IN_DS&IN_DS.GYEAR=&IN_DS.GMONTH=&baRs=OUT_DS%2COUT_TEAM&actID=BR_RetrieveGameSchedule"
			target="_blank" alt='lg' />
		<area shape='rect' coords='1119,0,1259,120'
			href="https://www.ncdinos.com/game/majorSchedule.do" target="_blank"
			alt='nc' />
		<area shape='rect' coords='1260,0,1400,120'
			href="http://www.ssglanders.com/game/schedule" target="_blank"
			alt='ssg' />
		<area shape='rect' coords='1401,0,1542,120'
			href="https://www.ktwiz.co.kr/game/regular/schedule" target="_blank"
			alt='kt' />
	</map>


	<div class="container-ranking">
		<div class="ranking-main">
			<jsp:include page="rank.jsp"></jsp:include>
		</div>
	</div>
	 <div class="thumbnail chat-image">
        <a href="chatting.jsp"><img src="image/chat.png" alt="Chatting"></a>
    </div>
    
    <c:choose>
    	<c:when test="${userID == 'ts'}">
    		<a href="gmVoteResult.jsp" class="btn-custom">관리자</a>
    	</c:when>
    </c:choose>
	
</body>
</html>