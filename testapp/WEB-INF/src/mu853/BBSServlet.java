package mu853;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class BBSServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		System.out.println("doGet");
		String path = req.getServletPath();
		HttpSession session = req.getSession();
		if("/".equals(path)){
			if(session.isNew() || session.getAttribute("user") == null){
				System.out.println("session is new");
				getServletContext().getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
			}else{
				System.out.println("do list");
				doList(req, res);
			}
		}else if("/logout".equals(path)){
			System.out.println("do logout");
			session.invalidate();
			res.sendRedirect(req.getContextPath() + "/");
		}else{
			System.out.println("else");
			res.sendRedirect(req.getContextPath() + "/");
		}
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		System.out.println("doPost");
		String path = req.getServletPath();
		if("/login".equals(path)){
			doLogin(req, res);
		}else if("/signup".equals(path)){
			doSignup(req, res);
		}else if("/entry".equals(path)){
			doEntry(req, res);
		}
	}
	
	public void doList(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		System.out.println("doList");
		req.getSession().setAttribute("bbsList", BBS.findAll());
		req.getSession().setAttribute("userList", User.findAll());
		getServletContext().getRequestDispatcher("/WEB-INF/jsp/bbs.jsp").forward(req, res);
	}
	
	public void doEntry(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		System.out.println("doEntry");
		String id = req.getParameter("id");
		String comment = req.getParameter("comment");
		BBS bbs = new BBS(id, comment);
		if(BBS.save(bbs)){
			System.out.println("bbs saved");
		}else{
			System.out.println("bbs save failed.");
		}
		res.sendRedirect(req.getContextPath() + "/");
	}
	
	public void doLogin(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		System.out.println("doLogin");
		User user = User.find(req.getParameter("userid"), req.getParameter("password"));
		if(user == null){
			System.out.println("user is not registered");
			res.sendRedirect(req.getContextPath() + "/");
		}else{
			System.out.println("ok login");
			HttpSession session = req.getSession();
			session.setAttribute("user", user);
			res.sendRedirect(req.getContextPath() + "/");
		}
	}
	
	public void doSignup(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		System.out.println("doSignup");
		User user = new User(req.getParameter("userid"), req.getParameter("password"));
		if(User.save(user)){
			System.out.println("user registered.");
		}else{
			System.out.println("save user failed.");
		}
		res.sendRedirect(req.getContextPath() + "/");
	}
}

