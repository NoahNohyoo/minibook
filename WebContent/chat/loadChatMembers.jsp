<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" session="false" trimDirectiveWhitespaces="true"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.mini.dao.ChatDAO"%>
<%
	int chatNo = Integer.parseInt(request.getParameter("chatNo").replaceAll("'", ""));
	
	ChatDAO dao = new ChatDAO();
	JSONArray data = dao.loadChatMembers(chatNo);

	out.write(data.toJSONString());
%>
