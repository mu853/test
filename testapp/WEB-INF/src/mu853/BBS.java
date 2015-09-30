package mu853;
import java.util.*;
import java.sql.*;

public class BBS {
	private String userId;
	private String comment;
	
	public BBS(String userId, String comment) {
		this.userId = userId;
		this.comment = comment;
	}
	
	public String getUserId() { return this.userId; }
	public String getComment() { return this.comment; }
	
	static boolean save(BBS bbs) {
		String sql = "insert into bbs values(?, ?);";
		boolean result = false;
		try{
			PreparedStatement stmt = BBSUtil.getConnection().prepareStatement(sql);
			stmt.setString(1, bbs.getUserId());
			stmt.setString(2, bbs.getComment());
			result = stmt.executeUpdate() == 1;
		}catch(Exception e){
			System.out.println("err at BBS.save: " + e.getMessage());
		}
		return result;
	}
	
	static List<BBS> findAll() {
		String sql = "select * from bbs;";
		List<BBS> list = new ArrayList<BBS>();
		try{
			Statement stmt = BBSUtil.getConnection().createStatement();
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()){
				list.add(new BBS(rs.getString("user_id"), rs.getString("comment")));
			}
			rs.close();
			stmt.close();
		}catch(Exception e){
			System.out.println("err at BBS.findAll: " + e.getMessage());
		}
		return list;
	}
}

