<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.mini.dao.PeopleDAO"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%
	request.setCharacterEncoding("UTF-8");
	MemberVO loginMember = (MemberVO)request.getSession().getAttribute("LOGIN_MEMBER");
	double memberLat = loginMember.getMemberLat();
	double memberLng = loginMember.getMemberLng();
	int memberNo = loginMember.getMemberNo();
	
	PeopleDAO dao = new PeopleDAO();
	JSONArray people = dao.getAroundPeopleJson(memberLat, memberLng, memberNo);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/include/include-header.jspf" %>
<c:set var="memberLat" value="<%=memberLat%>" />
<c:set var="memberLng" value="<%=memberLng%>" />
<c:set var="people" value="<%=people%>" />
</head> 
<body>
<div id="map" style="width:650px; height:600px;"></div>
<script src="http://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>
<script type="text/javascript">
	var locations = JSON.parse('${people}');
	var map = new google.maps.Map(document.getElementById('map'), {
	  zoom: 14,
	  center: new google.maps.LatLng('${memberLat}', '${memberLng}'),
	  mapTypeId: google.maps.MapTypeId.ROADMAP
	});
	var infowindow = new google.maps.InfoWindow();
	var marker, i;
	
	marker = new google.maps.Marker({
      position: new google.maps.LatLng('${memberLat}', '${memberLng}'),
      map: map
    });
    google.maps.event.addListener(marker, 'click', (function(marker, i) {
      return function() {
        infowindow.setContent('<strong>My location</strong>');
        infowindow.open(map, marker);
      }
    })(marker, i));
	
	for (var i in locations) {
	    marker = new google.maps.Marker({
	      position: new google.maps.LatLng(locations[i].memberLat, locations[i].memberLng),
	      map: map
	    });
	    google.maps.event.addListener(marker, 'click', (function(marker, i) {
	      return function() {
	        infowindow.setContent('<a href="javascript:openInfoPerson('+locations[i].memberNo+')"><img src="/mini/img/member_img/'+locations[i].memberPhoto+'" class="img-circle" width="35" height="35"><strong>'+locations[i].memberId+'('+locations[i].memberName+')</strong></a>');
	        infowindow.open(map, marker);
	      }
	    })(marker, i));
	}

	function openInfoPerson(mno) {
		var popUrl = "infoPerson.jsp?accessType=P&memberNo="+mno;
		var popOption = "width=520, height=500, resizable=no, scrollbars=no, status=no, toolbar=no, loation=no, directories=no";    //팝업창 옵션(optoin)
		window.open(popUrl,"",popOption);
	}
</script>
</body>
</html>