<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ page import="com.mini.dao.ChatDAO"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%
	MemberVO loginMember = (MemberVO)request.getSession().getAttribute("LOGIN_MEMBER");
	String memberId = loginMember.getMemberId();
	String chatTitle = request.getParameter("chatTitle");
	String accessType = request.getParameter("accessType");	

	if("AP".equals(accessType)) {
		chatTitle = chatTitle + " by " + memberId; 
	}
	
	ChatDAO dao = new ChatDAO();
	dao.createNewChat(memberId, chatTitle);
	int chatNo = dao.getNewChatNo(memberId);
	
	
	if("AP".equals(accessType)) {
		dao.inviteChat(chatNo, chatTitle.substring(0,chatTitle.indexOf("(")));
	}
%>
<script>
	var popUrl = "chat.jsp?chatNo=<%=chatNo%>";
	var popOption = "width=451, height=598, resizable=yes, scrollbars=no, status=no, toolbar=no, loation=no, directories=no";    //팝업창 옵션(optoin)
	window.open(popUrl,"",popOption);

	if ("AP" == "<%=accessType%>") {
		history.back();
		
	} else {
		location.href = "../main.jsp";
	}
</script>
