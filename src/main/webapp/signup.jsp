<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="styles.css">
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
			
	         
	         else if(f.userPassword.value == ""){
	            alert("비밀번호를 입력해주세요.")
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
	<div class="container">
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<div class="jumbotron" style="padding-top: 20px;">
				<form method="post" action="signup_proccess.jsp" name="userInfo"
					onsubmit="return checkFun()">
					<h3 style="text-align: center;">회원가입</h3>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="ID"
							name="userID" maxlength="20">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="Password"
							name="userPassword" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="name"
							name="userName" maxlength="5">
					</div>
					<div class="form-group">
						<input type="email" class="form-control" placeholder="email"
							name="userEmail" maxlength="30">
					</div>
					<input type="submit" class="btn btn-primary form-control"
						value="가입하기">
				</form>
			</div>
		</div>
		<div class="col-lg-4"></div>
	</div>


	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>
