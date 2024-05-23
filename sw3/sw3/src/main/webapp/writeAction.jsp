<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sw3.BbsDAO"%>
<!-- bbsdao의 클래스 가져옴 -->
<%@ page import="java.io.PrintWriter"%>
<!-- 자바 클래스 사용 -->
<%
request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>

<jsp:useBean id="bbs" class="sw3.Bbs" scope="page"/>
<jsp:setProperty property="bbsTitle" name="bbs"/>    
<jsp:setProperty property="bbsContent" name="bbs"/>
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>KBO 게시판</title>
</head>
<body>
<%
	String userID = null;
	if (session.getAttribute("userID") != null) {//유저아이디이름으로 세션이 존재하는 회원들은 
		userID = (String) session.getAttribute("userID");//유저아이디에 해당 세션값을 넣어준다.
	}
	
	if(userID == null){
		
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		//로그인 안된 사람들은 로그인 페이지로 이동하게 만들어주면 된다.
		script.println("location.href = 'login.jsp'");
		script.println("</script>");
		//로그인이 된 사람들은 이쪽으로 넘어가게 해준다.
	}
	
	
	
	else {
		//사용자가 만약에 제목이나, 내용을 입력하지 않았을 경우에 발생 할 상황
		if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안된 사항이 있습니다')");
			script.println("history.back()");
			script.println("</script>");
		//모든 조건이 다 만족 되었을때
		}else {
			//실제로 데이터 베이스에 등록을 해준다 BbsDAO 인스턴스를 만들고,
			BbsDAO BbsDAO = new BbsDAO();
         	String bbsType = request.getParameter("bbsType");
			//write함수를 실행해서 실제로 게시글을 작성 할 수 있게한다. 함수(차례대로 매개변수를 넣어준다.) 이러면 아주 간단하게 작동한다.
			int result = BbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent(), bbsType);
			//만약에 함수에 반환된 값이 -1라면 디비오류 발생이니까
			if (result == -1) {
				//실패띄워줌
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('글쓰기에 실패했습니다')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				//그렇지않으면 성공적으로 글을 작성한 부분이기때문에 게시판 메인화면으로 보낸다.
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href='bbs.jsp?bbsType="+bbsType+"'");
				//script.println("history.back()");
				script.println("</script>");
			}
		}
	}
%>
</body>
</html>