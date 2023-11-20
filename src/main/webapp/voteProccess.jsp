<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.servlet.*"%>

<%
    String userID = (String) session.getAttribute("userID");
    if (userID == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String gameIdParam = request.getParameter("gameId");
    String selectedTeam = request.getParameter("selectedTeam");

    if (gameIdParam == null || gameIdParam.trim().isEmpty()) {
        response.sendRedirect("vote.jsp");
        return;
    }

    int gameId = 0;
    try {
        gameId = Integer.parseInt(gameIdParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("vote.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmtCheckVote = null;
    PreparedStatement pstmtInsertVote = null;
    ResultSet rs = null;

    try {
        String jdbcUrl = "jdbc:mysql://35.177.120.128:3306/mydb";
        String jdbcUser = "admin";
        String jdbcPassword = "swvmfhwprxm2023";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);

        // 사용자가 이미 해당 경기에 투표했는지 확인합니다.
        String checkVoteSql = "SELECT 1 FROM vote WHERE userId = ? AND gameId = ?";
        pstmtCheckVote = conn.prepareStatement(checkVoteSql);
        pstmtCheckVote.setString(1, userID);
        pstmtCheckVote.setInt(2, gameId);
        rs = pstmtCheckVote.executeQuery();

        if (rs.next()) {
            // 이미 투표한 경우 메시지를 띄우고 메인 페이지로 리디렉트합니다.
            out.println("<script>alert('이미 투표했습니다.'); location.href='main.jsp';</script>");
            return;
        }

        // 경기 날짜와 시간을 가져옵니다.
        String matchSql = "SELECT date, time FROM kbo_matches WHERE id = ?";
        pstmtInsertVote = conn.prepareStatement(matchSql);
        pstmtInsertVote.setInt(1, gameId);
        rs = pstmtInsertVote.executeQuery();
        
        if (rs.next()) {
            Timestamp matchDateTime = Timestamp.valueOf(rs.getString("date") + " " + rs.getString("time"));

            // 투표 정보를 삽입합니다.
            String voteSql = "INSERT INTO vote (gameId, date, voteRec, userId) VALUES (?, ?, ?, ?)";
            pstmtInsertVote = conn.prepareStatement(voteSql);
            pstmtInsertVote.setInt(1, gameId);
            pstmtInsertVote.setTimestamp(2, matchDateTime);
            pstmtInsertVote.setString(3, selectedTeam);
            pstmtInsertVote.setString(4, userID);

            int result = pstmtInsertVote.executeUpdate();
            if (result > 0) {
                // 투표 성공 시 메시지를 띄우고 메인 페이지로 리디렉트합니다.
                out.println("<script>alert('투표에 성공했습니다.'); location.href='vote.jsp';</script>");
            } else {
                // 투표 실패 시 메시지를 띄우고 메인 페이지로 리디렉트합니다.
                out.println("<script>alert('투표를 처리할 수 없습니다.'); location.href='vote.jsp';</script>");
            }
        } else {
            response.sendRedirect("vote.jsp?error=noMatch");
        }
    } catch (SQLException e) {
        response.sendRedirect("error.jsp?error=sqlException&message=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
    } catch (Exception e) {
        response.sendRedirect("error.jsp?error=generalException&message=" + URLEncoder.encode(e.getMessage(), "UTF-8"));
    } finally {
        if (rs != null) try { rs.close(); } catch(SQLException ex) {}
        if (pstmtCheckVote != null) try { pstmtCheckVote.close(); } catch(SQLException ex) {}
        if (pstmtInsertVote != null) try { pstmtInsertVote.close(); } catch(SQLException ex) {}
        if (conn != null) try { conn.close(); } catch(SQLException ex) {}
    }
%>