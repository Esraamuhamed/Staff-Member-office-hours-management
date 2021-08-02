<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Connection"%>
<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <title> </title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet"  type="text/css" href="style.css" >
</head>
<script>

  
function sendajax(){

          var day = document.getElementById("day").value;
          var start = document.getElementById("start").value;
          var staff = document.getElementById("staff").value;
          var end = document.getElementById("end").value;
          
          var xmlhttp = new XMLHttpRequest();

          xmlhttp.open("GET","makeAppointment?staff="+staff+"&day="+day+"&end="+end+"&start="+start,true);
          //xmlhttp.send('day='+ day +'&start=' + start);
          xmlhttp.send();

          xmlhttp.onreadystatechange=function()
          {
              if (xmlhttp.readyState==4 && xmlhttp.status==200)
              {
                  document.getElementById("show_response").innerHTML=xmlhttp.responseText;
              }
          }
      }

</script>
<body>
    <%      int ID =(int) session.getAttribute("id");
            String type = (String)session.getAttribute("type");
            int studentID;
            if (request.getParameter("wdth")!=null)
            {
                studentID = Integer.parseInt(request.getParameter("wdth"));
                //session.setAttribute("staffID", staffID);
            }
            studentID = Integer.parseInt(request.getParameter("wdth"));
            /*else
            {
                staffID= (int)session.getAttribute("staffID");
            }*/
            %>

<div class="topnav">
  <a  href="home.jsp">Home</a>
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
                
                RS = Stmt.executeQuery("SELECT * FROM student where studentID = '"+studentID+"';");
                RS.next();
                %>
                <p><b>ID :</b> <%=RS.getString("studentID")%></p>
                <p><b>Name :</b> <%=RS.getString("name")%></p>
                <p><b>e-mail :</b> <%=RS.getString("email")%></p>
                <p><b>Major :</b> <%=RS.getString("major")%></p>
                <%
                 
                Stmt.close();
                Con.close();
            } catch (Exception cnfe) {
                System.err.println("Exception: " + cnfe);
            }
    %>
</div>

</body>
</html>
