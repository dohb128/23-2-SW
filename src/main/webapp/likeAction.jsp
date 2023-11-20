<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, javax.sql.*" %>
<%@ page import="sw2.BbsDAO" %>
<%@ page import="sw2.LikeDAO" %>

<%
    String userID = (String) session.getAttribute("userID");
    if (userID == null) {
        // 사용자가 로그인하지 않은 경우 처리
        response.getWriter().write("로그인 필요");
    } else {
        int bbsID = Integer.parseInt(request.getParameter("bbsID"));

        LikeDAO likeDAO = new LikeDAO();
        try {
            boolean likeResult = likeDAO.addLike(bbsID, userID); // "좋아요" 추가 또는 제거
            int likeCount = likeDAO.getLikeCount(bbsID); // 현재 "좋아요" 수 조회
            response.getWriter().write(String.valueOf(likeCount)); // 클라이언트에게 "좋아요" 수 반환
        } catch (Exception e) {
            // 에러 처리
            response.getWriter().write("오류 발생");
        } finally {
            
        }
    }
%>

