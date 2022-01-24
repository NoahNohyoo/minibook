<%@page import="com.mini.vo.BoardVO"%>
<%@page import="com.mini.dao.BoardDAO"%>
<%@ include file="/include/include-navbar.jspf"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
	request.setCharacterEncoding("utf-8");
	BoardDAO dao = new BoardDAO();
	int bno = Integer.parseInt(request.getParameter("bno"));
	BoardVO board = dao.callBoardforEdit(bno);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/../include/include-header.jspf"%>
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
	margin-top: 100px;
}
.form-caption {
	margin-top: 20px;
}

</style>
</head>
<body>
<%@ include file="/include/include-navbar.jspf"%>
<div class="container" style="width:800px;">
	<h2>Edit Posting</h2>
		<div class="panel-group">
			<div class="panel panel-success">
			<div class="panel-heading">&nbsp;</div>
			<div class="panel-body">
			<form action="../edit.jsp" method="post" enctype="multipart/form-data" onsubmit="return checkUploadForm()">
				<div class="form-group">
					<label class="form-caption">Contents</label><textarea rows="5" class="form-control" name="board_content" id="edit-content-area" onkeyup="countContentArea()"><%=board.getBoard_content() %></textarea>
					<div class="pull-right"><span id="count-edit-content">0</span> / 1000</div>
					<label class="form-caption">Tags</label><input type="text" class="form-control" name="board_tag" value="<%=board.getBoard_tag()==null ? "" : board.getBoard_tag() %>" placeholder="ex ) #James #Anna #Pizza #Manhattan #NYC" id="tag-on-update" onblur="checkTagMax()"/>
					<label class="form-caption">Uploads</label><input type="file" id="upload-file" name="board_file" class="form-control"/>
					<input type="hidden" name="board_no" value="<%=board.getBoard_no()%>">
					<input type="hidden" name="listType" value="<%=request.getParameter("listType")%>">
					<div class="row" id="uploadPhotoPreviewDiv" style="display:none">
						<img id="uploadPhotoPreview" class="img-rounded" height="230px" width="300px"/>
					</div>
					<hr>
					<div class="pull-right">
						<button class="btn btn-success" type="submit" value="Submit">Submit</button>
						<button class="btn btn-danger" type="reset" value="Reset" id="reset-button">Reset</button>
						<button class="btn btn-warning" onclick="backward()">Back</button>
					</div>
				</div>
			</form>
			</div>
		</div>
	</div>
</div>

</body>
<script type="text/javascript">
	var maxHashTag = 20;
	function backward() {
		history.back();
	}


	
	function countContentArea() {
		var textarea = document.getElementById("edit-content-area").value;
		document.getElementById("count-edit-content").innerText = textarea.length;
		if (textarea.length>1000) {
			document.getElementById("edit-content-area").value = textarea.substring(0,1000);
			
			alert("The field must not have more than 1000 characters.");
		}
	}

	
	function checkUploadForm() {	
		// 업로드에 2글자 이상 입력됬는지 확인하기
		var textarea = document.getElementById("edit-content-area").value;
		if (textarea.length<2) {			
			alert("The Content must have more than 2 characters.");
			document.getElementById("edit-content-area").focus();
			return false;
		}
		// 업로드 파일 형식 체크
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
	
	// 태그 20개이상 넘는지 확인하기
	function checkTagMax() {
		var text = document.getElementById('tag-on-update').value;
		var tagArray = text.split("#");
		var tagArrayTemp = "";
		if (tagArray.length > maxHashTag + 1) {
			for (var i = 1; i < maxHashTag + 1; i++) {
				tagArrayTemp += "#" + tagArray[i];
			}
			document.getElementById('tag-on-update').value = tagArrayTemp;
			document.getElementById('tag-on-update').focus();
			alert("Sorry, this post has too many tags attached(maximum: "
					+ maxHashTag + ").");
		}
	}
	
	// 사진 미리보기
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
	
	document.getElementById("reset-button").onclick = function () {
		document.getElementById("uploadPhotoPreview").src = "";
		document.getElementById("uploadPhotoPreviewDiv").setAttribute('style', 'display:none');
	}
</script>
</html>