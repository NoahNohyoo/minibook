<%@page import="com.mini.dao.MemberDAO"%>
<%@page import="com.mini.util.NumberUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%@ page import="com.mini.vo.BoardVO"%>
<%@ page import="com.mini.dao.BoardDAO"%>
<%@ page import="java.util.ArrayList"%>
<%
	request.setCharacterEncoding("utf-8");
	String listType = (String) request.getParameter("listType");
	MemberVO member = (MemberVO) request.getSession().getAttribute("LOGIN_MEMBER");
	MemberVO userNow = null;
	BoardDAO dao = new BoardDAO();
	MemberDAO mdao = new MemberDAO();
	String subcon = null;
	if ("null".equals(listType)) {
		listType = "main";
		
	}
	ArrayList<Integer> likeBoards = dao.findLikesByMemberNo(member.getMemberNo());
	ArrayList<Integer> subsBoards = dao.findSubscribesByMemberNo(member.getMemberNo());
	

	
	//paging
	final int ROWS_PER_PAGE = 8;
	int totalRows = 0;
	int totalPages = 0;
	int pageNo = 0;
	
	int bno = 0;
	int cno = 0;
	int pno = 0;	
	
	int beginIndex = 0;
	int endIndex = 0;
	
	if (request.getParameter("bno")!=null) {
		bno = Integer.parseInt(request.getParameter("bno"));
	} 
	
	if (request.getParameter("cno")!=null) {
		cno = Integer.parseInt(request.getParameter("cno"));
	}
	
	if (request.getParameter("pno")!=null) {
		pno = Integer.parseInt(request.getParameter("pno"));
	} else {
		pno = 1;
	}
	
	if (request.getParameter("user")!=null) {
		userNow = mdao.getMemberByNo(Integer.parseInt(request.getParameter("user")));
	}
	
	if (request.getParameter("subcon")!=null) {
		subcon = request.getParameter("subcon");
	}
	
	
%>
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/include/include-header.jspf"%>
<style>
footer {
	background-color: #2d2d30;
	color: #f5f5f5;
	padding: 15px;
}

footer a {
	color: #f5f5f5;
}

footer a:hover {
	color: #777;
	text-decoration: none;
}

.container {
	margin-top: 70px;
}

#modalImg {
    border-radius: 5px;
    cursor: pointer;
    transition: 0.3s;
}

.board_file:hover {
	cursor:pointer;
}

#myImg:hover {opacity: 0.7;}

/* The Modal (background) */
.modal {
    display: none; /* Hidden by default */
    position: fixed; /* Stay in place */
    z-index: 1; /* Sit on top */
    padding-top: 100px; /* Location of the box */
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: rgb(0,0,0); /* Fallback color */
    background-color: rgba(0,0,0,0.9); /* Black w/ opacity */
}

/* Modal Content (image) */
.modal-content {
    margin: auto;
    display: block;
    width: 80%;
    max-width: 700px;
}

/* Caption of Modal Image */
#caption {
    margin: auto;
    display: block;
    width: 80%;
    max-width: 700px;
    text-align: center;
    color: #ccc;
    padding: 10px 0;
    height: 150px;
}

/* Add Animation */
.modal-content, #caption {    
    -webkit-animation-name: zoom;
    -webkit-animation-duration: 0.6s;
    animation-name: zoom;
    animation-duration: 0.6s;
}

@-webkit-keyframes zoom {
    from {-webkit-transform:scale(0)} 
    to {-webkit-transform:scale(1)}
}

@keyframes zoom {
    from {transform:scale(0)} 
    to {transform:scale(1)}
}


/* 100% Image Width on Smaller Screens */
@media only screen and (max-width: 700px){
    .modal-content {
        width: 100%;
    }
}

</style>
</head>
<body onload="focusBoard(<%=bno %>, <%=cno %>, '<%=listType%>')">
<%@ include file="/include/include-navbar.jspf"%>
	<div class="container text-center">
		<div class="row">
			<div class="col-sm-2 well" id="section_left">
				<div class="well">
					<a href="member/checkAccount.jsp"><img src="img/member_img/<%=member.getMemberPhoto()%>" class="img-circle" height="120" width="120"
						alt="Avatar"></a> 
					<p></p>	
					<p>
						<strong><%=member.getMemberId()%>(<%=member.getMemberName()%>)</strong><br>
						<font size="2"><%=member.getMemberBirth().substring(0,4)%>년 <%=member.getMemberBirth().substring(5,7)%>월 <%=member.getMemberBirth().substring(8,10)%>일</font>
					</p>
				</div>
				<div class="well" style="height:120px;">
					<p>
						<a href="#">interests</a>
					</p>
					<p>
						<span class="label label-default">News</span> <span
							class="label label-primary">W3Schools</span> <span
							class="label label-success">Labels</span> <span
							class="label label-info">Football</span> <span
							class="label label-warning">Gaming</span> <span
							class="label label-danger">Friends</span>
					</p>
				</div>
				<jsp:include page="/member/loadRequesters.jsp" flush="true" />
				<div class="well" style="text-align:left; overflow:auto; width:160px; height:360px; padding:10px;">
					<p style="text-align:center;">
						<i class="material-icons" style="font-size:24px;color:#FF4000">people</i><strong style="font-size:18px; color:#0040FF;">Friends</strong>
					</p>
					<jsp:include page="/member/loadFriends.jsp" flush="true" />
				</div>
			</div>

			<!-- 업데이트 새글 -->
			<!-- 업데이트 새글 -->
			<!-- 업데이트 새글 -->
			<div class="col-sm-7">
				<div class="row">
					<div class="col-sm-12">
						<div class="panel panel-default text-left">
							<div class="panel-heading">
								<span class="glyphicon glyphicon-pencil"></span><strong>Update</strong>
							</div>
							<form method="post" action="uploadFile.jsp"
								enctype="multipart/form-data"
								onsubmit="return checkUploadForm()">
								<div class="panel-body">
									<div class="row">
										<div class="form-group">
											<div class="col-sm-10">
												<!-- 본문 -->
												<!-- 본문 -->
												<!-- 본문 -->
												<textarea id="new-board-textarea-content"
													name="board_content" class="form-control" cols="70"
													rows="10" onkeyup="countNewBoardTextareaContent()"
													onblur="checkContentMaxChar()"></textarea>
											</div>
											<!-- 태그열기닫기 -->
											<!-- 태그열기닫기 -->
											<div class="col-sm-2 pull-right pull-bottom">
												<button type="button" id="update-add-tag"
													class="form-control btn btn-default btn-sm"
													onclick="showTagOnUpdate()" style="margin-top: 90px;">
													<span class="glyphicon glyphicon-align-justify"> </span>
													Tag
												</button>
												<!-- 클리어 -->
												<!-- 클리어 -->
												<button type="reset" onclick="clearPicture()"
													class="form-control btn btn-danger btn-sm"
													style="margin-top: 10px;">Clear</button>
												<!-- 올리기 -->
												<!-- 올리기 -->
												<button type="submit"
													class="form-control btn btn-success btn-sm"
													style="margin-top: 10px;">Update</button>
											</div>
										</div>
									</div>
									<!-- 태그 -->
									<!-- 태그 -->
									<!-- 태그 -->
									<div class="row">
										<input type="hidden" id="tag-on-update" name="board_tag"
											class="form-control"
											placeholder="ex ) #James #Anna #Pizza #Manhattan #NYC"
											onblur="checkTagMax()"
											style="margin-top: 5px; margin-left: 15px; width: 79%; display: inline;" />
									</div>
									<!-- 파일 -->
									<!-- 파일 -->
									<!-- 파일 -->
									<div class="row">
										<input type="file" name="board_file" id="upload-file"
											class="form-control btn btn-default btn-sm"
											style="margin-top: 5px; margin-left: 15px; width: 60%; display: inline;">
										<div class="pull-right"
											style="margin-right: 130px; margin-top: 15px">
											<span id="textarea-content-size">0</span> / 1000
										</div>
									</div>
									<div class="row" id="uploadPhotoPreviewDiv" style="display:none">
										<img id="uploadPhotoPreview" class="img-rounded" height="230px" width="300px"/>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
				<%
					//리스트 분기점
					//리스트 분기점
					//리스트 분기점
//=========================================================================================================================================================================
//=========================================================================================================================================================================
//=====================================================================================================================================================================--->

				if ("user".equals(listType)) {
			%>
			<div class="row">
				<div class="col-sm-12">
					<div class="panel panel-default text-center">
						<div class="panel-body">
							<a
								href="main.jsp?listType=user&member_no=<%=Integer.parseInt(request.getParameter("member_no"))%>"><button
									type="button" class="btn btn-primary" style="width: 140px;">Friend's
									All</button></a> <a href="main.jsp?listType=main"><button type="button"
									class="btn btn-danger">
									<span class="glyphicon glyphicon-home"></span>
								</button></a>
						</div>
					</div>
				</div>
			</div>

			<%
				} else if ("main".equals(listType) || listType == null || "me".equals(listType) || "subs".equals(listType) || "news".equals(listType) || "search".equals(listType))  {
			%>
					<div class="row">
						<div class="col-sm-12">
							<div class="panel panel-default text-center">
								<div class="panel-body">
									<a href="main.jsp?listType=main"><button type="button"
											class="btn btn-primary" style="width: 140px;">All</button></a> <a
										href="main.jsp?listType=me"><button type="button"
											class="btn btn-success" style="width: 140px;">Me</button></a> <a
										href="main.jsp?listType=subs"><button type="button"
											class="btn btn-info" style="width: 140px;">Subscribe</button></a>
									<a href="main.jsp?listType=news"><button type="button"
											class="btn btn-warning" style="width: 140px;">News</button></a>
									<a href="main.jsp?listType=main"><button type="button"
									class="btn btn-danger">
									<span class="glyphicon glyphicon-home"></span>
								</button></a>
								</div>
							</div>
						</div>
					</div>
			<%
				}  else {
					listType = "main"; %>
					<div class="row">
						<div class="col-sm-12">
							<div class="panel panel-default text-center">
								<div class="panel-body">
									<a href="main.jsp?listType=main"><button type="button"
											class="btn btn-primary" style="width: 140px;">All</button></a> <a
										href="main.jsp?listType=me"><button type="button"
											class="btn btn-success" style="width: 140px;">Me</button></a> <a
										href="main.jsp?listType=subs"><button type="button"
											class="btn btn-info" style="width: 140px;">Subscribe</button></a>
									<a href="main.jsp?listType=news"><button type="button"
											class="btn btn-warning" style="width: 140px;">News</button></a>
									<a href="main.jsp?listType=main"><button type="button"
									class="btn btn-danger">
									<span class="glyphicon glyphicon-home"></span>
								</button></a>
								</div>
							</div>
						</div>
					</div>
				<%}
				%>
				<!-- 목록 불러오기 -->
				<!-- 목록 불러오기 -->
				<!-- 목록 불러오기 -->


				<!-- 글 -->
				<!-- 글 -->
				<!-- 글 -->
				<%
					//메인 리스트
					//메인 리스트
					//메인 리스트
