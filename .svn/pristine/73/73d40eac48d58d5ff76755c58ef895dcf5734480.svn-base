<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
</style>
</head>
<body id="body" data-spy="scroll" data-target=".navbar" data-offset="50" >
	
<nav class="navbar navbar-default navbar-fixed-top">
  <div class="container-fluid" >
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>                        
      </button>
      <a class="navbar-brand" href="#">MINI</a>
    </div>
    <form class="navbar-form navbar-right" method="post" action="member/login.jsp" onsubmit="return loginFormCheck()">
      <div class="form-group">
        <input type="text" id="memId" name="memId" class="form-control" placeholder="ID">
      </div>
      <div class="form-group">
        <input type="password" id="memPwd" name="memPwd" class="form-control" placeholder="Password">
      </div>
      <button type="submit" class="btn btn-default">Log in</button> 
      <div class="form-group">
       <p><a href="getAccount.jsp">forgot account?</a></p>
      </div>   
    </form>		
    </div>
</nav>

<div class="container">
	<div class="row">
		<div class="col-sm-6">
			<div>
				<h1>Connect with friends and the world around you on MINI Facebook.</h1>
			</div><br/>
			<div>
				<img src="/mini/img/intro_01.png" width="45px" height="45px">	
				<strong>See photos and updates</strong> from friends in News Feed.
			</div><br/>
			<div>
				<img src="/mini/img/intro_02.png" width="45px" height="45px">	
				<strong>Share what's new</strong> in your life on your Timeline.
			</div><br/>
			<div>
				<img src="/mini/img/intro_03.png" width="45px" height="45px">	
				<strong>Find more</strong> of what you're looking for with Facebook Search.
			</div>
			<div>
				<img src="/mini/img/intro_04.png" width="530px" height="200px">	
			</div>
		</div>
				
		<div class="col-sm-4 col-sm-offset-2">
			<div class="panel panel-info">
				<div class="panel-heading">
					Sign Up	
				</div>
				<div class="panel-body">
					<form method="post" action="member/register.jsp" onsubmit="return registryFormCheck();" >
						<div class="form-group">
							<label>ID</label>
							<input type="text" class="form-control" id="user-id" name="id" onkeyup="duplicateCheck()">
							<div id="result-box"></div>
						</div>
						<div class="form-group">
							<label>Password</label>
							<input type="password" class="form-control" id="user-pwd" name="pwd"><span id='msgPwd'></span>
						</div>
						 
						<div class="form-group">
							<label>Confirm Password</label>
							<input type="password" class="form-control" id="user-repwd" name="repwd"><span id='msgRepwd'></span>
						</div>
						
						<div class="form-group">
							<label>Name</label>
							<input type="text" class="form-control" id="user-name" name="name">
						</div>
						
						<div class="form-group">
							<label>Gender</label>
							<input type="radio" name="gender" value="F" checked="checked"> female
							<input type="radio" name="gender" value="M"> male
							<input type="radio" name="gender" value="O"> others							
						</div>
						
						<div class="form-group">
							<label>Contact</label>
							<input type="text" class="form-control" id="user-contact" name="contact" placeholder="numbers only">
						</div>
						
						<div class="form-group">
							<label>Address</label>
							<input type="text" class="form-control" id="user-addr" name="addr">
						</div>
						
						<div class="form-group">
							<label>Email</label>
							<input type="text" class="form-control" id="user-email" name="email">
						</div>

						<div class="form-group">
							<label>Date of Birth</label>
							<input type="date" class="form-control" id="user-dob" name="dob">
						</div>						
						<div class="form-group">
							<button type="submit" class="btn btn-default pull-right">Register</button> 
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<footer class="text-center">
  <a class="up-arrow" href="#">
    <span class="glyphicon glyphicon-chevron-up"></span>
  </a><br><br>
  <p>
  	<strong>MINI Facebook © 2017</strong>
  </p> 
