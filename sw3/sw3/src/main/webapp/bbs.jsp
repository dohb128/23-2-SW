<%@page import="java.util.ArrayList"%>
<%@page import="sw3.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="sw3.Bbs"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1">
<!-- 반응형 웹에 사용하는 메타태그 -->
<!-- 참조  -->
<link rel="stylesheet" href="style.css">
<title>KBO 게시판</title>
<style type="text/css">
@font-face {
	font-family: abster-light;
	src:url(font/KBO-Dia-Gothic_light.woff) format('woff');
}
	table{border-collapse: collapse; font-family: abster-light;}
	th{color: #BDBDBD; padding: 15px; text-align: center;}
	td{text-align: center; padding: 15px;}
	
	th{border-bottom: 1px solid black;}
	td{border-bottom: 1px solid rgba(0, 0, 0, .2);}
	th:nth-child(1), td:nth-child(1),th:nth-child(2), td:nth-child(2) {
	text-align: left;	
}
	th:nth-child(4), td:nth-child(4) {
	text-align: right;	
}
	


td a {
	text-decoration: none;
	color: black ;
}

td a:hover {
	color: #BDBDBD;
}

.th-10{
	width: 10%;
}

.th-15{
	width: 15%;
}

.th-60{
	width: 60%;
}
</style>
</head>
<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null)
	{
		userID = (String)session.getAttribute("userID");
	}
	// 기본적으로 페이지 1부터 선언
	int pageNumber = 1 ;
	
	//만약 파라미터로 넘어올경우 해당 파라미터 값을 넣어준다.
	if(request.getParameter("pageNumber") != null)
	{
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
	}
 	String bbsType = request.getParameter("bbsType");

	
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
						<li><a href="bbs.jsp?bbsType=bbsMain">자유게시판</a></li>
						<li><a href="bbs.jsp?bbsType=bbsBaseball">야구게시판</a></li>
						<li><a href="vote.jsp">투표하기</a></li>
					</ul>
				</div>
			</div>


		</div>
	</div>
	<!-- 특정한 내용들을 담을 공간을 확보 해준다.-->
	
	<div class="bbs-border">
		<div class="bbs-express">	
			<c:choose>
					<c:when test="${userID == null }">
						<h1>게시물 확인 불가. 로그인 필요</h1>
						<% bbsType = null; %>
					</c:when>
					<c:when test="${param.bbsType =='bbsFun'}">
						<h1>유머게시판</h1>
						<div class="button-flex">
						<div class="nothing">
						
						</div>
						<div class="p">
							<p>재미있는 소식들을 게시판에 올리실 수 있습니다.</p>
						</div>
						<div class="a">
							<a href="write.jsp?bbsType=<%=bbsType %>"
							class="btn-custom btn-right">게시글등록</a>
						</div>
						</div>
					</c:when>
					<c:when test="${param.bbsType =='bbsMain'}">
						<h1>자유게시판</h1>
						<div class="button-flex">
						<div class="nothing">
						
						</div>
						<div class="p">
							<p>누구나 자유롭게 의견을 올리실 수 있습니다.</p>
						</div>
						<div class="a">
							<a href="write.jsp?bbsType=<%=bbsType %>"
							class="btn-custom btn-right">게시글등록</a>
						</div>
						</div>
					</c:when>
					<c:when test="${param.bbsType =='bbsBaseball'}">
						<h1>야구게시판</h1>
						<div class="button-flex">
						<div class="nothing">
						
						</div>
						<div class="p">
							<p>야구 관련 정보를 올리실 수 있습니다.</p>
						</div>
						<div class="a">
							<a href="write.jsp?bbsType=<%=bbsType %>"
							class="btn-custom btn-right">게시글등록</a>
						</div>
						</div>
					</c:when>
					
				</c:choose>
				
		</div>
		</div>
	<div style=" width:1150px ; margin: 0 auto ;">
		<!-- 테이블이 들어갈 수 있는 공간 구현 -->
		
			<table style=" width:100%;">
				<!-- thead는 테이블의 제목부분에 해당함 -->
				
				<tr>
					<th class="th-10">NO</th>
					<th class="th-60">제목</th>
					<th class="th-15">작성자</th>
					<th class="th-15">작성일</th>
				</tr>
				<%
                 	//게시글 담을 인스턴스
                 	BbsDAO bbsDAO = new BbsDAO();

                 	ArrayList<Bbs> list = bbsDAO.getList(pageNumber, bbsType);
                 	for(int i = 0; i < list.size(); i++)
                 	{
         %>
				
				<tr>
					<td><%= list.get(i).getBbsID() %></td>
					<td><a
						href="view.jsp?bbsID=<%=list.get(i).getBbsID() %>&bbsType=<%= bbsType%>"><%= list.get(i).getBbsTitle() %></a>
					</td>
					<td><%= list.get(i).getUserID() %></td>
					<td><%= list.get(i).getBbsDate().substring(0,11) %>
					</td>
				</tr>
				<%} %>
			</table>
			<div class="next-bbs">
			<%
            	//테이블 밑에 이전 버튼과 다음 버튼을 구현
            	if(pageNumber != 1){
            %>
			<!--페이지넘버가 1이 아니면 전부다 2페이지 이상이기 때문에 pageN에서 1을뺀값을 넣어서 게시판
            	 메인화면으로 이동하게 한다. class내부 에는 화살표모양으로 버튼이 생기게 하는 소스작성 아마 부트스트랩 기능인듯.-->
            
			<a href="bbs.jsp?pageNumber=<%=pageNumber - 1 %>&bbsType=<%= bbsType%>"
				class="btn-custom btn-left">이전</a>
			<%
            	//BbsDAO에서 만들었던 함수를 이용해서, 다음페이지가 존재 할 경우
                } if (bbsDAO.nextPage( pageNumber + 1, bbsType)) {
            %>
			<!-- a태그를 이용해서 다음페이지로 넘어 갈 수있는 버튼을 만들어 준다. -->
			<a href="bbs.jsp?pageNumber=<%=pageNumber + 1 %>&bbsType=<%= bbsType%>"
				class="btn-custom btn-left">다음</a>
			<%
                }
            %>
            </div>


			<!-- 테이블 자체는 글의 목록을 보여주는 역할밖에 하지않는다. 글을 쓸수있는 화면으로 넘어갈 수 있는 태그 설정-->
			
		</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	

</body>
</html>