//=========================================================================================================================================================================
//=========================================================================================================================================================================
//=========================================================================================================================================================================
					if ("main".equals(listType) || listType == null) {
						totalRows = dao.getAllBoardRows(member.getMemberNo());
						totalPages = (int)Math.ceil((double)totalRows/ROWS_PER_PAGE);
						NumberUtil.StringToInt(request.getParameter("pno"), 1, totalRows);
						beginIndex = (pno - 1) * ROWS_PER_PAGE + 1;
						endIndex = pno * ROWS_PER_PAGE;
						ArrayList<BoardVO> boards = dao.findAllBoards(beginIndex, endIndex, member);
						if (boards != null) {
							for (BoardVO board : boards) {
								if (board.getMember_no() == member.getMemberNo()) {
				%>
									<div class="row well" id="board-no-<%=board.getBoard_no() %>" style="margin-left: 10px; margin-right: 10px;">
										<div class="col-sm-3">			
											<img src="img/member_img/<%=member.getMemberPhoto()%>"
												class="img-circle" height="90" width="90" alt="Avatar"
												style="margin-top: 10px;">
											<p style="font-size: 18px; margin-top: 5px;">
												<a href="main.jsp?listType=main"><%=member.getMemberName()%></a>
											</p>
					
										</div>
										<div class="col-sm-9">
											<div class="well" style="background-color: white;">
												<div class="thumbnail">
													<%
														if (board.getBoard_file() != null) {
													%>
															<img src="img/board_img/<%=board.getBoard_file()%>"	alt="<%=board.getBoard_tag()%>" class="board_file"
															onclick="imgModal(<%=board.getBoard_no()%>)"  id="img-<%=board.getBoard_no()%>"/>
													<%
														if (null == (board.getBoard_tag())) {
													%>
															<div class="caption">
																<p></p>
															</div>
													<%
														} else {
													%>
													<div class="caption">
														<p><%=board.getBoard_tag()%></p>
													</div>
													<%
														}
													%>
													<%
														} else {
													%>
													<%
														if (null == (board.getBoard_tag())) {
													%>
													<div class="caption">
														<p></p>
													</div>
													<%
														} else {
													%>
													<div class="caption">
														<p><%=board.getBoard_tag()%></p>
													</div>
													<%
														}
																		}
													%>
												</div>
					
												<p><%=board.getBoard_content()%></p>
											</div>
					<!-- style="background-color:#33af49; color:white;" 좋아요 -->
					<!-- style="background-color:#51c8ff; color:white;" 서브스크라이브 -->
					
											<div>
												<a href="board/like.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
														type="button" class="btn btn-default btn-sm" <%=likeBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#33af49; color:white;'" : "" %>>
														<span class="glyphicon glyphicon-thumbs-up"></span> Like
														<%=board.getBoard_like_cnt()%>
													</button></a> <a href="board/subscribe.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
														type="button" class="btn btn-default btn-sm" <%=subsBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#51c8ff; color:white;'" : "" %>>
														<span class="glyphicon glyphicon-pushpin"></span> Subs
													</button></a> <a href="board/editform.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
														type="button" class="btn btn-default btn-sm" data-toggle="modal" data-target="#editModal">
														<span class="glyphicon glyphicon-wrench"></span> Edit
													</button></a><a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
														type="button" class="btn btn-default btn-sm">
														<span class="glyphicon glyphicon-trash"></span> Del
													</button></a>
												<!-- 
													<button type="button" class="btn btn-default btn-sm">
														<span class="glyphicon glyphicon-align-justify"></span> Tag
													</button> -->
												<button type="button" class="btn btn-default btn-sm"
													onclick="commentsClicked(<%=board.getBoard_no()%>, '<%=listType%>')">
													<span class="glyphicon glyphicon-menu-down"
														id="comment-btn-<%=board.getBoard_no()%>"></span> Comments
												</button>
												<!-- Reply Show -->
												<!-- Reply Show -->
												<!-- Reply Show -->
												<div id="comment-list-<%=board.getBoard_no()%>"
													style="display: none">
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<div>
														<div class='row thumbnail'
															style='margin-top: 15px; margin-bottom: 1px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px'>
															<div class='col-sm-3'>
																<div class='row'>
																	<img src='img/member_img/<%=member.getMemberPhoto()%>'
																		class='img-circle' height='40' width='40' alt='Avatar'
																		style='margin-top: 10px;'>
																</div>
																<div style='margin-top: 3px'>
																	<a href='main.jsp?listType=main'><%=member.getMemberName()%></a>
																</div>
															</div>
															<form class='form-group' method='post'
																onsubmit='return checkReplyForm(<%=board.getBoard_no()%>);'
																action='board/updatecomment.jsp?listType=<%=listType%>&bno=<%=board.getBoard_no()%>'>
																<input type='hidden' name='board_level'
																	value='<%=board.getBoard_no()%>'>
																<div class='col-sm-8'
																	style='text-align: left; margin-right: 0;'>
																	<textarea name='board_content' class='form-control'
																		id="reply-textarea-<%=board.getBoard_no()%>" rows='3'></textarea>
																</div>
																<div class='col-sm-1'
																	style='margin-top: 20px; padding-left: 0; margin-left: 0'>
																	<button class='btn btn-success btn-xs form-group'>reply</button>
																</div>
															</form>
														</div>
														<!-- 댓글리스트 -->
														<!-- 댓글리스트 -->
														<!-- 댓글리스트 -->
														<%
															ArrayList<BoardVO> comments = dao.findCommentsByBoardNo(board.getBoard_no());
																			if (comments != null) {
																				for (BoardVO comment : comments) {
																					if (comment.getMember_no() == member.getMemberNo()) {
														%>
									<!-- My Reply -->
									<!-- My Reply -->
									<!-- My Reply -->
									
														<div>
															<div class="row thumbnail"
																id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
																style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
																<div class="col-sm-3">
																	<div class="row">
																		<img src="img/member_img/<%=member.getMemberPhoto()%>"
																			class="img-circle" height="40" width="40" alt="Avatar"
																			style="margin-top: 10px;">
																	</div>
																	<div style="margin-top: 3px">
																		<a href="main.jsp?listType=user&member_no=
																			<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
																	</div>
																	<div style="margin-top: 10px">
																		<a
																			href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
																			class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
																		<a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
																			class="glyphicon glyphicon-trash"></span></a>
																	</div>
																</div>
																<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
																</div>
															</div>
														</div>
														<%
															} else {
														%>
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
														<div>
															<div class="row thumbnail"
																id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
																style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
																<div class="col-sm-3">
																	<div class="row">
																		<img src="img/member_img/<%=comment.getMember_photo()%>"
																			class="img-circle" height="40" width="40" alt="Avatar"
																			style="margin-top: 10px;">
																	</div>
																	<div style="margin-top: 3px">
																		<a href="main.jsp?listType=user&member_no=<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
																	</div>
																	<div style="margin-top: 5px">
																		<a
																			href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
																			class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
																	</div>
																</div>
																<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
																</div>
															</div>
														</div>
														<%
																}
															}
														}

														%>
													</div>
												</div>
							<!-- reply end -->
							<!-- reply end -->
							<!-- reply end -->
					
											</div>
										</div>
					
									</div>

				<%
				// 내 글이 아니라면
					} else {
				%>
				<div class="row well" id="board-no-<%=board.getBoard_no() %>" style="margin-left: 10px; margin-right: 10px">
					<div class="col-sm-3">

						<img src="img/member_img/<%=board.getMember_photo()%>" 
							class="img-circle" height="90" width="90" alt="Avatar" 
							style="margin-top: 10px;">
						<p style="font-size: 18px; margin-top: 5px;">
							<a
								href="main.jsp?listType=user&member_no=<%=board.getMember_no()%>"><%=board.getMember_name()%></a>
						</p>

					</div>
					<div class="col-sm-9">
						<div class="well" style="background-color: white;">
							<div class="thumbnail">
								<%
									if (board.getBoard_file() != null) {
								%>
								<img src="img/board_img/<%=board.getBoard_file()%>"	alt="<%=board.getBoard_tag()%>" class="board_file"
								onclick="imgModal(<%=board.getBoard_no()%>)"  id="img-<%=board.getBoard_no()%>"/>
								<%
									if (null == (board.getBoard_tag())) {
								%>
								<div class="caption">
									<p></p>
								</div>
								<%
									} else {
								%>
								<div class="caption">
									<p><%=board.getBoard_tag()%></p>
								</div>
								<%
									}
								%>
								<%
									} else {
								%>
								<%
									if (null == (board.getBoard_tag())) {
								%>
								<div class="caption">
									<p></p>
								</div>
								<%
									} else {
								%>
								<div class="caption">
									<p><%=board.getBoard_tag()%></p>
								</div>
								<%
									}
													}
								%>
							</div>
							<p><%=board.getBoard_content()%></p>
						</div>
						<div>

							<a href="board/like.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
									type="button" class="btn btn-default btn-sm" <%=likeBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#33af49; color:white;'" : "" %>>
									<span class="glyphicon glyphicon-thumbs-up"></span> Like
									<%=board.getBoard_like_cnt()%>
								</button></a> <a href="board/subscribe.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
									type="button" class="btn btn-default btn-sm" <%=subsBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#51c8ff; color:white;'" : "" %>>
									<span class="glyphicon glyphicon-pushpin"></span> Subs
								</button></a>
							<button type="button" class="btn btn-default btn-sm"
								onclick="commentsClicked(<%=board.getBoard_no()%>, '<%=listType%>')">
								<span class="glyphicon glyphicon-menu-down"
									id="comment-btn-<%=board.getBoard_no()%>"></span> Comments
							</button>

							<!-- Reply Show -->
							<!-- Reply Show -->
							<!-- Reply Show -->
							<div id="comment-list-<%=board.getBoard_no()%>"
								style="display: none">
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
								<div>
									<div class='row thumbnail'
										style='margin-top: 15px; margin-bottom: 1px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px'>
										<div class='col-sm-3'>
											<div class='row'>
												<img src='img/member_img/<%=member.getMemberPhoto()%>'
													class='img-circle' height='40' width='40' alt='Avatar'
													style='margin-top: 10px;'>
											</div>
											<div style='margin-top: 3px'>
												<a href='main.jsp?listType=main'><%=member.getMemberName()%></a>
											</div>
										</div>
										<form class='form-group' method='post'
											onsubmit='return checkReplyForm(<%=board.getBoard_no()%>);'
											action='board/updatecomment.jsp?listType=<%=listType%>&bno=<%=board.getBoard_no()%>'>
											<input type='hidden' name='board_level'
												value='<%=board.getBoard_no()%>'>
											<div class='col-sm-8'
												style='text-align: left; margin-right: 0;'>
												<textarea name='board_content' class='form-control'
													id="reply-textarea-<%=board.getBoard_no()%>" rows='3'></textarea>
											</div>
											<div class='col-sm-1'
												style='margin-top: 20px; padding-left: 0; margin-left: 0'>
												<button class='btn btn-success btn-xs form-group'>reply</button>
											</div>
										</form>
									</div>
									<!-- 댓글리스트 -->
									<!-- 댓글리스트 -->
									<!-- 댓글리스트 -->
									<%
										ArrayList<BoardVO> comments = dao.findCommentsByBoardNo(board.getBoard_no());
														if (comments != null) {
															for (BoardVO comment : comments) {
																if (comment.getMember_no() == member.getMemberNo()) {
									%>
									<!-- My Reply -->
									<!-- My Reply -->
									<!-- My Reply -->
									<div>
										<div class="row thumbnail"
											id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
											style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
											<div class="col-sm-3">
												<div class="row">
													<img src="img/member_img/<%=member.getMemberPhoto()%>"
														class="img-circle" height="40" width="40" alt="Avatar"
														style="margin-top: 10px;">
												</div>
												<div style="margin-top: 3px">
													<a href="main.jsp?listType=user&member_no=
														<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
												</div>
												<div style="margin-top: 10px">
													<a
														href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
														class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
													<a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
														class="glyphicon glyphicon-trash"></span></a>
												</div>
											</div>
											<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
											</div>
										</div>
									</div>
									<%
										} else {
									%>
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<div>
										<div class="row thumbnail"
											id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
											style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
											<div class="col-sm-3">
												<div class="row">
													<img src="img/member_img/<%=comment.getMember_photo()%>"
														class="img-circle" height="40" width="40" alt="Avatar"
														style="margin-top: 10px;">
												</div>
												<div style="margin-top: 3px">
													<a href="main.jsp?listType=user&member_no=<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
												</div>
												<div style="margin-top: 5px">
													<a
														href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
														class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
												</div>
											</div>
											<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
											</div>
										</div>
									</div>
									<%
										}
															}
														}
									%>
								</div>

							</div>
							<!-- reply end -->
							<!-- reply end -->
							<!-- reply end -->
						</div>
					</div>

				</div>
							<!-- Paging -->
							<!-- Paging -->
							<!-- Paging -->
				<%
								}
							}
						}
						if (totalPages < 7) {
							%>
							<div>
								<ul class="pagination">
								<%	
									for (int index=1; index<=totalPages; index++) { 
										if (pno == index) { 
										%>
										<li class="active"><a href=""><%=index %></a></li>
										<%
										} else {
										%>
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
										<%																
										}									
									} 																
									%>									
								</ul>
							</div>				
					<%	
						} else {							
							if (pno <= 4) {
							%>
								<div>
									<ul class="pagination">
									<%	
										for (int index=1; index<=pno+3; index++) { 
											if (pno == index) { 
											%>
											<li class="active"><a href=""><%=index %></a></li>
											<%
											} else {
											%>
											<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
											<%																
											}									
										} 								
									
										%>									
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno+4)%>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
									</ul>
								</div>				
						<%							
							} else if (pno >= (totalPages-3)) {
								%>
								<div>
									<ul class="pagination">
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno-4)%>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
									<%	
										for (int index=pno-3; index<=totalPages; index++) { 
											if (pno == index) { 
											%>
											<li class="active"><a href=""><%=index %></a></li>
											<%
											} else {
											%>
											<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
											<%																
											}									
										} 								
									
										%>									
	
									</ul>
								</div>				
						<%	
							} else {
					%>
							<div>
								<ul class="pagination">
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno-4)%>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
								<%	
									for (int index=pno-3; index<=pno+3; index++) { 
										if (pno == index) { 
										%>
										<li class="active"><a href=""><%=index %></a></li>
										<%
										} else {
										%>
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
										<%																
										}									
									} 								
								
									%>									
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno+4)%>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
	
								</ul>
							</div>				
					<%
							}
						}

			
					//Me 리스트
					//Me 리스트
					//Me 리스트
