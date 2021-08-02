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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author E.MOHAMED
 */
@WebServlet(urlPatterns = {"/validation"})
public class validation extends HttpServlet {

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
                ResultSet RS= null;

                Con = DriverManager.getConnection(url, user, password);
                 
                Stmt = Con.createStatement();
                
                String email = request.getParameter("email");
                email.toLowerCase();
                String Password = request.getParameter("password");
                String type =request.getSession().getAttribute("type").toString();

                
            
          
               if(type.equals("student"))
           {
               RS=Stmt.executeQuery("select * from student where email = '"+email+"'");
               String studentID = "";
 
               while(RS.next()){
               studentID = RS.getString("studentID");
               }
//               HttpSession session = request.getSession ();
//               session.setAttribute("ID", studentID);
           
                
                
                rs=Stmt.executeQuery("select * from student where email = '"+email +"' and password = '"+Password+"'");
                
            if(rs.next()) {
                //out.println("The user is valid");
                HttpSession session = request.getSession ();
                 //session.setAttribute("email", email);
                 //HttpSession session = request.getSession ();
                 session.setAttribute("id", rs.getInt("studentID"));
                 
                 response.sendRedirect("home.jsp");
            }
            else {
               out.println("<script type=\"text/javascript\">");
                        out.println("alert('Your data is invalid');");
                        out.println("location='signIn.html';");
                        out.println("</script>");
            }}
           
                    
         if(type.equals("staff"))
           {
               RS=Stmt.executeQuery("select * from staff where email = '"+email+"'");
               String staffID = "";
 
               while(RS.next()){
               staffID = RS.getString("staffID");
               }
//               HttpSession session = request.getSession ();
//               session.setAttribute("ID", studentID);
           
                
                
                rs=Stmt.executeQuery("select * from staff where email = '"+email +"' and password = '"+Password+"'");
                
            if(rs.next()) {
                //out.println("The user is valid");
                HttpSession session = request.getSession ();                
                 session.setAttribute("id", rs.getInt("staffID"));
                 
                 response.sendRedirect("home.jsp");
            }
            else {
               out.println("<script type=\"text/javascript\">");
                        out.println("alert('Your data is invalid');");
                        out.println("location='signIn.html';");
                        out.println("</script>");
            }}
                   
               
               
                rs.close();
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
