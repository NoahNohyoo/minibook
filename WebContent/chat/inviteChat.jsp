<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ page import="com.mini.dao.ChatDAO"%>
<%
	int chatNo = Integer.parseInt(request.getParameter("chatNo").replaceAll("'", ""));
	String[] friends = request.getParameterValues("friends"); 
	String result = "";
	
	ChatDAO dao = new ChatDAO();
	
	
	for(String friend : friends) {
		dao.inviteChat(chatNo, friend);
		result += friend+", ";
	}
	out.write(result.substring(0, result.length()-2));
%>
