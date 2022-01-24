<%@page import="com.mini.util.MD5"%>
<%@page import="com.mini.util.FileName"%>
<%@page import="com.mini.vo.MemberVO"%>
<%@page import="com.mini.dao.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<%

	request.setCharacterEncoding("utf-8");

	MemberVO member = (MemberVO) request.getSession().getAttribute("LOGIN_MEMBER");

	String pwd = request.getParameter("newpwd");
	if(pwd == null){
		pwd = member.getMemberPwd();
	}else{
		pwd = MD5.hash(pwd);
	}
	String name = request.getParameter("name");
	String gender = request.getParameter("gender");
	String contact = request.getParameter("contact");
	String addr = request.getParameter("addr");
	String email= request.getParameter("email");
	String dob= request.getParameter("dob");
	
	
	Part part = request.getPart("photo");
	String photo = FileName.getFileName(part);
	System.out.println(photo);
	
	member.setMemberPhoto(photo);
	member.setMemberPwd(pwd);
	member.setMemberName(name);
	member.setMemberGender(gender);
	member.setMemberContact(contact);
	member.setMemberAddr(addr);
	member.setMemberEmail(email);
	member.setMemberBirth(dob);
	
	MemberDAO dao = new MemberDAO();
	 
	dao.updateMember(member);
	
	// 첨부파일 처리하기
	String imgDir = "C:\\project\\workspace\\mini\\WebContent\\img\\member_img";
	
	if(!photo.equals("") && photo !=null){
		part.write(imgDir + "/"+photo);
	}
	
	response.sendRedirect("../main.jsp");
	return;
	
	%>