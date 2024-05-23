<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="style.css">
<title>회원가입</title>
<script type="text/javascript">
		function checkFun() {
			// 유효성 검사.
			var f = document.userInfo;
			if(f.userID.value.length < 2 || f.userID.value.length > 16) {
				alert("아이디는 2~16글자 이내로 입력해야 합니다.")
				f.userID.focus();
				return false
			}
			else if(f.userID.value == ""){
				alert("아이디를 입력해주세요.")
				f.userID.focus();
				return false
			}
			
			//  밑에도 추가로 원하는 작업 하면됨.
			
			else if(f.userPassword.value == ""){
				alert("비밀번호르르 입력해주세요.")
				f.userPassword.focus();
				return false;
			}
			
			else if(f.userName.value == ""){
				alert("이름을 입력해주세요.")
				f.userName.focus();
				return false;
			}
			else if(f.userEmail.value == ""){
				alert("이메일을 입력해주세요.")
				f.userEmail.focus();
				return false;
			}
			
			
		}
		


</script>
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
	<div class="container-signform">
		<div class="signform">
			<div class="signform-main">
				<br>
				<h2>회원가입</h2>
				<div class="signform-input">
					<form method="post" action="signup_proccess.jsp" name="userInfo" onsubmit="return checkFun()">
						<input type="text" class="form-control" id="inputEmail3" name="userID" maxlength="12" placeholder="id">
						<input type="password" class="form-control" id="inputPassword3" name="userPassword" maxlength="12" placeholder="password">
						<input type="text" class="form-control" placeholder="name" name="userName" maxlength="5" placeholder="name">	
						<input type="email" class="form-control" placeholder="email" name="userEmail" maxlength="30" placeholder="email">
						<button type="submit" >가입</button>
					</form>
				</div>
			</div>
		</div>
	</div>
		
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>
