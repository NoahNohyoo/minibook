<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.mini.dao.PeopleDAO"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%@ page import="java.util.ArrayList"%>
<%
	MemberVO loginMember = (MemberVO)request.getSession().getAttribute("LOGIN_MEMBER");
	int memberNo = loginMember.getMemberNo();
	double memberLat = loginMember.getMemberLat();
	double memberLng = loginMember.getMemberLng();
	
	PeopleDAO peopledao = new PeopleDAO();
	ArrayList<MemberVO> people = peopledao.getAroundPeople(memberLat, memberLng, memberNo);
	
%>
<c:set var="people" value="<%=people%>" />

<c:choose>
	<c:when test="${fn:length(people) > 0}" >
		<c:forEach var="list" items="${people}" >
			<c:choose>
				<c:when test="${fn:length(list.memberId) > 16}">
					<p>
						<strong><a href="javascript:openInfoPerson('${list.memberNo}')"><img src="img/member_img/${list.memberPhoto}" class="img-circle" width="35" height="35"> ${list.memberId}(${list.memberName}) - ${list.shortDistance}km</a></strong>
					</p>
				</c:when>
				<c:otherwise>
					<p>
						<strong><a href="javascript:openInfoPerson('${list.memberNo}')"><img src="img/member_img/${list.memberPhoto}" class="img-circle" width="35" height="35"> ${list.memberId}(${list.memberName}) - ${list.shortDistance}km</a></strong>
					</p>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<p style="margin-top:80px; text-align:center;">
			<strong>no people</strong>
		</p>
	</c:otherwise>
</c:choose>
<script>
	function openInfoPerson(memberNo) {
		var popUrl = "people/infoPerson.jsp?memberNo="+memberNo;
		var popOption = "width=520, height=500, resizable=no, scrollbars=no, status=no, toolbar=no, loation=no, directories=no";    //팝업창 옵션(optoin)
		window.open(popUrl,"",popOption);
	}
</script>
