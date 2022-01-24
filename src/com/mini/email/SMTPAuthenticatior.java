package com.mini.email;
 
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
 
public class SMTPAuthenticatior extends Authenticator{
 
    @Override
    protected PasswordAuthentication getPasswordAuthentication() {
    	
    	String id = "miniemail2017@gmail.com";
    	String pwd = "@asdzxc159753";
    	
        return new PasswordAuthentication(id, pwd);
    }
}