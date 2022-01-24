<%@page import="com.mini.dao.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ include file="/include/include-navbar.jspf"%>
<%
	request.setCharacterEncoding("utf-8");
	BoardDAO dao = new BoardDAO();
	int bno = Integer.parseInt(request.getParameter("bno"));
	int cno;
	String listType = request.getParameter("listType");
	int member_no;
	
	
	if (request.getParameter("cno")!=null) {
		cno = Integer.parseInt(request.getParameter("cno"));
		dao.deleteCommentByNo(cno);
		if ("user".equals(listType)) {
			member_no = Integer.parseInt(request.getParameter("member_no"));
			response.sendRedirect("../main.jsp?bno="+bno+"&listType="+listType+"&member_no="+member_no);

		} else {
			response.sendRedirect("../main.jsp?bno="+bno+"&listType="+listType);

		}
	} else {		
		dao.deleteBoardByNo(bno);
		if ("user".equals(listType)) {
			member_no = Integer.parseInt(request.getParameter("member_no"));
			response.sendRedirect("../main.jsp?listType="+listType+"&member_no="+member_no);
	
		} else {
			response.sendRedirect("../main.jsp?listType="+listType);
		}
	}
	
%>
