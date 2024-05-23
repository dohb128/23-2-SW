<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=divice-width" , initial-scale="1">
<link rel="stylesheet" href="style.css">
<title>KBO 게시판</title>
</head>
<body>
	<div class="container-mine">
		<div class="painted">
			<div class="header">
				<div class="nav">
					<ul>
						<li><a href="login.jsp">로그인</a></li>
						<li><a>|</a></li>
						<li><a href="signup.jsp">회원가입</a></li>
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
	<br>
	
	<div class="loginform">
			<div class="loginform-main">
				<br>
				<h2>로그인</h2>
				<div class="loginform-input">
				 <form action="loginAction.jsp" method="post" name="userInfo" onsubmit="return check()">
					<input type="text" class="form-control" id="inputEmail3" name="userID" maxlength="12" placeholder="id">
					<input type="password" class="form-control" id="inputPassword3" name="userPassword" maxlength="12" placeholder="password">
					<button type="submit" >확인</button>
				</form>
				</div>
			</div>
		</div>
	<script>
		function check() {
			var f = document.userInfo;
			if(f.userID.value == ""){
				alert("아이디를 입력해주세요.")
				f.userID.focus();
				return false;
			}
			else if(f.userPassword.value == ""){
				alert("비밀번호를 입력해주세요.")
				f.userPassword.focus();
				return false;
			}
		}
	</script>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>