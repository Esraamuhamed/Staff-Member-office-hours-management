
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Random;
import java.util.regex.Pattern;
import javax.servlet.RequestDispatcher;
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
@WebServlet(urlPatterns = {"/signUp_ajax"})
public class signUp_ajax extends HttpServlet {

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
                ResultSet Rs = null;

                Con = DriverManager.getConnection(url, user, password);

                Stmt = Con.createStatement();
                int random = (int) Math.round(Math.random());
                String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\."
                        + "[a-zA-Z0-9_+&*-]+)*@"
                        + "(?:[a-zA-Z0-9-]+\\.)+[a-z"
                        + "A-Z]{2,7}$";

                Pattern pat = Pattern.compile(emailRegex);

                String username = request.getParameter("username");
                String email = request.getParameter("email");
                email.toLowerCase();

                String type = request.getSession().getAttribute("type").toString();
                if (username == "") {
                    out.print("You Must Enter Your Name");
                } else if (email.equals("") || !pat.matcher(email).matches()) {
                    out.print("Enter A valid E-mail");
                } else {
                    if (type.equals("student")) {
                        String major = request.getParameter("major");
                        rs = Stmt.executeQuery("select * from student where email = '" + email + "'");
                        if (rs.next() == false) {
                            Rs = Stmt.executeQuery("select * from student");
                            int ID =201700;
                            if(Rs.last()){
                            ID = Rs.getInt("studentID");
                            ID++;
                            }
                            
                            String line = "INSERT INTO student  (studentID,name,email,password,major) VALUES("
                                    + "'" + ID + "',"
                                    + "'" + username + "',"
                                    + "'" + email + "',"
                                    + "'" + ID + username + random + "',"
                                    + "'" + major + "')";
                            int Rows = Stmt.executeUpdate(line);
                            
                            SendMail sendMail = new SendMail();
                            sendMail.send(email,"Office Hours Password  ", "Your password is "+ID + username + random, "officehoursmanager@gmail.com", "ABc123456!");
                            HttpSession session = request.getSession();
                            session.setAttribute("id", ID);
                            out.print(".");

                        } else {
                            out.print("This E-mail Has An Account");
                        }
                    } else if (type.equals("staff")) {
                        String title = request.getParameter("title");
                        rs = Stmt.executeQuery("select * from staff where email = '" + email + "'");
                        if (rs.next() == false) {
                            Rs = Stmt.executeQuery("select * from staff");
                            int ID =0;
                            if(Rs.last()){
                            ID = Rs.getInt("staffID");
                            ID++;
                            }
                            String line = "INSERT INTO staff  (staffID,name,email,password,title) VALUES("
                                    + "'" + ID + "',"
                                    + "'" + username + "',"
                                    + "'" + email + "',"
                                    + "'" + ID + username + random + "',"
                                    + "'" + title + "')";
                            int Rows = Stmt.executeUpdate(line);
                            SendMail sendMail = new SendMail();
                            sendMail.send(email,"Office Hours Password  ", "Your password is "+ID + username + random, "officehoursmanager@gmail.com", "ABc123456!");
                            HttpSession session = request.getSession();
                            session.setAttribute("id", ID);

                            out.print(".");

                        } else {
                            out.print("This E-mail Has An Account");
                        }
                    }

                }

                Rs.close();
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
