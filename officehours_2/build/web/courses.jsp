<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <title>Courses</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet"  type="text/css" href="style.css" >

</head>
<body>
    <% int ID =(int) session.getAttribute("id");
    String type = (String)session.getAttribute("type");%>
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
                
                RS = Stmt.executeQuery("SELECT * FROM course;");
                RS.last();
                int[] cid  = new int[RS.getRow()];
                String[] cname  = new String[RS.getRow()];
                int c = 0;
                RS.beforeFirst();
                while (RS.next())
                {
                    cid[c] =RS.getInt("courseID");
                    cname[c] = RS.getString("name");
                    c++;

                }
        
        %>
    
<script>
/* When the user clicks on the button, 
toggle between hiding and showing the dropdown content */
    
  function myFunction(x) {
  document.getElementById(x).classList.toggle("show");
 }



// Close the dropdown if the user clicks outside of it
window.onclick = function(event) {
  if (!event.target.matches('.dropbtn')) {
    var dropdowns = document.getElementsByClassName("dropdown-content");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}
</script>

<div class="topnav">
  <a  href="home.jsp">Home</a>
  <a href="profile.jsp">Profile</a>
  <a href="messages.jsp">Messages</a>
  <a href="appointments.jsp">Appointments</a>
  <%
  if(type.equals("student")){
      
%>
  <a class="active" href="courses.jsp">Courses</a> <%}%>
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
  
    <br>
    <% 
            
                
                
                for(int i=0;i<cid.length;i++)
                {
                    %>
                
                    <b><%=cname[i]%>   <%=cid[i]%> :<b>

                  <%
                    RS = Stmt.executeQuery("SELECT * FROM courseStaff where courseID = '"+cid[i]+"';");
                    RS.last();
                    int[] sid  = new int[RS.getRow()];
                    int x = 0;
                    RS.beforeFirst();
                    while (RS.next())
                    {
                        sid[x] =RS.getInt("staffID");
                        x++;
                    }
                    
                    %>
                    <form action="staffPage.jsp">
                        <select name="wdth" id="wdth"  >
                        <%
                    for (int j=0;j<sid.length;j++)
                    {
                        RS = Stmt.executeQuery("SELECT * FROM staff where staffID = '"+sid[j]+"';");
                        //session.setAttribute("stID",1);
                        
                        while(RS.next())
                        {%>
                        
                            <option name="selectedC" value="<%=sid[j]%>"> <%=RS.getString("name")%> </option>

                        <%}

                    }
                %>
                        
                        <select/>
                        <button type="submit"  class="button3"  > Show </button>
                        
                    </form>
                    
                        
                <br><br><br>

                <%
                }
                
                Stmt.close();
                Con.close();
            } catch (Exception cnfe) {
                System.err.println("Exception: " + cnfe);
            }
    %>
    
</div>

</body>
</html>
