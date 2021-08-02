<%-- 
    Document   : studentProfile
    Created on : Jan 7, 2021, 1:41:05 PM
    Author     : afnan
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Profile</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet"  type="text/css" href="style.css" >

</head>
<body>
    <% int ID =(int) session.getAttribute("id");
    String type = (String)session.getAttribute("type");%>

<div class="topnav">
  <a  href="home.jsp">Home</a>
  <a class="active" href="#profile">Profile</a>
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
    <%--<h2>Responsive Search Bar</h2>--%>
    <br/><br/>
  
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
                //int rows_affected = Stmt.executeUpdate("INSERT INTO department VALUES ('TestDepartment', 100, '111111101', '1988-05-22');");
                //out.println("Number of Rows Affected  "+ rows_affected);
                if (type.equals("student"))
                {
                    RS = Stmt.executeQuery("SELECT * FROM student where studentID = '"+ID+"';");
                    RS.next();
                    %>
                    <p><b>Name :</b> <%=RS.getString("name")%></p>
                    <p><b>e-mail :</b> <%=RS.getString("email")%></p>
                    <p><b>Major : </b> <%=RS.getString("major")%></p>
                    <%
                        
                }
                else
                {
                    RS = Stmt.executeQuery("SELECT * FROM staff where staffID = '"+ID+"';");
                    RS.next();
                    %>
                    <p><b>Name :</b> <%=RS.getString("name")%></p>
                    <p><b>e-mail :</b> <%=RS.getString("email")%></p>
                    <p><b>Title :</b> <%=RS.getString("title")%></p>
                    <%
                     RS = Stmt.executeQuery("SELECT * FROM courseStaff where staffID = '"+ID+"';");
                     %> <p><b>Courses :</b> </p> <%
                    RS.last();
                    int[] cid  = new int[RS.getRow()];
                    RS.beforeFirst();
                    int c = 0;
                    while (RS.next())
                    {
                        cid[c] =RS.getInt("courseID");;
                        c++;
                    }
                    for (int i=0;i<cid.length;i++)
                    {
                        
                        RS = Stmt.executeQuery("SELECT * FROM course where courseID = '"+cid[i]+"';");
                        RS.next();
                        %> <p> &nbsp;&nbsp;  <%=RS.getString("name")%> </p> <%
                    }
                    
                        
                    RS = Stmt.executeQuery("SELECT * FROM officeHours where staffID = '"+ID+"';");
                    %> <p><b>Office Hours :</b> </p> <%
                    while (RS.next())
                    {
                        %> <p> &nbsp;&nbsp; from <%=RS.getString("start")%> to <%=RS.getString("end")%> at <%=RS.getString("day")%> in <%=RS.getString("place")%> </p> <%
                    }
                    
                }
                
                
                
                
                Stmt.close();
                Con.close();
            } catch (Exception cnfe) {
                System.err.println("Exception: " + cnfe);
            }
            %>
            <form action="updateProfile.jsp">
             <button class="button3"  type="submit" > Update</button>      
            </form>
            
</div>

</body>
</html>
