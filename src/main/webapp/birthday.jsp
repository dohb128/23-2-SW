<%@page import="java.util.Base64"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>🎉 생일축하합니다 🎉</title>
<style>
    .player-container {
        border: 1px solid #ccc;
        padding: 10px;
        margin: 10px;
        display: inline-block;
        text-align: center;
    }
    .player-photo {
        max-width: 200px;
        max-height: 200px;
    }
    .player-info {
        margin-top: 10px;
        font-weight: bold;
    }
    .birthday-message {
        font-size: 20px;
        margin-top: 10px;
    }
</style>
</head>
<body>
    <%
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    //생일인 선수 존재 확인 변수
    boolean birthdayExists = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String jdbcUrl = "jdbc:mysql://35.177.120.128:3306/mydb";
        String jdbcUser = "admin";
        String jdbcPassword = "swvmfhwprxm2023";
        connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);

        SimpleDateFormat dateFormat = new SimpleDateFormat("MM-dd");
        Date currentDate = new Date(System.currentTimeMillis());
        String formattedCurrentDate = dateFormat.format(currentDate);

        // SQL 쿼리를 생성하여 현재 월과 일과 일치하는 선수 찾기
        String sql = "SELECT pNo, pName, birth, photo FROM playerInfo WHERE DATE_FORMAT(birth, '%m-%d') = ?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, formattedCurrentDate);

        resultSet = preparedStatement.executeQuery();

        while (resultSet.next()) {
            //생일인 선수 존재
            birthdayExists = true;

            // 선수 정보 출력
            String pNo = resultSet.getString("pNo");
            String pName = resultSet.getString("pName");
            String birth = resultSet.getString("birth");
            byte[] photoData = resultSet.getBytes("photo");

            // 선수 컨테이너 시작
            out.println("<div class='player-container'>");

            // 이미지 출력
            if (photoData != null) {
                String base64Image = Base64.getEncoder().encodeToString(photoData);
                out.println("<img class='player-photo' src=\"data:image/jpeg;base64, " + base64Image + "\" alt=\"선수 이미지\">");
            } else {
                out.println("이미지가 없습니다.");
            }

            // 생일 메시지 출력
            out.println("<p class='birthday-message'>🎂" + pName + " 선수의 생일을 축하합니다🎂</p>");

            // 선수 정보 출력
            out.println("<p class='player-info'>선수 번호: " + pNo + "</p>");
            out.println("<p class='player-info'>생일: " + birth + "</p>");

            // 선수 컨테이너 종료
            out.println("</div>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (resultSet != null) {
            resultSet.close();
        }
        if (preparedStatement != null) {
            preparedStatement.close();
        }
        if (connection != null) {
            connection.close();
        }
    }
    %>
   
</body>
</html>