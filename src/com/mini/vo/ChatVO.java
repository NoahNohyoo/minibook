package com.mini.vo;

public class ChatVO {
	
	private int chatNo;
	private String chatTitle;
	private String chatEntrance;
	private String chatText;
	private String chatRegdate;
	private int memberNo;
	
	public int getChatNo() {
		return chatNo;
	}
	public void setChatNo(int chatNo) {
		this.chatNo = chatNo;
	}
	public String getChatTitle() {
		return chatTitle;
	}
	public void setChatTitle(String chatTitle) {
		this.chatTitle = chatTitle;
	}
	public String getChatEntrance() {
		return chatEntrance;
	}
	public void setChatEntrance(String chatEntrance) {
		this.chatEntrance = chatEntrance;
	}
	public String getChatText() {
		return chatText;
	}
	public void setChatText(String chatText) {
		this.chatText = chatText;
	}
	public String getChatRegdate() {
		return chatRegdate;
	}
	public void setChatRegdate(String chatRegdate) {
		this.chatRegdate = chatRegdate;
	}
	public int getMemberNo() {
		return memberNo;
	}
	public void setMemberNo(int memberNo) {
		this.memberNo = memberNo;
	}
	
	@Override
	public String toString() {
		return "ChatVO [chatNo=" + chatNo + ", chatTitle=" + chatTitle + ", chatEntrance=" + chatEntrance
				+ ", chatText=" + chatText + ", chatRegdate=" + chatRegdate + ", memberNo=" + memberNo + "]";
	}
	
	
}
