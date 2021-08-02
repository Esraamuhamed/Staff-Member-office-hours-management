/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mail.SendMail;

/**
 *
 * @author E.MOHAMED
 */
@WebServlet(urlPatterns = {"/send"})
public class send extends HttpServlet {

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
                ResultSet rs = null;
                ResultSet RS = null;
                ResultSet rs2 = null;
                ResultSet rs3 = null;
                ResultSet rsNotify = null;
                int notifyID = 0;

                ArrayList<String> IDlist = new ArrayList<String>();

                Con = DriverManager.getConnection(url, user, password);
                Stmt = Con.createStatement();

                String courseID = request.getParameter("courseID");
                String to = request.getParameter("to");
                String title = request.getParameter("title");
                String content = request.getParameter("content");

                String type = request.getSession().getAttribute("type").toString();
                String ID = request.getSession().getAttribute("id").toString();
                LocalDate date = LocalDate.now();
                LocalTime time = LocalTime.now();

                if (type.equals("student")) {

                    RS = Stmt.executeQuery("select * from coursestaff where staffID= '" + to + "'");
                    if (RS.next() || to.length() == 0) {
                        rs = Stmt.executeQuery("select * from message");
                        int messageID = 0;
                            if(rs.last()){
                            messageID = rs.getInt("messageID");
                             messageID++;
                            }
                        String line = "INSERT INTO message  (messageID,title,content,date,time) VALUES("
                                + "'" + messageID + "',"
                                + "'" + title + "',"
                                + "'" + content + "',"
                                + "'" + date + "',"
                                + "'" + time + "')";
                        int Rows = Stmt.executeUpdate(line);

                        rsNotify = Stmt.executeQuery("select * from notification");
                            if(rsNotify.last()){
                            notifyID = rsNotify.getInt("notificationID");
                            notifyID++;
                            }
                        
                        String notifycontent = "Student " + ID + " send you a message at date " + date + " and time " + time;
                        String line3 = "INSERT INTO notification (notificationID,date,time,content) VALUES("
                                + "'" + notifyID + "',"
                                + "'" + date + "',"
                                + "'" + time + "',"
                                + "'" + notifycontent + "')";

                        int Rows3 = Stmt.executeUpdate(line3);

                        if (to.length() == 0) {

                            rs2 = Stmt.executeQuery("select * from coursestaff where courseID= '" + courseID + "'");
                            while (rs2.next()) {
                                IDlist.add(rs2.getString("staffID"));
                            }

                            for (int k = 0; k < IDlist.size(); k++) {
                                String line2 = "INSERT INTO staffinbox  (messageID,fromID,toID) VALUES("
                                        + "'" + messageID + "',"
                                        + "'" + ID + "',"
                                        + "'" + IDlist.get(k) + "')";
                                int Rows2 = Stmt.executeUpdate(line2);

                                String line4 = "INSERT INTO staffNotification  (notificationID,staffID) VALUES("
                                        + "'" + notifyID + "',"
                                        + "'" + IDlist.get(k) + "')";
                                int Rows4 = Stmt.executeUpdate(line4);
                                RS = Stmt.executeQuery("SELECT * FROM staff where staffID = "+IDlist.get(k)+";");
                                RS.next();
                                SendMail sendMail = new SendMail();
                                sendMail.send(RS.getString("email"),"New Message ", notifycontent, "officehoursmanager@gmail.com", "ABc123456!");
                            }
                        } else {
                            String line2 = "INSERT INTO staffinbox  (messageID,fromID,toID) VALUES("
                                    + "'" + messageID + "',"
                                    + "'" + ID + "',"
                                    + "'" + to + "')";
                            int Rows2 = Stmt.executeUpdate(line2);
                            String line4 = "INSERT INTO staffNotification  (notificationID,staffID) VALUES("
                                    + "'" + notifyID + "',"
                                    + "'" + to + "')";
                            int Rows4 = Stmt.executeUpdate(line4);
                            RS = Stmt.executeQuery("SELECT * FROM staff where staffID = "+to+";");
                                RS.next();
                                SendMail sendMail = new SendMail();
                                sendMail.send(RS.getString("email"),"New Message ", notifycontent, "officehoursmanager@gmail.com", "ABc123456!");
                            
                        

                        }
                        out.println("<script type=\"text/javascript\">");
                        out.println("alert('Your Message Sent Successfully');");
                        out.println("location='messages.jsp';");
                        out.println("</script>");

                    } else {
                        out.println("<script type=\"text/javascript\">");
                        out.println("alert('Enter a valid Staff ID');");
                        out.println("location='sendMessage.jsp';");
                        out.println("</script>");
                    }
                }

///-----------------------------------------------------------------------------------------------------------------------------
                if (type.equals("staff")) {

                    RS = Stmt.executeQuery("select * from coursestaff where staffID= '" + to + "'");

                    if (RS.next() || to.length() == 0) {
                        rs = Stmt.executeQuery("select * from message");
                        int messageID = 0;
                            if(rs.last()){
                            messageID = rs.getInt("messageID");
                             messageID++;
                            }
                        String line = "INSERT INTO message  (messageID,title,content,date,time) VALUES("
                                + "'" + messageID + "',"
                                + "'" + title + "',"
                                + "'" + content + "',"
                                + "'" + date + "',"
                                + "'" + time + "')";
                        int Rows = Stmt.executeUpdate(line);

                        rsNotify = Stmt.executeQuery("select * from notification");
                        if(rsNotify.last()){
                            notifyID = rsNotify.getInt("notificationID");
                            notifyID++;
                            }
                        String notifycontent = "Staff " + ID + " send you a message at date " + date + " and time " + time;
                        String line3 = "INSERT INTO notification (notificationID,date,time,content) VALUES("
                                + "'" + notifyID + "',"
                                + "'" + date + "',"
                                + "'" + time + "',"
                                + "'" + notifycontent + "')";

                        int Rows3 = Stmt.executeUpdate(line3);

                        if (to.length() == 0) {

                            rs2 = Stmt.executeQuery("select * from coursestaff where courseID= '" + courseID + "'");
                            while (rs2.next()) {
                                if ((rs2.getString("staffID").equals(ID)==false)){
                                IDlist.add(rs2.getString("staffID"));}
                            }

                            for (int k = 0; k < IDlist.size(); k++) {
                                String line2 = "INSERT INTO stafftostaff  (messageID,fromID,toID) VALUES("
                                        + "'" + messageID + "',"
                                        + "'" + ID + "',"
                                        + "'" + IDlist.get(k) + "')";
                                int Rows2 = Stmt.executeUpdate(line2);

                                String line4 = "INSERT INTO staffNotification  (notificationID,staffID) VALUES("
                                        + "'" + notifyID + "',"
                                        + "'" + IDlist.get(k) + "')";
                                int Rows4 = Stmt.executeUpdate(line4);
                                RS = Stmt.executeQuery("SELECT * FROM staff where staffID = "+IDlist.get(k)+";");
                                RS.next();
                                SendMail sendMail = new SendMail();
                                sendMail.send(RS.getString("email"),"New Message ", notifycontent, "officehoursmanager@gmail.com", "ABc123456!");
                            }

                        } else {
                            String line2 = "INSERT INTO stafftostaff  (messageID,fromID,toID) VALUES("
                                    + "'" + messageID + "',"
                                    + "'" + ID + "',"
                                    + "'" + to + "')";
                            int Rows2 = Stmt.executeUpdate(line2);

                            String line4 = "INSERT INTO staffNotification  (notificationID,staffID) VALUES("
                                    + "'" + notifyID + "',"
                                    + "'" + to + "')";
                            int Rows4 = Stmt.executeUpdate(line4);
                            RS = Stmt.executeQuery("SELECT * FROM staff where staffID = "+to+";");
                                RS.next();
                                SendMail sendMail = new SendMail();
                                sendMail.send(RS.getString("email"),"New Message ", notifycontent, "officehoursmanager@gmail.com", "ABc123456!");

                        }
                        out.println("<script type=\"text/javascript\">");
                        out.println("alert('Your Message Sent Successfully');");
                        out.println("location='messages.jsp';");
                        out.println("</script>");

                    }
                    //send message to student
                    rs3 = Stmt.executeQuery("select * from student where studentID= '" + to + "'");
                    if (rs3.next()) {
                        rs = Stmt.executeQuery("select * from message");
                        int messageID = 0;
                            if(rs.last()){
                            messageID = rs.getInt("messageID");
                             messageID++;
                            }
                        String line = "INSERT INTO message  (messageID,title,content,date,time) VALUES("
                                + "'" + messageID + "',"
                                + "'" + title + "',"
                                + "'" + content + "',"
                                + "'" + date + "',"
                                + "'" + time + "')";
                        int Rows = Stmt.executeUpdate(line);

                        
                        rsNotify = Stmt.executeQuery("select * from notification");
                        if(rsNotify.last()){
                            notifyID = rsNotify.getInt("notificationID");
                            notifyID++;
                            }
                        String notifycontent = "Staff " + ID + " send you a message at date " + date + " and time " + time;
                        String line3 = "INSERT INTO notification (notificationID,date,time,content) VALUES("
                                + "'" + notifyID + "',"
                                + "'" + date + "',"
                                + "'" + time + "',"
                                + "'" + notifycontent + "')";

                        int Rows3 = Stmt.executeUpdate(line3);

                        String line2 = "INSERT INTO studentinbox  (messageID,fromID,toID) VALUES("
                                + "'" + messageID + "',"
                                + "'" + ID + "',"
                                + "'" + to + "')";
                        int Rows2 = Stmt.executeUpdate(line2);

                        String line6 = "INSERT INTO studentNotification  (notificationID,studentID) VALUES("
                                + "'" + notifyID + "',"
                                + "'" + to + "')";
                        int Rows6 = Stmt.executeUpdate(line6);
                        RS = Stmt.executeQuery("SELECT * FROM student where studentID = "+to+";");
                                RS.next();
                                SendMail sendMail = new SendMail();
                                sendMail.send(RS.getString("email"),"New Message ", notifycontent, "officehoursmanager@gmail.com", "ABc123456!");

                        out.println("<script type=\"text/javascript\">");
                        out.println("alert('Your Message Sent Successfully');");
                        out.println("location='messages.jsp';");
                        out.println("</script>");

                    } else {
                        out.println("<script type=\"text/javascript\">");
                        out.println("alert('Enter a valid ID');");
                        out.println("location='sendMessage.jsp';");
                        out.println("</script>");
                    }
                }

                rs.close();
                rs3.close();
                RS.close();
                rs2.close();
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
