<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%
	request.setCharacterEncoding("UTF-8");
	MemberVO loginMember = (MemberVO)request.getSession().getAttribute("LOGIN_MEMBER");
	String memberId = loginMember.getMemberId();
	String memberPhoto = loginMember.getMemberPhoto();
	int chatNo = Integer.parseInt(request.getParameter("chatNo"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/include/include-header.jspf" %>
<c:set var="memberId" value="<%=memberId%>" />
<c:set var="memberPhoto" value="<%=memberPhoto%>" />
<c:set var="chatNo" value="<%=chatNo%>" />
<style>
	.nav-tabs li a {
      color: #777;
	  } 
	  .navbar {
	      font-family: Montserrat, sans-serif;
	      margin-bottom: 0;
	      background-color: #2d2d30;			
	      border: 0;
	      font-size: 11px !important;
	      letter-spacing: 4px;
	      opacity: 0.9;
	  }
	  .navbar li a, .navbar .navbar-brand { 
	/*      color: #d5d5d5 !important;	*/
	      color: white !important;
	  }
	  .navbar-nav li a:hover {
	      color: #fff !important;
	  }
	  .navbar-nav li.active a {
	      color: #fff !important;
	      background-color: #29292c !important;
	  }
	  .navbar-default .navbar-toggle {
	      border-color: transparent;
	  }
	  .btn-success {
	  	height: 25px;
	  	vertical-align:top;
	  }
</style>
</head>
<body>
	<nav class="navbar navbar-inverse navbar-fixed-top" style="width:451px">
		<form method="post" id="inviteForm" name="inviteForm">
		  <input type="hidden" name="chatNo" value="${chatNo}" />
		  <div class="container-fluid">
		  	<div class="navbar-header">
		      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar" id="iconBtn">
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>                        
		      </button>
		    </div>
		    <div class="collapse navbar-collapse" id="myNavbar">
		      <ul class="nav navbar-nav navbar-left">
		        <li class="dropdown">
		          <a class="dropdown-toggle" data-toggle="dropdown" href="#" id="loadChatMembers">
			          <span class="glyphicon"></span> ?????? ??????
			          <span class="caret"></span>
		          </a>
		          <ul class="dropdown-menu" id="loadMemberArea">
		          	<li id="addMembers"></li>
		          </ul>
		        </li>
		        <li class="dropdown">
		          <a class="dropdown-toggle" data-toggle="dropdown" href="#" id="loadFriends">
			          <span class="glyphicon"></span> ?????? ??????
			          <span class="caret"></span>
		          </a>
		          <ul class="dropdown-menu" id="loadFriendsArea">
		          	<li id="addFriends"></li>
		          </ul>
		          <ul id="inviteBtnArea" style="display:none;">
		          	<li><a href="#" id="inviteChat" >????????????</a></li>
		          </ul>
		        </li>
		      </ul>
		      <ul class="nav navbar-nav navbar-right">
		      	<li id="outChat"><a href="#"><b>????????? ?????????</b> <span class="glyphicon glyphicon-log-out"></span></a></li>
		      </ul>
		    </div>
		  </div>
		</form>
	</nav>

	<div style="border:1px solid grey; width:450px; margin-top:50px;background-color:#819FF7;">
	  		<div id="viewArea" style="overflow:scroll; overflow:auto; width:450px; height:500px; padding:10px;">
	  			<div id="viewData"></div>
	  		</div>
	       <br/>
	       <input id="inputMsg" type="text" size="48" maxlength="4000" placeholder="?????? ???????????? ???????????????." onkeydown="sendEnter()"/>
	       <input type="submit" value="?????????" onclick="send()" class="btn btn-success"/>
	</div>
</body>
<script type="text/javascript">

	var host = location.host;
	var webSocket = new WebSocket('ws://'+host+'/mini/broadcasting');
	var nDate = new Date();
	var year = nDate.getFullYear();
	var month = nDate.getMonth()+1;
	var date = nDate.getDate();
	var week = new Array('???','???','???','???','???','???','???');
	var day = week[nDate.getDay()]+"??????";
	var viewDate;
	var time;
	
	if (9 >= month) {
		month = "0"+month;
	}
	if (9 >= date) {
		date = "0"+date;
	}
	var now = year+"-"+month+"-"+date;
   	$("#inputMsg").focus();
   

    webSocket.onerror = function(event) {
      onError(event)
    };
    webSocket.onopen = function(event) {
      onOpen(event)
    };
    webSocket.onmessage = function(event) {
      onMessage(event)
    };
    
    function onOpen(event) {
    	$.ajax({
			url : 'getTextList.jsp',
			type : 'post',
			datatype : 'json',
			data : {
				chatNo : ${chatNo}
			},
			success : function(data) {
				console.log(data);
				for (var i in data) {
					var chatText = data[i].chatText;
					var memId = data[i].memberId;
					var regdate = data[i].chatRegdate;
					var regtime = data[i].chatRegtime;
					var regampm = data[i].chatRegampm;
					var regday = data[i].chatRegday;
					var memberPhoto = data[i].memberPhoto;
					
					if (null == viewDate || (viewDate != regdate && viewDate < regdate)) {
						if (now > regdate) {
							$("#viewData").append("<p align='center'><span style='background-color:#D8D8D8;'>"+regdate+" "+regday+"</span></p>");
							viewDate = regdate;
						} else if (now == regdate) {
							$("#viewData").append("<p align='center'><span style='background-color:#D8D8D8;'>"+now+" "+day+"</span></p>");
							viewDate = regdate;
						}
					}
					
					if ("${memberId}" == memId) {
						$("#viewData").append("<p align='right'><font size='1'>"+regampm+" "+regtime+"</font> <span style='background-color:#F3F781;'>"+chatText+"</span></p>");
					} else {
						$("#viewData").append("<p align='left'><img src='../img/member_img/"+memberPhoto+"' class='img-circle' height='46' width='46'> <strong>"+memId+"</strong> <br/> <span style='background-color:#FAFAFA;'>"+chatText + "</span> <font size='1'>"+regampm+" "+regtime+"</font></p>");
					}
				}			
		        $("#viewArea").html($("#viewData"));
		        refreshLine();
			},
			error : function() {
				alert("data load error!");
				return false;
			}
		});
    }
    
    function onError(event) {
      alert(event.data);
    }
    
    function onMessage(event) {
    	
    	var textDate = event.data;
    	var check = textDate.substring(0,textDate.indexOf("<"));
    	
    	if (check == "${chatNo}") {
    		
    		getTime();
    		if (null == viewDate || viewDate < now) {
    			$("#viewData").append("<p align='center'><span style='background-color:#D8D8D8;'>"+now+" "+day+"</span></p>");
    			viewDate = now;
    		}
    		
    		textDate = textDate.substring(textDate.indexOf("<"));
	    	$("#viewData").append("<p align='left'>"+textDate+"</p>");
	        $("#viewArea").html($("#viewData"));
	        refreshLine();
    		
    	}
    	
    }
    
    function send() {
    	var inputMsg = $("#inputMsg").val().trim();
    	if (null == inputMsg || "" == inputMsg) {
    		alert("???????????? ??????????????????.");
    		$("#inputMsg").val("");
    		$("#inputMsg").focus();
    		return false;
    	}
    	
	    getTime();
	    
		if (null == viewDate || viewDate < now) {
			$("#viewData").append("<p align='center'><span style='background-color:#D8D8D8;'>"+now+" "+day+"</span></p>");
			viewDate = now;
		}
    	$("#viewData").append("<p align='right'><font size='1'>"+time+"</font> <span style='background-color:#F3F781;'>"+$("#inputMsg").val()+"</span></p>");
        $("#viewArea").html($("#viewData"));
        webSocket.send("${chatNo}<img src='../img/member_img/${memberPhoto}' class='img-circle' height='46' width='46'><strong>${memberId}</strong> <br/> <span style='background-color:#FAFAFA;'>"+$("#inputMsg").val() + "</span> <font size='1'>"+time+"</font>");

        $.ajax({
			url : 'textSave.jsp',
			type : 'post',
			data : {
				chatNo : '${chatNo}',
				chatText : $("#inputMsg").val()
			},
			success : function(data) {
			},
			error : function() {
				alert("data save error!");
				return false;
			}
		});
		
        $("#inputMsg").val("");
        refreshLine();
    }
    
    function sendEnter() {
	    if(event.keyCode == 13){
			send();
		}
	    return false;
    }

    function refreshLine() {
    	$("#viewArea").scrollTop($("#viewArea")[0].scrollHeight);
    }

    function getTime() {
		var now = new Date();
		var ampm = "??????";
		var hours = now.getHours();
		var minutes = now.getMinutes();

		if (11 < hours) {
			ampm = "??????"
			if (12 != hours) {
				hours -= 12; 
			}
		}
		
		if (9 >= hours) {
			if (0 == hours) {
				hours = 12;
			} else {
				hours = "0"+hours;
			}
		}
		if (9 >= minutes) {
			minutes = "0"+minutes;
		}
		
		time = ampm+" "+hours+":"+minutes;
		
    }
    
	$(document).ready(function() {
    	
		var viewBtn = false;
		$("#loadFriends").click(function() {

			if(viewBtn) {
				$("#inviteBtnArea").hide();
				viewBtn = false;
			
			} else {
				$("#inviteBtnArea").show();
				viewBtn = true;
			}
			
			$.ajax({
				url : 'loadInviteFriends.jsp',
				type : 'post',
				datatype : 'json',
				data : {
					chatNo : ${chatNo}
				},
				success : function(data) {

					$("#addFriends").empty();
					for (var i in data) {
						var friendId = data[i].friendId;
						var friendName = data[i].friendName;
						$("#addFriends").append('<li><input type="checkbox" name="friends" value="'+friendId+'"/> <font color="white" >'+friendId+'('+friendName+')</font></li>');

					}			
			        $("#loadFriendsArea").html($("#addFriends"));
				},
				error : function() {
					alert("data save error!");
					return false;
				}
			});
			
		});
		
		$("#loadChatMembers").click(function() {

			$.ajax({
				url : 'loadChatMembers.jsp',
				type : 'post',
				datatype : 'json',
				data : {
					chatNo : ${chatNo}
				},
				success : function(data) {

					$("#addMembers").empty();
					for (var i in data) {
						var memberId = data[i].memberId;
						var memberName = data[i].memberName;
						var memberPhoto = data[i].memberPhoto;
						$("#addMembers").append('<li><img src="../img/member_img/'+memberPhoto+'" class="img-circle" height="46" width="46"><font color="white" >'+memberId+'('+memberName+')</font></li>');

					}			
			        $("#loadMemberArea").html($("#addMembers"));
				},
				error : function() {
					alert("data save error!");
					return false;
				}
			});
			
		});

		
		
		$("#inviteChat").click(function() {
			var isChecked = $("input:checkbox[name='friends']").is(":checked");
			if (!isChecked) {
				alert("???????????? ????????? ??????????????????.");
				return false;
			}
			
			var formData = $("#inviteForm").serialize();
			$.ajax({
				url : 'inviteChat.jsp',
				type : 'post',
				data : formData,
				success : function(data) {
					var inviteMsg = "<p align='center'><span style='background-color:#CEF6D8;'><strong>${memberId}</strong>?????? <strong>"+data+"</strong>?????? ?????????????????????.</span></p>";
					$("#viewData").append(inviteMsg);
					webSocket.send("${chatNo}"+inviteMsg);
					$("#iconBtn").click();
					$("#inputMsg").focus();
					refreshLine();
				},
				error : function() {
					alert("data save error!");
					return false;
				}
			});
			
		});
		
    	$("#outChat").click(function() {
    		var answer = confirm("???????????? ???????????? ??????????????? ?????? ???????????????.");
    		if (answer) {
    			var outMsg = "<p align='center'><span style='background-color:#CEF6D8;'><strong>${memberId}</strong>?????? ???????????????.</span></p>";
    			$("#viewData").append(outMsg);
    			webSocket.send("${chatNo}"+outMsg);
    			location.href = "outChat.jsp?chatNo=${chatNo}";
    		} else {
    			return false;
    		}
    	});
    	
    });
    
</script>
</html>