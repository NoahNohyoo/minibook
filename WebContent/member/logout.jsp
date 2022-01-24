<%@page import="com.mini.vo.MemberVO"%>
<%@page import="com.mini.dao.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	if (session != null) {
		MemberDAO memberDao = new MemberDAO();
		MemberVO member = (MemberVO)request.getSession().getAttribute("LOGIN_MEMBER");
		memberDao.toggleLogined("N", member.getMemberNo());
		session.invalidate();
	}
	
	response.sendRedirect("../intro.jsp");

%>