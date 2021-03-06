<%@page import="com.mini.util.MD5"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Random"%>
<%@page import="com.mini.dao.MemberDAO"%>
<%@page import="com.mini.vo.MemberVO"%>
<%
	request.setCharacterEncoding("utf-8");

	MemberDAO dao = new MemberDAO();
	
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	String id = request.getParameter("id");

	int mno = dao.getPwdByNameAndEmailAndId(name, email, id);
	
	String newPwd  = "";
	if (mno > 0) {
		Random rnd = new Random(); 
		StringBuffer buf = new StringBuffer(); 
		for(int i=0;i<8;i++){ 
			if(rnd.nextBoolean()){ 
				buf.append((char)((int)(rnd.nextInt(26))+97)); 
			} else { 
				buf.append((rnd.nextInt(10))); 
			} 
		} 
		
		newPwd = buf.toString();		
		String secuPwd = MD5.hash(newPwd);
		dao.updatePwd(mno, secuPwd);
		
	}
%>

<!DOCTYPE html>
<html lang="en" >
<head>
<title>Mini Facebook</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="shortcut icon" href="https://www.facebook.com/images/fb_icon_325x325.png">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet" type="text/css">
<link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet" type="text/css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<style>
.container {
		margin-top:100px;
}

body {
    background-color: #A9BCF5;
}

.text-center {
	position: fixed;
	bottom: 0px;
	width: 100%;
	background-color: #F2F2F2;
}
.col-sm-6 div {
	font-size:16px;
}
.col-sm-6 div strong {
	font-size:18px;
}

p {
    font-size: 120%;
    text-align: center;
}
</style>
</head>

<body id="body" data-spy="scroll" data-target=".navbar" data-offset="50">
	
<nav class="navbar navbar-default navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>                        
      </button>
      <a class="navbar-brand" href="intro.jsp">MINI</a>
    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
		<form class="navbar-form navbar-right" method="post" action="member/login.jsp" autocomplete="on">
	      <div class="form-group">
	        <input type="text" id="memId" name="memId" class="form-control" placeholder="ID">
	      </div>
	      <div class="form-group">
	        <input type="password" id="memPwd" name="memPwd" class="form-control" placeholder="Password">
	      </div>
	      <button type="submit" class="btn btn-default">Log in</button>    
		</form>
    </div>
  </div>
</nav>
<div class= "container">
	<div class="row">
		<div class="col-md-6">
			<form method="post" action="getId.jsp">
				<div class="panel panel-primary">
					<div class="panel-heading">
								Find your ID
					</div>
					<div class="panel-body">
						<div class="form-group">
							<label>Type your name</label>
							<input type="text" class="form-control" id="name" name="name">
						</div>
					</div>
					<div class="panel-body">
						<div class="form-group">
							<label>Type your email</label>
							<input type="text" class="form-control" id="email" name="email">
						</div>
					</div>
					<div class="panel-body">
						<button type="submit" class="btn btn-primary pull-right">Submit</button>
					</div>
				</div>
			</form>
	</div>	
	
				
		<div class="col-md-6">
			<form method="post" action="getPwd.jsp"> 
				<div class="panel panel-primary">
					<div class="panel-heading">
								Find your Password
					</div>
					<div class="panel-body">
						<div class="form-group">
							<label>Type your name</label>
							<input type="text" class="form-control" id="user_name" name="name">
						</div>
					</div>
					<div class="panel-body">
						<div class="form-group">
							<label>Type your email</label>
							<input type="text" class="form-control" id="user_email" name="email">
						</div>
					</div>	

					<div class="panel-body">
						<div class="form-group">
							<label>Type your ID</label>
							<input type="text" class="form-control" id="user_id" name="id">
						</div>
						<div class="form-group">
							<label>Your New Password</label>
							<%
								if (mno == 0) {
							%>		
								<p><strong>No account available</strong></p>
							<%	
								} else {
							%>
								<p><strong><%=newPwd %></strong></p>
							<%
								}
							%>
						</div>	
					<button type="submit" class="btn btn-primary pull-right">Submit</button>	
					</div>
					
				</div>
			</form>
		</div>
	</div>	
</div>

</body>
</html>


