<%-- 
    Document   : signUp
    Created on : Jan 8, 2021, 2:42:14 AM
    Author     : E.MOHAMED
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet"  type="text/css" href="style.css" >
        <!--        <script src="https://www.google.com/recaptcha/api.js"></script>-->
        <script src="https://www.google.com/recaptcha/api.js" async defer></script>


        <script type="text/javascript">

            function sendajax() {
                var username = document.getElementById("username").value;
                var email = document.getElementById("email").value;
                var majorOrtitle = document.getElementById("majorOrtitle").value;

                var xmlhttp = new XMLHttpRequest();

                xmlhttp.open("GET", "signUp_ajax?username=" + username + "&email=" + email + "&major=" + majorOrtitle + "&title=" + majorOrtitle, true);
                xmlhttp.send();

                xmlhttp.onreadystatechange = function ()
                {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
                    {
                        document.getElementById("show_response").innerHTML = xmlhttp.responseText;

                    }

                }
            }


            function redirection()
            {

                var response = document.getElementById("show_response").innerHTML;
                //alert(response);
                if (response == ".")
                {

                    window.location.replace("home.jsp");
                } else
                {
                    return false;
                }
            }

            function test() {
                var response = grecaptcha.getResponse();
                if (response.length == 0)
                {
                    //reCaptcha not verified
                    alert("please verify you are humann!");
                    test.preventDefault();
                    return false;
                }
            }



        </script>
    <body>

        <div class="topnav">     
            <a href="index.html">Home</a>
        </div>

        <h1 style=" color:#02ced1 ; font-size: 2.4em" >Sign Up</h1>
        <br>

        <form>

            <label>Name</label>
            <br>
            <input class="user" type="text" name="username" id="username" required> 
            <!--            <div id="show_response"></div>-->

            <br>
            <br>

            <label>E-mail</label>
            <br>
            <input class="user" type="email"  name="email" id="email" required> 
            <!--            <div id="show_response"></div>-->
            <br>
            <br>
            <% String user = session.getAttribute("type").toString();%>

            <%
               if (user.equals("student")) {%>
            <label>Major</label>
            <!--            <div id="show_response"></div>-->
            <br>
            <!--            <input required class="user" type="text" name="major" > -->
            <select  name="major" id="majorOrtitle" required>
                <option value="IS">IS</option>
                <option value="CS">CS</option>
                <option value="IT">IT</option>
                <option value="DS">DS</option>
            </select>
            <%  } else if (user.equals("staff")) {
            %>

            <label>Title</label>
            <br>
            <select   name="title" id="majorOrtitle" required>
                <option value="doctor">Doctor</option>
                <option value="TA">TA</option>

            </select>
            <%}%>
            <br>
            <br>
            <div id="show_response"></div>


            <br>


            <div class="form_container">
                <form id="my_captcha_form">
                    <div class="g-recaptcha" 
                         data-sitekey="6LcZiCQaAAAAAICylE8J09rmRV4V6eio4y51CZYw" 
                         ></div>
                </form>
            </div>      
            <input type="button" class="button button2 " value="Sign Up" onclick=" test();sendajax();redirection();"/>

        </form>

    </body>
</html>
