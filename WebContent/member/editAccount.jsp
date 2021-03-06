<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@page import="com.mini.util.MD5"%>
<%@page import="com.mini.dao.MemberDAO"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%
	request.setCharacterEncoding("utf-8");
	String userpwd = request.getParameter("memPwd");
	String listType = (String) request.getParameter("listType");
	MemberVO member = (MemberVO) request.getSession().getAttribute("LOGIN_MEMBER");
%>	

<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/include/include-header.jspf"%>
<style>

	.container {
		margin-top:70px;
	}
	
	body {
	background-image: url(http://images.natureworldnews.com/data/images/full/37685/the-universe-is-starting-to-die-scientists-say.jpg);

	}
	.title {
		margin-top:50px;
		margin-bottom:50px;
		font-color: white;	
	}

	h1 {
		font-size: 200%;
	  background-color: black;
	  background-color: black;
	  color: #fff; 
	  display: inline;
	  padding: 0.5rem;
	  
	  -webkit-box-decoration-break: clone;
	  box-decoration-break: clone;

	}
	
	p {
		font-size: 150%;
		 background-color: black;
	  background-color: black;
	  color: #fff; 
	  display: inline;
	  padding: 0.5rem;
	  
	  -webkit-box-decoration-break: clone;
	  box-decoration-break: clone;
	}
</style>

</head>
<body>
<%@ include file="../include/include-navbar.jspf"%>
	<div class="container">
		<div class="col-sm-4 col-sm-offset-4">
			<div class="panel panel-info">
				<div class="panel-heading">
					Account Settings
				</div>
				<div class="panel-body">
					<form method="post" action="uploadProfile.jsp" enctype="multipart/form-data" onsubmit="return formcheck();">
						<div class="form-group">				
							<label>Profile Photo</label>
							<br/>							
							<img src="../img/member_img/<%=member.getMemberPhoto()%>" class="img-circle" id="imgPhoto" height="120" width="120" style="margin-bottom:10px">
							<input type="file" name="photo" value="<%=member.getMemberPhoto() %>" id="photo" accept="image/*" style="display:none;">	
						</div>					
					
						<div class="form-group">
							<label>New Password</label>
							<input type="password" class="form-control" name="newpwd" id="newpwd"><span id='msgPwd'></span>
						</div>
						
						<div class="form-group">
							<label>Confirm New Password</label>
							<input type="password" class="form-control" name="confirm_pwd" id="confirm_pwd"><span id='msgRepwd'></span>
						</div>
					
						<div class="form-group">
							<label>Name</label>
							<input type="text" class="form-control" value="<%=member.getMemberName() %>" id="name" name="name">
						</div>
						<div class="form-group">
							<label>Gender</label>
							<input type="radio" name="gender" <%=member.getMemberGender().equals("F") ? "checked" : "" %> value="F" id="F"> female
							<input type="radio" name="gender" <%=member.getMemberGender().equals("M") ? "checked" : "" %> value="M" id="M"> male
							<input type="radio" name="gender" <%=member.getMemberGender().equals("O") ? "checked" : "" %> value="O" id="O"> others							
						</div>
						
						<div class="form-group">
							<label>Contact</label>
							<input type="text" class="form-control" value="<%=member.getMemberContact()%>" id="contact" name="contact">
						</div>
						
						<div class="form-group">
							<label>Address</label>
							<input type="text" class="form-control" value="<%=member.getMemberAddr()%>" id="addr" name="addr">
						</div>
						
						<div class="form-group">
							<label>Email</label>
							<input type="text" class="form-control" value="<%=member.getMemberEmail()%>" id="email" name="email">
						</div>
		
						<div class="form-group">
							<label>Date of Birth</label>
							<input type="date" class="form-control" value="<%=member.getMemberBirth()%>" id="dob" name="dob">
						</div>
						
						<div class="form-group" >
							<button type="submit" class="btn btn-default pull-left">Update</button> 
							<button type="button" id="btn-delete" class="btn btn-default pull-right" onclick="reallyDelete()">Withdrawal</button>						
						</div>	
					</form>		
				</div>
			</div>
		</div>
	</div>		
</body>

<%
	session.setAttribute("LOGIN_MEMBER", member);

	//response.sendRedirect("../main.jsp");
%>
<script type="text/javascript">

document.getElementById("photo").onchange = function () {
    var reader = new FileReader();

    reader.onload = function (e) {
        // get loaded data and render thumbnail.
        document.getElementById("imgPhoto").src = e.target.result;
    };

    // read the image file as a data URL.
    reader.readAsDataURL(this.files[0]);
};


$(document).ready(function() {
	
	$('#newpwd').on('keyup', function () {
		var userPwd = $("#newpwd").val().trim();
		
		if (userPwd.length >= 4) {
	        $('#msgPwd').html('').css('color', 'green');
		
		} else {
	        $('#msgPwd').html('4?????? ?????? ???????????????.').css('color', 'red');
	        $('#user').focus();
			return false;
			
		}
		
	});
	$('#confirm_pwd').on('keyup', function () {
		var userRepwd = $("#confirm_pwd").val();
		
	    if ($('#newpwd').val() == $('#confirm_pwd').val()) {
	        $('#msgRepwd').html('Matching').css('color', 'green');
	    } else 
	        $('#msgRepwd').html('Not Matching').css('color', 'red');
	});
	
	$("#imgPhoto").click(function() {
		$("#photo").click();
		
	});
});


/*		// ??????????????? ??????????????? ???????????? (8?????? ??????)
var pattern3 = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{8,}/;
if (!pattern3.test(pwd)) {
	alert("??????????????? 8?????? ??????, ?????? ????????? ?????????, ?????????, ??????, ??????????????? ???????????? ?????????.");
	pwdEL.focus();
	return false;
}

*/

function formcheck() {

	var pwdEL = document.getElementById("newpwd");
	var pwd = pwdEL.value.trim();
	var repwdEL = document.getElementById("confirm_pwd");
	var repwd = repwdEL.value.trim();
	var pattern3 = /(?=\S+$).{4,}/;
	
	if (pwd == "") { 
		if (repwd != "") {	
			alert("??????????????? ??????????????????.");
			pwdEL.focus();
			return false;
		}
	}
	
	if (pwd != "") {		
		if (!pattern3.test(pwd)) {
			alert("??????????????? 4?????? ?????? ??????????????????.");
			pwdEL.focus();
			return false;	
			
		} else if (pattern3.test(pwd))  {
			if (repwd == '') {
				alert("???????????? ???????????? ?????? ??????????????????.");
				repwdEL.focus();
				return false;
			}
			
		} else if (pattern3.test(pwd)) {
			if (repwd != '') {
				if (pwd != repwd) {
					alert("??????????????? ???????????? ????????????.");
					repwdEL.focus();
					return false;		
				}
				
			}
		}
	}
		
	var nameEL = document.getElementById("name");
	var name = nameEL.value.trim();
	if (name == "") {
		alert("????????? ?????? ??????????????????.");
		nameEL.focus();
		return false;
	}
	// ????????? ????????? ?????? 2?????? ???????????? ????????????
	var pattern1 = /^[???-???]{2,}$/;
	if (!pattern1.test(name)) {
		alert("????????? ?????? 2 ?????? ?????? ?????????????????????.");
		nameEL.focus();
		return false;
	}
	
	var genderEL = document.getElementById("F" || "M" || "O");
	
	var contactEL = document.getElementById("contact");
	var contact = contactEL.value.trim();
	if (contact == "") {
		alert("???????????? ?????? ??????????????????.");
		contactEL.focus();
		return false;
	}
/*
	var contactEL = document.getElementById("contact");
	var contact = contactEL.value.trim();				
	var pattern4 = /^01[016789]-\d{3,4}-\d{4}$/;
	if (!pattern4.test(contact)) {
		alert("01??? ???????????? 0/1/6/7/8/9 ??? ????????? ????????????-0~9??? ????????? ??????-0~9??? ?????? ??????????????????.");
		contactEL.focus();
		return false;
	}
*/	
	var addrEL = document.getElementById("addr");
	var addr = addrEL.value.trim();
	if (addr == "") {
		alert("????????? ?????? ??????????????????.");
		addrEL.focus();
		return false;
	}
	var emailEL = document.getElementById("email");
	var email = emailEL.value.trim();
	if (email == "") {
		alert("???????????? ?????? ??????????????????.");
		emailEL.focus();
		return false;
	}
	var dobEL = document.getElementById("dob");
	var dob = dobEL.value.trim();
	if (dob == "") {
		alert("??????????????? ?????? ??????????????????.");
		dobEL.focus();
		return false;
	}
	
	return true;
}
     
function reallyDelete() {
    var retVal = confirm("Do you really want to delete your account?");
    
    if (retVal) {
       location.href="withdrawalAccount.jsp";
    }
}
   
</script>
</html>