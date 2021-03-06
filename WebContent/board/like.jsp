<%@page import="com.mini.vo.BoardVO"%>
<%@page import="com.mini.dao.BoardDAO"%>
<%@page import="com.mini.vo.MemberVO"%>
<%@ include file="/include/include-navbar.jspf"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false"%>
<%
	request.setCharacterEncoding("utf-8");
	MemberVO member = (MemberVO) request.getSession().getAttribute("LOGIN_MEMBER");
	BoardDAO dao = new BoardDAO();
	int bno = Integer.parseInt(request.getParameter("bno"));
	int cno = 0;
	String listType = request.getParameter("listType");
	int member_no = 0;
	BoardVO board = new BoardVO();
	board.setBoard_no(bno);
	board.setMember_name(member.getMemberName());
	board.setMember_no(member.getMemberNo());
	boolean isAlreadyLike = false;
	if (request.getParameter("cno")!=null){
		cno = Integer.parseInt(request.getParameter("cno"));
		isAlreadyLike = dao.isAlreadyLike(cno, member.getMemberNo());
		if (isAlreadyLike) {
			%>
			<script>alert("you already liked it!");</script>
			<%
			
			if ("user".equals(listType)) {
				member_no = Integer.parseInt(request.getParameter("member_no"));
				response.sendRedirect("../main.jsp?bno="+bno+"&cno="+cno+"&listType="+listType+"&member_no="+member_no);	
				return;
			}
			String url = "../main.jsp?bno="+bno+"&cno="+cno+"&listType="+listType;

			response.sendRedirect(url);				
			return;
			
		} else {
			dao.likeBoard(cno, member.getMemberNo());
			if ("user".equals(listType)) {
				member_no = Integer.parseInt(request.getParameter("member_no"));
				response.sendRedirect("../main.jsp?bno="+bno+"&cno="+cno+"&listType="+listType+"&member_no="+member_no);	
				return;
			}
			response.sendRedirect("../main.jsp?bno="+bno+"&cno="+cno+"&listType="+listType);				
			return;
		}
	}
	
	isAlreadyLike = dao.isAlreadyLike(bno, member.getMemberNo());
	if (isAlreadyLike) {
		%>
		<script>alert("you already liked it!");</script>
		<%
		if ("user".equals(listType)) {			
			member_no = Integer.parseInt(request.getParameter("member_no"));
			response.sendRedirect("../main.jsp?bno="+bno+"&listType="+listType+"&member_no="+member_no);
			return;
		}
		response.sendRedirect("../main.jsp?bno="+bno+"&listType="+listType);
		return;
	} else {
		dao.likeBoard(bno, member.getMemberNo());
		dao.autoUpdateBoardWhenLike(board);
		if ("user".equals(listType)) {			
			member_no = Integer.parseInt(request.getParameter("member_no"));
			response.sendRedirect("../main.jsp?bno="+bno+"&listType="+listType+"&member_no="+member_no);
			return;
		}
		response.sendRedirect("../main.jsp?bno="+bno+"&listType="+listType);
		return;
	}
%>