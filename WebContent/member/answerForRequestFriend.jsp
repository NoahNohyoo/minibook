<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ page import="com.mini.dao.MemberDAO"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%
	MemberVO loginMember = (MemberVO)request.getSession().getAttribute("LOGIN_MEMBER");
	int memberNo = loginMember.getMemberNo();
	int friendNo = Integer.parseInt(request.getParameter("friendNo"));
	String answer = request.getParameter("answer");
	
	MemberDAO dao = new MemberDAO();
	
	if ("A".equals(answer)) {
		dao.requestAcceptForFriend(memberNo, friendNo);
		
	} else if ("D".equals(answer)) {
		dao.requestDenyForFriend(memberNo, friendNo);
	}
	
	response.sendRedirect("../main.jsp");
%>