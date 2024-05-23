<%@page import="sw3.BbsDAO"%>
<%@page import="sw3.Bbs"%>
<%@page import="sw3.Bbs"%>
<%@page import="sw3.BbsDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- 뷰포트 -->
<meta name="viewport" content="width=device-width" initial-scale="1">
<!-- 스타일시트 참조  -->
<link rel="stylesheet" href="css/custom.css">
<link rel="stylesheet" href="style.css">

<title>KBO 게시판</title>
</head>
<body>
<%
	//로그인한 사람이라면 userID라는 변수에 해당 아이디가 담기고 그렇지 않으면 null 값
	String userID = null;
	if(session.getAttribute("userID")!= null){
		userID = (String) session.getAttribute("userID");
	}
	//로그인 안한 경우에 로그인 페이지로 돌려보내는 코드 작성
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.href = 'login.jsp'");
		script.println("</script>");
	}
	int bbsID = 0;
	//view페이지에서 넘겨준 bbsID를 들고오는 소스 코드
	if(request.getParameter("bbsID")!=null){
		//받은 bbsID를 정수형으로 반환해서 bbsID 인스턴스에 저장
		bbsID = Integer.parseInt(request.getParameter("bbsID"));
	}
	if(bbsID == 0){
		//다시 게시판 메인 페이지로 돌려보낸다.
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글 입니다.')");
		script.println("location.href = 'bbs.jsp'");
		script.println("</script>");	
	}
	
	String bbsType = request.getParameter("bbsType");
	//현재 작성한 글이 작성자가 일치하는지 확인해주는 소스코드 작성
	Bbs bbs = new BbsDAO().getBbs(bbsID,bbsType);
	//실제로 이 글의 작성자가 일치하는지 비교해준다. userID는 세션에 있는 값이고, bbs.getUserID는 이글을 작성한 사람의 값이다.
	if (!userID.equals(bbs.getUserID())) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다.')");
		//동일하지 않다면 오류를 출력해 돌려보내준다.
		script.println("location.href = 'bbs.jsp'");
		script.println("</script>");				
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
	<form method="post" action="updateAction.jsp?bbsID=<%= bbsID %>&bbsType=<%= bbsType%> ">
	<div class="bbs-border">
		<div class="bbs-express">
			<h1>게시글 수정</h1>
			<br>
			<div class="button-flex">
				<div class="nothing-5">
				
				</div>
				<div class="p-85">
					<p>※ 상업성광고, 정치적 목적 게시물, 특정단체나 개인의 명예훼손 게시물, 음란물 등 미풍양속에 어긋나는 게시물 게시자는 <br>민형사상 불이익을 받을 수 있으며 관리자의 권한으로 삭제 될 수 있으니 게시판 성격에 맞는 내용만 게시하시기 바랍니다.</p>
				</div>
				<div class="a-5">
					
				</div>
			</div>
		</div>
	</div>
			<div class="write-border">
			<div class="write-main">
				<input type="text" placeholder="글 제목" name="bbsTitle" maxlength="30">
				
				<textarea placeholder="글 내용" name="bbsContent" maxlength="2048"></textarea>
				
				<div class="write-btn">
						<input type="submit" class="button-width btn-custom" value="등록"/>
						<button type="button" class="button-back btn-custom" onclick="history.back();">취소</button>
				</div>
			</div>
		</div>
		</form>
		
		
</body>
</html>