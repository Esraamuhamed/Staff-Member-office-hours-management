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

        <div class="topnav">
            <a  href="index.html">Home</a>
            <a href="#profile">Profile</a>
            <a href="messages.jsp">Messages</a>
            <a  href="appointments.jsp">Appointments</a>
            <a href="#Appointments">Courses</a>
            <a href="signOut">Sign Out</a>
            <div class="search-container">
                <form action="/action_page.php">
                    <input type="text" placeholder="Search for staff member.." name="search">
                    <button type="submit"><i class="fa fa-search"></i></button>	  
                </form>

            </div>
        </div>
        <h1 style="color: #02ced1 ; font-size: 3em">Send Message <span style="color: #02ced1 ">&#9993;</span></h1>

     

        <form action="sendReply">
           
            <% String data=request.getParameter("data");
            String temp="";
            int ctr =0;
            ArrayList<String> datalist = new ArrayList<String>();
                for(int i = 0 ; i < data.length() ; i++ ){
                if(data.charAt(i)!='-'){
                    temp+=data.charAt(i);
                   if(ctr==1 && i== data.length()-1 ) {datalist.add(temp);}
                }
                else{
                datalist.add(temp);
                temp="";
                ctr++;
                }
                }
                String title = datalist.get(0);
                String to = datalist.get(1);
                session.setAttribute("to",to); 
                session.setAttribute("title",title);
                %>
                
           Title: <%=datalist.get(0)%>
           <br>
           To:    <%=datalist.get(1)%>
           <br>
            Reply:
            <br>
            <textarea  class="user" id="subject" name="content" style="height:300px ; width: 500px" required></textarea>
            <br>

            <input type="submit" class="button button2" value="Send"/>

        </form>    
    </body>
</html>
   