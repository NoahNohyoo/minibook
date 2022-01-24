package com.mini.email;

import javax.mail.Transport;
import javax.mail.Message;
import javax.mail.Address;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.Session;
import javax.mail.Authenticator;

import java.net.InetAddress;
import java.util.Properties;

public class SendEmail {

	public boolean sendAuthEmail(String memberId, String memberName, String memberEmail) throws Exception {
		
		boolean result = false;
		InetAddress hostAddr = InetAddress.getLocalHost();
		String hostIP = hostAddr.getHostAddress();
		
		try{
			Properties p = new Properties();
			p.put("mail.smtp.host","smtp.gmail.com"); // Gmail SMTP
			p.put("mail.smtp.port", "465");  // or 587
			p.put("mail.smtp.starttls.enable", "true");
			p.put("mail.smtp.auth", "true");
			p.put("mail.smtp.debug", "true");
			p.put("mail.smtp.socketFactory.port", "465");  // or 587
			p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
			p.put("mail.smtp.socketFactory.fallback", "false");
			
			Authenticator auth = new SMTPAuthenticatior();
			Session ses = Session.getInstance(p, auth);

			
			String from = "miniemail2017@gmail.com"; // project mini admin account	
			String to = memberEmail;
			String subject = "회원가입 환영 이메일 발송";
			
			String authImg = "<img src='http://blog.kr.intelisystems.com/wp-content/uploads/2015/06/facebook-254165_1280-1024x723.jpg'>";
			String content = memberId+"("+memberName+") 회원님 가입을 환영합니다.<br>			" +
							"아래의 링크를 이용하여 로그인 후 서비스를 이용하세요.	" + 
							"<a href='http://"+hostIP+":80/mini/intro.jsp'>사이트로 이동</a>"+authImg;
			
			ses.setDebug(true);
			
			// 메일의 내용을 담을 객체
			MimeMessage msg = new MimeMessage(ses); 
			msg.setSubject(subject);
			
			// 보내는 사람
			Address fromAddr = new InternetAddress(from);
			msg.setFrom(fromAddr);
			
			// 받는 사람
			Address toAddr = new InternetAddress(to);
			msg.addRecipient(Message.RecipientType.TO, toAddr); 
			
			msg.setContent(content, "text/html;charset=UTF-8"); // 내용과 인코딩
			Transport.send(msg); // 전송
			
			result = true;
			
		} catch(Exception e){
			e.printStackTrace();
		} 
		
		return result;
	}
}