//=========================================================================================================================================================================
//=========================================================================================================================================================================
//=========================================================================================================================================================================
					} else if ("me".equals(listType)) {
						totalRows = dao.getMeBoardRows(member.getMemberNo());
						totalPages = (int)Math.ceil((double)totalRows/ROWS_PER_PAGE);
						NumberUtil.StringToInt(request.getParameter("pno"), 1, totalRows);
						beginIndex = (pno - 1) * ROWS_PER_PAGE + 1;
						endIndex = pno * ROWS_PER_PAGE;
						ArrayList<BoardVO> boards = dao.findBoardsOnMe(beginIndex, endIndex, member);
						if (boards != null) {
							for (BoardVO board : boards) {
								if (board.getMember_no() == member.getMemberNo()) {
				%>
									<div class="row well" id="board-no-<%=board.getBoard_no() %>" style="margin-left: 10px; margin-right: 10px;">
										<div class="col-sm-3">			
											<img src="img/member_img/<%=member.getMemberPhoto()%>"
												class="img-circle" height="90" width="90" alt="Avatar"
												style="margin-top: 10px;">
											<p style="font-size: 18px; margin-top: 5px;">
												<a href="main.jsp?listType=main"><%=member.getMemberName()%></a>
											</p>
					
										</div>
										<div class="col-sm-9">
											<div class="well" style="background-color: white;">
												<div class="thumbnail">
													<%
														if (board.getBoard_file() != null) {
													%>
															<img src="img/board_img/<%=board.getBoard_file()%>"	alt="<%=board.getBoard_tag()%>" class="board_file"
															onclick="imgModal(<%=board.getBoard_no()%>)"  id="img-<%=board.getBoard_no()%>"/>
													<%
														if (null == (board.getBoard_tag())) {
													%>
															<div class="caption">
																<p></p>
															</div>
													<%
														} else {
													%>
													<div class="caption">
														<p><%=board.getBoard_tag()%></p>
													</div>
													<%
														}
													%>
													<%
														} else {
													%>
													<%
														if (null == (board.getBoard_tag())) {
													%>
													<div class="caption">
														<p></p>
													</div>
													<%
														} else {
													%>
													<div class="caption">
														<p><%=board.getBoard_tag()%></p>
													</div>
													<%
														}
																		}
													%>
												</div>
					
												<p><%=board.getBoard_content()%></p>
											</div>
					<!-- style="background-color:#33af49; color:white;" 좋아요 -->
					<!-- style="background-color:#51c8ff; color:white;" 서브스크라이브 -->
					
											<div>
												<a href="board/like.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
														type="button" class="btn btn-default btn-sm" <%=likeBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#33af49; color:white;'" : "" %>>
														<span class="glyphicon glyphicon-thumbs-up"></span> Like
														<%=board.getBoard_like_cnt()%>
													</button></a> <a href="board/subscribe.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
														type="button" class="btn btn-default btn-sm" <%=subsBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#51c8ff; color:white;'" : "" %>>
														<span class="glyphicon glyphicon-pushpin"></span> Subs
													</button></a> <a href="board/editform.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
														type="button" class="btn btn-default btn-sm" data-toggle="modal" data-target="#editModal">
														<span class="glyphicon glyphicon-wrench"></span> Edit
													</button></a><a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
														type="button" class="btn btn-default btn-sm">
														<span class="glyphicon glyphicon-trash"></span> Del
													</button></a>
												<!-- 
													<button type="button" class="btn btn-default btn-sm">
														<span class="glyphicon glyphicon-align-justify"></span> Tag
													</button> -->
												<button type="button" class="btn btn-default btn-sm"
													onclick="commentsClicked(<%=board.getBoard_no()%>, '<%=listType%>')">
													<span class="glyphicon glyphicon-menu-down"
														id="comment-btn-<%=board.getBoard_no()%>"></span> Comments
												</button>
							<!-- Reply Show -->
							<!-- Reply Show -->
							<!-- Reply Show -->
												<div id="comment-list-<%=board.getBoard_no()%>"
													style="display: none">
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<div>
														<div class='row thumbnail'
															style='margin-top: 15px; margin-bottom: 1px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px'>
															<div class='col-sm-3'>
																<div class='row'>
																	<img src='img/member_img/<%=member.getMemberPhoto()%>'
																		class='img-circle' height='40' width='40' alt='Avatar'
																		style='margin-top: 10px;'>
																</div>
																<div style='margin-top: 3px'>
																	<a href='main.jsp?listType=main'><%=member.getMemberName()%></a>
																</div>
															</div>
															<form class='form-group' method='post'
																onsubmit='return checkReplyForm(<%=board.getBoard_no()%>);'
																action='board/updatecomment.jsp?listType=<%=listType%>&bno=<%=board.getBoard_no()%>'>
																<input type='hidden' name='board_level'
																	value='<%=board.getBoard_no()%>'>
																<div class='col-sm-8'
																	style='text-align: left; margin-right: 0;'>
																	<textarea name='board_content' class='form-control'
																		id="reply-textarea-<%=board.getBoard_no()%>" rows='3'></textarea>
																</div>
																<div class='col-sm-1'
																	style='margin-top: 20px; padding-left: 0; margin-left: 0'>
																	<button class='btn btn-success btn-xs form-group'>reply</button>
																</div>
															</form>
														</div>
														<!-- 댓글리스트 -->
														<!-- 댓글리스트 -->
														<!-- 댓글리스트 -->
														<%
															ArrayList<BoardVO> comments = dao.findCommentsByBoardNo(board.getBoard_no());
																			if (comments != null) {
																				for (BoardVO comment : comments) {
																					if (comment.getMember_no() == member.getMemberNo()) {
														%>
														<!-- 본인의 댓글 -->
														<!-- 본인의 댓글 -->
														<!-- 본인의 댓글 -->
														<div>
															<div class="row thumbnail"
																id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
																style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
																<div class="col-sm-3">
																	<div class="row">
																		<img src="img/member_img/<%=member.getMemberPhoto()%>"
																			class="img-circle" height="40" width="40" alt="Avatar"
																			style="margin-top: 10px;">
																	</div>
																	<div style="margin-top: 3px">
																		<a href="main.jsp?listType=user&member_no=
																			<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
																	</div>
																	<div style="margin-top: 10px">
																		<a
																			href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
																			class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
																		<a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
																			class="glyphicon glyphicon-trash"></span></a>
																	</div>
																</div>
																<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
																</div>
															</div>
														</div>
														<%
															} else {
														%>
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
														<div>
															<div class="row thumbnail"
																id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
																style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
																<div class="col-sm-3">
																	<div class="row">
																		<img src="img/member_img/<%=comment.getMember_photo()%>"
																			class="img-circle" height="40" width="40" alt="Avatar"
																			style="margin-top: 10px;">
																	</div>
																	<div style="margin-top: 3px">
																		<a href="main.jsp?listType=user&member_no=<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
																	</div>
																	<div style="margin-top: 5px">
																		<a
																			href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
																			class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
																	</div>
																</div>
																<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
																</div>
															</div>
														</div>
														<%
																}
															}
														}

														%>
													</div>
												</div>
							<!-- reply end -->
							<!-- reply end -->
							<!-- reply end -->
					
											</div>
										</div>
					
									</div>

				<%
				// 내 글이 아니라면
					} else {
				%>
				<div class="row well" id="board-no-<%=board.getBoard_no() %>" style="margin-left: 10px; margin-right: 10px">
					<div class="col-sm-3">

						<img src="img/member_img/<%=board.getMember_photo()%>" 
							class="img-circle" height="90" width="90" alt="Avatar" 
							style="margin-top: 10px;">
						<p style="font-size: 18px; margin-top: 5px;">
							<a
								href="main.jsp?listType=user&member_no=<%=board.getMember_no()%>"><%=board.getMember_name()%></a>
						</p>

					</div>
					<div class="col-sm-9">
						<div class="well" style="background-color: white;">
							<div class="thumbnail">
								<%
									if (board.getBoard_file() != null) {
								%>
								<img src="img/board_img/<%=board.getBoard_file()%>"	alt="<%=board.getBoard_tag()%>" class="board_file"
								onclick="imgModal(<%=board.getBoard_no()%>)"  id="img-<%=board.getBoard_no()%>"/>
								<%
									if (null == (board.getBoard_tag())) {
								%>
								<div class="caption">
									<p></p>
								</div>
								<%
									} else {
								%>
								<div class="caption">
									<p><%=board.getBoard_tag()%></p>
								</div>
								<%
									}
								%>
								<%
									} else {
								%>
								<%
									if (null == (board.getBoard_tag())) {
								%>
								<div class="caption">
									<p></p>
								</div>
								<%
									} else {
								%>
								<div class="caption">
									<p><%=board.getBoard_tag()%></p>
								</div>
								<%
									}
													}
								%>
							</div>
							<p><%=board.getBoard_content()%></p>
						</div>
						<div>

							<a href="board/like.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
									type="button" class="btn btn-default btn-sm" <%=likeBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#33af49; color:white;'" : "" %>>
									<span class="glyphicon glyphicon-thumbs-up"></span> Like
									<%=board.getBoard_like_cnt()%>
								</button></a> <a href="board/subscribe.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
									type="button" class="btn btn-default btn-sm" <%=subsBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#51c8ff; color:white;'" : "" %>>
									<span class="glyphicon glyphicon-pushpin"></span> Subs
								</button></a>
							<button type="button" class="btn btn-default btn-sm"
								onclick="commentsClicked(<%=board.getBoard_no()%>, '<%=listType%>')">
								<span class="glyphicon glyphicon-menu-down"
									id="comment-btn-<%=board.getBoard_no()%>"></span> Comments
							</button>

							<!-- Reply Show -->
							<!-- Reply Show -->
							<!-- Reply Show -->
							<div id="comment-list-<%=board.getBoard_no()%>"
								style="display: none">
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
								<div>
									<div class='row thumbnail'
										style='margin-top: 15px; margin-bottom: 1px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px'>
										<div class='col-sm-3'>
											<div class='row'>
												<img src='img/member_img/<%=member.getMemberPhoto()%>'
													class='img-circle' height='40' width='40' alt='Avatar'
													style='margin-top: 10px;'>
											</div>
											<div style='margin-top: 3px'>
												<a href='main.jsp?listType=main'><%=member.getMemberName()%></a>
											</div>
										</div>
										<form class='form-group' method='post'
											onsubmit='return checkReplyForm(<%=board.getBoard_no()%>);'
											action='board/updatecomment.jsp?listType=<%=listType%>&bno=<%=board.getBoard_no()%>'>
											<input type='hidden' name='board_level'
												value='<%=board.getBoard_no()%>'>
											<div class='col-sm-8'
												style='text-align: left; margin-right: 0;'>
												<textarea name='board_content' class='form-control'
													id="reply-textarea-<%=board.getBoard_no()%>" rows='3'></textarea>
											</div>
											<div class='col-sm-1'
												style='margin-top: 20px; padding-left: 0; margin-left: 0'>
												<button class='btn btn-success btn-xs form-group'>reply</button>
											</div>
										</form>
									</div>
									<!-- 댓글리스트 -->
									<!-- 댓글리스트 -->
									<!-- 댓글리스트 -->
									<%
										ArrayList<BoardVO> comments = dao.findCommentsByBoardNo(board.getBoard_no());
														if (comments != null) {
															for (BoardVO comment : comments) {
																if (comment.getMember_no() == member.getMemberNo()) {
									%>
									<!-- 본인의 댓글 -->
									<!-- 본인의 댓글 -->
									<!-- 본인의 댓글 -->
									<div>
										<div class="row thumbnail"
											id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
											style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
											<div class="col-sm-3">
												<div class="row">
													<img src="img/member_img/<%=member.getMemberPhoto()%>"
														class="img-circle" height="40" width="40" alt="Avatar"
														style="margin-top: 10px;">
												</div>
												<div style="margin-top: 3px">
													<a href="main.jsp?listType=user&member_no=
														<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
												</div>
												<div style="margin-top: 10px">
													<a
														href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
														class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
													<a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
														class="glyphicon glyphicon-trash"></span></a>
												</div>
											</div>
											<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
											</div>
										</div>
									</div>
									<%
										} else {
									%>
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<div>
										<div class="row thumbnail"
											id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
											style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
											<div class="col-sm-3">
												<div class="row">
													<img src="img/member_img/<%=comment.getMember_photo()%>"
														class="img-circle" height="40" width="40" alt="Avatar"
														style="margin-top: 10px;">
												</div>
												<div style="margin-top: 3px">
													<a href="main.jsp?listType=user&member_no=<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
												</div>
												<div style="margin-top: 5px">
													<a
														href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
														class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
												</div>
											</div>
											<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
											</div>
										</div>
									</div>
									<%
										}
															}
														}
									%>
								</div>

							</div>
							<!-- reply end -->
							<!-- reply end -->
							<!-- reply end -->
						</div>
					</div>

				</div>
							<!-- Paging -->
							<!-- Paging -->
							<!-- Paging -->
				<%
								}
							}
						}
						if (totalPages < 7) {
							%>
							<div>
								<ul class="pagination">
								<%	
									for (int index=1; index<=totalPages; index++) { 
										if (pno == index) { 
										%>
										<li class="active"><a href=""><%=index %></a></li>
										<%
										} else {
										%>
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
										<%																
										}									
									} 																
									%>									
								</ul>
							</div>				
					<%	
						} else {							
							if (pno <= 4) {
							%>
								<div>
									<ul class="pagination">
									<%	
										for (int index=1; index<=pno+3; index++) { 
											if (pno == index) { 
											%>
											<li class="active"><a href=""><%=index %></a></li>
											<%
											} else {
											%>
											<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
											<%																
											}									
										} 								
									
										%>									
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno+4)%>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
									</ul>
								</div>				
						<%							
							} else if (pno >= (totalPages-3)) {
								%>
								<div>
									<ul class="pagination">
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno-4)%>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
									<%	
										for (int index=pno-3; index<=totalPages; index++) { 
											if (pno == index) { 
											%>
											<li class="active"><a href=""><%=index %></a></li>
											<%
											} else {
											%>
											<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
											<%																
											}									
										} 								
									
										%>									
	
									</ul>
								</div>				
						<%	
							} else {
					%>
							<div>
								<ul class="pagination">
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno-4)%>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
								<%	
									for (int index=pno-3; index<=pno+3; index++) { 
										if (pno == index) { 
										%>
										<li class="active"><a href=""><%=index %></a></li>
										<%
										} else {
										%>
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
										<%																
										}									
									} 								
								
									%>									
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno+4)%>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
	
								</ul>
							</div>				
					<%
							}
						}
						//Subs
						//Subs
						//Subs
