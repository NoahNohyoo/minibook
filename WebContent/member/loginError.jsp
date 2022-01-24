<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<title>sample</title>
<style>
.container {
		margin-top:100px;
}

body {
    background-color: #ccdcff;
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

p  {
    color: red;
    font-family: verdana;
    font-size: 160%;
}

</style>
</head>
<body>

<nav class="navbar navbar-default navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>                        
      </button>
      <a class="navbar-brand" href="../intro.jsp">MINI</a>
    </div>
    <div class="collapse navbar-collapse" id="myNavbar">	    
		<form class="navbar-form navbar-right" method="post" action="login.jsp" onsubmit="return loginFormCheck()">
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
<div class="container">
	<h1>Error</h1>
	

	<%
		String err = request.getParameter("err");
		String errorMessage = null;
		if (err != null) {	
				errorMessage = "ID or Password is incorrect.";			
		}
	%>
	
	<%
		if (errorMessage != null) {			
	%>	
		<p><%=errorMessage %></p>
	<%	
		}
	%>
</div>
</body>
<script type="text/javascript">

function loginFormCheck() {
	
	var memIdEL = document.getElementById("memId");
	var memId = memIdEL.value.trim();
	if (memId == "") {
		alert("Please type your ID.");
		memIdEL.focus();
		return false;
	}	
	
	// 비밀번호가 입력됐는지 체크하기 (8글자 이상)
	var memPwdEL = document.getElementById("memPwd");
	var memPwd = memPwdEL.value.trim();
	if (memPwd == '') {
		alert("Please type your Password.");
		memPwdEL.focus();
		return false;
	}
	
	return true;
}

</script>