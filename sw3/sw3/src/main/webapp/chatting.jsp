<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">

<link rel="stylesheet" href="style.css">

<title>실시간 익명 채팅 사이트</title>
<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<script type="text/javascript">

	var lastID = 0;
	
	function submitFunction() {
		var chatName = $('#chatName').val();
		var chatContent = $('#chatContent').val();
		$.ajax({
			type : "POST",
			url : "./ChatSubmitServlet",
			data : {
				chatName : encodeURIComponent(chatName),
				chatContent : encodeURIComponent(chatContent)
			},
			success : function(result) {
				console.log(result)
				if (result == 1) {
					autoClosingAlert('#successMessage', 2000);
					
					// 채팅이 성공적으로 전송되었으므로, lastID를 업데이트합니다.
					lastID++;
				} else if (result == 0) {
					autoClosingAlert('#dangerMessage', 2000);
				} else {
					autoClosingAlert('#successMessage', 2000);
				}
			}
		});
		$('#chatContent').val('');
	}
	
	function autoClosingAlert(selector, delay) {
		var alert = $(selector).alert();
		alert.show();
		window.setTimeout(function() {
			alert.hide()
		}, delay);
	}

	function chatListFunction(type) {
	    $.ajax({
	        type : "POST",
	        url : "./ChatListServlet",
	        data : {
	            listType : type,
	        },
	        success : function(data) {
	            if (data == "")
	                return;
	            var parsed = JSON.parse(data);
	            var result = parsed.result;
	            for (var i = 0; i < result.length; i++) {
	                addChat(result[i][0].value, result[i][1].value,
	                        result[i][2].value);
	            }
	            lastID = Number(parsed.last);
	            isUpdating = false;
	        }
	    });
	}
	
	function addChat(chatName, chatContent, chatTime) {
        $('#chatList').append(
            '<div class="row">' +
            '<div class="col-lg-12">' +
            '<div class="media">' +
            '<a class="pull-left" href="#">' +
            '<img class="media-object img-circle" src="image/icon.png" alt="" width="60" height="60">' +
            '</a>' +
            '<div class="media-body">' +
            '<h4 class="media-heading">' + chatName +
            '<span class="small pull-right">' + chatTime + '</span>' + // 'formattedTime'을 'chatTime'으로 변경하였습니다.
            '</h4>' +
            '<p>' + chatContent + '</p>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '<hr>'
        );

        $('#chatList').scrollTop($('#chatList')[0].scrollHeight);
    }



	function getInfiniteChat() {
		setInterval(function() {
			chatListFunction(lastID);
		}, 3000);  // db에 업로드 되는 속도가 새로고침이 속도와 맞지 않아 여러번 뜨는 오류 발생
	}

</script>
</head>
<body>
<div class="container-mine">
		
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
	<div class="container">
		<div class="container bootstrap snippet">
			<div class="row">
				<div class="col-xs-12">
					<div class="portlet portlet-default">
						<div class="portlet-heading">
							<div class="portlet-title">
								<h4>
									<i class="fa fa-circle text-green"></i>실시간채팅방
								</h4>
							</div>
							<div class="clearfix"></div>
						</div>
						<div id="chat" class="panel-collapse collapse in">
							<div id="chatList" class="portlet-body char-widget"
								style="overflow-y: auto; width: auto; height: 600px;"></div>
						</div>
						<div class="portlet-footer">
							<div class="row">
								<div class="form-group col-xs-4">
									<input style="height: 40px;" type="text" id="chatName"
										class="form-control" placeholder="이름" maxlength="8">
								</div>
							</div>
							<div class="row" style="height: 90px">
								<div class="form-group col-xs-10">
									<textarea style="height: 80px;" id="chatContent"
										class="form-control" placeholder="메시지를입력하시오" maxlength="100"></textarea>
								</div>
								<div class="form-group col-xs-2">
									<button type="button" class="btn btn-default pull-right"
										onclick="submitFunction();">전송</button>
									<div class="clearfix"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="alert alert-success" id="successMessage"
			style="display: none;">
			<strong>메시지 전송에 성공하였습니다.</strong>
		</div>
		<div class="alert alert-danger" id="dangerMessage"
			style="display: none;">
			<strong>이름과 내용을 모두 입력해주세요.</strong>
		</div>
		<div class="alert alert-warning" id="warningMessage"
			style="display: none;">
			<strong>데이터베이스 오류가 발생했습니다.</strong>
		</div>
	</div>
	<script type="text/javascript">
		// 문서가 준비되면 초기화 함수 호출
		$(document).ready(function() {
			chatListFunction('ten');
			getInfiniteChat();
		});
	</script>
</body>
</html>
