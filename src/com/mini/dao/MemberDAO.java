package com.mini.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import com.mini.locate.GetLocateByAddr;
import com.mini.util.ConnectionUtil;
import com.mini.vo.MemberVO;

public class MemberDAO {
	
	public MemberVO getIdByNameAndEmail(String name, String email) throws Exception {
		
		String sql = " select member_id "
				+ " from tb_member "
				+ " where member_name = ? "
				+ " and member_email = ? ";
		
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, name);
		pstmt.setString(2, email);
		ResultSet rs = pstmt.executeQuery();
		
		MemberVO member = null;
		
		if (rs.next()) {
			member = new MemberVO();
			member.setMemberId(rs.getString("member_id"));
			
		}
		
		rs.close();
		con.close();
		pstmt.close();
		return member;
	
	}
	
	public int getPwdByNameAndEmailAndId(String name, String email, String id) throws Exception {
		
		String sql = " select member_no "
				+ " from tb_member "
				+ " where member_name = ? "
				+ " and member_email = ? "
				+ " and member_id = ? ";
		
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, name);
		pstmt.setString(2, email);
		pstmt.setString(3, id);
		ResultSet rs = pstmt.executeQuery();
		
		
		int mno = 0;
		if (rs.next()) {
			mno = rs.getInt("member_no");
		}
		
		rs.close();
		con.close();
		pstmt.close();
		return mno;
		
	}

	public void updatePwd(int mno, String newPwd) throws Exception {
		String sql = "update tb_member			"
					+"set member_pwd = ?		"
					+"where member_no = ?";
		
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, newPwd);
		pstmt.setInt(2, mno);
		
		pstmt.executeUpdate();
		
		con.close();
		pstmt.close();
	}
	
	public void addMember(MemberVO member) throws Exception {
		String sql = "insert into tb_member 															"											
					+" (member_no, member_contact, member_lng, member_lat, member_id,					"
					+"member_pwd, member_email, member_gender, member_name, member_addr, member_birth) 	"
					+"values (seq_member_no.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ";

		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, member.getMemberContact());
		pstmt.setDouble(2, member.getMemberLng());
		pstmt.setDouble(3, member.getMemberLat());
		pstmt.setString(4, member.getMemberId());
		pstmt.setString(5, member.getMemberPwd());
		pstmt.setString(6, member.getMemberEmail());
		pstmt.setString(7, member.getMemberGender());
		pstmt.setString(8, member.getMemberName());
		pstmt.setString(9, member.getMemberAddr());
		pstmt.setString(10, member.getMemberBirth());
		
		pstmt.executeUpdate();
		
		con.close();
		pstmt.close();
	}
	
	public MemberVO getMemberById(String id) throws Exception {
		String sql = "select member_no, member_contact, member_lng, member_lat, member_id,"
				+ " member_pwd, member_email, member_gender, member_name, member_addr, member_birth, member_photo "
				+ " from tb_member "
				+ " where member_id = ?";
		 
		MemberVO member = null;
		
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, id);
		ResultSet rs = pstmt.executeQuery();
		
		if (rs.next()) {
			member = new MemberVO();
			member.setMemberNo(rs.getInt("member_no"));
			member.setMemberContact(rs.getString("member_contact"));
			member.setMemberLng(rs.getDouble("member_lng"));
			member.setMemberLat(rs.getDouble("member_lat"));
			member.setMemberId(rs.getString("member_id"));
			member.setMemberPwd(rs.getString("member_pwd"));
			member.setMemberEmail(rs.getString("member_email"));
			member.setMemberGender(rs.getString("member_gender"));
			member.setMemberName(rs.getString("member_name"));
			member.setMemberAddr(rs.getString("member_addr"));
			member.setMemberBirth(rs.getString("member_birth"));
			member.setMemberPhoto(rs.getString("member_photo"));
			
		}
		
		rs.close();
		con.close();
		pstmt.close();
		return member;
	
	}
		
	public void toggleLogined(String flag, int memberNo) throws Exception {
		
		String sql = "update tb_member				"
					+"set member_is_logined = ?		"
					+"where member_no = ?";

		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, flag);
		pstmt.setInt(2, memberNo);
		pstmt.executeUpdate();
		
		con.close();
		pstmt.close();
	}
	
	public ArrayList<MemberVO> getFriendsByMemberNo(int memberNo) throws Exception {
		
		String sql = "select member_no, member_id, member_name, member_photo, member_is_logined		"
					+"from tb_member																"
					+"where member_no in ((select member_no											"
					+"					from tb_friend												"
					+"					where (member_no = ? or friend_no = ?)						"
					+"					and friend_agree = 'Y')										"
					+"					union														"
					+"					(select friend_no											"
					+"					from tb_friend												"
					+"					where (member_no = ? or friend_no = ?)						"
					+"					and friend_agree = 'Y'))									"
					+"and member_no <> ?															"
					+"order by member_is_logined desc";
		
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, memberNo);
		pstmt.setInt(2, memberNo);
		pstmt.setInt(3, memberNo);
		pstmt.setInt(4, memberNo);
		pstmt.setInt(5, memberNo);
		ResultSet rs = pstmt.executeQuery();
		
		ArrayList<MemberVO> friends = new ArrayList<>();
		while (rs.next()) {
			MemberVO member = new MemberVO();
			member.setMemberNo(rs.getInt("member_no"));
			member.setMemberId(rs.getString("member_id"));
			member.setMemberName(rs.getString("member_name"));
			member.setMemberPhoto(rs.getString("member_photo"));
			member.setMemberIsLogined(rs.getString("member_is_logined"));
			friends.add(member);
		}
		
		rs.close();
		con.close();
		pstmt.close();
		return friends;
	
	}
	
	public MemberVO getMemberByNo(int no) throws Exception {
		
		String sql = "select member_no, member_contact, member_lng, member_lat, member_id,"
				+ " member_pwd, member_email, member_gender, member_name, member_addr, member_birth, member_photo "
				+ " from tb_member "
				+ " where member_no = ?";
		
		MemberVO member = null;
		
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, no);
		ResultSet rs = pstmt.executeQuery();
		
		if (rs.next()) {
			member = new MemberVO();
			member.setMemberNo(rs.getInt("member_no"));
			member.setMemberContact(rs.getString("member_contact"));
			member.setMemberLng(rs.getDouble("member_lng"));
			member.setMemberLat(rs.getDouble("member_lat"));
			member.setMemberId(rs.getString("member_id"));
			member.setMemberPwd(rs.getString("member_pwd"));
			member.setMemberEmail(rs.getString("member_email"));
			member.setMemberGender(rs.getString("member_gender"));
			member.setMemberName(rs.getString("member_name"));
			member.setMemberAddr(rs.getString("member_addr"));
			member.setMemberBirth(rs.getString("member_birth"));
			member.setMemberPhoto(rs.getString("member_photo"));
			
		}
		
		rs.close();
		con.close();
		pstmt.close();
		return member;
		
	}
	
	public ArrayList<MemberVO> getFriendRequesters(int memberNo) throws Exception {
		
		String sql = "select member_no, member_id				"
					+"from tb_member							"
					+"where member_no in (select member_no		"
					+"					from tb_friend			"
					+"					where friend_no = ?		"
					+"					and friend_agree = 'N')";
		
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, memberNo);
		ResultSet rs = pstmt.executeQuery();
		
		ArrayList<MemberVO> requesters = new ArrayList<>();
		while (rs.next()) {
			MemberVO member = new MemberVO();
			member.setMemberNo(rs.getInt("member_no"));
			member.setMemberId(rs.getString("member_id"));
			requesters.add(member);
		}
		
		rs.close();
		con.close();
		pstmt.close();
		return requesters;
		
	}
	
	public void requestFriend(int memberNo, int friendNo) throws Exception {
			
		String sql = "insert into tb_friend		"
					+"values(?, ?, 'N')";
		
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, memberNo);
		pstmt.setInt(2, friendNo);
		pstmt.executeUpdate();
		
		con.close();
		pstmt.close();
	}
	
	public void requestAcceptForFriend(int memberNo, int friendNo) throws Exception {
		
		String sql = "update tb_friend			"
					+"set friend_agree = 'Y'	"
					+"where member_no = ?		"
					+"and friend_no = ?";
		
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, friendNo);	// ????????? ????????? no??? tb_friend??? member_no
		pstmt.setInt(2, memberNo);	// ???????????? ????????? friend_no
		pstmt.executeUpdate();
		
		con.close();
		pstmt.close();
	}
	
	public void requestDenyForFriend(int memberNo, int friendNo) throws Exception {
		
		String sql = "delete from tb_friend		"
					+"where member_no = ?		"
					+"and friend_no = ?";
		
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, friendNo);	// ????????? ????????? no??? tb_friend??? member_no
		pstmt.setInt(2, memberNo);	// ???????????? ????????? friend_no
		pstmt.executeUpdate();
		
		con.close();
		pstmt.close();
	}
	
	
	public void deleteFriend(int memberNo, int friendNo) throws Exception {
		
		String sql = "delete from tb_friend						"
					+"where (member_no = ? and friend_no = ?	"
					+"	or friend_no = ? and member_no = ?)";

		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, memberNo);
		pstmt.setInt(2, friendNo);
		pstmt.setInt(3, memberNo);
		pstmt.setInt(4, friendNo);
		pstmt.executeUpdate();
		
		con.close();
		pstmt.close();
	}
	
	
	public void updateMember(MemberVO member) throws Exception {
		
		String hasNewPwd = member.getMemberPwd();
		String hasPhoto = member.getMemberPhoto();
		
		GetLocateByAddr glba = new GetLocateByAddr();
		HashMap locate = glba.getLocate(member.getMemberAddr());
		double lat = Double.parseDouble((String)locate.get("lat"));
		double lng = Double.parseDouble((String)locate.get("lng"));
		
		String sql = "update tb_member												"
					+"set member_email = ?, member_gender = ?, member_name = ?, 	"
					+"member_addr = ?, member_birth = ?, member_contact = ?, 		"
					+"member_lat = ?, member_lng = ? 								";
				if (null != hasNewPwd) {
					sql += ", member_pwd = ?										";
				}
				if (null != hasPhoto) {
					sql += ", member_photo = ?										";
				}
					sql += "where member_no = ?";

		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, member.getMemberEmail());
		pstmt.setString(2, member.getMemberGender());
		pstmt.setString(3, member.getMemberName());
		pstmt.setString(4, member.getMemberAddr());
		pstmt.setString(5, member.getMemberBirth());
		pstmt.setString(6, member.getMemberContact());
		pstmt.setDouble(7, lat);
		pstmt.setDouble(8, lng);
		if (null != hasNewPwd && null == hasPhoto) {
			pstmt.setString(9, member.getMemberPwd());
			pstmt.setInt(10, member.getMemberNo());
			
		} else if (null == hasNewPwd && null != hasPhoto) {
			pstmt.setString(9, member.getMemberPhoto());
			pstmt.setInt(10, member.getMemberNo());
			
		} else if (null != hasNewPwd && null != hasPhoto){
			pstmt.setString(9, member.getMemberPwd());
			pstmt.setString(10, member.getMemberPhoto());
			pstmt.setInt(11, member.getMemberNo());
			
		} else {
			pstmt.setInt(9, member.getMemberNo());
			
		}
		pstmt.executeUpdate();
		
		con.close();
		pstmt.close();
	}
	
	public void withdrawalMember(int mno) throws Exception {
		String sql = "delete from tb_member where member_no = ?";
		
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, mno);
		pstmt.executeUpdate();
		
		pstmt.close();
		con.close();
		
	}
	
	public boolean checkAccount(String mid, String mpwd) throws Exception {
		boolean result = false;
		String sql = " select member_no		"
					+" from tb_member		"
					+" where member_id = ?	"
					+" and member_pwd = ?";
		
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, mid);
		pstmt.setString(2, mpwd);
		ResultSet rs = pstmt.executeQuery();
		
		if (rs.next()) {
			result = true;
		}
		
		pstmt.close();
		con.close();
		return result;
		
	}
}
