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
        <h1 class="sign" style="color: #02ced1">Appointments</h1>
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
            ResultSet rs5 = null;
            ResultSet rs6 = null;

            ArrayList<String> IDlist = new ArrayList<String>();
            ArrayList<String> daylist = new ArrayList<String>();

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

       
            <%       type = session.getAttribute("type").toString();
                ID = session.getAttribute("id").toString();

                try {

                    if (type.equals("student")) {%>
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
                 <%       RS = Stmt.executeQuery("select * from appointment where studentID  = '" + ID + "'");
                        while (RS.next()) {
                            if (RS.getBoolean("state") == false) {%>
 
            <tr>
                <td><%=RS.getString("appointmentID")%></td>
                <td><%=RS.getString("staffID")%></td>
                <td><%=RS.getString("studentID")%></td>
                <td><%=RS.getString("day")%></td>
                <td><%=RS.getString("start")%></td>
                <td><%=RS.getString("end")%></td>
                <td><%=RS.getString("place")%></td>
            </tr>
            <%}
                }
            %>


            <h3> Appointment Cancellation </h3>

            Select The Appointment ID You Want To Cancel
            <br> 
            <form action="cancel">

                <%
                    try {
                        rs = Stmt.executeQuery("select * from appointment where studentID  = '" + ID + "'");
                %>
                <select name="appointment" >
                    <%
                        while (rs.next()) {
                            if (rs.getBoolean("state") == false) {%>

                    <option><%=rs.getString("appointmentID")%></option>
                    <%}
                            }
                        } catch (Exception cnfe) {
                            System.err.println("Exception: " + cnfe);
                        }

                    %>
                </select>
                <input class="button button2" type="submit" value="cancel" />
            </form>

            <%}%>



            <%if (type.equals("staff")) {%>

            View history of appointments slot
            <br>
            <form action ="viewAppointmentshistory.jsp">
                Date: <input class="user" type="date" name="day" required >
                Start: <input class="user" type="time" name="start" required >
                End:  <input class="user" type="time" name="end"required >
                <button class="button button2 " >Show</button>

            </form>
            <br>
            <br>
            
            View history of appointments 
            <br>
            <form action ="dateAppointmentshistory.jsp">
                From Date: <input class="user" type="date" name="fromdate" required >
                To Date:  <input class="user" type="date" name="todate"required >
                <button class="button button2 " >Show</button>

            </form>
            <br>
            <br>

            View history of appointments place 
            <br>
            <form action ="placeAppointmentshistory.jsp">
                 <br>
                Place: <select name="place" > 
                    <option value="online">Online</option>
                    <option value="offline">Offline</option>

                </select>
                <button class="button button2 " >Show</button>

            </form>
            <br>
            <br>
          



            View appointment on a specific office hours slot
            <br>
            <form action ="viewAppointments.jsp">
                Day:  <input class="user" type="date" name="day" required >
                Start: <input class="user" type="time" name="start" required >
                End:  <input class="user" type="time" name="end" required >


                <button class="button button2 " >Show</button>

            </form>
            <br>
            <br>

            <h3> Appointment Cancellation </h3>

            Select The Appointment Date You Want To Cancel
            <br> 
            <form action="cancel">

                <%
                    try {
                        rs = Stmt.executeQuery("select * from appointment where staffID  = '" + ID + "'");

                        while (rs.next()) {
                            if (rs.getBoolean("state") == false && !daylist.contains(rs.getString("day"))) {

                                daylist.add(rs.getString("day"));

                            }

                        }%>
                <select name="appointment" > 
                    <% for (int i = 0; i < daylist.size(); i++) {%>
                    <option><%=daylist.get(i)%></option>
                    <%}%>
                </select>  
                
                
                Start: <input class="user" type="time" name="start" >
                End:  <input class="user" type="time" name="end" > 

                <%  } catch (Exception cnfe) {
                        System.err.println("Exception: " + cnfe);
                    }

                %>

                <input class="button button2" type="submit" value="cancel" />
            </form>
            <%}

                } catch (Exception cnfe) {
                    System.err.println("Exception: " + cnfe);
                }
            %>
        </table>

        <br/>

    </body>
</html>

<%
    try {
        rs5.close();
        rs6.close();
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