//=========================================================================================================================================================================
//=========================================================================================================================================================================
//=========================================================================================================================================================================
					} else if ("subs".equals(listType)) {
						totalRows = dao.getSubsBoardRows(member.getMemberNo());
						totalPages = (int)Math.ceil((double)totalRows/ROWS_PER_PAGE);
						NumberUtil.StringToInt(request.getParameter("pno"), 1, totalRows);
						beginIndex = (pno - 1) * ROWS_PER_PAGE + 1;
						endIndex = pno * ROWS_PER_PAGE;
						ArrayList<BoardVO> boards = dao.findMySubscribedBoards(beginIndex, endIndex, member);
						if (boards != null) {
							for (BoardVO board : boards) {
								if (board.getMember_no() == member.getMemberNo()) {
				%>
									<div class="row well" id="board-no-<%=board.getBoard_no() %>" style="margin-left: 10px; margin-right: 10px;">
										<div class="col-sm-3">			
											<img src="img/member_img/<%=member.getMemberPhoto()%>"
												class="img-circle" height="90" width="90" alt="Avatar"
												style="margin-top: 10px;">
											<p style="font-size: 18px; margin-top: 5px;">
												<a href="main.jsp?listType=main"><%=member.getMemberName()%></a>
											</p>
					
										</div>
										<div class="col-sm-9">
											<div class="well" style="background-color: white;">
												<div class="thumbnail">
													<%
														if (board.getBoard_file() != null) {
													%>
														<img src="img/board_img/<%=board.getBoard_file()%>"	alt="<%=board.getBoard_tag()%>" class="board_file"
														onclick="imgModal(<%=board.getBoard_no()%>)"  id="img-<%=board.getBoard_no()%>"/>
													<%
														if (null == (board.getBoard_tag())) {
													%>
															<div class="caption">
																<p></p>
															</div>
													<%
														} else {
													%>
													<div class="caption">
														<p><%=board.getBoard_tag()%></p>
													</div>
													<%
														}
													%>
													<%
														} else {
													%>
													<%
														if (null == (board.getBoard_tag())) {
													%>
													<div class="caption">
														<p></p>
													</div>
													<%
														} else {
													%>
													<div class="caption">
														<p><%=board.getBoard_tag()%></p>
													</div>
													<%
														}
																		}
													%>
												</div>
					
												<p><%=board.getBoard_content()%></p>
											</div>
					
											<div>
												<a href="board/like.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
														type="button" class="btn btn-default btn-sm" <%=likeBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#33af49; color:white;'" : "" %>>
														<span class="glyphicon glyphicon-thumbs-up"></span> Like
														<%=board.getBoard_like_cnt()%>
													</button></a> <a href="board/subscribe.jsp?bno=<%=board.getBoard_no()%>&listType=subs"><button
														type="button" class="btn btn-default btn-sm" <%=subsBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#51c8ff; color:white;'" : "" %>>
														<span class="glyphicon glyphicon-pushpin"></span> Subs
													</button></a> <a href="board/editform.jsp?bno=<%=board.getBoard_no()%>&listType=subs"><button
														type="button" class="btn btn-default btn-sm" data-toggle="modal" data-target="#editModal">
														<span class="glyphicon glyphicon-wrench"></span> Edit
													</button></a> <a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
														type="button" class="btn btn-default btn-sm">
														<span class="glyphicon glyphicon-trash"></span> Del
													</button></a>
												<!-- 
													<button type="button" class="btn btn-default btn-sm">
														<span class="glyphicon glyphicon-align-justify"></span> Tag
													</button> -->
												<button type="button" class="btn btn-default btn-sm"
													onclick="commentsClicked(<%=board.getBoard_no()%>, '<%=listType%>')">
													<span class="glyphicon glyphicon-menu-down"
														id="comment-btn-<%=board.getBoard_no()%>"></span> Comments
												</button>
							<!-- Reply Show -->
							<!-- Reply Show -->
							<!-- Reply Show -->
												<div id="comment-list-<%=board.getBoard_no()%>"
													style="display: none">
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<div>
														<div class='row thumbnail'
															style='margin-top: 15px; margin-bottom: 1px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px'>
															<div class='col-sm-3'>
																<div class='row'>
																	<img src='img/member_img/<%=member.getMemberPhoto()%>'
																		class='img-circle' height='40' width='40' alt='Avatar'
																		style='margin-top: 10px;'>
																</div>
																<div style='margin-top: 3px'>
																	<a href='main.jsp?listType=main'><%=member.getMemberName()%></a>
																</div>
															</div>
															<form class='form-group' method='post'
																onsubmit='return checkReplyForm(<%=board.getBoard_no()%>);'
																action='board/updatecomment.jsp?listType=<%=listType%>&bno=<%=board.getBoard_no()%>'>
																<input type='hidden' name='board_level'
																	value='<%=board.getBoard_no()%>'>
																<div class='col-sm-8'
																	style='text-align: left; margin-right: 0;'>
																	<textarea name='board_content' class='form-control'
																		id="reply-textarea-<%=board.getBoard_no()%>" rows='3'></textarea>
																</div>
																<div class='col-sm-1'
																	style='margin-top: 20px; padding-left: 0; margin-left: 0'>
																	<button class='btn btn-success btn-xs form-group'>reply</button>
																</div>
															</form>
														</div>
														<!-- 댓글리스트 -->
														<!-- 댓글리스트 -->
														<!-- 댓글리스트 -->
														<%
															ArrayList<BoardVO> comments = dao.findCommentsByBoardNo(board.getBoard_no());
																			if (comments != null) {
																				for (BoardVO comment : comments) {
																					if (comment.getMember_no() == member.getMemberNo()) {
														%>
									<!-- My Reply -->
									<!-- My Reply -->
									<!-- My Reply -->
														<div>
															<div class="row thumbnail"
																id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
																style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
																<div class="col-sm-3">
																	<div class="row">
																		<img src="img/member_img/<%=member.getMemberPhoto()%>"
																			class="img-circle" height="40" width="40" alt="Avatar"
																			style="margin-top: 10px;">
																	</div>
																	<div style="margin-top: 3px">
																		<a href="main.jsp?listType=user&member_no=
																			<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
																	</div>
																	<div style="margin-top: 10px">
																		<a
																			href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
																			class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
																		<a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
																			class="glyphicon glyphicon-trash"></span></a>
																	</div>
																</div>
																<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
																</div>
															</div>
														</div>
														<%
															} else {
														%>
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
														<div>
															<div class="row thumbnail"
																id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
																style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
																<div class="col-sm-3">
																	<div class="row">
																		<img src="img/member_img/<%=comment.getMember_photo()%>"
																			class="img-circle" height="40" width="40" alt="Avatar"
																			style="margin-top: 10px;">
																	</div>
																	<div style="margin-top: 3px">
																		<a href="main.jsp?listType=user&member_no=<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
																	</div>
																	<div style="margin-top: 5px">
																		<a
																			href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
																			class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
																	</div>
																</div>
																<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
																</div>
															</div>
														</div>
														<%
															}
																				}
																			}
														%>
													</div>
												</div>
							<!-- reply end -->
							<!-- reply end -->
							<!-- reply end -->
					
											</div>
										</div>
					
									</div>

				<%
				// 내 글이 아니라면
					} else {
				%>
				<div class="row well" id="board-no-<%=board.getBoard_no() %>" style="margin-left: 10px; margin-right: 10px">
					<div class="col-sm-3">

						<img src="img/member_img/<%=board.getMember_photo()%>" 
							class="img-circle" height="90" width="90" alt="Avatar" 
							style="margin-top: 10px;">
						<p style="font-size: 18px; margin-top: 5px;">
							<a
								href="main.jsp?listType=user&member_no=<%=board.getMember_no()%>"><%=board.getMember_name()%></a>
						</p>

					</div>
					<div class="col-sm-9">
						<div class="well" style="background-color: white;">
							<div class="thumbnail">
								<%
									if (board.getBoard_file() != null) {
								%>
									<img src="img/board_img/<%=board.getBoard_file()%>"	alt="<%=board.getBoard_tag()%>" class="board_file"
									onclick="imgModal(<%=board.getBoard_no()%>)"  id="img-<%=board.getBoard_no()%>"/>
								<%
									if (null == (board.getBoard_tag())) {
								%>
								<div class="caption">
									<p></p>
								</div>
								<%
									} else {
								%>
								<div class="caption">
									<p><%=board.getBoard_tag()%></p>
								</div>
								<%
									}
								%>
								<%
									} else {
								%>
								<%
									if (null == (board.getBoard_tag())) {
								%>
								<div class="caption">
									<p></p>
								</div>
								<%
									} else {
								%>
								<div class="caption">
									<p><%=board.getBoard_tag()%></p>
								</div>
								<%
									}
													}
								%>
							</div>
							<p><%=board.getBoard_content()%></p>
						</div>
						<div>

							<a href="board/like.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
									type="button" class="btn btn-default btn-sm" <%=likeBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#33af49; color:white;'" : "" %>>
									<span class="glyphicon glyphicon-thumbs-up"></span> Like
									<%=board.getBoard_like_cnt()%>
								</button></a> <a href="board/subscribe.jsp?bno=<%=board.getBoard_no()%>&listType=subs"><button
									type="button" class="btn btn-default btn-sm" <%=subsBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#51c8ff; color:white;'" : "" %>>
									<span class="glyphicon glyphicon-pushpin"></span> Subs
								</button></a>
							<button type="button" class="btn btn-default btn-sm"
								onclick="commentsClicked(<%=board.getBoard_no()%>, '<%=listType%>')">
								<span class="glyphicon glyphicon-menu-down"
									id="comment-btn-<%=board.getBoard_no()%>"></span> Comments
							</button>

							<!-- Reply Show -->
							<!-- Reply Show -->
							<!-- Reply Show -->
							<div id="comment-list-<%=board.getBoard_no()%>"
								style="display: none">
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
								<div>
									<div class='row thumbnail'
										style='margin-top: 15px; margin-bottom: 1px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px'>
										<div class='col-sm-3'>
											<div class='row'>
												<img src='img/member_img/<%=member.getMemberPhoto()%>'
													class='img-circle' height='40' width='40' alt='Avatar'
													style='margin-top: 10px;'>
											</div>
											<div style='margin-top: 3px'>
												<a href='main.jsp?listType=main'><%=member.getMemberName()%></a>
											</div>
										</div>
										<form class='form-group' method='post'
											onsubmit='return checkReplyForm(<%=board.getBoard_no()%>);'
											action='board/updatecomment.jsp?listType=<%=listType%>&bno=<%=board.getBoard_no()%>'>
											<input type='hidden' name='board_level'
												value='<%=board.getBoard_no()%>'>
											<div class='col-sm-8'
												style='text-align: left; margin-right: 0;'>
												<textarea name='board_content' class='form-control'
													id="reply-textarea-<%=board.getBoard_no()%>" rows='3'></textarea>
											</div>
											<div class='col-sm-1'
												style='margin-top: 20px; padding-left: 0; margin-left: 0'>
												<button class='btn btn-success btn-xs form-group'>reply</button>
											</div>
										</form>
									</div>
									<!-- 댓글리스트 -->
									<!-- 댓글리스트 -->
									<!-- 댓글리스트 -->
									<%
										ArrayList<BoardVO> comments = dao.findCommentsByBoardNo(board.getBoard_no());
														if (comments != null) {
															for (BoardVO comment : comments) {
																if (comment.getMember_no() == member.getMemberNo()) {
									%>
									<!-- My Reply -->
									<!-- My Reply -->
									<!-- My Reply -->
									<div>
										<div class="row thumbnail"
											id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
											style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
											<div class="col-sm-3">
												<div class="row">
													<img src="img/member_img/<%=member.getMemberPhoto()%>"
														class="img-circle" height="40" width="40" alt="Avatar"
														style="margin-top: 10px;">
												</div>
												<div style="margin-top: 3px">
													<a href="main.jsp?listType=user&member_no=
														<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
												</div>
												<div style="margin-top: 10px">
													<a
														href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
														class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
													<a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
														class="glyphicon glyphicon-trash"></span></a>
												</div>
											</div>
											<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
											</div>
										</div>
									</div>
									<%
										} else {
									%>
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<div>
										<div class="row thumbnail"
											id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
											style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
											<div class="col-sm-3">
												<div class="row">
													<img src="img/member_img/<%=comment.getMember_photo()%>"
														class="img-circle" height="40" width="40" alt="Avatar"
														style="margin-top: 10px;">
												</div>
												<div style="margin-top: 3px">
													<a href="main.jsp?listType=user&member_no=<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
												</div>
												<div style="margin-top: 5px">
													<a
														href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
														class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
												</div>
											</div>
											<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
											</div>
										</div>
									</div>
									<%
										}
															}
														}
									%>
								</div>

							</div>
							<!-- reply end -->
							<!-- reply end -->
							<!-- reply end -->
						</div>
					</div>

				</div>
							<!-- Paging -->
							<!-- Paging -->
							<!-- Paging -->
				<%
								}
							}
						}
						if (totalPages < 7) {
							%>
							<div>
								<ul class="pagination">
								<%	
									for (int index=1; index<=totalPages; index++) { 
										if (pno == index) { 
										%>
										<li class="active"><a href=""><%=index %></a></li>
										<%
										} else {
										%>
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
										<%																
										}									
									} 																
									%>									
								</ul>
							</div>				
					<%	
						} else {							
							if (pno <= 4) {
							%>
								<div>
									<ul class="pagination">
									<%	
										for (int index=1; index<=pno+3; index++) { 
											if (pno == index) { 
											%>
											<li class="active"><a href=""><%=index %></a></li>
											<%
											} else {
											%>
											<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
											<%																
											}									
										} 								
									
										%>									
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno+4)%>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
									</ul>
								</div>				
						<%							
							} else if (pno >= (totalPages-3)) {
								%>
								<div>
									<ul class="pagination">
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno-4)%>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
									<%	
										for (int index=pno-3; index<=totalPages; index++) { 
											if (pno == index) { 
											%>
											<li class="active"><a href=""><%=index %></a></li>
											<%
											} else {
											%>
											<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
											<%																
											}									
										} 								
									
										%>									
	
									</ul>
								</div>				
						<%	
							} else {
					%>
							<div>
								<ul class="pagination">
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno-4)%>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
								<%	
									for (int index=pno-3; index<=pno+3; index++) { 
										if (pno == index) { 
										%>
										<li class="active"><a href=""><%=index %></a></li>
										<%
										} else {
										%>
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
										<%																
										}									
									} 								
								
									%>									
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno+4)%>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
	
								</ul>
							</div>				
					<%
							}
						}
					//News
					//News
					//News
