package mu853;
import java.io.*;
import java.util.*;
import java.security.*;
import java.sql.*;

public class User {
	private String id;
	private String passwordHash;
	private String bgColor;

	public User(String id, String password, String bgColor) {
		this.id = id;
		if(password != null){
			this.passwordHash = User.hash(password);
		}
		this.bgColor = bgColor;
	}

	public User(String id, String password) {
		this(id, password, "black");
		StringBuilder buff = new StringBuilder("#");
		for(int i = 0; i < 3; i++) {
			buff.append(Integer.toHexString((int)(Math.random() * 112) + 144));
		}
		this.bgColor = buff.toString();
	}

	public String getId() { return this.id; }
	public String getPasswordHash() { return this.passwordHash; }
	public String getBGColor() { return this.bgColor; }

	static String hash(String password) {
		String passwordHash = "";
		try{
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			md.update(password.getBytes());
			passwordHash = new String(md.digest());
		}catch(Exception e){
			System.out.println("hash err: " + e.getMessage());
		}
		return passwordHash;
	}

	static boolean save(User user) {
		String sql = "insert into user values(?, ?, ?);";
		boolean result = false;
		try{
			PreparedStatement stmt = BBSUtil.getConnection().prepareStatement(sql);
			stmt.setString(1, user.getId());
			stmt.setString(2, user.getPasswordHash());
			stmt.setString(3, user.getBGColor());
			result = stmt.executeUpdate() == 1;
		}catch(Exception e){
			System.out.println("err at User.save: " + e.getMessage());
		}
		return result;
	}

	static User find(String id, String password) {
		String sql = "select * from user where id = ? and password_hash = ?;";
		User user = null;
		try{
			PreparedStatement stmt = BBSUtil.getConnection().prepareStatement(sql);
			stmt.setString(1, id);
			stmt.setString(2, User.hash(password));
			ResultSet rs = stmt.executeQuery();
			if(rs.next()){
				user = new User(rs.getString("id"), rs.getString("password_hash"));
			}
			rs.close();
			stmt.close();
		}catch(Exception e){
			System.out.println("err at User.find: " + e.getMessage());
		}
		return user;
	}

        static List<User> findAll() {
                String sql = "select * from user;";
                List<User> list = new ArrayList<User>();
                try{
                        Statement stmt = BBSUtil.getConnection().createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        while(rs.next()){
                                list.add(new User(rs.getString("id"), null, rs.getString("bgcolor")));
                        }
                        rs.close();
                        stmt.close();
                }catch(Exception e){
                        System.out.println("err at User.findAll: " + e.getMessage());
                }
                return list;
        }
}
