<%-- 
    Document   : updateProfile
    Created on : Jan 7, 2021, 4:21:45 PM
    Author     : afnan
--%>

<%@page import="java.util.List"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <script >
        
        function redirection ()
        {
            
            var response = document.getElementById("show_response").innerHTML;
            //alert(response);
            if (response=="s")
            {
                
                window.location.replace("home.jsp");
            }
            else 
            {
                return false;
            }
        }

    
        function sendajax(myfield){
                       
            var name = document.getElementById(myfield).value;
            var xmlhttp = new XMLHttpRequest();
            
            xmlhttp.open("GET","updateName?name="+name,true);
            xmlhttp.send();
            
            xmlhttp.onreadystatechange=function()
            {
                if (xmlhttp.readyState==4 && xmlhttp.status==200)
                {
                    document.getElementById("show_response").innerHTML=xmlhttp.responseText;
                }
            }
        }
        
        function sendajax2(myfield){
                       
            var name = document.getElementById(myfield).value;
            var xmlhttp = new XMLHttpRequest();
            
            xmlhttp.open("GET","updateEmail?name="+name,true);
            xmlhttp.send();
            
            xmlhttp.onreadystatechange=function()
            {
                if (xmlhttp.readyState==4 && xmlhttp.status==200)
                {
                    document.getElementById("show_response2").innerHTML=xmlhttp.responseText;
                }
            }
        }
        
        function sendajax3(myfield){
                       
            var name = document.getElementById(myfield).value;
            var xmlhttp = new XMLHttpRequest();
            
            xmlhttp.open("GET","updatePassword?name="+name,true);
            xmlhttp.send();
            
            xmlhttp.onreadystatechange=function()
            {
                if (xmlhttp.readyState==4 && xmlhttp.status==200)
                {
                    document.getElementById("show_response3").innerHTML=xmlhttp.responseText;
                }
            }
        }
        
        function sendajax4(myfield){
                       
            var name = document.getElementById(myfield).value;
            var xmlhttp = new XMLHttpRequest();
            
            xmlhttp.open("GET","updateMajorTitle?name="+name,true);
            xmlhttp.send();
            
            xmlhttp.onreadystatechange=function()
            {
                if (xmlhttp.readyState==4 && xmlhttp.status==200)
                {
                    document.getElementById("show_response4").innerHTML=xmlhttp.responseText;
                }
            }
        }
        
        
        
        
    </script>
    <head>
        <title>Update Profile</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet"  type="text/css" href="style.css" >

</head>
<body>
    <% int ID =(int) session.getAttribute("id");
    String type = (String)session.getAttribute("type");%>
<div class="topnav">
  <a  href="home.jsp">Home</a>
  <a class="active" href="profile.jsp">Profile</a>
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
    <%if (type.equals("student")) {%>
    <br>
    
    
    
    <form id="stname" onsubmit="return false;" >
        <b>Name :</b> <input type="text"  id="name1" required > <button type="submit"  class="button3" onclick="sendajax('name1');redirection();"  > Update </button><div id="show_response"></div>
        
        
    </form>
    
    <form id="stemail" onsubmit="return false;">
        <b>e-mail :</b> <input type="email"  id="email1" required> <button type="submit"  class="button3" onclick="sendajax2('email1');" >Update </button><div id="show_response2"></div>
    </form>
    
    <form id="stpass" onsubmit="return false;">
        <b>Password :</b> <input type="password"  id="pass1" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" title="Must contain at least one number and one uppercase and lowercase letter, and at least 8 or more characters" required > 
        <button type="submit" class="button3"  type="submit" onclick="sendajax3('pass1');" >Update </button><div id="show_response3"></div>
    </form>
    
    <form id="stmajor"onsubmit="return false;">
        <b>Major :</b> <input type="text"  id="major" required > <button class="button3"  type="submit" onclick="sendajax4('major');" >Update </button><div id="show_response4"></div>
    </form>
    <%}
