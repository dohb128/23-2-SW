<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<%
	String userID = null;

	if(session.getAttribute("userID") != null){
		userID = (String) session.getAttribute("userID");
	}
%>
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
								<li><a href="dropout.jsp">회원탈퇴</a></li>
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
		<br>
		<div class="section">
		<input type="radio" name="slide" id="slide01" checked>
		<input type="radio" name="slide" id="slide02" >
		<input type="radio" name="slide" id="slide03" >
		<input type="radio" name="slide" id="slide04">
		
		<div class="slidewrap">
			<ul class="slidelist">
				<li>
					<a href="vote.jsp">
						<label for="slide04" class="left"></label>
						<img src="image/vote.png">
						<label for="slide02" class="right"></label>
					</a>
				</li>
				<li>
					<a href="bbs.jsp?bbsType=bbsFun">
						<label for="slide01" class="left"></label>
						<img src="image/funnyBbs.png">
						<label for="slide03" class="right"></label>
					</a>
				</li>
				<li>
					<a href="bbs.jsp?bbsType=bbsMain">
						<label for="slide02" class="left"></label>
						<img src="image/normalBbs.png">
						<label for="slide04" class="right"></label>
					</a>
				</li>
				<li>
					<a href="bbs.jsp?bbsType=bbsBaseball">
						<label for="slide03" class="left"></label>
						<img src="image/baseballBbs.png">
						<label for="slide01" class="right"></label>
					</a>
				</li>
			</ul>
		</div>
	</div>
		
		<br>
		
		<div class ="team-plan-container"style='width: 900px; '>
			<img src="https://www.ppomppu.co.kr/images/baseball_pro5.gif" usemap='#Map' alt='야구 중계'
				style='width: 100%; height: 80px' />
		</div>
		<map name='Map' id='Map'>
			<area shape='rect' coords='75,0,157,80'
				href="https://www.doosanbears.com/season/sche/R" target="_blank"
				alt='두산' />
			<area shape='rect' coords='158,0,239,80'
				href="http://www.giantsclub.com/html/?pcode=257" target="_blank"
				alt='롯데' />
			<area shape='rect' coords='240,0,322,80'
				href="http://www.samsunglions.com/score/score_index.asp"
				target="_blank" alt='삼성' />
			<area shape='rect' coords='323,0,404,80'
				href="http://www.heroesbaseball.co.kr/games/schedule/list.do"
				target="_blank" alt='키움' />
			<area shape='rect' coords='405,0,487,80'
				href="https://www.hanwhaeagles.co.kr/GA/GE/PCFAGE01.do"
				target="_blank" alt='한화' />
			<area shape='rect' coords='488,0,569,80'
				href="https://tigers.co.kr/game/schedule/major/202007"
				target="_blank" alt='kia' />
			<area shape='rect' coords='570,0,652,80'
				href="http://www.lgtwins.com/service/html.ncd?view=%2Fpc_twins%2Ftwins_game%2Ftwins_planner&baRq=IN_DS&IN_DS.GYEAR=&IN_DS.GMONTH=&baRs=OUT_DS%2COUT_TEAM&actID=BR_RetrieveGameSchedule"
				target="_blank" alt='lg' />
			<area shape='rect' coords='653,0,734,80'
				href="https://www.ncdinos.com/game/majorSchedule.do" target="_blank"
				alt='nc' />
			<area shape='rect' coords='735,0,817,80'
				href="http://www.ssglanders.com/game/schedule" target="_blank"
				alt='ssg' />
			<area shape='rect' coords='818,0,899,80'
				href="https://www.ktwiz.co.kr/game/regular/schedule" target="_blank"
				alt='kt' />
		</map>
	</div>
	
	<div class = "container-ranking">
		<h1>🔥 🔥 배팅의 신 🔥 🔥</h1>
		<div class="ranking-main">
			<jsp:include page="rank.jsp"></jsp:include>
		</div>
	</div>
</body>
</html>