//=========================================================================================================================================================================
//=========================================================================================================================================================================
//=========================================================================================================================================================================
					} else if ("news".equals(listType)) {
						totalRows = dao.getNoticeRows();
						totalPages = (int)Math.ceil((double)totalRows/1);
						NumberUtil.StringToInt(request.getParameter("pno"), 1, totalRows);
						beginIndex = (pno - 1) * 1 + 1;
						endIndex = pno * 1;
						ArrayList<BoardVO> boards = dao.findNotice(beginIndex, endIndex);
						if (boards != null) {
							for (BoardVO board : boards) {
				%>
									<div class="row well" style="margin-left: 10px; margin-right: 10px;">
										<div class="col-sm-12">
											<div class="well" style="background-color: white;">
												<h2><span class="glyphicon glyphicon-bullhorn"></span> Notice #<%=board.getBoard_no() %></h2>
												<hr>
												<div class="thumbnail">
													<img src="<%=board.getBoard_file()%>" onclick="noticeImgModal(<%=board.getBoard_no()%>)" id="noticeImg-<%=board.getBoard_no()%>"/>
												</div>
												<h4><%=board.getBoard_regdate() %></h4>
											</div>
					<!-- style="background-color:#33af49; color:white;" 좋아요 -->
					<!-- style="background-color:#51c8ff; color:white;" 서브스크라이브 -->					
										</div>				
									</div>

				<%
					
							}
						}
						if (totalPages < 7) {
							%>
							<div>
								<ul class="pagination">
								<%	
									for (int index=1; index<=totalPages; index++) { 
										if (pno == index) { 
										%>
										<li class="active"><a href=""><%=index %></a></li>
										<%
										} else {
										%>
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
										<%																
										}									
									} 																
									%>									
								</ul>
							</div>				
					<%	
						} else {							
							if (pno <= 4) {
							%>
								<div>
									<ul class="pagination">
									<%	
										for (int index=1; index<=pno+3; index++) { 
											if (pno == index) { 
											%>
											<li class="active"><a href=""><%=index %></a></li>
											<%
											} else {
											%>
											<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
											<%																
											}									
										} 								
									
										%>									
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno+4)%>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
									</ul>
								</div>				
						<%							
							} else if (pno >= (totalPages-3)) {
								%>
								<div>
									<ul class="pagination">
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno-4)%>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
									<%	
										for (int index=pno-3; index<=totalPages; index++) { 
											if (pno == index) { 
											%>
											<li class="active"><a href=""><%=index %></a></li>
											<%
											} else {
											%>
											<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
											<%																
											}									
										} 								
									
										%>									
	
									</ul>
								</div>				
						<%	
							} else {
					%>
							<div>
								<ul class="pagination">
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno-4)%>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
								<%	
									for (int index=pno-3; index<=pno+3; index++) { 
										if (pno == index) { 
										%>
										<li class="active"><a href=""><%=index %></a></li>
										<%
										} else {
										%>
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
										<%																
										}									
									} 								
								
									%>									
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno+4)%>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
	
								</ul>
							</div>				
					<%
							}
						}
					//User
					//User
					//User
