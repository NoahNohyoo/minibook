<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="com.mini.util.MD5"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%@ page import="com.mini.dao.MemberDAO"%>

		<% 
			request.setCharacterEncoding("utf-8");

			String userid = request.getParameter("memId");
			String userpwd = request.getParameter("memPwd");
			
			MemberDAO memberDao = new MemberDAO();
			MemberVO member = memberDao.getMemberById(userid);

			// 입력한 아이디에 해당하는 사용자 정보가 없는 경우
			if (member == null) {
				response.sendRedirect("loginError.jsp?err");
				return;
			
			}
			
			String securityPassword = MD5.hash(userpwd);
			if (!securityPassword.equals(member.getMemberPwd())) {
				response.sendRedirect("loginError.jsp?err");
				return;
			}

			memberDao.toggleLogined("Y", member.getMemberNo());
			session.setMaxInactiveInterval(60 * 60); // 세션 60분 유지
			session.setAttribute("LOGIN_MEMBER", member);
			
			response.sendRedirect("../main.jsp");
		%>
		
