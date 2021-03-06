<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mini.dao.PeopleDAO"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%
	request.setCharacterEncoding("UTF-8");
	String accessType = request.getParameter("accessType");
	if (null == accessType) {
		accessType = "";
	}
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	
	PeopleDAO dao = new PeopleDAO();
	MemberVO person = dao.getAroundPerson(memberNo);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/include/include-header.jspf" %>
<c:set var="person" value="<%=person%>" />
<c:set var="accessType" value="<%=accessType%>" />
<style>
	.container {
		margin-top:10px;
	}
</style>
</head>
<body onload="initialize()">
	<div class="container text-center">  
		<div id="map_view" style="width:480px; height:350px;"></div><br/>
		<div class="row">
			<div class="col-sm-4">
	  			<img src="../img/member_img/${person.memberPhoto}" class="img-circle" height="80" width="80"> <strong>${person.memberName}(${person.memberId})</strong>
	  			<button class="btn btn-primary" id="btnFriend">be friend</button>
	  			<button class="btn btn-success" id="btnChat">with chat</button>
			</div>
		</div>
	</div>
</body>
<script src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>
<script>
	function initialize() {

		/*
			http://openapi.map.naver.com/api/geocode.php?key=f32441ebcd3cc9de474f8081df1e54e3&encoding=euc-kr&coord=LatLng&query=서울특별시 강남구 강남대로 456
               위와같이 링크에서 뒤에 주소를 적으면 x,y 값을 구할수 있습니다.
		*/
		var Y_point			= "${person.memberLat}";	// lat 위도
		var X_point			= "${person.memberLng}";	// lng 경도

		var zoomLevel		= 15;				// 지도의 확대 레벨 : 숫자가 클수록 확대정도가 큼

		var markerTitle		= "${person.memberName}(${person.memberId})";			// 현재 위치 마커에 마우스를 오버을때 나타나는 정보
		var markerMaxWidth	= 300;				// 마커를 클릭했을때 나타나는 말풍선의 최대 크기

		// 말풍선 내용
		var contentString	= '<div>' +
							'<h2>${person.memberName}(${person.memberId})</h2>'+
							'<p>${person.memberAddr}</p>' +
							//'<a href="http://www.daegu.go.kr" target="_blank">http://www.daegu.go.kr</a>'+ //링크도 넣을 수 있음
							'</div>';

		var myLatlng = new google.maps.LatLng(Y_point, X_point);
		var mapOptions = {
							zoom: zoomLevel,
							center: myLatlng,
							mapTypeId: google.maps.MapTypeId.ROADMAP
						}
		var map = new google.maps.Map(document.getElementById('map_view'), mapOptions);

		var marker = new google.maps.Marker({
											position: myLatlng,
											map: map,
											title: markerTitle
		});

		var infowindow = new google.maps.InfoWindow({
													content: contentString,
													maxWidth: markerMaxWidth
		});

		google.maps.event.addListener(marker, 'click', function() {
			infowindow.open(map, marker);
		});


		$(document).ready(function() {
			$("#btnFriend").click(function() {
				location.href = "../member/requestFriend.jsp?friendNo=${person.memberNo}&accessType=${accessType}";
			});
			
			$("#btnChat").click(function() {
				location.href = "../chat/createNewChat.jsp?chatTitle=${person.memberId}(${person.memberName})&accessType=AP";
			});
		});
	}
</script>
</html>