package com.mini.vo;

import java.util.Date;

public class BoardVO {
	private int board_no;
	private String board_file;
	private String board_tag;
	private String board_content;
	private int board_like_cnt;
	private int board_level;
	private Date board_regdate;
	private int member_no;
	private String member_name;
	private String member_photo;
	
	public int getBoard_no() {
		return board_no;
	}
	public void setBoard_no(int board_no) {
		this.board_no = board_no;
	}
	public String getBoard_file() {
		return board_file;
	}
	public void setBoard_file(String board_file) {
		this.board_file = board_file;
	}
	public String getBoard_tag() {
		return board_tag;
	}
	public void setBoard_tag(String board_tag) {
		this.board_tag = board_tag;
	}
	public String getBoard_content() {
		return board_content;
	}
	public void setBoard_content(String board_content) {
		this.board_content = board_content;
	}
	public int getBoard_like_cnt() {
		return board_like_cnt;
	}
	public void setBoard_like_cnt(int board_like_cnt) {
		this.board_like_cnt = board_like_cnt;
	}
	public int getBoard_level() {
		return board_level;
	}
	public void setBoard_level(int board_level) {
		this.board_level = board_level;
	}
	public Date getBoard_regdate() {
		return board_regdate;
	}
	public void setBoard_regdate(Date board_regdate) {
		this.board_regdate = board_regdate;
	}
	public int getMember_no() {
		return member_no;
	}
	public void setMember_no(int member_no) {
		this.member_no = member_no;
	}
	public String getMember_name() {
		return member_name;
	}
	public void setMember_name(String member_name) {
		this.member_name = member_name;
	}
	public String getMember_photo() {
		return member_photo;
	}
	public void setMember_photo(String member_photo) {
		this.member_photo = member_photo;
	}
}
