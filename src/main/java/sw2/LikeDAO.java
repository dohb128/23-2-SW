package sw2;

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
			conn = DriverManager.getConnection("jdbc:mysql://35.177.120.128:3306/mydb", "admin", "1234");
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	// addLike 메서드
	public boolean addLike(int bbsID, String userID) {
		String checkSql = "SELECT * FROM likes WHERE bbsID = ? AND userID = ?";
		String insertSql = "INSERT INTO likes (bbsID, userID) VALUES (?, ?)";
		String deleteSql = "DELETE FROM likes WHERE bbsID = ? AND userID = ?";

		try {
			pstmt = conn.prepareStatement(checkSql);
			pstmt.setInt(1, bbsID);
			pstmt.setString(2, userID);
			rs = pstmt.executeQuery();

			if (rs.next()) { // 이미 "좋아요"가 있다면 제거
				pstmt = conn.prepareStatement(deleteSql);
				pstmt.setInt(1, bbsID);
				pstmt.setString(2, userID);
				pstmt.executeUpdate();
				return false;
			} else { // "좋아요"가 없다면 추가
				pstmt = conn.prepareStatement(insertSql);
				pstmt.setInt(1, bbsID);
				pstmt.setString(2, userID);
				pstmt.executeUpdate();
				return true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			// 자원 정리
			// close(rs, pstmt, conn);
		}
		return false;
	}

	// getLikeCount 메서드
	public int getLikeCount(int bbsID) {
		String sql = "SELECT COUNT(*) AS likeCount FROM likes WHERE bbsID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				return rs.getInt("likeCount");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			// 자원 정리
			// close(rs, pstmt, conn);
		}
		return 0;
	}

	// 기타 필요한 메서드 추가 가능
}
