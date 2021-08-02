
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import static java.time.temporal.TemporalQueries.localTime;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mail.SendMail;

/**
 *
 * @author E.MOHAMED
 */
@WebServlet(urlPatterns = {"/cancel"})
public class cancel extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/officehoursmanagement";
                String user = "root";
                String password = "root";
                Connection Con = null;
                Statement Stmt = null;
                ResultSet rsNotify = null;
                ResultSet rs = null;
                ResultSet RS = null;
                ResultSet R = null;
                ResultSet RS2 = null;
                ArrayList<String> appointmentlist = new ArrayList<String>();
                ArrayList<String> appointmentIDlist = new ArrayList<String>();


                Con = DriverManager.getConnection(url, user, password);

                Stmt = Con.createStatement();

                String staffID = "";
                String studentID = "";
                String appointmentID = "";
                String start = "";
                String end = "";
                String day = "";
                String appointmentDate = "";
               

//                while (rs.next()) {
//                    staffID= rs.getString("staffID");   
//                    studentID= rs.getString("studentID"); 
//                    appointmentID= rs.getString("appointmentID");
//                    appointmentDate= rs.getString("day"); 
//                    start= rs.getString("start");
//                    end= rs.getString("end");
//                }
//                
//                String query = "delete from appointment where appointmentID = '"+appointment +"'";
//                int count = Stmt.executeUpdate(query);
//                
//                
//                 rsNotify=Stmt.executeQuery("select * from notification");
//                            int notifyID = 0;
//                            if(rsNotify.last()){
//                            notifyID = rsNotify.getInt("notificationID") ;
//                            notifyID++;
//                            }
//                                                        
//                            LocalDate date = LocalDate.now();
//                            LocalTime time = LocalTime.now();
                    LocalDate date = LocalDate.now();
                    LocalTime time = LocalTime.now();
                String type = request.getSession().getAttribute("type").toString();
                String ID = request.getSession().getAttribute("id").toString();

                if (type.equals("student")) {
                    String appointment = request.getParameter("appointment");

                    rs = Stmt.executeQuery("select * from appointment where appointmentID = '" + appointment + "'");

                    while (rs.next()) {
                        staffID = rs.getString("staffID");
                        studentID = rs.getString("studentID");
                        appointmentID = rs.getString("appointmentID");
                        appointmentDate = rs.getString("day");
                        start = rs.getString("start");
                        end = rs.getString("end");
                    }

                    String query = "delete from appointment where appointmentID = '" + appointment + "'";
                    int count = Stmt.executeUpdate(query);

                    rsNotify = Stmt.executeQuery("select * from notification");
                    int notifyID = 0;
                    if (rsNotify.last()) {
                        notifyID = rsNotify.getInt("notificationID");
                        notifyID++;
                    }

                    
                    String content = "Student " + studentID + " cancel the appointment with ID " + appointmentID + ", the appointment date was " + appointmentDate + ",starts at " + start + ", and ends at " + end + ". He canceled the appointment at date " + date + " and time" + time;

                    String line = "INSERT INTO notification (notificationID,date,time,content) VALUES("
                            + "'" + notifyID + "',"
                            + "'" + date + "',"
                            + "'" + time + "',"
                            + "'" + content + "')";

                    int Rows = Stmt.executeUpdate(line);

                    String line2 = "INSERT INTO staffNotification  (notificationID,staffID) VALUES("
                            + "'" + notifyID + "',"
                            + "'" + staffID + "')";
                    int Rows2 = Stmt.executeUpdate(line2);
                    RS = Stmt.executeQuery("SELECT * FROM staff where staffID = " + staffID + ";");
                    RS.next();
                    SendMail sendMail = new SendMail();
                    sendMail.send(RS.getString("email"), "Appointment cancelled ", content, "officehoursmanager@gmail.com", "ABc123456!");

                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('This Appointment is cancelled Successfully');");
                    out.println("location='appointments.jsp';");
                    out.println("</script>");

                }

                if (type.equals("staff")) {
                    
                String appointment = request.getParameter("appointment");
                String startform = request.getParameter("start");
                String endform = request.getParameter("end");
                if(startform.equals("")||endform.equals("")){
                    rs = Stmt.executeQuery("select * from appointment where day = '" + appointment + "'");
                    while (rs.next()) {
                        
                        staffID = rs.getString("staffID");
                        studentID = rs.getString("studentID");
                        appointmentID = rs.getString("appointmentID");
                        appointmentDate = rs.getString("day");
                        start = rs.getString("start");
                        end = rs.getString("end");
                        day = rs.getString("day");
                        appointmentlist.add(studentID);
                        
                    }

                    String query = "delete from appointment where day = '" + appointment +"' and staffID= '" + ID +"'";
;
                    int count = Stmt.executeUpdate(query);

                    rsNotify = Stmt.executeQuery("select * from notification");
                    int notifyID = 0;
                    if (rsNotify.last()) {
                        notifyID = rsNotify.getInt("notificationID");
                        notifyID++;
                    }

                    

                    String content = "Appointment with date " + appointment + " has been cancelled at date " + date + " and time" + time;

                    String line = "INSERT INTO notification (notificationID,date,time,content) VALUES("
                            + "'" + notifyID + "',"
                            + "'" + date + "',"
                            + "'" + time + "',"
                            + "'" + content + "')";

                    int Rows = Stmt.executeUpdate(line);
                    
                    for(int i=0 ; i < appointmentlist.size() ; i++){
                    String line2 = "INSERT INTO studentNotification  (notificationID,studentID) VALUES("
                            + "'" + notifyID + "',"
                            + "'" + appointmentlist.get(i) + "')";
                    int Rows2 = Stmt.executeUpdate(line2);
                    
                    
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                    RS = Stmt.executeQuery("SELECT * FROM student where studentID = " + appointmentlist.get(i) + ";");
                    RS.next();
                    SendMail sendMail = new SendMail();
                    sendMail.send(RS.getString("email"), "Appointment cancelled ", content, "officehoursmanager@gmail.com", "ABc123456!");
                    }
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Appointment/s cancelled Successfully');");
                    out.println("location='appointments.jsp';");
                    out.println("</script>");

                }
                
                
                else{
                day = request.getParameter("appointment");
                
                start = request.getParameter("start");
                end = request.getParameter("end");
                LocalTime st = LocalTime.parse(String.valueOf(start));
                LocalTime en = LocalTime.parse(String.valueOf(end));

                R = Stmt.executeQuery("select * from officehours where staffID  = '" + ID + "' and day= '" + day +"' and start= '" + start + "' and end= '" + end +"'");
                if (R.next()){
                RS = Stmt.executeQuery("select * from appointment where staffID  = '" + ID + "'");

                while (RS.next()) {
                   // boolean check = false;
                    if (RS.getString("day").equals(day)) {
                   
                    if ((st.isBefore( LocalTime.parse(RS.getString("start"))) || st.equals(LocalTime.parse(RS.getString("start")))) && (en.isAfter(LocalTime.parse(RS.getString("end"))) || en.equals(LocalTime.parse(RS.getString("end"))))) {
                        
                       // check = true;
                        appointmentID = RS.getString("appointmentID");
                        appointmentIDlist.add(appointmentID);
                        
                        appointmentlist.add(RS.getString("studentID"));
                    }
                   }
//                    if(check){
//                    rs = Stmt.executeQuery("select * from appointment where day = '" + appointment +"'");
//                    while (rs.next()) {
//                        
//                        staffID = rs.getString("staffID");
//                        studentID = rs.getString("studentID");
//                        appointmentID = rs.getString("appointmentID");
//                        appointmentDate = rs.getString("day");
//                        start = rs.getString("start");
//                        end = rs.getString("end");
//                        day = rs.getString("day");
//                        appointmentlist.add(studentID);
//                        appointmentIDlist.add(appointmentID);
//                     
//                        
//                    }}
                }
                if (appointmentIDlist.size()>0){
                    for(int i=0 ; i < appointmentIDlist.size() ; i++){
                   // String query = "delete from appointment where day = '" + appointment +"' and staffID= '" + ID +"' and start= '" + startform +"' and end= '" + endform +"'";
                    String query = "delete from appointment where appointmentID = '" + appointmentIDlist.get(i)+"'";

                    int count = Stmt.executeUpdate(query);
                    }
                    
                    rsNotify = Stmt.executeQuery("select * from notification");
                    int notifyID = 0;
                    if (rsNotify.last()) {
                        notifyID = rsNotify.getInt("notificationID");
                        notifyID++;
                    }

                    

                    String content = "Appointment with date " + appointment + " has been cancelled at date " + date + " and time" + time;

                    String line = "INSERT INTO notification (notificationID,date,time,content) VALUES("
                            + "'" + notifyID + "',"
                            + "'" + date + "',"
                            + "'" + time + "',"
                            + "'" + content + "')";

                    int Rows = Stmt.executeUpdate(line);
                    
                    for(int i=0 ; i < appointmentlist.size() ; i++){
                    String line2 = "INSERT INTO studentNotification  (notificationID,studentID) VALUES("
                            + "'" + notifyID + "',"
                            + "'" + appointmentlist.get(i) + "')";
                    int Rows2 = Stmt.executeUpdate(line2);
                    
                    
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                    RS = Stmt.executeQuery("SELECT * FROM student where studentID = " + appointmentlist.get(i) + ";");
                    RS.next();
                    SendMail sendMail = new SendMail();
                    sendMail.send(RS.getString("email"), "Appointment cancelled ", content, "officehoursmanager@gmail.com", "ABc123456!");
                    }
                    
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Appointment/s cancelled Successfully');");
                    out.println("location='appointments.jsp';");
                    out.println("</script>");
                    }
                else{
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('NO Appointments to cancel');");
                    out.println("location='appointments.jsp';");
                    out.println("</script>");
                }
                }
                    else{
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Enter right office hours slot');");
                    out.println("location='appointments.jsp';");
                    out.println("</script>");
                    }
                }
                    
                    
                }
                

                rs.close();
                RS2.close();
                RS.close();
                R.close();
                rsNotify.close();
                Stmt.close();
                Con.close();

            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
