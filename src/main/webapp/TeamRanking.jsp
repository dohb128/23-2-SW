<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>KBO 팀 랜킹</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="tables.css">
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="style.css">

    <style>
        <!-- Add your styles here -->
    </style>
</head>
<body>
    <%
        String userID = (String) session.getAttribute("userID");
    %>

    <!-- Webpage common menu -->
    <%-- <%@ include file="commonMenu.jsp"%> --%>

    <div class="table-container">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>순위</th>
                    <th>팀 명</th>
                    <th>승률</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection connection = null;
                    PreparedStatement preparedStatement = null;
                    ResultSet resultSet = null;

                    try {
                        String jdbcUrl = "jdbc:mysql://35.177.120.128:3306/mydb";
                        String jdbcUser = "admin";
                        String jdbcPassword = "swvmfhwprxm2023";

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        connection = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);

                        String sql = "SELECT * FROM TeamRank;";
                        preparedStatement = connection.prepareStatement(sql);
                        resultSet = preparedStatement.executeQuery();

                        while (resultSet.next()) {
                %>
                            <tr>
                                <td><%=resultSet.getString("Ranking")%></td>
                                <td><%=resultSet.getString("Team")%></td>
                                <td><%=resultSet.getString("WP")%></td>
                            </tr>
                <%
                        }
                    } catch (Exception e) {
                        // Log the exception to a file or use a logging framework
                        e.printStackTrace();
                    } finally {
                        try {
                            if (resultSet != null) resultSet.close();
                            if (preparedStatement != null) preparedStatement.close();
                            if (connection != null) connection.close();
                        } catch (SQLException e) {
                            // Log or handle the exception
                            e.printStackTrace();
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>




