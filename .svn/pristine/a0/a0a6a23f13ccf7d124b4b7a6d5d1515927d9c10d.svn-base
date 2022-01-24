<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.mini.dao.MemberDAO"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%
	MemberVO loginMember = (MemberVO)request.getSession().getAttribute("LOGIN_MEMBER");
	int memberNo = loginMember.getMemberNo();
	
	MemberDAO dao = new MemberDAO();
	ArrayList<MemberVO> requesters = dao.getFriendRequesters(memberNo);
%>
<c:set var="requesters" value="<%=requesters%>" />
<c:choose>
	<c:when test="${fn:length(requesters) > 0}" >
		<div class="alert alert-success fade in">
			<a href="#" class="close" data-dismiss="alert" aria-label="close">×</a>
			<p>
				<strong>New Message!</strong>
			</p>
			<c:forEach var="list" items="${requesters}" varStatus="i">
				<p>
					<strong>${list.memberId}</strong> wants to be friend with you.
					<input type="button" value="accept" onClick="javascript:goAccept(${list.memberNo});"/>
					<input type="button" value="deny" onClick="javascript:goDeny(${list.memberNo});"/>
				</p>
			</c:forEach>
		</div>
	</c:when>
</c:choose>

<script>

	function goAccept(no) {
		location.href = "member/answerForRequestFriend.jsp?answer=A&friendNo="+no;
	}
	
	function goDeny(no) {
		location.href = "member/answerForRequestFriend.jsp?answer=D&friendNo="+no;
	}
</script>