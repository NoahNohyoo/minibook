<%@page import="com.mini.vo.MemberVO"%>
<%@page import="com.mini.vo.BoardVO"%>
<%@page import="com.mini.dao.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
    <%@ include file="/include/include-navbar.jspf"%>
<%
	request.setCharacterEncoding("utf-8");
	MemberVO member = (MemberVO)request.getSession().getAttribute("LOGIN_MEMBER");
	BoardDAO dao = new BoardDAO();
	BoardVO board = new BoardVO();
	String listType = (String)request.getParameter("listType");
	board.setBoard_content(request.getParameter("board_content"));
	board.setBoard_level(Integer.parseInt(request.getParameter("board_level")));
	board.setMember_no(member.getMemberNo());
	board.setMember_name(member.getMemberName());
	dao.addNewComments(board);
	int cno = dao.findCommentNo(board);
	if ("null".equals(listType) || "undefined".equals(listType)) {
		response.sendRedirect("../main.jsp?listType=main&bno="+request.getParameter("bno")+"&cno="+cno);		
	} else {		
		response.sendRedirect("../main.jsp?listType="+listType+"&bno="+request.getParameter("bno")+"&cno="+cno);		
	}
%>