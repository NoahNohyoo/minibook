<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.mini.util.ConnectionUtil"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.mini.util.MD5"%>
<%@page import="com.mini.dao.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ page import="com.mini.vo.MemberVO"%>
<%@ page import="com.mini.vo.BoardVO"%>
<%@ page import="com.mini.dao.BoardDAO"%>
<%@ page import="java.util.ArrayList"%>
<%
	request.setCharacterEncoding("utf-8");

	String userpwd = request.getParameter("memPwd");
	String listType = (String) request.getParameter("listType");
	MemberVO member = (MemberVO) request.getSession().getAttribute("LOGIN_MEMBER");
	BoardDAO dao = new BoardDAO();
	
	System.out.println(userpwd);
	System.out.println(listType);
	System.out.println(member.getMemberName());
	
	
%>	

<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/include/include-header.jspf"%>
<style>

	.container {
		margin-top:150px;
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
					<strong>Account Successfully Updated</strong>
				</div>
				<div class="panel-body">
					<form method="post" action="editAccount.jsp">
						<div class="form-group" >
							<button type="submit" class="btn btn-default pull-left">Edit Account</button> 							
							<button type="button" id="btn-delete" class="btn btn-default pull-right" onclick="main()">Main Page</button>						
						</div>					
					</form>		
				</div>
			</div>
		</div>
	</div>		
</body>


<script type="text/javascript">
  
function main() {
	location.href="../main.jsp";
}
   
</script>
</html>