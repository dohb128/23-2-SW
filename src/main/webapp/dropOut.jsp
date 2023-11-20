<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=divice-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="style.css">
<title>회원 탈퇴</title>
</head>
<body>
	<%
	//로그인한 사람이라면 userID라는 변수에 아이디 담기고 그렇지않다면 null
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");

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
	
	<div class="container-signform">
		<div class="signform">
			<div class="signform-main">
				<br>
				<h2>회원탈퇴</h2>
				<div class="signform-input">
					<form method="post" action="signup_proccess.jsp" name="userInfo" onsubmit="return checkFun()">
						<p>계정 : <%=userID %></p>
						<input type="password" class="form-control" id="inputPassword3" name="userPassword" maxlength="12" placeholder="password">
						<div class="input_chk">
							<input type="checkbox" class="chk" id="termsEmail" name="userCheck">
							<label for="termsEmail" id="termsEmailLb">회원 탈퇴 시 다시 복구하지 못합니다. 이에 동의하십니까?(체크박스 필수)</label>
						</div>
						<button type="submit" >회원 탈퇴</button>
					</form>
				</div>
			</div>
		</div>
	</div>
	<script>
		function check() {
			var f = document.dropInfo; //form 값
			if(!f.userCheck.checked){
				alert("체크박스를 선택해주세요");
				return false;
			}
			else if(f.userPassword.value == ""){
				alert("비밀번호를 입력하세요.");
				f.userPassword.focus();
				return false;
			}
			
		}
	</script>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>