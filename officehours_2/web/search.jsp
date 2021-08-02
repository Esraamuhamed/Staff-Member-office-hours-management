<%-- 
    Document   : home
    Created on : Jan 8, 2021, 10:07:19 PM
    Author     : afnan
--%>

<%@page import="java.time.LocalTime"%>
<%@page import="java.time.LocalTime"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Home Page</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet"  type="text/css" href="style.css" >
</head>
<body>
    <% int ID =(int) session.getAttribute("id");
    String type = (String)session.getAttribute("type");%>

<div class="topnav">
  <a href="home.jsp">Home</a>
  <a href="profile.jsp">Profile</a>
  <a href="messages.jsp">Messages</a>
  <a href="appointments.jsp">Appointments</a>
  <%
  if(type.equals("student")){
      
%>
  <a href="courses.jsp">Courses</a> <%}%>
  <a href="signOut">Sign Out</a>
   <%
  if(type.equals("student")){
      
   %>
  <div class="search-container">
    <form action="search.jsp">
      <input type="text" placeholder="Search for staff member.." name="search">
      <button type="submit"><i class="fa fa-search"></i></button> 
	  
    </form>
	
  </div> <%}
  
  
  else{
      
   %>
  <div class="search-container">
    <form action="search.jsp">
      <input type="text" placeholder="Search for student.." name="search">
      <button type="submit"><i class="fa fa-search"></i></button> 
	  
    </form>
	
  </div> <%}%>
</div>

<div style="padding-left:16px">
 
  
</div></br>
<%
    Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://localhost:3306/officehoursmanagement";
    String user = "root";
    String password = "root";
    String Line;
    Connection Con = null;
    Statement Stmt = null;
    ResultSet RS = null;


    try {

        Con = DriverManager.getConnection(url, user, password);
        Stmt = Con.createStatement();
        
        
        String s = request.getParameter("search");
        String name =s.toLowerCase();
        boolean check = false;
        if (type.equals("student"))
        {
            RS = Stmt.executeQuery("SELECT * FROM staff ;");
            while (RS.next())
            {
                String res = RS.getString("name").toLowerCase();
                if (res.contains(name))
                {
                    check = true;
                    %>
                <form action="staffPage.jsp">
                       &nbsp;&nbsp; <button style="font-size: 18px;" class="link" type="submit" name ="wdth" value="<%=RS.getInt("staffID")%>"  class="button3"  > <%=RS.getString("name")%> </button>
                    </form>
                </br> <%
                    
                }
            }
            if (!check)
                {
                    %> <p style="font-size: 18px;"> &nbsp;&nbsp; No Results Found ..</p><%
                }
            
        }
        else
        {
            RS = Stmt.executeQuery("SELECT * FROM student ;");
            while (RS.next())
            {
                String res = RS.getString("name").toLowerCase();
                if (res.contains(name))
                {
                    check = true;
                    %>
                <form action="studentPage.jsp">
                       &nbsp;&nbsp; <button style="font-size: 18px;" class="link" type="submit" name ="wdth" value="<%=RS.getInt("studentID")%>"  class="button3"  > <%=RS.getString("name")%> </button>
                    </form>
                </br> <%
                    
                }
            }
            if (!check)
                {
                    %> <p style="font-size: 18px;"> &nbsp;&nbsp; No Results Found ..</p><%
                }

        }

        
        

        Stmt.close();
        Con.close();
    } catch (Exception cnfe) {
        System.err.println("Exception: " + cnfe);
    }

%>


</body>
</html>

    </body>
</html>