</footer>
</body>
<script type="text/javascript">

	function duplicateCheck() {
		var regiId = document.getElementById('user-id').value;
		console.log("입력한 아이디", regiId);
		
		// 1. XHR 생성하기
		var xhr = new XMLHttpRequest(); // chrome, IE7+, Safari, Opera
		
		// 4. XHR에서 이벤트 발생시 실행될 콜백함수 등록하기
		xhr.onreadystatechange = function() {
			//console.log(xhr.readyState);
			if (xhr.readyState == 4 && xhr.status == 200) {
				var result = xhr.responseText.trim();
				console.log("중복여부", result);
				
				var box = document.getElementById("result-box");
				
				if (result == "Y") {
					box.innerHTML = "<p class='text-danger'>not available</p>";
				
				} else if (result == "N") {
					box.innerHTML = "<p class='text-success'>available</p>";
							
				}
			}
		}
		// 2. XHR에 요청 URL 지정하기
		xhr.open("GET", "idDuplicationCheck?user=id" + regiId);
		
		// 3. 서버에게 요청을 보내기
		xhr.send(null);
		
	}

	$(document).ready(function() {
		$("#memId").focus();
		
		$('#user-pwd').on('keyup', function () {
			var userPwd = $("#user-pwd").val().trim();
			
			if (userPwd.length >= 4) {
		        $('#msgPwd').html('').css('color', 'green');
			
			} else {
		        $('#msgPwd').html('Please type at least 4 characters.').css('color', 'red');
		        $('#user').focus();
				return false;
				
			}
			
		});
		$('#user-repwd').on('keyup', function () {
			var userRepwd = $("#user-repwd").val();
			
		    if ($('#user-pwd').val() == $('#user-repwd').val()) {
		        $('#msgRepwd').html('Matching').css('color', 'green');
		    } else 
		        $('#msgRepwd').html('Not Matching').css('color', 'red');
		});
	});
	

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

	function registryFormCheck() {
		
		// 아이디가 입력됐는지 확인하기 
		var idEL = document.getElementById("user-id");
		var id = idEL.value.trim();
		if (id == "") {
			alert("Please type your ID.");
			idEL.focus();
			return false;
		}	
		
		var pwdEL = document.getElementById("user-pwd");
		var pwd = pwdEL.value.trim();
		if (pwd == '') {
			alert("Please type your password.");
			pwdEL.focus();
			return false;
		}
		
		var pattern3 = /(?=\S+$).{4,}/;
		if (!pattern3.test(pwd)) {
			alert("Please type at least 4 characters.");
			pwdEL.focus();
			return false;
		}
		
		var repwdEL = document.getElementById("user-repwd");
		var repwd = repwdEL.value.trim();
		if (repwd == '') {
			alert("Please re-enter your password.");
			repwdEL.focus();
			return false;
		}
	
		if (pwd != repwd) {
			alert("Passwords do not match.");
			repwdEL.focus();
			return false;
		}

/*		// 비밀번호가 입력됐는지 체크하기 (8글자 이상)
		var pattern3 = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{8,}/;
		if (!pattern3.test(pwd)) {
			alert("비밀번호는 8글자 이상, 하나 이상의 대문자, 소문자, 숫자, 특수문자를 포함해야 합니다.");
			pwdEL.focus();
			return false;
		}

*/		
		var nameEL = document.getElementById("user-name");
		var name = nameEL.value.trim();
		if (name == "") {
			alert("이름은 필수 입력값입니다.");
			nameEL.focus();
			return false;
		}
		// 사용자 이름이 한글 2글자 이상인지 체크하기
		var pattern1 = /^[가-힣]{2,}$/;
		if (!pattern1.test(name)) {
			alert("이름은 한글 2 글자 이상 입력해야합니다.");
			nameEL.focus();
			return false;
		}

		var contactEL = document.getElementById("user-contact");
		var contact = contactEL.value.trim();
		if (contact == "") {
			alert("연락처는 필수 입력값입니다.");
			contactEL.focus();
			return false;
		}
/*		
		var contactEL = document.getElementById("user-contact");
		var contact = contactEL.value.trim();				
		var pattern4 = /^01[016789]-\d{3,4}-\d{4}$/;
		if (!pattern4.test(contact)) {
			alert("01로 시작해서 0/1/6/7/8/9 중 하나를 선택하고-0~9중 세네개 선택-0~9중 네개 선택해주세요.");
			contactEL.focus();
			return false;
		}
*/	
		var addrEL = document.getElementById("user-addr");
		var addr = addrEL.value.trim();
		if (addr == "") {
			alert("주소는 필수 입력값입니다.");
			addrEL.focus();
			return false;
		}
		var emailEL = document.getElementById("user-email");
		var email = emailEL.value.trim();
		if (email == "") {
			alert("이메일은 필수 입력값입니다.");
			emailEL.focus();
			return false;
		}
		var dobEL = document.getElementById("user-dob");
		var dob = dobEL.value.trim();
		if (dob == "") {
			alert("생년월일은 필수 입력값입니다.");
			dobEL.focus();
			return false;
		}
		
		return true;
	}
	$(document).ready(function() {
		$("#memId").focus();
	});
	
</script>
</html>
