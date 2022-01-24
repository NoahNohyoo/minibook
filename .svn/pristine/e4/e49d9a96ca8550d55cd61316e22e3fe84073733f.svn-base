<%@page import="com.mini.email.SendEmail"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>
<%@ page import="com.mini.util.MD5"%>
<%@ page import="com.mini.dao.MemberDAO"%>
<%@ page import="com.mini.vo.MemberVO"%>
<%@ page import="com.mini.locate.GetLocateByAddr"%>
<%@ page import="java.util.HashMap"%>

<%  	

	request.setCharacterEncoding("utf-8");

 	String id = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	String name = request.getParameter("name");
	String gender = request.getParameter("gender");
	String contact = request.getParameter("contact");
	String addr = request.getParameter("addr");
	String dob = request.getParameter("dob");
	String email= request.getParameter("email");
	
	

	String secuPwd = MD5.hash(pwd);
	
	MemberVO member = new MemberVO();
	
	member.setMemberId(id);		
	member.setMemberPwd(secuPwd);		
	member.setMemberName(name);		
	member.setMemberGender(gender);		
	member.setMemberContact(contact);		
	member.setMemberAddr(addr);		
	member.setMemberBirth(dob);		
	member.setMemberEmail(email);
	
	// 회원 주소값으로 좌표 추출 후 member객체에 추가
	GetLocateByAddr glba = new GetLocateByAddr();
	HashMap locate = glba.getLocate(addr);
	member.setMemberLat(Double.parseDouble((String)locate.get("lat")));
	member.setMemberLng(Double.parseDouble((String)locate.get("lng")));
	
	
	MemberDAO dao = new MemberDAO();
	dao.addMember(member);
	
	// 가입완료 후 가입환영 이메일 발송
	SendEmail se = new SendEmail();
	se.sendAuthEmail(id, name, email);
%>

<script>
	alert("Thank you. You have been successfully registered.");
	location.href="../intro.jsp";
</script>