//=========================================================================================================================================================================
//=========================================================================================================================================================================
//=========================================================================================================================================================================
					} else if ("user".equals(listType)) {
						MemberVO curr_user = new MemberVO();
						curr_user.setMemberNo(Integer.parseInt(request.getParameter("member_no")));
						totalRows = dao.getMeBoardRows(curr_user.getMemberNo());
						totalPages = (int)Math.ceil((double)totalRows/ROWS_PER_PAGE);
						NumberUtil.StringToInt(request.getParameter("pno"), 1, totalRows);
						beginIndex = (pno - 1) * ROWS_PER_PAGE + 1;
						endIndex = pno * ROWS_PER_PAGE;
						ArrayList<BoardVO> boards = dao.findBoardsOnMe(beginIndex, endIndex, curr_user);
						if (boards != null) {
							for (BoardVO board : boards) {
								if (board.getMember_no() == member.getMemberNo()) {
				%>
									<div class="row well" id="board-no-<%=board.getBoard_no() %>" style="margin-left: 10px; margin-right: 10px;">
										<div class="col-sm-3">			
											<img src="img/member_img/<%=member.getMemberPhoto()%>"
												class="img-circle" height="90" width="90" alt="Avatar"
												style="margin-top: 10px;">
											<p style="font-size: 18px; margin-top: 5px;">
												<a href="main.jsp?listType=main"><%=member.getMemberName()%></a>
											</p>
					
										</div>
										<div class="col-sm-9">
											<div class="well" style="background-color: white;">
												<div class="thumbnail">
													<%
														if (board.getBoard_file() != null) {
													%>
															<img src="img/board_img/<%=board.getBoard_file()%>"	alt="<%=board.getBoard_tag()%>" class="board_file"
															onclick="imgModal(<%=board.getBoard_no()%>)"  id="img-<%=board.getBoard_no()%>"/>
													<%
														if (null == (board.getBoard_tag())) {
													%>
															<div class="caption">
																<p></p>
															</div>
													<%
														} else {
													%>
													<div class="caption">
														<p><%=board.getBoard_tag()%></p>
													</div>
													<%
														}
													%>
													<%
														} else {
													%>
													<%
														if (null == (board.getBoard_tag())) {
													%>
													<div class="caption">
														<p></p>
													</div>
													<%
														} else {
													%>
													<div class="caption">
														<p><%=board.getBoard_tag()%></p>
													</div>
													<%
														}
																		}
													%>
												</div>
					
												<p><%=board.getBoard_content()%></p>
											</div>
					
											<div>
												<a href="board/like.jsp?bno=<%=board.getBoard_no()%>&listType=user&member_no=<%=curr_user.getMemberNo()%>"><button
														type="button" class="btn btn-default btn-sm" <%=likeBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#33af49; color:white;'" : "" %>>
														<span class="glyphicon glyphicon-thumbs-up"></span> Like
														<%=board.getBoard_like_cnt()%>
													</button></a> <a href="board/subscribe.jsp?bno=<%=board.getBoard_no()%>&listType=user&member_no=<%=curr_user.getMemberNo()%>"><button
														type="button" class="btn btn-default btn-sm" <%=subsBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#51c8ff; color:white;'" : "" %>>
														<span class="glyphicon glyphicon-pushpin"></span> Subs
													</button></a> <a href="board/editform.jsp?bno=<%=board.getBoard_no()%>&listType=user&member_no=<%=curr_user.getMemberNo()%>"><button
														type="button" class="btn btn-default btn-sm" data-toggle="modal" data-target="#editModal">
														<span class="glyphicon glyphicon-wrench"></span> Edit
													</button></a> <a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&listType=user&member_no=<%=curr_user.getMemberNo()%>"><button
														type="button" class="btn btn-default btn-sm">
														<span class="glyphicon glyphicon-trash"></span> Del
													</button></a>
												<!-- 
													<button type="button" class="btn btn-default btn-sm">
														<span class="glyphicon glyphicon-align-justify"></span> Tag
													</button> -->
												<button type="button" class="btn btn-default btn-sm"
													onclick="commentsClicked(<%=board.getBoard_no()%>, '<%=listType%>')">
													<span class="glyphicon glyphicon-menu-down"
														id="comment-btn-<%=board.getBoard_no()%>"></span> Comments
												</button>
							<!-- Reply Show -->
							<!-- Reply Show -->
							<!-- Reply Show -->
												<div id="comment-list-<%=board.getBoard_no()%>"
													style="display: none">
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<div>
														<div class='row thumbnail'
															style='margin-top: 15px; margin-bottom: 1px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px'>
															<div class='col-sm-3'>
																<div class='row'>
																	<img src='img/member_img/<%=member.getMemberPhoto()%>'
																		class='img-circle' height='40' width='40' alt='Avatar'
																		style='margin-top: 10px;'>
																</div>
																<div style='margin-top: 3px'>
																	<a href='main.jsp?listType=main'><%=member.getMemberName()%></a>
																</div>
															</div>
															<form class='form-group' method='post'
																onsubmit='return checkReplyForm(<%=board.getBoard_no()%>);'
																action='board/updatecomment.jsp?listType=<%=listType%>&bno=<%=board.getBoard_no()%>'>
																<input type='hidden' name='board_level'
																	value='<%=board.getBoard_no()%>'>
																<div class='col-sm-8'
																	style='text-align: left; margin-right: 0;'>
																	<textarea name='board_content' class='form-control'
																		id="reply-textarea-<%=board.getBoard_no()%>" rows='3'></textarea>
																</div>
																<div class='col-sm-1'
																	style='margin-top: 20px; padding-left: 0; margin-left: 0'>
																	<button class='btn btn-success btn-xs form-group'>reply</button>
																</div>
															</form>
														</div>
														<!-- 댓글리스트 -->
														<!-- 댓글리스트 -->
														<!-- 댓글리스트 -->
														<%
															ArrayList<BoardVO> comments = dao.findCommentsByBoardNo(board.getBoard_no());
																			if (comments != null) {
																				for (BoardVO comment : comments) {
																					if (comment.getMember_no() == member.getMemberNo()) {
														%>
									<!-- My Reply -->
									<!-- My Reply -->
									<!-- My Reply -->
														<div>
															<div class="row thumbnail"
																id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
																style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
																<div class="col-sm-3">
																	<div class="row">
																		<img src="img/member_img/<%=member.getMemberPhoto()%>"
																			class="img-circle" height="40" width="40" alt="Avatar"
																			style="margin-top: 10px;">
																	</div>
																	<div style="margin-top: 3px">
																		<a href="main.jsp?listType=user&member_no=
																			<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
																	</div>
																	<div style="margin-top: 10px">
																		<a
																			href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=user&member_no=<%=curr_user.getMemberNo()%>"><span
																			class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
																		<a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=user&member_no=<%=curr_user.getMemberNo()%>"><span
																			class="glyphicon glyphicon-trash"></span></a>
																			
																	</div>
																</div>
																<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
																</div>
															</div>
														</div>
														<%
															} else {
														%>
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
														<div>
															<div class="row thumbnail"
																id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
																style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
																<div class="col-sm-3">
																	<div class="row">
																		<img src="img/member_img/<%=comment.getMember_photo()%>"
																			class="img-circle" height="40" width="40" alt="Avatar"
																			style="margin-top: 10px;">
																	</div>
																	<div style="margin-top: 3px">
																		<a href="main.jsp?listType=user&member_no=<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
																	</div>
																	<div style="margin-top: 5px">
																		<a
																			href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=user&member_no=<%=curr_user.getMemberNo()%>"><span
																			class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
																	</div>
																</div>
																<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
																</div>
															</div>
														</div>
														<%
															}
																				}
																			}
														%>
													</div>
												</div>
							<!-- reply end -->
							<!-- reply end -->
							<!-- reply end -->
					
											</div>
										</div>
					
									</div>

				<%
				// 내 글이 아니라면
					} else {
				%>
				<div class="row well" id="board-no-<%=board.getBoard_no() %>" style="margin-left: 10px; margin-right: 10px">
					<div class="col-sm-3">

						<img src="img/member_img/<%=board.getMember_photo()%>"
							class="img-circle" height="90" width="90" alt="Avatar"
							style="margin-top: 10px;">
						<p style="font-size: 18px; margin-top: 5px;">
							<a
								href="main.jsp?listType=user&member_no=<%=board.getMember_no()%>"><%=board.getMember_name()%></a>
						</p>

					</div>
					<div class="col-sm-9">
						<div class="well" style="background-color: white;">
							<div class="thumbnail">
								<%
									if (board.getBoard_file() != null) {
								%>
										<img src="img/board_img/<%=board.getBoard_file()%>"	alt="<%=board.getBoard_tag()%>" class="board_file"
										onclick="imgModal(<%=board.getBoard_no()%>)"  id="img-<%=board.getBoard_no()%>"/>
								<%
									if (null == (board.getBoard_tag())) {
								%>
								<div class="caption">
									<p></p>
								</div>
								<%
									} else {
								%>
								<div class="caption">
									<p><%=board.getBoard_tag()%></p>
								</div>
								<%
									}
								%>
								<%
									} else {
								%>
								<%
									if (null == (board.getBoard_tag())) {
								%>
								<div class="caption">
									<p></p>
								</div>
								<%
									} else {
								%>
								<div class="caption">
									<p><%=board.getBoard_tag()%></p>
								</div>
								<%
									}
													}
								%>
							</div>
							<p><%=board.getBoard_content()%></p>
						</div>
						<div>

							<a href="board/like.jsp?bno=<%=board.getBoard_no()%>&listType=user&member_no=<%=curr_user.getMemberNo()%>"><button
									type="button" class="btn btn-default btn-sm" <%=likeBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#33af49; color:white;'" : "" %>>
									<span class="glyphicon glyphicon-thumbs-up"></span> Like
									<%=board.getBoard_like_cnt()%>
								</button></a> <a href="board/subscribe.jsp?bno=<%=board.getBoard_no()%>&listType=main&member_no=<%=curr_user.getMemberNo()%>"><button
									type="button" class="btn btn-default btn-sm" <%=subsBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#51c8ff; color:white;'" : "" %>>
									<span class="glyphicon glyphicon-pushpin"></span> Subs
								</button></a>
							<button type="button" class="btn btn-default btn-sm"
								onclick="commentsClicked(<%=board.getBoard_no()%>, '<%=listType%>')">
								<span class="glyphicon glyphicon-menu-down"
									id="comment-btn-<%=board.getBoard_no()%>"></span> Comments
							</button>

							<!-- Reply Show -->
							<!-- Reply Show -->
							<!-- Reply Show -->
							<div id="comment-list-<%=board.getBoard_no()%>"
								style="display: none">
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
								<div>
									<div class='row thumbnail'
										style='margin-top: 15px; margin-bottom: 1px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px'>
										<div class='col-sm-3'>
											<div class='row'>
												<img src='img/member_img/<%=member.getMemberPhoto()%>'
													class='img-circle' height='40' width='40' alt='Avatar'
													style='margin-top: 10px;'>
											</div>
											<div style='margin-top: 3px'>
												<a href='main.jsp?listType=main'><%=member.getMemberName()%></a>
											</div>
										</div>
										<form class='form-group' method='post'
											onsubmit='return checkReplyForm(<%=board.getBoard_no()%>);'
											action='board/updatecomment.jsp?listType=<%=listType%>&bno=<%=board.getBoard_no()%>'>
											<input type='hidden' name='board_level'
												value='<%=board.getBoard_no()%>'>
											<div class='col-sm-8'
												style='text-align: left; margin-right: 0;'>
												<textarea name='board_content' class='form-control'
													id="reply-textarea-<%=board.getBoard_no()%>" rows='3'></textarea>
											</div>
											<div class='col-sm-1'
												style='margin-top: 20px; padding-left: 0; margin-left: 0'>
												<button class='btn btn-success btn-xs form-group'>reply</button>
											</div>
										</form>
									</div>
									<!-- 댓글리스트 -->
									<!-- 댓글리스트 -->
									<!-- 댓글리스트 -->
									<%
										ArrayList<BoardVO> comments = dao.findCommentsByBoardNo(board.getBoard_no());
														if (comments != null) {
															for (BoardVO comment : comments) {
																if (comment.getMember_no() == member.getMemberNo()) {
									%>
									<!-- My Reply -->
									<!-- My Reply -->
									<!-- My Reply -->
									<div>
										<div class="row thumbnail"
											id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
											style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
											<div class="col-sm-3">
												<div class="row">
													<img src="img/member_img/<%=member.getMemberPhoto()%>"
														class="img-circle" height="40" width="40" alt="Avatar"
														style="margin-top: 10px;">
												</div>
												<div style="margin-top: 3px">
													<a href="main.jsp?listType=user&member_no=
														<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
												</div>
												<div style="margin-top: 10px">
													<a
														href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=user&member_no=<%=curr_user.getMemberNo()%>"><span
														class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
													<a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=user&member_no=<%=curr_user.getMemberNo()%>"><span
														class="glyphicon glyphicon-trash"></span></a>
												</div>
											</div>
											<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
											</div>
										</div>
									</div>
									<%
										} else {
									%>
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<div>
										<div class="row thumbnail"
											id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
											style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
											<div class="col-sm-3">
												<div class="row">
													<img src="img/member_img/<%=comment.getMember_photo()%>"
														class="img-circle" height="40" width="40" alt="Avatar"
														style="margin-top: 10px;">
												</div>
												<div style="margin-top: 3px">
													<a href="main.jsp?listType=user&member_no=<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
												</div>
												<div style="margin-top: 5px">
													<a
														href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=user&member_no=<%=curr_user.getMemberNo()%>"><span
														class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
												</div>
											</div>
											<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
											</div>
										</div>
									</div>
									<%
										}
															}
														}
									%>
								</div>

							</div>
							<!-- reply end -->
							<!-- reply end -->
							<!-- reply end -->
						</div>
					</div>

				</div>

							<!-- Paging -->
							<!-- Paging -->
							<!-- Paging -->
				<%
								}
							}
						}
						if (totalPages < 7) {
							%>
							<div>
								<ul class="pagination">
								<%	
									for (int index=1; index<=totalPages; index++) { 
										if (pno == index) { 
										%>
										<li class="active"><a href=""><%=index %></a></li>
										<%
										} else {
										%>
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
										<%																
										}									
									} 																
									%>									
								</ul>
							</div>				
					<%	
						} else {							
							if (pno <= 4) {
							%>
								<div>
									<ul class="pagination">
									<%	
										for (int index=1; index<=pno+3; index++) { 
											if (pno == index) { 
											%>
											<li class="active"><a href=""><%=index %></a></li>
											<%
											} else {
											%>
											<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
											<%																
											}									
										} 								
									
										%>									
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno+4)%>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
									</ul>
								</div>				
						<%							
							} else if (pno >= (totalPages-3)) {
								%>
								<div>
									<ul class="pagination">
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno-4)%>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
									<%	
										for (int index=pno-3; index<=totalPages; index++) { 
											if (pno == index) { 
											%>
											<li class="active"><a href=""><%=index %></a></li>
											<%
											} else {
											%>
											<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
											<%																
											}									
										} 								
									
										%>									
	
									</ul>
								</div>				
						<%	
							} else {
					%>
							<div>
								<ul class="pagination">
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno-4)%>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
								<%	
									for (int index=pno-3; index<=pno+3; index++) { 
										if (pno == index) { 
										%>
										<li class="active"><a href=""><%=index %></a></li>
										<%
										} else {
										%>
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>"><%=index %></a></li>
										<%																
										}									
									} 								
								
									%>									
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno+4)%>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
	
								</ul>
							</div>				
					<%
							}
						}
						//Search
						//Search
						//Search
