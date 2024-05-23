package sw3;

import java.sql.*;
import java.util.*;

public class ChatDAO {
	private Connection conn;

	public ChatDAO() {
		try {
			// JDBC 드라이버 로드
			Class.forName("com.mysql.cj.jdbc.Driver");

			// 연결 URL에 useUnicode 및 characterEncoding, 서울 시간 속성 추가
			String url = "jdbc:mysql://35.177.120.128:3306/mydb?characterEncoding=UTF-8&serverTimezone=Asia/Seoul";

			// 연결
			conn = DriverManager.getConnection(url, "admin", "swvmfhwprxm2023");
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	

	public ArrayList<Chat> getChatListByRecent(String chatID) {
		ArrayList<Chat> chatList = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String SQL = "SELECT * FROM CHAT WHERE chatID > ? ORDER BY chatTime";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(chatID));
			rs = pstmt.executeQuery();

			chatList = new ArrayList<>();

			while (rs.next()) {
				Chat chat = new Chat();
				chat.setChatID(rs.getInt("chatID"));
				chat.setChatName(rs.getString("chatName"));
				chat.setChatContent(rs.getString("chatContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
						.replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11, 13));
				String timeType = "오전";
				if (Integer.parseInt(rs.getString("chatTime").substring(11, 13)) >= 12) {
					timeType = "오후";
					chatTime -= 12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0, 11) + " " + timeType + " " + chatTime + ":"
						+ rs.getString("chatTime").substring(14, 16) + " ");
				chatList.add(chat);
			}

		} catch (SQLException e) {
			e.printStackTrace();
			return new ArrayList<>(); // SQL 예외 발생 시 빈 리스트 반환
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return chatList;
	}

	public ArrayList<Chat> getChatListByRecent(int number) {
		ArrayList<Chat> chatList = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String SQL = "SELECT * FROM CHAT WHERE chatTime > (SELECT MAX(chatID) - ? FROM CHAT) ORDER BY chatTime";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, number);
			rs = pstmt.executeQuery();

			chatList = new ArrayList<Chat>();

			while (rs.next()) {
				Chat chat = new Chat();
				chat.setChatID(rs.getInt("chatID"));
				chat.setChatName(rs.getString("chatName"));
				chat.setChatContent(rs.getString("chatContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt")
						.replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11, 13));
				String timeType = "오전";
				if (Integer.parseInt(rs.getString("chatTime").substring(11, 13)) >= 12) {
					timeType = "오후";
					chatTime -= 12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0, 11) + " " + timeType + " " + chatTime + ":"
						+ rs.getString("chatTime").substring(14, 16) + " ");
				chatList.add(chat);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return chatList;
	}

	// 특정한 시간대에서 메시지를 가져오는 메소드
	public ArrayList<Chat> getChatList(String nowTime) {
		ArrayList<Chat> chatList = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String SQL = "SELECT * FROM CHAT WHERE chatTime > ? ORDER BY chatTime";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, nowTime);
			rs = pstmt.executeQuery();

			chatList = new ArrayList<Chat>();

			while (rs.next()) {
				Chat chat = new Chat();
				chat.setChatID(rs.getInt("chatID"));
				chat.setChatName(rs.getString("chatName"));
				chat.setChatContent(rs.getString("chatContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt")
						.replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11, 13));
				String timeType = "오전";
				if (Integer.parseInt(rs.getString("chatTime").substring(11, 13)) >= 12) {
					timeType = "오후";
					chatTime -= 12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0, 11) + " " + timeType + " " + chatTime + ":"
						+ rs.getString("chatTime").substring(14, 16) + " ");
				chatList.add(chat);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return chatList;
	}

	// input method 정상적인 값은 1 , 아니면 -1

	public int submit(String chatName, String chatContent) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String SQL = "INSERT INTO CHAT (chatName, chatContent, chatTime) VALUES (?, ?, NOW())";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, chatName);
			pstmt.setString(2, chatContent);

			int affectedRows = pstmt.executeUpdate();

			if (affectedRows == 1) {
				return 1; // 성공
			}
		} catch (Exception e) {
			e.printStackTrace();
			return -1; // 실패
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 실패
	}

}