package sw3;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	private Connection con;

	private ResultSet rs;

	public BbsDAO() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://35.177.120.128:3306/mydb", "admin", "swvmfhwprxm2023");
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public String getDate() {
		// 시간을 가져오는 함수
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = con.prepareStatement(SQL);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				return rs.getString(1);
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		// db 오류날때
		return "";
	}

	public int getNext(String bbsType) {
		String sql = "SELECT bbsID FROM bbs WHERE type = ? ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = con.prepareStatement(sql);

			pstmt.setString(1, bbsType);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public int write(String bbsTitle, String userID, String bbsContent, String bbsType) {
		String sql = "INSERT INTO bbs VALUES(?,?,?,?,?,?,?)";
		try {
			PreparedStatement pstmt = con.prepareStatement(sql);

			pstmt.setInt(1, getNext(bbsType));
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);
			pstmt.setString(7, bbsType);

			// insert은 성공했을때 0이상의 값을 반환.
			return pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		// db 오류
		return -1;
	}

	public boolean nextPage(int pageNumber, String bbsType) {
		String sql = "SELECT * FROM bbs WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		try {
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, getNext(bbsType) - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				return true;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return false;

	}

	public Bbs getBbs(int bbsID, String bbstype) {
	    // view 기능 함수
	    String sql = "SELECT * FROM bbs WHERE bbsID = ? AND type = ?";
	    try {
	        PreparedStatement pstmt = con.prepareStatement(sql);
	        pstmt.setInt(1, bbsID);
	        pstmt.setString(2, bbstype);
	        rs = pstmt.executeQuery(); // 쿼리 실행 추가

	        if (rs.next()) {
	            Bbs bbs = new Bbs();
	            bbs.setBbsID(rs.getInt(1));
	            bbs.setBbsTitle(rs.getString(2));
	            bbs.setUserID(rs.getString(3));
	            bbs.setBbsDate(rs.getString(4));
	            bbs.setBbsContent(rs.getString(5));
	            bbs.setBbsAvailable(rs.getInt(6));

	            return bbs;
	        }
	    } catch (Exception ex) {
	        ex.printStackTrace();
	    }
	    // 해당 글이 존재하지 않을 경우
	    return null;
	}

	public int update(int bbsID, String bbsTitle, String bbsContent, String bbsType) {
		String sql = "UPDATE bbs SET bbsTitle = ?, bbsContent = ? WHERE bbsID=? AND type = ?";

		try {
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			pstmt.setString(4, bbsType);

			// 성공할 시 0이상의 값이 반환됨.
			return pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return -1; // db 오류
	}

	// delete함수를 사용하는 jsp에서 bbsID값을 받아와서,
	public int delete(int bbsID, String bbsType) {
		// db내부에 bbsAvailable을 0으로 바꿈으로써 사용자 입장에서는 삭제가 되었다고 볼 수있다.
		// 하지만 db내부에는 삭제된 글도 남아있다.
		String SQL = "UPDATE bbs SET bbsAvailable = 0 WHERE bbsID = ? AND type = ?";
		try {
			PreparedStatement pstmt = con.prepareStatement(SQL);
			// bbsID값에 글을 Avaliable값을 0으로 바꿔주면서 글을 삭제시키고
			pstmt.setInt(1, bbsID);
			pstmt.setString(2, bbsType);
			// 결과가 무사히 성공을 했다면 0이상의 값이 반환을 하기에
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 나머지는 디비오류
		return -1;
	}

	public ArrayList<Bbs> getList(int pageNumber, String bbsType) {
		String sql = "SELECT b.*, IFNULL(l.likeCount, 0) as likeCount " + "FROM bbs b "
				+ "LEFT JOIN (SELECT bbsID, COUNT(*) as likeCount FROM likes GROUP BY bbsID) l ON b.bbsID = l.bbsID "
				+ "WHERE b.bbsID < ? AND b.bbsAvailable = 1 AND b.Type = ? " + "ORDER BY b.bbsID DESC LIMIT 10";

		ArrayList<Bbs> list = new ArrayList<Bbs>();

		try {
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, getNext(bbsType) - (pageNumber - 1) * 10);
			pstmt.setString(2, bbsType);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				Bbs bbs = new Bbs();

				bbs.setBbsID(rs.getInt("bbsID"));
				bbs.setBbsTitle(rs.getString("bbsTitle"));
				bbs.setUserID(rs.getString("userID"));
				bbs.setBbsDate(rs.getString("bbsDate"));
				bbs.setBbsContent(rs.getString("bbsContent"));
				bbs.setBbsAvailable(rs.getInt("bbsAvailable"));
				bbs.setBbsType(rs.getString("type"));
				bbs.setLikeCount(rs.getInt("likeCount")); // 좋아요 수 추가

				list.add(bbs);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return list;
	}

}
