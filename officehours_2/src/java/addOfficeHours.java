/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author afnan
 */
@WebServlet(urlPatterns = {"/addOfficeHours"})
public class addOfficeHours extends HttpServlet {

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
            
            String date = request.getParameter("date");
            String start = request.getParameter("start");
            String end = request.getParameter("end");
            String place = request.getParameter("place");
            //out.print(date+start+end);
            
            DateFormat sdf = new SimpleDateFormat("hh:mm"); 
            java.util.Date s = sdf.parse(start);
            java.util.Date e = sdf.parse(end);
            
            try {
                
                Con = DriverManager.getConnection(url, user, password);
                Stmt = Con.createStatement();
                
                boolean check = false;
                RS = Stmt.executeQuery("SELECT * FROM officeHours where staffID = '"+ID+"';");
                while(RS.next())
                {
                    
                        java.util.Date st = sdf.parse(RS.getString("start"));
                        java.util.Date en = sdf.parse(RS.getString("end"));
                    
                    if(RS.getString("day").equals(date)&&((st.before(s)&&en.after(s))||(st.before(e)&&en.after(e)||(st.before(s)&&en.after(e))||(s.before(st)&&e.after(en)))))
                    {
                        check = true;
                    }
                    
                    LocalDate today = LocalDate.now();
                    
                    LocalDate day = LocalDate.parse(date);
                    LocalTime time = LocalTime.now();
                    LocalTime x= LocalTime.parse(end);
                    out.print("erm "+today+" "+day+" "+time+" "+x);
                   
                    
                    if (day.isBefore(today)&&x.isBefore(time)) check=true;
                    
                    
                }
                if (check)
                {
//                    out.println("<script type=\"text/javascript\">");
//                    out.println("alert('You cant add this slot');");
//                    out.println("location='updateProfile.jsp';");
//                    out.println("</script>");
//                    
                    Stmt.close();
                    Con.close();
                }
                else
                {
                    RS = Stmt.executeQuery("SELECT * FROM officeHours;");
                    RS.last();
                    int ofID=0;
                    if(RS.getRow()==0) ofID=1;
                    else { ofID = RS.getInt("officeHoursID")+1;}
                    
                 String line = "Insert into officehours (officeHoursID,staffID,day,start,end,place) values ("+ofID+","+ID+",'"+date+"','"+start+"','"+end+"','"+place+"');";
                 int Rows = Stmt.executeUpdate(line);
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('Slot added successfully');");
                    out.println("location='updateProfile.jsp';");
                    out.println("</script>");
                    Stmt.close();
                    Con.close();
                    
                }
                
//                
                
                
                
                
                Stmt.close();
                Con.close();
            } catch (Exception cnfe) {
                System.err.println("Exception: " + cnfe);
            }
        } catch (ParseException ex) {
            Logger.getLogger(addOfficeHours.class.getName()).log(Level.SEVERE, null, ex);
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
