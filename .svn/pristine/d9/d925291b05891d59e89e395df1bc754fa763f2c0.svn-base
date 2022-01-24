<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ page import="com.mini.dao.MemberDAO"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%
	MemberVO loginMember = (MemberVO)request.getSession().getAttribute("LOGIN_MEMBER");
	int memberNo = loginMember.getMemberNo();
	String accessType = request.getParameter("accessType");
	int friendNo = Integer.parseInt(request.getParameter("friendNo"));
	
	MemberDAO dao = new MemberDAO();
	dao.requestFriend(memberNo, friendNo);
	
%>
<script>
	var at = "<%=accessType%>";
	if ("P" == at) {
		alert("request complete!");
		opener.parent.opener.parent.location.reload();
		opener.parent.location.reload();
		window.close();

	} else {
		alert("request complete!");
		opener.parent.location.reload();
		window.close();
	}
</script>