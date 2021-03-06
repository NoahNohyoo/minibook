<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.mini.dao.ChatDAO"%>
<%@ page import="com.mini.vo.ChatVO"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%
	MemberVO loginMember = (MemberVO)request.getSession().getAttribute("LOGIN_MEMBER");
	String memberId = loginMember.getMemberId();
	
	ChatDAO chatdao = new ChatDAO();
	ArrayList<ChatVO> chatList = chatdao.loadChatList(memberId);
%>
<c:set var="chatList" value="<%=chatList%>" />

<c:choose>
	<c:when test="${fn:length(chatList) > 0}" >
		<c:forEach var="list" items="${chatList}" >
			<c:choose>
				<c:when test="${fn:length(list.chatTitle) > 30}">
					<p><strong><a href="javascript:openChat(${list.chatNo})">${fn:substring(list.chatTitle, 0, 30)}..</a></strong></p>
				</c:when>
				<c:otherwise>
					<p><strong><a href="javascript:openChat(${list.chatNo})">${list.chatTitle}</a></strong></p>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<p style="margin-top:80px; text-align:center;">
			<strong>no active chats</strong>
		</p>
	</c:otherwise>
</c:choose>
<script>
	function openChat(chatNo) {
		var popUrl = "chat/chat.jsp?chatNo="+chatNo;
		var popOption = "width=451, height=598, resizable=yes, scrollbars=no, status=no, toolbar=no, loation=no, directories=no";    //팝업창 옵션(optoin)
		window.open(popUrl,"",popOption);
	}
</script>