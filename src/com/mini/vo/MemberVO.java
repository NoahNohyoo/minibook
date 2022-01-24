package com.mini.vo;

import java.text.DecimalFormat;

public class MemberVO {

	private int MemberNo;
	private String MemberId;
	private String MemberPwd;
	private String MemberEmail;
	private String MemberRegdate;
	private String MemberBirth;
	private String MemberName;
	private String MemberGender;
	private String MemberContact;
	private String MemberAddr;
	private double MemberLng;
	private double MemberLat;
	private String MemberIsLogined;
	private String MemberPhoto;
	private double MemberDistance;
	
	public int getMemberNo() {
		return MemberNo;
	}
	public void setMemberNo(int memberNo) {
		MemberNo = memberNo;
	}
	public String getMemberId() {
		return MemberId;
	}
	public void setMemberId(String memberId) {
		MemberId = memberId;
	}
	public String getMemberPwd() {
		return MemberPwd;
	}
	public void setMemberPwd(String memberPwd) {
		MemberPwd = memberPwd;
	}
	public String getMemberEmail() {
		return MemberEmail;
	}
	public void setMemberEmail(String memberEmail) {
		MemberEmail = memberEmail;
	}
	public String getMemberRegdate() {
		return MemberRegdate;
	}
	public void setMemberRegdate(String memberRegdate) {
		MemberRegdate = memberRegdate;
	}
	public String getMemberBirth() {
		return MemberBirth;
	}
	public void setMemberBirth(String memberBirth) {
		MemberBirth = memberBirth;
	}
	public String getMemberName() {
		return MemberName;
	}
	public void setMemberName(String memberName) {
		MemberName = memberName;
	}
	public String getMemberGender() {
		return MemberGender;
	}
	public void setMemberGender(String memberGender) {
		MemberGender = memberGender;
	}
	public String getMemberContact() {
		return MemberContact;
	}
	public void setMemberContact(String memberContact) {
		MemberContact = memberContact;
	}
	public String getMemberAddr() {
		return MemberAddr;
	}
	public void setMemberAddr(String memberAddr) {
		MemberAddr = memberAddr;
	}
	public double getMemberLng() {
		return MemberLng;
	}
	public void setMemberLng(double memberLng) {
		MemberLng = memberLng;
	}
	public double getMemberLat() {
		return MemberLat;
	}
	public void setMemberLat(double memberLat) {
		MemberLat = memberLat;
	}
	public String getMemberIsLogined() {
		return MemberIsLogined;
	}
	public void setMemberIsLogined(String memberIsLogined) {
		MemberIsLogined = memberIsLogined;
	}
	public String getMemberPhoto() {
		return MemberPhoto;
	}
	public void setMemberPhoto(String memberPhoto) {
		MemberPhoto = memberPhoto;
	}
	public double getMemberDistance() {
		return MemberDistance;
	}
	public void setMemberDistance(double memberDistance) {
		MemberDistance = memberDistance;
	}
	
	public String getShortDistance() {
		DecimalFormat df = new DecimalFormat("#,##0.0");
		String result = df.format(MemberDistance);
		if ("0.0".equals(result)) {
			result = "0.1";
		}
		return result;
	}
	
	@Override
	public String toString() {
		return "MemberVO [MemberNo=" + MemberNo + ", MemberId=" + MemberId + ", MemberPwd=" + MemberPwd
				+ ", MemberEmail=" + MemberEmail + ", MemberRegdate=" + MemberRegdate + ", MemberBirth=" + MemberBirth
				+ ", MemberName=" + MemberName + ", MemberGender=" + MemberGender + ", MemberContact=" + MemberContact
				+ ", MemberAddr=" + MemberAddr + ", MemberLng=" + MemberLng + ", MemberLat=" + MemberLat
				+ ", MemberIsLogined=" + MemberIsLogined + ", MemberPhoto=" + MemberPhoto + ", MemberDistance="
				+ MemberDistance + "]";
	}
	
}
