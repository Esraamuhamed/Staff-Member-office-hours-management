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
        <h1 style="color: #02ced1 ; font-size: 3em">In Box<span style="color: #02ced1 ">&#9993;</span></h1>

        <form action="sendMessage.jsp">
            <input type="submit" class="button button2" value="+ Compose"/>
        </form>



        <%

            String url = "jdbc:mysql://localhost:3306/officehoursmanagement";
            String user = "root";
            String password = "root";
            String Line;
            Connection Con = null;
            Statement Stmt = null;
            ResultSet RS = null;
            ResultSet RS1 = null;
            ResultSet RS2 = null;
            ResultSet rs = null;
            ResultSet rs1 = null;
            ResultSet rs2 = null;
            ResultSet rS = null;
            int ctr = 0;
            ArrayList<String> fromID = new ArrayList<String>();
            ArrayList<String> messageID = new ArrayList<String>();
            try {
                Con = DriverManager.getConnection(url, user, password);
                Stmt = Con.createStatement();
            } catch (Exception cnfe) {
                System.err.println("Exception: " + cnfe);
            }

             type = session.getAttribute("type").toString();
             ID = session.getAttribute("id").toString();
            // String messageID = "";
            try {
                if (type.equals("student")) {
                    rs1 = Stmt.executeQuery("SELECT * FROM studentinbox where toID= '" + ID + "'");
                    while (rs1.next()) {
                        messageID.add(rs1.getString("messageID"));
                    }
        %>
        <table  border="1">
            <tr>
                <th style="color: #02ced1">From</th>
                <th style="color: #02ced1">Title</th> 
                <th style="color: #02ced1">Date</th> 
                <th style="color: #02ced1">Time</th> 
                <th style="color: #02ced1">Content</th>               
            </tr>
            <%
                for (int k = 0; k < messageID.size(); k++) {

                    rs = Stmt.executeQuery("SELECT * FROM studentinbox where messageID= '" + messageID.get(k) + "'");
                    while (rs.next()) {%>
            <tr>
                <td><%=rs.getString("fromID")%></td>

                <%  }
                    RS = Stmt.executeQuery("SELECT * FROM message where messageID= '" + messageID.get(k) + "'");
                    while (RS.next()) {
                %>

                <td><%=RS.getString("title")%></td>
                <td><%=RS.getString("date")%></td>
                <td><%=RS.getString("time")%></td>
                <td><%=RS.getString("content")%></td>

            </tr>

            <%
                        }
                    }
                }

                if (type.equals("staff")) {
                    rs = Stmt.executeQuery("SELECT * FROM staffinbox where toID= '" + ID + "'");
                    while (rs.next()) {
                        messageID.add(rs.getString("messageID"));
                        fromID.add(rs.getString("fromID"));

                    }
                    ctr = messageID.size();
                    rs2 = Stmt.executeQuery("SELECT * FROM stafftostaff where toID= '" + ID + "'");
                    while (rs2.next()) {
                        messageID.add(rs2.getString("messageID"));
                        fromID.add(rs2.getString("fromID"));
                    }
            %>
            <table  border="1">
                <tr>
                    <th style="color: #02ced1">From</th>
                    <th style="color: #02ced1">Title</th> 
                    <th style="color: #02ced1">Date</th> 
                    <th style="color: #02ced1">Time</th> 
                    <th style="color: #02ced1">Content</th>  
                    <th style="color: #02ced1">Reply</th>
                </tr>
                <%
                    for (int k = 0; k < messageID.size(); k++) {

                        RS = Stmt.executeQuery("SELECT * FROM message where messageID= '" + messageID.get(k) + "'");
                        while (RS.next()) {
                            String data=RS.getString("title")+"-"+fromID.get(k);
                %>

                <td><%=fromID.get(k)%></td>
                <td><%=RS.getString("title")%></td>
                <td><%=RS.getString("date")%></td>
                <td><%=RS.getString("time")%></td>
                <td><%=RS.getString("content")%></td>
                <% if(fromID.get(k).contains("2017")){%>
                <td> <form action="reply.jsp">
                        <select name="data"> <option><%=data%><option></select>
                    <input type="submit" class="button button2 " value="Reply" >
                    </form></td>
   <%}%>
                </tr>

                <%
                                }
                            }
                        }
                    } catch (Exception cnfe) {
                        System.err.println("Exception: " + cnfe);
                    }
                %>
            </table>
            <br>
            <br>
            <%
                try {
                    RS2.close();
                    rs2.close();
                    RS.close();
                    RS2.close();
                    rs.close();
                    rS.close();
                    rs1.close();
                    Stmt.close();
                    Con.close();

                } catch (Exception cnfe) {
                    System.err.println("Exception: " + cnfe);
                }

            %>