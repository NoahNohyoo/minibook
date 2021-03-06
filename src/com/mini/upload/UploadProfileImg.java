package com.mini.upload;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.mini.dao.MemberDAO;
import com.mini.util.MD5;
import com.mini.vo.MemberVO;

@MultipartConfig
@WebServlet(urlPatterns="/member/uploadProfile.jsp")
public class UploadProfileImg extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("utf-8");
		HttpSession session = req.getSession(false);
		if(session == null){
			resp.sendRedirect("login.jsp");
			return;
		}
		MemberVO mem = (MemberVO)session.getAttribute("LOGIN_MEMBER");
		if(mem == null){
			resp.sendRedirect("login.jsp");
			return;
		}
		
		int no = mem.getMemberNo();
		String id = mem.getMemberId();
		String newPwd = req.getParameter("newpwd");
		String name = req.getParameter("name");
		String gender = req.getParameter("gender");
		String contact = req.getParameter("contact");
		String addr = req.getParameter("addr");
		String email = req.getParameter("email");
		String dob = req.getParameter("dob");
		
		if (null == newPwd || "".equals(newPwd)) {
			newPwd = null;
		} else {
			try {
				newPwd = MD5.hash(newPwd);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		Part part = req.getPart("photo");
		String memberPhoto = getFileName(part);
		if (null == memberPhoto || "".equals(memberPhoto)) {
			memberPhoto = null;
		}
		
		ServletContext application = this.getServletContext();
		//String imgDir = application.getRealPath("img/member_img");
		String imgDir = "C:\\workspace\\mini\\WebContent\\img\\member_img";
		
		String unique = String.valueOf(new Date().getTime());
		
		MemberVO member = new MemberVO();
		if (memberPhoto != null && !memberPhoto.isEmpty()) {
			part.write(imgDir+"/"+unique+memberPhoto);
			member.setMemberPhoto(unique+memberPhoto);
		}
		
		member.setMemberNo(no);
		member.setMemberName(name);
		member.setMemberGender(gender);
		member.setMemberContact(contact);
		member.setMemberAddr(addr);
		member.setMemberEmail(email);
		member.setMemberBirth(dob);
		member.setMemberPwd(newPwd);
		
		
		MemberDAO dao = new MemberDAO();
		try {
			dao.updateMember(member);
		} catch(Exception e) {
			e.printStackTrace();
		}
	
		MemberVO nowMember = new MemberVO();
		try {
			nowMember = dao.getMemberById(id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		session.setMaxInactiveInterval(60 * 60); // ?????? 60??? ??????
		session.setAttribute("LOGIN_MEMBER", nowMember);
		resp.sendRedirect("/mini/member/successfulEditAccount.jsp");
	}
	
	private String getFileName(Part part) {
		String fileName = null;
		String headValue = part.getHeader("Content-Disposition");
		String[] elements = headValue.split(";");
		for (String el : elements) {
			if(el.trim().startsWith("filename")) {
				fileName = el.substring(el.indexOf("=")+1).replace("\"", "");
			}
		}
		return fileName;
	}
}
