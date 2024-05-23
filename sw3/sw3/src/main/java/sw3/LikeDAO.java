package sw3;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LikeDAO {

	// 데이터베이스 연결을 위한 변수들
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	public LikeDAO() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://35.177.120.128:3306/mydb", "admin", "swvmfhwprxm2023");
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	// addLike 메서드
	public boolean addLike(int bbsID, String userID, String type) {
		String checkSql = "SELECT * FROM likes WHERE bbsID = ? AND userID = ? AND type = ?";
		String insertSql = "INSERT INTO likes (bbsID, userID, type) VALUES (?, ?, ?)";
		String deleteSql = "DELETE FROM likes WHERE bbsID = ? AND userID = ? AND type = ?";

		try {
			pstmt = conn.prepareStatement(checkSql);
			pstmt.setInt(1, bbsID);
			pstmt.setString(2, userID);
			pstmt.setString(3, type);
			rs = pstmt.executeQuery();

			if (rs.next()) { // 이미 "좋아요"가 있다면 제거
				pstmt = conn.prepareStatement(deleteSql);
				pstmt.setInt(1, bbsID);
				pstmt.setString(2, userID);
				pstmt.setString(3, type);
				pstmt.executeUpdate();
				return false;
			} else { // "좋아요"가 없다면 추가
				pstmt = conn.prepareStatement(insertSql);
				pstmt.setInt(1, bbsID);
				pstmt.setString(2, userID);
				pstmt.setString(3, type);
				pstmt.executeUpdate();
				return true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
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
		return false;
	}

	// getLikeCount 메서드
	public int getLikeCount(int bbsID, String type) {
		String sql = "SELECT COUNT(*) AS likeCount FROM likes WHERE bbsID = ? AND type = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, bbsID);
			pstmt.setString(2, type);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				return rs.getInt("likeCount");
			}
		} catch (SQLException e) {
			e.printStackTrace();
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
		return 0;
	}

	public boolean userLiked(int bbsID, String userID, String type) {
		String sql = "SELECT COUNT(*) FROM likes WHERE bbsID = ? AND userID = ? AND type = ?";
		// try-with-resources를 사용하여 자동으로 리소스를 해제합니다.
		try (Connection conn = DriverManager.getConnection("jdbc:mysql://35.177.120.128:3306/mydb", "admin",
				"swvmfhwprxm2023"); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, bbsID);
			pstmt.setString(2, userID);
			pstmt.setString(3, type);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					return rs.getInt(1) > 0;
				}
			}
		} catch (SQLException e) {
			e.printStackTrace(); // 실제 애플리케이션에서는 로깅 프레임워크를 사용하는 것이 좋습니다.
		}
		return false;
	}
}
