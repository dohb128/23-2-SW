<%@page import="sw3.BbsDAO"%>
<%@page import="sw3.Bbs,sw3.LikeDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/custom.css">
<link rel="stylesheet" href="style.css">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
</head>
<title>KBO 게시판</title>
</head>
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
<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}

	// 로그인 상태를 확인합니다.
	boolean isLoggedIn = userID != null;

	String bbsType = request.getParameter("bbsType");
	if (bbsType == null || bbsType.trim().isEmpty()) {
		bbsType = "defaultType"; // 기본 타입 설정
	}

	int bbsID = 0;
	if (request.getParameter("bbsID") != null) {
		bbsID = Integer.parseInt(request.getParameter("bbsID"));
	}

	BbsDAO dao = new BbsDAO();
	Bbs bbs = dao.getBbs(bbsID, bbsType);
	LikeDAO likeDAO = new LikeDAO();
	int likeCount = likeDAO.getLikeCount(bbsID, bbsType);
	boolean userLiked = likeDAO.userLiked(bbsID, userID, bbsType);
	String heartClass = userLiked ? "fas" : "far";

	if (bbsID == 0) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글 입니다.')");
		script.println("location.href = 'bbs.jsp?bbsType=" + bbsType + "'");
		script.println("</script>");
		return;
	}
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
	</div>
	<!-- 화면 공통메뉴 끝 -->
	<div class="bbs-border">
		<div class="bbs-express">
			<h1><%=bbs.getBbsTitle()%></h1>
			<br>
			<div class="button-flex">
				<div class="nothing-5"></div>
				<div class="p-85"></div>
				<div class="a-5"></div>
			</div>
		</div>
	</div>
	<!-- 게시판 틀 -->
	<div class="view-logo">
		<p>
			작성자 :
			<%=bbs.getUserID()%></p>
		<p>
			작성일 :
			<%=bbs.getBbsDate().substring(0, 11)%></p>
			<a href="javascript:void(0)"
		class="like-button <%=!isLoggedIn ? "requires-login" : ""%>"
		data-bbsid="<%=bbs.getBbsID()%>"> <i
		class="<%=heartClass%> fa-heart"></i> 좋아요 (<span id="like-count"><%=likeCount%></span>)
	</a>
	</div>
	<div class="view-content">
		<p>
			<%=bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n",
		"<br>")%>
		</p>
	</div>
	<div class="view-button">
		<a href="bbs.jsp?bbsType=<%=bbsType%>" class="btn-custom">목록</a>
		
		<div class="view-button-2">
			<%
			//만약 글작성자가 본인일시 현재 페이지의 userID와 bbs Db내부의 UserID를 들고와서 비교 후
			if (userID != null && userID.equals(bbs.getUserID())) {
			%>
			<a
				href="update.jsp?bbsID=<%=bbsID%>&bbsType=<%=bbsType%>&bbsType=<%=bbsType%>"
				class="btn-custom">글수정</a> <a
				onclick="return confirm('정말 삭제하시겠습니까?')"
				href="deleteAction.jsp?bbsID=<%=bbsID%>&bbsType=<%=bbsType%>"
				class="btn-custom">글삭제</a>
			<%
			}
			%>
		</div>
	</div>
	<!-- 삭제는 페이지를 거치지않고 바로 실행될꺼기때문에 Action페이지로 바로 보내준다. -->

	<script>
	$(document).ready(function() {
	    $('.like-button').click(function() {
	        // 로그인이 필요한 경우
	        if ($(this).hasClass('requires-login')) {
	            window.location.href = 'login.jsp'; // 로그인 페이지로 리디렉션
	            return; // 이벤트 핸들러 종료
	        }

	        var bbsID = $(this).data('bbsid');
	        var likeButton = $(this);
	        var heartIcon = likeButton.find('.fa-heart');

	        $.ajax({
	            url: 'likeAction.jsp',
	            type: 'POST',
	            data: {
	                bbsID: bbsID,
	                bbsType: '<%=bbsType%>'
					},
					success : function(response) {
						// 현재 페이지 새로고침
						location.reload();
					}
				});
			});
		});
	</script>
</body>
</html>