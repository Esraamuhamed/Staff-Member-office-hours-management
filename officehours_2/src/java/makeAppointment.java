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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mail.SendMail;

/**
 *
 * @author afnan
 */
@WebServlet(urlPatterns = {"/makeAppointment"})
public class makeAppointment extends HttpServlet {

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
            /* TODO output your page here. You may use following sample code. */
            HttpSession session = request.getSession(true);
            int ID =(int) session.getAttribute("id");
            String type = (String)session.getAttribute("type");
            int staffID= (int)session.getAttribute("staffID");
            
            
            try {
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(updateName.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            String url = "jdbc:mysql://localhost:3306/officehoursmanagement";
            String user = "root";
            String password = "root";
            String Line;
            Connection Con = null;
            Statement Stmt = null;
            ResultSet RS = null;
            
            String day = request.getParameter("day");
            String start = request.getParameter("start");
            String end = request.getParameter("end");
            //int staffID = Integer.parseInt(request.getParameter("staff"));
            //out.print(day+start+end+place);
            String place ="";
            LocalTime s= LocalTime.parse(start);
            LocalTime e= LocalTime.parse(end);

            try {
                
                Con = DriverManager.getConnection(url, user, password);
                Stmt = Con.createStatement();
                
                if(day.equals("")||start.equals("")||end.equals("")){}
                else
                {
                    boolean check = false;
                    RS = Stmt.executeQuery("SELECT * FROM officeHours where staffID = '"+staffID+"';");
                    
                    while(RS.next())
                    {
                        LocalTime st= LocalTime.parse(String.valueOf(RS.getString("start")));
                        LocalTime en= LocalTime.parse(String.valueOf(RS.getString("end")));
                        if (RS.getString("day").equals(day))
                        {
                            if ((st.isBefore(s)||st.equals(s))&&(en.isAfter(e)||en.equals(e)))
                            {
                                place=RS.getString("place");
                                check=true;
                            }
                        }
                    }
                    if (check)
                    {
                        RS = Stmt.executeQuery("SELECT * FROM appointment;");
                        RS.last();
                        int AID = 0;
                        if(RS.getRow()==0) AID=1;
                        else AID=RS.getInt("appointmentID")+1;
                        LocalDate date = LocalDate.parse(day);
                        //out.print(start+s);
                        String line = "Insert into appointment (appointmentID,staffID,studentID,day,start,end,place,state) values ("+ AID+","+staffID+","+ID+",'"+date+"','"+start+"','"+end+"','"+place+"',"+0+");";
                        int Rows = Stmt.executeUpdate(line);
                        out.print("Your appointment is accepted");
                        RS = Stmt.executeQuery("SELECT * FROM notification;");
                        RS.last();
                        int Nd = 0;
                        if (RS.getRow()==0) Nd+=1;
                        else Nd = RS.getInt("NotificationID")+1;
                        LocalDate today = LocalDate.now();
                        LocalTime now = LocalTime.now();
                        RS = Stmt.executeQuery("SELECT * FROM student where studentID ="+ID+";");
                        RS.next();
                        String stname = RS.getString("name");
                        
                        //String content = "Student "+stname+" made an appointment from "+s+" to "+e+" at "+place;
                        String content = "Student "+stname+" made an appointment from "+s+" to "+e+" at "+place + " on " + day;

                        
                        line = "Insert into notification (notificationID,date,time,content) values ("+ Nd+",'"+today+"','"+now+"','"+content+"');";
                        Rows = Stmt.executeUpdate(line);
                        line = "Insert into staffNotification (notificationID,staffID) values ("+ Nd+","+staffID+");";
                        Rows = Stmt.executeUpdate(line);
                        RS = Stmt.executeQuery("SELECT * FROM staff where staffID = "+staffID+";");
                        RS.next();
                        SendMail.send(RS.getString("email"),"Upcoming Appointment ", content, "officehoursmanager@gmail.com", "ABc123456!");
                        
                        
                    }
                    else out.print("You can't make this appointment");
                        
                }
                
                //out.print(day+start+end+place+staffID);
                
                
                
                Stmt.close();
                Con.close();
            } catch (Exception cnfe) {
                System.err.println("Exception: " + cnfe);
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
