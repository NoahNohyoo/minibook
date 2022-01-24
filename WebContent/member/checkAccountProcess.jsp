<%@page import="com.mini.vo.MemberVO"%>
<%@page import="com.mini.dao.MemberDAO"%>
<%@page import="com.mini.util.MD5"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
 <%
	 request.setCharacterEncoding("utf-8");

	String pwd = request.getParameter("pwd");
	
	MemberDAO memberDao = new MemberDAO();
	MemberVO member = (MemberVO) request.getSession().getAttribute("LOGIN_MEMBER");
	
	String memberId = member.getMemberId();
	String securityPassword = MD5.hash(pwd);
	
	boolean result = memberDao.checkAccount(memberId, securityPassword);
	
	if (!result) {
%>

<script>
	alert("회원정보가 일치하지 않습니다.");
	history.back();
</script>

<%
	} else {

		response.sendRedirect("editAccount.jsp");
	
	}
%>







