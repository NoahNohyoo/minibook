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
	ArrayList<MemberVO> friends = dao.getFriendsByMemberNo(memberNo);
%>
<c:set var="friends" value="<%=friends%>" />

<c:choose>
	<c:when test="${fn:length(friends) > 0}" >
		<c:forEach var="list" items="${friends}" varStatus="i">
			<c:choose>
				<c:when test="${list.memberIsLogined eq 'Y'}">
					<p style="text-align:left;"><a href="javascript:toggleOption(${i.index})"><img src="img/member_img/${list.memberPhoto}" class="img-circle" width="35" height="35"> <strong>${list.memberId}(${list.memberName})</strong><i class="fa fa-user-circle" style="font-size:18px;color:#04B404"></i></a></p>
					<div style="display:none;" id="fList${i.index}">
						<p><a href="javascript:linkFriend(${list.memberNo})"><strong>friend page</strong></a></p>
						<p><a href="javascript:delFriend(${list.memberNo})"><strong>delete</strong></a></p>
					</div>
				</c:when>
				<c:otherwise>
					<p style="text-align:left;"><a href="javascript:toggleOption(${i.index})"><img src="img/member_img/${list.memberPhoto}" class="img-circle" width="35" height="35"> <strong>${list.memberId}(${list.memberName})</strong><i class="fa fa-user-circle" style="font-size:18px;color:#A4A4A4"></i></a></p>
					<div style="display:none;" id="fList${i.index}">
						<p><a href="javascript:linkFriend(${list.memberNo})"><strong>friend page</strong></a></p>
						<p><a href="javascript:delFriend(${list.memberNo})"><strong>delete</strong></a></p>
					</div>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<p style="margin-top:20px; text-align:center;">
			<strong>no friends</strong>
		</p>
	</c:otherwise>
</c:choose>

<script>

	function toggleOption(i) {
		var select = document.getElementById("fList"+i);
		if ('none' == select.style.display) {
			select.style.display = 'block';
		} else {
			select.style.display = 'none';
		}
	}

	function linkFriend(no) {
		location.href = "/mini/main.jsp?listType=user&member_no="+no;
		
	}
	
	function delFriend(no) {
		var answer = confirm("Are you sure?");
		if(answer) {
			location.href = "member/deleteFriend.jsp?friendNo="+no;
		} else {
			return false;
		}
		
	}
</script>