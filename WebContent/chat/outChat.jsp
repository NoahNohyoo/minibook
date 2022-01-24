<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ page import="com.mini.dao.ChatDAO"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%
	int chatNo = Integer.parseInt(request.getParameter("chatNo").replaceAll("'", ""));
	MemberVO loginMember = (MemberVO)request.getSession().getAttribute("LOGIN_MEMBER");
	String memberId = loginMember.getMemberId();
	
	ChatDAO dao = new ChatDAO();
	dao.outChat(chatNo, memberId);
%>
<script>
	opener.parent.location.reload();
	window.close();
</script>
