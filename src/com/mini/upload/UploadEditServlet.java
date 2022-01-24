package com.mini.upload;

import java.io.IOException; 

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.mini.dao.BoardDAO;
import com.mini.vo.BoardVO;
import com.mini.vo.MemberVO;

@MultipartConfig
@WebServlet(urlPatterns="/edit.jsp")
public class UploadEditServlet extends HttpServlet {
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("utf-8");
		HttpSession session = req.getSession(false);
		
		MemberVO member = (MemberVO)session.getAttribute("LOGIN_MEMBER");
		
		String board_content = req.getParameter("board_content");
		String board_tag = req.getParameter("board_tag");
		int board_no = Integer.parseInt(req.getParameter("board_no"));
		int member_no = member.getMemberNo();
		String listType = req.getParameter("listType");
		
		board_content = board_content.replaceAll("\n", "<br/>");
		Part part = req.getPart("board_file");
		String board_file = getFileName(part);
		ServletContext application = this.getServletContext();
		//String galleryDir = application.getRealPath("board_img");
		String galleryDir = "C:\\workspace\\mini\\WebContent\\img\\board_img";
		
		BoardVO vo = new BoardVO();
		if (board_file != null && !board_file.isEmpty()) {
			part.write(galleryDir+"/"+board_file);
			vo.setBoard_file(board_file);
		}
		vo.setBoard_no(board_no);
		vo.setBoard_content(board_content);
		vo.setBoard_tag(board_tag);
		vo.setMember_no(member.getMemberNo());
		
		BoardDAO dao = new BoardDAO();
		try {
			dao.updateEditedBoard(vo);
		} catch(Exception e) {
			e.printStackTrace();
		}
		if ("user".equals(listType)) {
			resp.sendRedirect("main.jsp?listType="+listType+"&bno="+board_no+"&member_no="+member_no);			
		} else {
			resp.sendRedirect("main.jsp?listType="+listType+"&bno="+board_no);						
		}
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