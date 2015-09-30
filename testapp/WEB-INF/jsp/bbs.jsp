<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="mu853.*" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>bbs</title>
  <link rel="stylesheet" type="text/css" href="css/default.css" />
  <style type="text/css">
<%
  List<User> userList = (List<User>)session.getAttribute("userList");
  for(User user : userList){
%>
    .<%= user.getId() %> { background-color: <%= user.getBGColor() %>; }
<%
  }
%>   
  </style>
</head>
<body>
<%
  String hostName = InetAddress.getLocalHost().getHostName();
%>
  <table>
    <tr><th>ServerName:</th><td><%= hostName %></td></tr>
    <tr><th>SessionId:</th><td><%= session.getId() %></td></tr>
  </table>
<%
  User user = (User)session.getAttribute("user");
  List<BBS> bbsList = (List<BBS>)session.getAttribute("bbsList");
  for(BBS bbs : bbsList){
%>
  <div><span class="<%= bbs.getUserId() %>"><%= bbs.getUserId() %></span><span><%= bbs.getComment() %></span></div>
<%
  }
%>
  <br/><br/>
  <form id="form1" action="entry" method="POST">
    <input type="hidden" value="<%= user.getId() %>" name="id"/>
    <%= user.getId() %><input type="text" size="60" name="comment"/>
    <input type="submit" value="Send"/>
  </form>

  <br/>
  <a href="logout">Logout</a>
</body>
</html>

