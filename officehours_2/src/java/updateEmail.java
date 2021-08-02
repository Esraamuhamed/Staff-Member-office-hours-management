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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.regex.Matcher; 
import java.util.regex.Pattern; 
import javax.servlet.http.HttpSession;
/**
 *
 * @author afnan
 */
@WebServlet(urlPatterns = {"/updateEmail"})
public class updateEmail extends HttpServlet {

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
            //out.print("Name updated successfully");
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
            
            String email = request.getParameter("name");
            

            try {
                
                Con = DriverManager.getConnection(url, user, password);
                Stmt = Con.createStatement();
                String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\."+ 
                            "[a-zA-Z0-9_+&*-]+)*@" + 
                            "(?:[a-zA-Z0-9-]+\\.)+[a-z" + 
                            "A-Z]{2,7}$"; 
                              
                Pattern pat = Pattern.compile(emailRegex); 
                
                if(email.equals("")||!pat.matcher(email).matches()){}
                else
                {
                    boolean check =false;
                    if (type.equals("student"))
                    {
                        RS = Stmt.executeQuery("SELECT * FROM student ");
                        
                        while (RS.next())
                        {
                            
                             
                            if(RS.getString("email").equals(email.toLowerCase()))
                            {
                                check=true;
                                out.print("This email already exists");
                                break;
                            }
                        }
                                
                        if(!check)
                        {
                            
                            String line = "UPDATE student SET email = '"+email.toLowerCase()+"'\n" +
                            "Where studentID ="+ID+";";
                            int Rows = Stmt.executeUpdate(line);
                            
                            out.print("Email updated successfully");
                        }
                    }
                    else 
                    {
                         RS = Stmt.executeQuery("SELECT * FROM staff ");
                        while (RS.next())
                        {
                            
                            if(RS.getString("email").equals(email))
                            {
                                check=true;
                                out.print("This email already exists");
                                break;
                            }
                        }
                        if(!check)
                        {
                            String line = "UPDATE staff SET email = '"+email.toLowerCase()+"'\n" +
                            "Where staffID ="+ID+";";
                            int Rows = Stmt.executeUpdate(line);
                            out.print("Email updated successfully");
                        }
                    }
                }
                
                
                
                Stmt.close();
                Con.close();
            } catch (Exception cnfe) {
                System.err.println("Exception: " + cnfe);
            }
            //sendMail.send("afnanetman@gmail,com","afnanetman@gmail,com", "afnanetman@gmail,com", "afnanetman@gmail,com", "Misskrisgalaxy");
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