else {%>
      <br>
    <form id="staname" onsubmit="return false;">
        <b>Name :</b> <input type="text"  id="name2" required > <button class="button3" type="submit" onclick="sendajax('name2');"  > Update </button><div id="show_response"></div>
    </form>
    
    <form id="staemail" onsubmit="return false;">
        <b>e-mail :</b> <input type="email" id="email2"  required> <button class="button3" type="submit" onclick="sendajax2('email2');"  > Update </button><div id="show_response2"></div>
    </form>
    
    <form id="stapass" onsubmit="return false;">
        <b>Password :</b> <input type="password"  id="pass2" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" title="Must contain at least one number and one uppercase and lowercase letter, and at least 8 or more characters" required > <button class="button3" type="submit" onclick="sendajax3('pass2');"  > Update </button><div id="show_response3"></div>
    </form>
    
    <form id="statitle" onsubmit="return false;">
        <b>Title :</b> <input type="text"  id="title" required > <button class="button3" type="submit" onclick="sendajax4('title');"  > Update </button><div id="show_response4"></div>
    </form>
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
                
                
                
                 RS = Stmt.executeQuery("SELECT * FROM courseStaff where staffID = '"+ID+"';");
                 %> <p><b>Courses :</b> </p> <%
                RS.last();
                Integer[] cid  = new Integer[RS.getRow()];
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
                    %> <form action="removeCourse">
                     &nbsp;&nbsp;  <%=RS.getString("name")%>  <button class="button4" name="course" value="<%=RS.getInt("courseID")%>" type="submit" > Remove </button>  
                    </form><%
                }
                    

                %>
                <form action="addCourse">
                    
                    <b>Select Course :</b> <select name="wdth" id="wdth" required  >
                          
			<%
                          RS = Stmt.executeQuery("SELECT * FROM courseStaff where staffID = '"+ID+"';");
                           RS.last();
                           cid  = new Integer[RS.getRow()];
                           c = 0;
                           RS.beforeFirst();
                            while (RS.next())
                            {
                                cid[c] =RS.getInt("courseID");;
                                c++;
                                
                            }
                            List<Integer> list = Arrays.asList(cid);
                            
                            
                            RS = Stmt.executeQuery("SELECT * FROM course ;");
                            
                            while (RS.next())
                            {
                                if(!list.contains(RS.getInt("courseID")))
                                {%>
                                   <option name="selectedC" value="<%=RS.getInt("courseID")%>"><%=RS.getString("name")%></option>
                                   
                                <%}

                            }
                            
                          %>
                      
                     <select/>                    

                <button type="submit" class="button3">Add</button><br>
                </form>
                  
                  
                  
                
                <%


                RS = Stmt.executeQuery("SELECT * FROM officeHours where staffID = '"+ID+"';");
                %> <p><b>Office Hours :</b> </p> <%
                while (RS.next())
                {
                    %><form action="removeOfficeHours">
                        
                         &nbsp;&nbsp; from <%=RS.getString("start")%> to <%=RS.getString("end")%> at <%=RS.getString("day")%> in <%=RS.getString("place")%>
                         <button class="button4" name="ohID" value="<%=RS.getInt("officeHoursID")%>" type="submit" > Remove </button> <br/>
                        </form><%
                }
                    
                
                
                
                
                
                
            %>
            
            <form action="addOfficeHours"  >
                <b>Day :</b>
                <input type="date" name ="date"  required >

                <b>Start :</b>
                <input type="time" min="00:00" name="start"   required >
                <b>End :</b>
                <input type="time" min="00:00" name="end"   required >
                <b>Place :<b/>
                <input type="text" name="place"  required>

                <button type="submit" class="button3">Add</button><br>
                
              </form>
            
            
            <form action="profile.jsp"  >
                

                <button type="submit" class="button3">Back</button><br>
                
              </form>
    
            
            
            
                                    

               
<%              Stmt.close();
                Con.close();
            } catch (Exception cnfe) {
                System.err.println("Exception: " + cnfe);
            }%>
<%}%>
</div>

    </body>
</html>
