<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%@ page import="com.mini.dao.MemberDAO"%>

 <%		
 
 	MemberVO member = (MemberVO) request.getSession().getAttribute("LOGIN_MEMBER");
 	int mno = member.getMemberNo();
 
 	MemberDAO dao = new MemberDAO();
	dao.withdrawalMember(mno);
	

	if (session != null) {
		session.invalidate();
	}
		
%>  
<script>
	alert("회원탈퇴 되었습니다.");
	location.href = "../intro.jsp";
</script>