//=========================================================================================================================================================================
//=========================================================================================================================================================================
//=========================================================================================================================================================================			
					} else if ("search".equals(listType)) {
						String keyword = "";
						if (!"".equals(request.getParameter("keyword"))) {
							keyword = request.getParameter("keyword");
						}
						totalRows = dao.getSearchBoardRows(keyword);
						totalPages = (int)Math.ceil((double)totalRows/ROWS_PER_PAGE);
						NumberUtil.StringToInt(request.getParameter("pno"), 1, totalRows);
						beginIndex = (pno - 1) * ROWS_PER_PAGE + 1;
						endIndex = pno * ROWS_PER_PAGE;

						ArrayList<BoardVO> boards = dao.findBoardsOnSearch(beginIndex, endIndex, keyword);
						System.out.println(boards.size());
						if (boards.size() != 0) {%>
						<div class="row" style="margin-bottom:30px"><h4>'<strong><%=keyword %></strong>'의 검색결과...<span class="glyphicon glyphicon-search"></span></h4></div>
							<%
							for (BoardVO board : boards) {
								if (board.getMember_no() == member.getMemberNo()) {
				%>
									<div class="row well" id="board-no-<%=board.getBoard_no() %>" style="margin-left: 10px; margin-right: 10px;">
										<div class="col-sm-3">			
											<img src="img/member_img/<%=member.getMemberPhoto()%>"
												class="img-circle" height="90" width="90" alt="Avatar"
												style="margin-top: 10px;">
											<p style="font-size: 18px; margin-top: 5px;">
												<a href="main.jsp?listType=main"><%=member.getMemberName()%></a>
											</p>
					
										</div>
										<div class="col-sm-9">
											<div class="well" style="background-color: white;">
												<div class="thumbnail">
													<%
														if (board.getBoard_file() != null) {
													%>
														<img src="img/board_img/<%=board.getBoard_file()%>"	alt="<%=board.getBoard_tag()%>" class="board_file"
														onclick="imgModal(<%=board.getBoard_no()%>)"  id="img-<%=board.getBoard_no()%>"/>
													<%
														if (null == (board.getBoard_tag())) {
													%>
															<div class="caption">
																<p></p>
															</div>
													<%
														} else {
													%>
													<div class="caption">
														<p><%=board.getBoard_tag().contains(keyword) ? board.getBoard_tag().replaceAll(keyword, "<strong>"+keyword+"</h5></strong>") : board.getBoard_tag() %></p>
													</div>
													<%
														}
													%>
													<%
														} else {
													%>
													<%
														if (null == (board.getBoard_tag())) {
													%>
													<div class="caption">
														<p></p>
													</div>
													<%
														} else {
													%>
													<div class="caption">
														<p><%=board.getBoard_tag().contains(keyword) ? board.getBoard_tag().replaceAll(keyword, "<strong>"+keyword+"</strong>") : board.getBoard_tag() %></p>
													</div>
													<%
														}
																		}
													%>
												</div>
					
												<p><%=board.getBoard_content().contains(keyword) ? board.getBoard_content().replaceAll(keyword, "<strong>"+keyword+"</strong>") : board.getBoard_content()%></p>
											</div>
					
											<div>
												<a href="board/like.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
														type="button" class="btn btn-default btn-sm" <%=likeBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#33af49; color:white;'" : "" %>>
														<span class="glyphicon glyphicon-thumbs-up"></span> Like
														<%=board.getBoard_like_cnt()%>
													</button></a> <a href="board/subscribe.jsp?bno=<%=board.getBoard_no()%>&listType=subs"><button
														type="button" class="btn btn-default btn-sm" <%=subsBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#51c8ff; color:white;'" : "" %>>
														<span class="glyphicon glyphicon-pushpin"></span> Subs
													</button></a> <a href="board/editform.jsp?bno=<%=board.getBoard_no()%>&listType=subs"><button
														type="button" class="btn btn-default btn-sm" data-toggle="modal" data-target="#editModal">
														<span class="glyphicon glyphicon-wrench"></span> Edit
													</button></a> <a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
														type="button" class="btn btn-default btn-sm">
														<span class="glyphicon glyphicon-trash"></span> Del
													</button></a>
												<!-- 
													<button type="button" class="btn btn-default btn-sm">
														<span class="glyphicon glyphicon-align-justify"></span> Tag
													</button> -->
												<button type="button" class="btn btn-default btn-sm"
													onclick="commentsClicked(<%=board.getBoard_no()%>, '<%=listType%>')">
													<span class="glyphicon glyphicon-menu-down"
														id="comment-btn-<%=board.getBoard_no()%>"></span> Comments
												</button>
							<!-- Reply Show -->
							<!-- Reply Show -->
							<!-- Reply Show -->
												<div id="comment-list-<%=board.getBoard_no()%>"
													style="display: none">
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<!-- ReplyUploadForm -->
													<div>
														<div class='row thumbnail'
															style='margin-top: 15px; margin-bottom: 1px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px'>
															<div class='col-sm-3'>
																<div class='row'>
																	<img src='img/member_img/<%=member.getMemberPhoto()%>'
																		class='img-circle' height='40' width='40' alt='Avatar'
																		style='margin-top: 10px;'>
																</div>
																<div style='margin-top: 3px'>
																	<a href='main.jsp?listType=main'><%=member.getMemberName()%></a>
																</div>
															</div>
															<form class='form-group' method='post'
																onsubmit='return checkReplyForm(<%=board.getBoard_no()%>);'
																action='board/updatecomment.jsp?listType=<%=listType%>&bno=<%=board.getBoard_no()%>'>
																<input type='hidden' name='board_level'
																	value='<%=board.getBoard_no()%>'>
																<div class='col-sm-8'
																	style='text-align: left; margin-right: 0;'>
																	<textarea name='board_content' class='form-control'
																		id="reply-textarea-<%=board.getBoard_no()%>" rows='3'></textarea>
																</div>
																<div class='col-sm-1'
																	style='margin-top: 20px; padding-left: 0; margin-left: 0'>
																	<button class='btn btn-success btn-xs form-group'>reply</button>
																</div>
															</form>
														</div>
														<!-- 댓글리스트 -->
														<!-- 댓글리스트 -->
														<!-- 댓글리스트 -->
														<%
															ArrayList<BoardVO> comments = dao.findCommentsByBoardNo(board.getBoard_no());
																			if (comments != null) {
																				for (BoardVO comment : comments) {
																					if (comment.getMember_no() == member.getMemberNo()) {
														%>
									<!-- My Reply -->
									<!-- My Reply -->
									<!-- My Reply -->
														<div>
															<div class="row thumbnail"
																id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
																style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
																<div class="col-sm-3">
																	<div class="row">
																		<img src="img/member_img/<%=member.getMemberPhoto()%>"
																			class="img-circle" height="40" width="40" alt="Avatar"
																			style="margin-top: 10px;">
																	</div>
																	<div style="margin-top: 3px">
																		<a href="main.jsp?listType=user&member_no=
																			<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
																	</div>
																	<div style="margin-top: 10px">
																		<a
																			href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
																			class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
																		<a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
																			class="glyphicon glyphicon-trash"></span></a>
																	</div>
																</div>
																<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
																</div>
															</div>
														</div>
														<%
															} else {
														%>
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
														<div>
															<div class="row thumbnail"
																id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
																style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
																<div class="col-sm-3">
																	<div class="row">
																		<img src="img/member_img/<%=comment.getMember_photo()%>"
																			class="img-circle" height="40" width="40" alt="Avatar"
																			style="margin-top: 10px;">
																	</div>
																	<div style="margin-top: 3px">
																		<a href="main.jsp?listType=user&member_no=<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
																	</div>
																	<div style="margin-top: 5px">
																		<a
																			href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
																			class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
																	</div>
																</div>
																<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
																</div>
															</div>
														</div>
														<%
															}
																				}
																			}
														%>
													</div>
												</div>
							<!-- reply end -->
							<!-- reply end -->
							<!-- reply end -->
					
											</div>
										</div>
					
									</div>

				<%
				// 내 글이 아니라면
					} else {
				%>
				<div class="row well" id="board-no-<%=board.getBoard_no() %>" style="margin-left: 10px; margin-right: 10px">
					<div class="col-sm-3">

						<img src="img/member_img/<%=board.getMember_photo()%>" 
							class="img-circle" height="90" width="90" alt="Avatar" 
							style="margin-top: 10px;">
						<p style="font-size: 18px; margin-top: 5px;">
							<a
								href="main.jsp?listType=user&member_no=<%=board.getMember_no()%>"><%=board.getMember_name()%></a>
						</p>

					</div>
					<div class="col-sm-9">
						<div class="well" style="background-color: white;">
							<div class="thumbnail">
								<%
									if (board.getBoard_file() != null) {
								%>
									<img src="img/board_img/<%=board.getBoard_file()%>"	alt="<%=board.getBoard_tag()%>" class="board_file"
									onclick="imgModal(<%=board.getBoard_no()%>)"  id="img-<%=board.getBoard_no()%>"/>
								<%
									if (null == (board.getBoard_tag())) {
								%>
								<div class="caption">
									<p></p>
								</div>
								<%
									} else {
								%>
								<div class="caption">
									<p><%=board.getBoard_tag().contains(keyword) ? board.getBoard_tag().replaceAll(keyword, "<storng>"+keyword+"</strong>") : board.getBoard_tag() %></p>
								</div>
								<%
									}
								%>
								<%
									} else {
								%>
								<%
									if (null == (board.getBoard_tag())) {
								%>
								<div class="caption">
									<p></p>
								</div>
								<%
									} else {
								%>
								<div class="caption">
									<p><%=board.getBoard_tag().contains(keyword) ? board.getBoard_tag().replaceAll(keyword, "<storng>"+keyword+"</strong>") : board.getBoard_tag() %></p>
								</div>
								<%
									}
													}
								%>
							</div>
								<p><%=board.getBoard_content().contains(keyword) ? board.getBoard_content().replaceAll(keyword, "<strong>"+keyword+"</strong>") : board.getBoard_content()%></p>
						</div>
						<div>

							<a href="board/like.jsp?bno=<%=board.getBoard_no()%>&listType=main"><button
									type="button" class="btn btn-default btn-sm" <%=likeBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#33af49; color:white;'" : "" %>>
									<span class="glyphicon glyphicon-thumbs-up"></span> Like
									<%=board.getBoard_like_cnt()%>
								</button></a> <a href="board/subscribe.jsp?bno=<%=board.getBoard_no()%>&listType=subs"><button
									type="button" class="btn btn-default btn-sm" <%=subsBoards.contains(new Integer(board.getBoard_no())) ? "style='background-color:#51c8ff; color:white;'" : "" %>>
									<span class="glyphicon glyphicon-pushpin"></span> Subs
								</button></a>
							<button type="button" class="btn btn-default btn-sm"
								onclick="commentsClicked(<%=board.getBoard_no()%>, '<%=listType%>')">
								<span class="glyphicon glyphicon-menu-down"
									id="comment-btn-<%=board.getBoard_no()%>"></span> Comments
							</button>

							<!-- Reply Show -->
							<!-- Reply Show -->
							<!-- Reply Show -->
							<div id="comment-list-<%=board.getBoard_no()%>"
								style="display: none">
										<!-- ReplyUploadForm -->
										<!-- ReplyUploadForm -->
										<!-- ReplyUploadForm -->
								<div>
									<div class='row thumbnail'
										style='margin-top: 15px; margin-bottom: 1px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px'>
										<div class='col-sm-3'>
											<div class='row'>
												<img src='img/member_img/<%=member.getMemberPhoto()%>'
													class='img-circle' height='40' width='40' alt='Avatar'
													style='margin-top: 10px;'>
											</div>
											<div style='margin-top: 3px'>
												<a href='main.jsp?listType=main'><%=member.getMemberName()%></a>
											</div>
										</div>
										<form class='form-group' method='post'
											onsubmit='return checkReplyForm(<%=board.getBoard_no()%>);'
											action='board/updatecomment.jsp?listType=<%=listType%>&bno=<%=board.getBoard_no()%>'>
											<input type='hidden' name='board_level'
												value='<%=board.getBoard_no()%>'>
											<div class='col-sm-8'
												style='text-align: left; margin-right: 0;'>
												<textarea name='board_content' class='form-control'
													id="reply-textarea-<%=board.getBoard_no()%>" rows='3'></textarea>
											</div>
											<div class='col-sm-1'
												style='margin-top: 20px; padding-left: 0; margin-left: 0'>
												<button class='btn btn-success btn-xs form-group'>reply</button>
											</div>
										</form>
									</div>
									<!-- 댓글리스트 -->
									<!-- 댓글리스트 -->
									<!-- 댓글리스트 -->
									<%
										ArrayList<BoardVO> comments = dao.findCommentsByBoardNo(board.getBoard_no());
														if (comments != null) {
															for (BoardVO comment : comments) {
																if (comment.getMember_no() == member.getMemberNo()) {
									%>
									<!-- My Reply -->
									<!-- My Reply -->
									<!-- My Reply -->
									<div>
										<div class="row thumbnail"
											id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
											style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
											<div class="col-sm-3">
												<div class="row">
													<img src="img/member_img/<%=member.getMemberPhoto()%>"
														class="img-circle" height="40" width="40" alt="Avatar"
														style="margin-top: 10px;">
												</div>
												<div style="margin-top: 3px">
													<a href="main.jsp?listType=user&member_no=
														<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
												</div>
												<div style="margin-top: 10px">
													<a
														href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
														class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
													<a href="board/delete.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
														class="glyphicon glyphicon-trash"></span></a>
												</div>
											</div>
											<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
											</div>
										</div>
									</div>
									<%
										} else {
									%>
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<!-- Friend's Reply -->
									<div>
										<div class="row thumbnail"
											id="board-<%=board.getBoard_no()%>-comment-<%=comment.getBoard_no()%>"
											style="margin-top: 3px; margin-bottom: 3px; padding-top: 10px; padding-bottom: 10px; padding-right: 20px">
											<div class="col-sm-3">
												<div class="row">
													<img src="img/member_img/<%=comment.getMember_photo()%>"
														class="img-circle" height="40" width="40" alt="Avatar"
														style="margin-top: 10px;">
												</div>
												<div style="margin-top: 3px">
													<a href="main.jsp?listType=user&member_no=<%=comment.getMember_no()%>"><%=comment.getMember_name()%></a>
												</div>
												<div style="margin-top: 5px">
													<a
														href="board/like.jsp?bno=<%=board.getBoard_no()%>&cno=<%=comment.getBoard_no()%>&listType=main"><span
														class="glyphicon glyphicon-thumbs-up"></span><%=comment.getBoard_like_cnt()%></a>
												</div>
											</div>
											<div class="col-sm-9" style="text-align: left;"><%=comment.getBoard_content()%>
											</div>
										</div>
									</div>
									<%
										}
															}
														}
									%>
								</div>

							</div>
							<!-- reply end -->
							<!-- reply end -->
							<!-- reply end -->
						</div>
					</div>

				</div>
							<!-- Paging -->
							<!-- Paging -->
							<!-- Paging -->
				<%
								}
							}
						} else {%>
							<div class="row" style="margin-bottom:30px"><h4>'<strong><%=keyword %></strong>'의 검색결과가 없습니다...<span class="glyphicon glyphicon-search"></span></h4></div>
							<img src="http://file2.instiz.net/data/file/20150830/4/1/0/410a99d697551c056799ed6fc3a90564.png"/>
						<%
						}
						if (totalPages < 7) {
							%>
							<div>
								<ul class="pagination">
								<%	
									for (int index=1; index<=totalPages; index++) { 
										if (pno == index) { 
										%>
										<li class="active"><a href=""><%=index %></a></li>
										<%
										} else {
										%>
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>&keyword=<%=keyword%>"><%=index %></a></li>
										<%																
										}									
									} 																
									%>									
								</ul>
							</div>				
					<%	
						} else {							
							if (pno <= 4) {
							%>
								<div>
									<ul class="pagination">
									<%	
										for (int index=1; index<=pno+3; index++) { 
											if (pno == index) { 
											%>
											<li class="active"><a href=""><%=index %></a></li>
											<%
											} else {
											%>
											<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>&keyword=<%=keyword%>"><%=index %></a></li>
											<%																
											}									
										} 								
									
										%>									
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno+4)%>&keyword=<%=keyword%>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
									</ul>
								</div>				
						<%							
							} else if (pno >= (totalPages-3)) {
								%>
								<div>
									<ul class="pagination">
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno-4)%>&keyword=<%=keyword%>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
									<%	
										for (int index=pno-3; index<=totalPages; index++) { 
											if (pno == index) { 
											%>
											<li class="active"><a href=""><%=index %></a></li>
											<%
											} else {
											%>
											<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>&keyword=<%=keyword%>"><%=index %></a></li>
											<%																
											}									
										} 								
									
										%>									
	
									</ul>
								</div>				
						<%	
							} else {
					%>
							<div>
								<ul class="pagination">
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno-4)%>&keyword=<%=keyword%>"><span class="glyphicon glyphicon-chevron-left"></span></a></li>
								<%	
									for (int index=pno-3; index<=pno+3; index++) { 
										if (pno == index) { 
										%>
										<li class="active"><a href=""><%=index %></a></li>
										<%
										} else {
										%>
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=index%>&keyword=<%=keyword%>"><%=index %></a></li>
										<%																
										}									
									} 								
								
									%>									
										<li><a href="main.jsp?listType=<%=listType%>&pno=<%=(pno+4)%>&keyword=<%=keyword%>"><span class="glyphicon glyphicon-chevron-right"></span></a></li>
	
								</ul>
							</div>			
					<%
							}
						}

					}
				%>
			</div>
