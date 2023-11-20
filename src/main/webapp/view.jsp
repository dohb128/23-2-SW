<%@page import="java.util.ArrayList"%>
<%@page import="sw2.BbsDAO, sw2.LikeDAO"%>
<%@page import="sw2.Bbs"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css"
	rel="stylesheet">
</head>
<title>KBO 게시판</title>
<style>
.like-button .fa-heart {
	color: red; /* 하트 색상 */
	margin-right: 5px; /* 텍스트와의 여백 */
}

.bbs-details {
	margin-bottom: 20px;
}

.bbs-details h2 {
	color: #007bff;
}

.bbs-details .bbs-content {
	padding: 15px;
	border: 1px solid #ddd;
	margin-bottom: 15px;
	background-color: #f9f9f9;
}
</style>
</head>
<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}

	// URL에서 bbsType 파라미터를 가져와서 변수에 저장합니다.
	String bbsType = request.getParameter("bbsType");
	if (bbsType == null || bbsType.trim().isEmpty()) {
		bbsType = "defaultType"; // 기본 타입 설정
	}

	int bbsID = 0;
	if (request.getParameter("bbsID") != null) {
		bbsID = Integer.parseInt(request.getParameter("bbsID"));
	}

	BbsDAO dao = new BbsDAO();
	Bbs bbs = dao.getBbs(bbsID);
	LikeDAO likeDAO = new LikeDAO();
	int likeCount = likeDAO.getLikeCount(bbsID);

	if (bbs == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글 입니다.')");
		script.println("location.href = 'bbs.jsp?bbsType=" + bbsType + "'");
		script.println("</script>");
		return;
	}
	%>


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
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<!-- 현재의 게시판 화면이라는 것을 사용자에게 보여주는 부분 -->
				<li class="active"><a href="bbs.jsp">게시판</a></li>
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
						<li><a href="join.jsp">회원가입</a></li>
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

	<!-- 게시판 틀 -->
	<div class="container">
		<div class="row">
			<table class="table table-striped"
				style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<!--테이블 제목 부분 구현 -->
						<th colspan="3"
							style="background-color: #eeeeee; text-align: center;">게시판 글
							보기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<!-- 게시판 글 보기 내부 1행 작성 -->
						<td style="width: 20%;">글 제목</td>
						<td colspan="2"><%=bbs.getBbsTitle()%></td>
					</tr>
					<tr>
						<!-- 게시판 글 보기 내부 2행 작성 -->
						<td>작성자</td>
						<td colspan="2"><%=bbs.getUserID()%></td>
					</tr>
					<tr>
						<!-- 게시판 글 보기 3행 작성 -->
						<td>작성일</td>
						<!-- bbs페이지에서 db에서 일자를 가져오는 소스코드를 참고 하는데 다른점은 내부 글의 데이터니까 아까만든 인스턴스에서 가져온다. -->
						<td colspan="2"><%=bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시"
		+ bbs.getBbsDate().substring(14, 16) + "분"%></td>
					</tr>
					<tr>
						<!-- 마지막 행 내용 최소 높이를 200px; 지정-->
						<td>내용</td>
						<!-- 들어갈 내용에 replaceAll을 사용해서 특수문자나 기호가 들어가도 정상 출력이 되게 해 주는 처리를 한다.
							replaceAll("공백","&nbsp;") 공백을 nbsp로 치환해서 출력해 줌 특수문자 치환을 넣어주면 크로스 브라우징 해킹방지도 가능하다.-->
						<td colspan="2" style="min-height: 200px; text-align: left;">
							<%=bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n",
		"<br>")%></td>
					</tr>
				</tbody>
			</table>

			<a href="javascript:void(0)" class="like-button"
				data-bbsid="<%=bbs.getBbsID()%>"> <i class="far fa-heart"></i> <!-- FontAwesome 클래스 'far fa-heart' 사용 -->
				좋아요 (<span id="like-count"><%=likeCount%></span>)
			</a>
			<!-- 목록으로 돌아갈 수 있는 버튼을 테이블 외부에서 작성해준다. -->
			<a href="bbs.jsp?bbsType=<%=bbsType%>" class="btn btn-primary">목록</a>

			<%
			//만약 글작성자가 본인일시 현재 페이지의 userID와 bbs Db내부의 UserID를 들고와서 비교 후
			if (userID != null && userID.equals(bbs.getUserID())) {
			%>
			<!-- 본인이라면 update.jsp에 bbsID를 가져갈 수 있게 해주고, 넘겨준다.-->
			<a href="update.jsp?bbsID=<%=bbsID%>&bbsType=<%=bbsType%>"
				class="btn btn-primary">수정</a>
			<!-- 삭제는 페이지를 거치지않고 바로 실행될꺼기때문에 Action페이지로 바로 보내준다. -->
			<a onclick="return confirm('정말 삭제하시겠습니까?')"
				href="deleteAction.jsp?bbsID=<%=bbsID%>&bbsType=<%=bbsType%>"
				class="btn btn-primary">삭제</a>
			<%
			}
			%>
		</div>
	</div>
	<!-- 애니매이션 담당 JQUERY -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<!-- 부트스트랩 JS  -->
	<script src="js/bootstrap.js"></script>
	<script>
		$(document).ready(
				function() {
					$('.like-button').click(
							function() {
								var bbsID = $(this).data('bbsid');
								var likeButton = $(this);
								var heartIcon = likeButton.find('.fa-heart');

								$.ajax({
									url : 'likeAction.jsp',
									type : 'POST',
									data : {
										bbsID : bbsID
									},
									success : function(response) {
										$('#like-count').text(response);
										// 하트 아이콘 상태 변경
										if (heartIcon.hasClass('far')) {
											heartIcon.removeClass('far')
													.addClass('fas').css(
															'color', 'red');
										} else {
											heartIcon.removeClass('fas')
													.addClass('far').css(
															'color', 'black');
										}
									}
								});
							});
				});
	</script>
</body>
</html>


