<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	// 중복여부를 검사할 아이디를 요청메시지에서 꺼내기
	String regiId = request.getParameter("regiId");
	System.out.println("중복여부를 검사할 아이디: " + regiId);
	
	// 중복여부를 검사하기
	String duplicated = "N";
	if ("11".equals(regiId)) {
		duplicated = "Y";
	}
	
	// 중복여부를 Y/N로 전달하기
	out.write(duplicated);
%>




