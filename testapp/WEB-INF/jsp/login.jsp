<%@ page import="java.net.*" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>login page</title>
  <link rel="stylesheet" type="text/css" href="css/default.css" />
  <script type="text/javascript">
    function signup(){
      var form = document.getElementById("form1");
      form.action = "signup";
      form.submit();
    }
  </script>
</head>
<body>
<%
  String hostName = InetAddress.getLocalHost().getHostName();
%>
  <table>
    <tr><th>ServerName:</th><td><%= hostName %></td></tr>
    <tr><th>SessionId:</th><td><%= session.getId() %></td></tr>
  </table>

  <br/>

  <form id="form1" action="login" method="POST">
    <table>
      <tr>
        <th>UserId:</th>
        <td><input type="text" size="12" name="userid"/></td>
      </tr>
      <tr>
        <th>Password:</th>
        <td><input type="password" size="12" name="password"/></td>
      </tr>
      <tr>
        <th>
          <input type="submit" value="Login"/>
        </th>
        <td>
          <input type="submit" value="Sign up" onclick="signup(); false;"/>
        </td>
      </tr>
    </table>
  </form>
</body>
</html>