<!-- ======================================================================================================================================================================
//=========================================================================================================================================================================
//=====================================================================================================================================================================--->

			<!-------------------- Yonghak Part Finish ----------------------->
			<!-------------------- YuSeok Part Start ----------------------->
			<div class="col-sm-3 well" id="section_right">
				<div class="well" style="text-align:left; overflow:auto; width:250px; height:355px; padding:10px;">
					<p style="text-align:center;">
						<i class="fa fa-comments" style="font-size:30px;color:#FA5858"></i><strong style="font-size:20px; color:#2E9AFE;">Chat List</strong>
					</p>
					<jsp:include page="/chat/loadChatList.jsp" flush="true" />
				</div>
				<div class="well" style="text-align:left; overflow:auto; width:250px; height:365px; padding:10px;">
					<p style="text-align:center;">
						<a href="#" id="openPopPeople"><i class="material-icons" style="font-size:22px;color:#2E64FE">people</i><strong style="font-size:14px; color:#0B610B;">Around People</strong>
						<i class="fa fa-map-o" style="font-size:22px;color:#2268ad"></i></a>
					</p>
					<jsp:include page="/people/loadAroundPeople.jsp" flush="true" />
				</div>
			</div>
		</div>
	</div>
		<!-------------------- YuSeok Part End ----------------------->
	<!-- MODAL -->
	<!-- MODAL -->
	<!-- MODAL -->
	<!-- Modal 
	
	<div id="editModal" class="modal fade" role="dialog">
	  <div class="modal-dialog">
	
	    Modal content
	    <div class="modal-content">
	      <div class="modal-header" style="background-color:#5cb85c; color:white;">
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	        <h4 class="modal-title">Edit Posting</h4>
	      </div>
	      <div class="modal-body">
	        <div class="form-group">
	        	Content<textarea rows="5" class="form-control" id="edit-board-textarea-content"></textarea>
	        </div>
	        <div class="form-group">
	        	tag<input type="Text" name="board_tag" id="board-tag" class="form-control"/>
	        </div>
	      </div>


			<div class="form-group">
			<input type="file" name="board_file" id="upload-file"
				class="form-control btn btn-default btn-sm"
				style="margin-top: 5px; margin-left: 15px; width: 60%; display: inline;">
			<div class="pull-right"
				style="margin-right: 130px; margin-top: 15px">
				<span id="textarea-content-size">0</span> / 1000
			</div>
			</div>

	      <div class="modal-footer">
	        <button type="button" class="btn btn-success" data-dismiss="modal">Update</button>
	        <button type="reset" class="btn btn-danger" data-dismiss="modal">Cancel</button>
	      </div>
	    </div>
	
	  </div>
	</div>
	-->

	<!-- IMG MODAL -->
	<!-- IMG MODAL -->
	<!-- IMG MODAL -->
	<div id="myModal" class="modal">
		<img class="modal-content" id="modalImg" src="" onclick="modalClose()">
		<div id="caption"></div>
	</div>
			
	<%@ include file="include/include-footer.jspf"%>
</body>
<script>
	var tagOnUpdateFlag = false;
	var maxHashTag = 20;
	
	
	// Get the modal
	var modal = document.getElementById('myModal');
	// Get the image and insert it inside the modal - use its "alt" text as a caption
	var modalImg = document.getElementById("modalImg");

	// board modal img extension when clicked
	var captionText = document.getElementById("caption");
	function imgModal(no) {
	    modal.style.display = "block";
		var now = document.getElementById('img-'+no);
	    modalImg.src = now.src;
		if (now.alt=='null') {			
		    captionText.innerHTML = "";			
		} else {
		    captionText.innerHTML = now.alt;			
		}
	}	
	
	// notice modal img extension when clicked
	function noticeImgModal(no) {
	    modal.style.display = "block";
		var now = document.getElementById('noticeImg-'+no);
	    modalImg.src = now.src;
	}	
	
	

	// Get the <span> element that closes the modal
	var span = document.getElementById("modalImg");

	// When the user clicks on <span> (x), close the modal
	function modalClose() { 
	    modal.style.display = "none";
	}
	
	// backward
	function backward() {
		history.back();
	}
	
	// focus on board when the page loaded
	function focusBoard(bno, cno, listType) {

		if (bno !="") {		
			if (cno !="") {
				commentsClicked(bno, 'listType');
				var here = document.getElementById('board-'+bno+'-comment-'+cno);
		
				here.scrollIntoView(false);
				here.setAttribute("style", "border:solid #b3d1ff 3px");
				
			} else {
				var here = document.getElementById('board-no-'+bno);
				here.scrollIntoView(false);				
				here.setAttribute("style", "border:solid #b3d1ff 3px");				
			}
		}
	}
	
	function checkReplyForm(no) {
	// check reply textarea minimum char numbers
		var textarea = document.getElementById('reply-textarea-'+no);
		var content = textarea.value;
		
		if (content.length < 2) {
			textarea.focus();
			alert("The field must have more than 2 characters.");
			return false;
		}
		return true;
	}	
	
	function checkUploadForm() {	
		// check new board textarea minimum char numbers
		var textarea = document.getElementById('new-board-textarea-content');
		var content = textarea.value;

		if (content.length < 2) {
			var cutContent = content.substring(0, 1000);
			textarea.value = cutContent;
			textarea.focus();
			countNewBoardTextareaContent();
			alert("The field must have more than 2 characters.");
			return false;
		}
		
		// check tag field start with # or not
		var tagarea = document.getElementById('tag-on-update').value;
		if (tagarea) {
			if (!tagarea.startsWith("#")) {
				alert("tagArea only can start with #");
				return false;
			}			
		}
		
		// check tag char number not over 100
		if (tagarea.length > 100) {
			alert("The field must not have more than 100 characters.");
			return false;
		}
		
		// check upload file type
		var file = document.getElementById('upload-file');
		console.log(file.value);
		if (file.value != "") {
			if (!(file.value.toLowerCase().endsWith("gif")
					|| file.value.toLowerCase().endsWith("png") || file.value
					.toLowerCase().endsWith("jpg"))) {
				alert("only jpg,png and gif files are allowed to upload.");
				file.value = "";
				return false;
			}
		}

		return true;
	}
	// check tag number not over 20
	function checkTagMax() {
		var tagField = document.getElementById('tag-on-update');
		var tagValue = tagField.value;
		var tagArray = tagValue.split("#");
		var tagArrayTemp = "";
		if (tagArray.length > maxHashTag + 1) {
			for (var i = 1; i < maxHashTag + 1; i++) {
				tagArrayTemp += "#" + tagArray[i];
			}
			tagField.value = tagArrayTemp;
			tagField.focus();
			alert("Sorry, this post has too many tags attached(maximum: "
					+ maxHashTag + ").");
		}
	}
	// check update new board 1000 char over or not
	function checkContentMaxChar() {
		var textarea = document.getElementById('new-board-textarea-content');
		var content = textarea.value;

		if (content.length > 1000) {
			var cutContent = content.substring(0, 1000);
			textarea.value = cutContent;
			textarea.focus();
			countNewBoardTextareaContent();
			alert("The field must not have more than 1000 characters.");
		}
	}

	// event click tag on update new board 
	function showTagOnUpdate() {
		var tagArea = document.getElementById('tag-on-update');
		if (tagOnUpdateFlag) {
			tagArea.setAttribute('type', 'hidden');
			tagArea.value = "";
			tagOnUpdateFlag = false;
		} else if (!tagOnUpdateFlag) {
			tagArea.setAttribute('type', 'text');
			tagOnUpdateFlag = true;
		}
	}

	// count number of char of new board
	function countNewBoardTextareaContent() {
		var textarea = document.getElementById('new-board-textarea-content');
		var content = textarea.value;
		var textareaSize = content.length;

		document.getElementById('textarea-content-size').innerText = textareaSize;
	}
	// clicked Comment event
	function commentsClicked(no, listType) {
		var span = document.getElementById('comment-btn-'+no);
		var arr = span.getAttribute('class').split("-");
		if (arr[2] == 'down') {
			span.setAttribute('class', 'glyphicon glyphicon-menu-up');
			document.getElementById('comment-list-'+no).setAttribute('style', 'display:inline;');
			
		} else if (arr[2] == 'up') {
			span.setAttribute('class', 'glyphicon glyphicon-menu-down');
			document.getElementById('comment-list-'+no).setAttribute('style', 'display:none;');
		}
	}
	
	// picture preview
	document.getElementById("upload-file").onchange = function() {
		var reader = new FileReader();
		
		// get loaded data and render tumbnail
		reader.onload = function(e) {
			document.getElementById("uploadPhotoPreview").src = e.target.result;
		};
		
		// read the image file as a data URL
		reader.readAsDataURL(this.files[0]);
		document.getElementById("uploadPhotoPreviewDiv").setAttribute('style', 'display:inline');
	}
	
	// clear preview picture on uploadForm
	function clearPicture() {
		document.getElementById("uploadPhotoPreview").src = "";
		document.getElementById("uploadPhotoPreviewDiv").setAttribute('style', 'display:none');
	}

	
	$(document).ready(function() {

		$("#top_btn").click(function() {
			$('html,body').animate({
				scrollTop : 0
			}, 800)
		});

		$("#createNewChat").click(function() {
			var chatTitle = $("#chatTitle").val().trim();
			if (null == chatTitle || "" == chatTitle) {
				alert("Please, Enter a chat title.");
				$("#chatTitle").focus();
				return false;
			}
			
			location.href = "chat/createNewChat.jsp?chatTitle="+chatTitle;
		});

		$("#NavChatArea").click(function() {
			$("#chatTitle").focus();
		});

		var leftCurrentPosition = parseInt($("#section_left").css("top"));  
		var rightCurrentPosition = parseInt($("#section_right").css("top"));  
	    $(window).scroll(function() {  
            var position = $(window).scrollTop();  
            $("#section_left").stop().animate({"top":position+leftCurrentPosition+"px"},800);  
            $("#section_right").stop().animate({"top":position+rightCurrentPosition+"px"},800);  
	    });  

	    $("#openPopPeople").click(function() {
			var popUrl = "people/infoPeople.jsp";
			var popOption = "width=650, height=600, resizable=no, scrollbars=no, status=no, toolbar=no, loation=no, directories=no";    //팝업창 옵션(optoin)
			window.open(popUrl,"",popOption);
		});

	});

</script>
</html>
