<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.List"%>
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
                DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                String x = request.getParameter("fromdate") + " 12:00:00";
                LocalDateTime startDate = LocalDateTime.parse(x, myFormatObj);
                String y = request.getParameter("todate") + " 12:00:00";
                LocalDateTime endDate = LocalDateTime.parse(y, myFormatObj);
                RS = Stmt.executeQuery("select * from appointment  where staffID  = '" + ID + "'");

                while (RS.next()) {
                    String day = RS.getString("day") + " 12:00:00";
                    LocalDateTime Date = LocalDateTime.parse(day, myFormatObj);
                    String appointmentID = RS.getString("appointmentID");
                    if ((startDate.isBefore(Date)||startDate.equals(Date)) && (endDate.isAfter(Date)||endDate.equals(Date))) {

                        // IDlist.add(appointmentID);

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