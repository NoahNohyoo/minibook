package com.mini.util;

import javax.servlet.annotation.WebListener; 
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import com.mini.dao.MemberDAO;
import com.mini.vo.MemberVO;

@WebListener
public class HttpSessionListenerImpl implements HttpSessionListener {

	@Override
	public void sessionCreated(HttpSessionEvent e) {
		// TODO Auto-generated method stub
	}
	
	@Override
	public void sessionDestroyed(HttpSessionEvent e) {
		HttpSession session = e.getSession();
		MemberVO member = (MemberVO)session.getAttribute("LOGIN_MEMBER");
		
		if (null != member) {
			int memberNo = member.getMemberNo();
			
			MemberDAO memberDao = new MemberDAO();
			try {
				memberDao.toggleLogined("N", memberNo);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
	}
	
}
