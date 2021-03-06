<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/include/include-header.jspf"%>
<style>
	.container {
		margin-top:100px;
	}

</style>
</head>
<body>
<%@ include file="../include/include-navbar.jspf"%>
	<div class="container">
	 	<div class="col-sm-4 col-sm-offset-4">
			<div class="panel panel-info">
				<div class="panel-heading">
					Security Check
				</div>
				<div class="panel-body">
					<form method="post" action="checkAccountProcess.jsp" id="frm">							
						<div class="form-group">
							<label>Password</label>
							<input type="password" class="form-control" name="pwd" id="pwd">
						</div>					
					</form>
					<div class="form-group" >
						<button class="btn btn-default pull-left" id="btnSubmit">edit my account</button> 
					</div>
				</div>
			</div>
		</div>
</div>	
</body>
<script>
	$(document).ready(function() {
		$("#pwd").focus();
		
		$("#btnSubmit").click(function() {
			var pwd = $("#pwd").val().trim();
			if(null == pwd || "" == pwd) {
				alert("비밀번호를 입력해주세요.");
				$("#pwd").focus();
				return false;
			}
			
			$("#frm").submit();
			
		});
		
	});
</script>
</html>