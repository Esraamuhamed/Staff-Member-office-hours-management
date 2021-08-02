<%@page import="java.time.LocalTime"%>
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
            String type = (String) session.getAttribute("type");%>

        <div class="topnav">
            <a  href="home.jsp">Home</a>
            <a href="profile.jsp">Profile</a>
            <a href="messages.jsp">Messages</a>
            <a class="active" href="appointments.jsp">Appointments</a>
            <%
                if (type.equals("student")) {

            %>
            <a href="courses.jsp">Courses</a> <%}%>
            <a href="signOut">Sign Out</a>
            <%
                if (type.equals("student")) {

            %>
            <div class="search-container">
                <form action="search.jsp">
                    <input type="text" placeholder="Search for staff member.." name="search">
                    <button type="submit"><i class="fa fa-search"></i></button> 

                </form>

            </div> <%} else {

            %>
            <div class="search-container">
                <form action="search.jsp">
                    <input type="text" placeholder="Search for student.." name="search">
                    <button type="submit"><i class="fa fa-search"></i></button> 

                </form>

            </div> <%}%>
        </div>
        <h1 style="color: #02ced1">Appointments</h1>
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

            try {
                RS2 = Stmt.executeQuery("select * from appointment;");

                while (RS2.next()) {
                    String appointmentID = RS2.getString("appointmentID");
                    String day = RS2.getString("day");
                    day += " " + RS2.getString("end");
                    LocalDateTime now = LocalDateTime.now();
                    DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                    String formattedDate = now.format(myFormatObj);
                    LocalDateTime end = LocalDateTime.parse(day, myFormatObj);
                    if (end.isBefore(now)) {

                        IDlist.add(appointmentID);

                    }
                }

                for (int k = 0; k < IDlist.size(); k++) {

                    String query = "Update appointment set state = '" + 1 + "' where appointmentID = '" + IDlist.get(k) + "'";
                    int count = Stmt.executeUpdate(query);

                }

            } catch (Exception cnfe) {
                System.err.println("Exception: " + cnfe);
            }
        %>

        <table border="1">
            <tr>

                <th style="color: #02ced1">appointment ID</th> 
                <th style="color: #02ced1">Staff ID</th> 
                <th style="color: #02ced1">Student ID</th> 
                <th style="color: #02ced1">Day</th> 
                <th style="color: #02ced1">Start</th> 
                <th style="color: #02ced1">End</th> 
                <th style="color: #02ced1">Place</th> 
            </tr>

            <%       ID = session.getAttribute("id").toString(); %>

            <%
                String day = request.getParameter("day");
                String start = request.getParameter("start");
                String end = request.getParameter("end");
                LocalTime st = LocalTime.parse(String.valueOf(start));

                LocalTime en = LocalTime.parse(String.valueOf(end));

                RS = Stmt.executeQuery("select * from appointment where staffID  = '" + ID + "'");
                
                while (RS.next()) {
                    boolean check = false;
                    if (RS.getString("day").equals(day)) {
                    if ((st.isBefore( LocalTime.parse(RS.getString("start"))) || st.equals(LocalTime.parse(RS.getString("start")))) && (en.isAfter(LocalTime.parse(RS.getString("end"))) || en.equals(LocalTime.parse(RS.getString("end"))))) {
                        
                        check = true;
                    }
               
                   }
                    if(check){
            %>
<tr>
                <td><%=RS.getString("appointmentID")%></td>
                <td><%=RS.getString("staffID")%></td>
                <td><%=RS.getString("studentID")%></td>
                <td><%=RS.getString("day")%></td>
                <td><%=RS.getString("start")%></td>
                <td><%=RS.getString("end")%></td>
                <td><%=RS.getString("place")%></td>

                <% if (RS.getBoolean("state")) {%> <td>Done</td> <%} else {%> <td>Upcoming</td> <%}%>
            </tr>
            
            <%}}%>


        </table>

        <br/>
        <form action="appointments.jsp">
            <button class="button button2 " >Back</button>
        </form>
    </body>
</html>

<%
    try {
        RS2.close();
        rs2.close();
        RS.close();
        rs.close();
        Stmt.close();
        Con.close();

    } catch (Exception cnfe) {
        System.err.println("Exception: " + cnfe);
    }

%>