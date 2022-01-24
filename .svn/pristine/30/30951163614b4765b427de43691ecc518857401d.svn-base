<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.mini.dao.ChatDAO"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%
	int chatNo = Integer.parseInt(request.getParameter("chatNo").replaceAll("'", ""));
	MemberVO loginMember = (MemberVO)request.getSession().getAttribute("LOGIN_MEMBER");
	String memberId = loginMember.getMemberId();
	
	ChatDAO dao = new ChatDAO();
	JSONArray data = dao.getText(chatNo, memberId);
	
	out.write(data.toJSONString());
%>