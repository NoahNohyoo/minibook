<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false"%>
    <%@ include file="/include/include-navbar.jspf"%>
<%
	request.setCharacterEncoding("utf-8");
	String keyword = request.getParameter("keyword");

	response.sendRedirect("../main.jsp?listType=search&keyword="+ URLEncoder.encode(keyword, "UTF-8"));
	return;
%>