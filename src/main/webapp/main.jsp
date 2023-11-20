<%@page import="java.util.Base64"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=divice-width" , initial-scale="1">
<title>KBO 게시판</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="styles.css">
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
    var left = (screen.width - 440) / 2;
    var top = (screen.height - 400) / 2;
    window.open('birthday.jsp', 'BirthdayPopup', 'width=440, height=400, top=' + top + ', left=' + left);
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
	    String dbPassword = "1234";
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
	    if (resultSet != null) try { resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
	    if (preparedStatement != null) try { preparedStatement.close(); } catch (SQLException e) { e.printStackTrace(); }
	    if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
	}
	//로그인한 사람이라면 userID라는 변수에 아이디 담기고 그렇지않다면 null
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");

	}
	%>

<script type="text/javascript">
    // 페이지 로딩 시 생일 확인 후 팝업 실행
    window.onload = function() {
        checkBirthdayAndOpenPopup(<%= hasBirthday %>);
    };
</script>
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
							<li><a href="bbs.jsp?bbsType=bbsFun">유머게시판</a></li>
							<li><a href="bbs.jsp?bbsType=bbsMain">일반게시판</a></li>
							<li><a href="bbs.jsp?bbsType=bbsBaseball">야구게시판</a></li>
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

	<!-- 경기 일정을 유머, 일반, 야구 게시판 왼쪽에 나열하고 오른쪽에 경기 일정 표시 -->
	<div class="container">
		<div class="jumbotron">
			<h1>이벤트 배너</h1>
			<p>승리 예측 투표가 들어갈 예정</p>
			<p>
				<a class="btn btn-primary" href="vote.jsp" role="button">투표하기</a>
				<c:choose>
					<c:when test="${userID == 'ts' }">
						<!-- 관리자만 보이게 설정 -->
						<a class="btn btn-primary" href="gmVoteResult.jsp" role="button">경기
							투표 (관리자 전용)</a>
					</c:when>
				</c:choose>
			</p>
		</div>
		<div class="row">
			<div class="row">
				<!-- 왼쪽 영역 (게시판) -->
				<div class="col-sm-6 col-md-4">
					<div class="thumbnail">
						<p>
							<a href="bbs.jsp?bbsType=bbsFun" class="btn btn-primary"
								role="button" style="float: right;">+</a>
						</p>
						<div class="caption">
							<h3>유머게시판</h3>
							<p>유머 게시판 입니다.</p>
						</div>
					</div>
					<div class="thumbnail">
						<p>
							<a href="bbs.jsp?bbsType=bbsMain" class="btn btn-primary"
								role="button" style="float: right;">+</a>
						</p>
						<div class="caption">
							<h3>일반게시판</h3>
							<p>일반 게시판 입니다.</p>
						</div>
					</div>
					<div class="thumbnail">
						<p>
							<a href="bbs.jsp?bbsType=bbsBaseball" class="btn btn-primary"
								role="button" style="float: right;">+</a>
						</p>
						<div class="caption">
							<h3>야구게시판</h3>
							<p>야구 게시판 입니다.</p>
						</div>
					</div>
				</div>
				<!-- 중앙 영역 (schedule.jsp 페이지 리다이렉트) -->
				<div class="col-sm-6 col-md-4">
					<div class="thumbnail">
						<div class="caption">
							<jsp:include page="schedule.jsp" />
						</div>
					</div>
				</div>
				<!-- 오른쪽 영역 (rank.jsp 페이지 리다이렉트) -->
				
				<div class="col-sm-6 col-md-4">
					<div class="thumbnail">
						<div class="caption">
							<jsp:include page="rank.jsp" />
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>