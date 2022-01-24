<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ page import="com.mini.dao.ChatDAO"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%
	MemberVO loginMember = (MemberVO)request.getSession().getAttribute("LOGIN_MEMBER");
	String memberId = loginMember.getMemberId();
	int chatNo = Integer.parseInt(request.getParameter("chatNo").replaceAll("'", ""));
	String chatText = request.getParameter("chatText");
	
	ChatDAO dao = new ChatDAO();
	dao.saveText(chatNo, memberId, chatText);
%>
