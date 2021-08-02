<%@page import="java.util.ArrayList"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.*"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet"  type="text/css" href="style.css" >


        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>

    <body>

        <% String ID = session.getAttribute("id").toString();
    String type = (String)session.getAttribute("type");%>

<div class="topnav">
  <a  href="home.jsp">Home</a>
  <a href="profile.jsp">Profile</a>
  <a class="active"  href="messages.jsp">Messages</a>
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
        <h1 style="color: #02ced1 ; font-size: 3em">Send Message <span style="color: #02ced1 ">&#9993;</span></h1>

        <%
            String url = "jdbc:mysql://localhost:3306/officehoursmanagement";
            String user = "root";
            String password = "root";
            String Line;
            Connection Con = null;
            Statement Stmt = null;
            ResultSet RS = null;
            ResultSet RS2 = null;
            ResultSet rs = null;
            ResultSet rs2 = null;

            ArrayList<String> IDlist = new ArrayList<String>();

            try {
                Con = DriverManager.getConnection(url, user, password);
                Stmt = Con.createStatement();

            } catch (Exception cnfe) {
                System.err.println("Exception: " + cnfe);
            }

        %>

        <form action="send">

            Subject ID:
            <%                    try {
                    rs = Stmt.executeQuery("select * from course");
            %>
            <select name="courseID" >
                <%
                    while (rs.next()) {
                %>

                <option><%=rs.getString("courseID")%></option>
                <%}
                    } catch (Exception cnfe) {
                        System.err.println("Exception: " + cnfe);
                    }

                %>
            </select>

            <br>
       
            To: 
            <input class="user" type="text" name="to" >
            <br>
            Title:
            <input class="user" type="text"  name="title" required>
            <br>
            Content:
            <br>
            <textarea  class="user" id="subject" name="content" style="height:300px ; width: 500px" required></textarea>
            <br>

            <input type="submit" class="button button2" value="Send"/>

        </form>    
    </body>
</html>

<%    try {
        rs.close();
        Stmt.close();
        Con.close();

    } catch (Exception cnfe) {
        System.err.println("Exception: " + cnfe);
    }

%>