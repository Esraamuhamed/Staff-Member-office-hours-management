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
<%@page import ="mail.SendMail"%>
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
  <a class="active" href="home.jsp">Home</a>
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
  <h2>Welcome</h2>
  
</div>
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
        
        if (type.equals("student"))
        {
            RS = Stmt.executeQuery("SELECT * FROM appointment where studentID = "+ID+";");
            List<String> notif=new ArrayList<>();
            LocalDate today = LocalDate.now();
            LocalTime now = LocalTime.now();
            RS = Stmt.executeQuery("SELECT * FROM notification ;");
            RS.last();
            int Nd = 0;
            if (RS.getRow()==0) Nd+=1;
            else Nd = RS.getInt("NotificationID")+1;

            RS = Stmt.executeQuery("SELECT * FROM appointment where studentID = '"+ID+"';");

            while (RS.next())
            {
                LocalDate day = LocalDate.parse(RS.getString("day"));
                if (day.equals(today))
                {
                    notif.add("You have an appointment today from "+RS.getString("start")+" to "+RS.getString("end") +" at "+RS.getString("place"));
                }
            }


            RS = Stmt.executeQuery("SELECT * FROM studentNotification where studentID = "+ID+";");
            List<Integer> nid=new ArrayList<>();

            while (RS.next())
            {
                nid.add(RS.getInt("notificationID"));
            }


            if (nid.size()==0)
            {
                for (int i=0;i<notif.size();i++)
                {

                    String line = "Insert into notification (notificationID,date,time,content) values ("+ Nd+",'"+today+"','"+now+"','"+notif.get(i)+"');";
                    int Rows = Stmt.executeUpdate(line);
                    line = "Insert into studentNotification (notificationID,studentID) values ("+ Nd+","+ID+");";
                    Rows = Stmt.executeUpdate(line);
                    Nd++;
                    RS = Stmt.executeQuery("SELECT * FROM student where studentID = "+ID+";");
                    RS.next();
                    SendMail sendMail = new SendMail();
                    sendMail.send(RS.getString("email"),"Upcoming Appointment ", notif.get(i), "officehoursmanager@gmail.com", "ABc123456!");
                }
            }
            else
            {
                List<String> content=new ArrayList<>();
                for (int i=0;i<nid.size();i++)
                {
                    RS = Stmt.executeQuery("SELECT * FROM notification where notificationID = "+nid.get(i)+";");
                    RS.next();
                    content.add(RS.getString("content"));
                }
                for (int i=0;i<notif.size();i++)
                {
                    if(!content.contains(notif.get(i)))
                    {
                        String line = "Insert into notification (notificationID,date,time,content) values ("+ Nd+",'"+today+"','"+now+"','"+notif.get(i)+"');";
                        int Rows = Stmt.executeUpdate(line);
                        line = "Insert into studentNotification (notificationID,studentID) values ("+ Nd+","+ID+");";
                        Rows = Stmt.executeUpdate(line);
                        Nd++;
                        RS = Stmt.executeQuery("SELECT * FROM student where studentID = "+ID+";");
                        RS.next();
                        SendMail sendMail = new SendMail();
                        sendMail.send(RS.getString("email"),"Upcoming Appointment ", notif.get(i), "officehoursmanager@gmail.com", "ABc123456!");
                        
                    }
                }
            }



            RS = Stmt.executeQuery("SELECT * FROM studentNotification where studentID = "+ID+";");
            nid.clear();
            while (RS.next())
            {
                nid.add(RS.getInt("notificationID"));
            }

            for (int i=nid.size()-1;i>=0;i--)
            {
                RS = Stmt.executeQuery("SELECT * FROM notification where notificationID = "+nid.get(i)+";");
                RS.next();
                %>
                <div class="notification" >
                    
                    <p style="font-size: 12px;"> <%=RS.getString("date")%>  <%=RS.getString("time")%> <p/>
                    <%=RS.getString("content")%>
                    
                </div>

        <%

            }
        }
        else
        {
            RS = Stmt.executeQuery("SELECT * FROM appointment where staffID = "+ID+";");
            List<String> notif=new ArrayList<>();
            LocalDate today = LocalDate.now();
            LocalTime now = LocalTime.now();
            RS = Stmt.executeQuery("SELECT * FROM notification ;");
            RS.last();
            int Nd = 0;
            if (RS.getRow()==0) Nd+=1;
            else Nd = RS.getInt("NotificationID")+1;

            RS = Stmt.executeQuery("SELECT * FROM appointment where staffID = '"+ID+"';");

            while (RS.next())
            {
                LocalDate day = LocalDate.parse(RS.getString("day"));
                if (day.equals(today))
                {
                    notif.add("You have an appointment today from "+RS.getString("start")+" to "+RS.getString("end") +" at "+RS.getString("place"));
                }
            }


            RS = Stmt.executeQuery("SELECT * FROM staffNotification where staffID = "+ID+";");
            List<Integer> nid=new ArrayList<>();

            while (RS.next())
            {
                nid.add(RS.getInt("notificationID"));
            }


            if (nid.size()==0)
            {
                for (int i=0;i<notif.size();i++)
                {

                    String line = "Insert into notification (notificationID,date,time,content) values ("+ Nd+",'"+today+"','"+now+"','"+notif.get(i)+"');";
                    int Rows = Stmt.executeUpdate(line);
                    line = "Insert into staffNotification (notificationID,staffID) values ("+ Nd+","+ID+");";
                    Rows = Stmt.executeUpdate(line);
                    Nd++;
                    RS = Stmt.executeQuery("SELECT * FROM staff where staffID = "+ID+";");
                    RS.next();
                    SendMail sendMail = new SendMail();
                    sendMail.send(RS.getString("email"),"Upcoming Appointment ", notif.get(i), "officehoursmanager@gmail.com", "ABc123456!");

                }
            }
            else
            {
                List<String> content=new ArrayList<>();
                for (int i=0;i<nid.size();i++)
                {
                    RS = Stmt.executeQuery("SELECT * FROM notification where notificationID = "+nid.get(i)+";");
                    RS.next();
                    content.add(RS.getString("content"));
                }
                for (int i=0;i<notif.size();i++)
                {
                    if(!content.contains(notif.get(i)))
                    {
                        String line = "Insert into notification (notificationID,date,time,content) values ("+ Nd+",'"+today+"','"+now+"','"+notif.get(i)+"');";
                        int Rows = Stmt.executeUpdate(line);
                        line = "Insert into staffNotification (notificationID,staffID) values ("+ Nd+","+ID+");";
                        Rows = Stmt.executeUpdate(line);
                        Nd++;
                        RS = Stmt.executeQuery("SELECT * FROM staff where staffID = "+ID+";");
                        RS.next();
                        SendMail sendMail = new SendMail();
                        sendMail.send(RS.getString("email"),"Upcoming Appointment ", notif.get(i), "officehoursmanager@gmail.com", "ABc123456!");
                    }
                }
            }



            RS = Stmt.executeQuery("SELECT * FROM staffNotification where staffID = "+ID+";");
            nid.clear();
            while (RS.next())
            {
                nid.add(RS.getInt("notificationID"));
            }

            for (int i=nid.size()-1;i>=0;i--)
            {
                RS = Stmt.executeQuery("SELECT * FROM notification where notificationID = "+nid.get(i)+";");
                RS.next();
                %>
                <div class="notification" >
                    
                    <p style="font-size: 12px;"> <%=RS.getString("date")%>  <%=RS.getString("time")%> <p/>
                    <%=RS.getString("content")%>
                    
                </div>

        <%

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
