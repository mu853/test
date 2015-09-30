package mu853;
import java.sql.*;

public class BBSUtil {
	private static final ThreadLocal<Connection> session = new ThreadLocal<Connection>();

	public static Connection getConnection() throws Exception {
		Connection conn = session.get();
		if(conn == null){
			String uri = "jdbc:mysql://172.16.10.253/test";
			String user = "user1";
			String password = "VMware1!";
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(uri, user, password);
			session.set(conn);
		}
		return conn;
	}

	public static void closeConnection() throws Exception {
		Connection conn = session.get();
		session.set(null);
		if(conn != null){
			conn.close();
		}
	}
}

