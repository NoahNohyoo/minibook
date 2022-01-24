<%@page import="com.mini.dao.BoardDAO"%>
<%@page import="com.mini.vo.MemberVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
    <%@ include file="/include/include-navbar.jspf"%>
<%
	request.setCharacterEncoding("utf-8");
	MemberVO member = (MemberVO) request.getSession().getAttribute("LOGIN_MEMBER");
	BoardDAO dao = new BoardDAO();
	int bno = Integer.parseInt(request.getParameter("bno"));
	String listType = request.getParameter("listType");
	int member_no = 0;
	boolean isAlreadySubscribed = false;

	isAlreadySubscribed = dao.isAlreadySubscribed(bno, member.getMemberNo());
	if (isAlreadySubscribed) {
		dao.removeBoardFromSubscribe(bno, member.getMemberNo());
		
		if ("user".equals(listType)) {			
			member_no = Integer.parseInt(request.getParameter("member_no"));
			response.sendRedirect("../main.jsp?bno="+bno+"&listType="+listType+"&member_no="+member_no+"&subcon=no");
		}
		response.sendRedirect("../main.jsp?bno="+bno+"&listType="+listType+"&subcon=no");
		return;
	} else {
		dao.addBoardToSubscribe(bno, member.getMemberNo());

		if ("user".equals(listType)) {			
			member_no = Integer.parseInt(request.getParameter("member_no"));
			response.sendRedirect("../main.jsp?bno="+bno+"&listType="+listType+"&member_no="+member_no+"&subcon=yes");
		}
		response.sendRedirect("../main.jsp?bno="+bno+"&listType="+listType+"&subcon=yes");
		return;
	}

%>