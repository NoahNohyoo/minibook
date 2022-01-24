package com.mini.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.mini.util.ConnectionUtil;
import com.mini.vo.MemberVO;

public class PeopleDAO {
	
	// 내 주변의 회원 조회하기(5km 이내)
	public ArrayList<MemberVO> getAroundPeople(double memberLat, double memberLng, int memberNo) throws Exception {
		
		String sql = "with																								"
					+"	around_people as(																				"
					+"			select member_no, member_id, member_name, member_photo,									"
					+"				   DISTANCE_MINI(member_lat, member_lng, ?, ?) as member_distance					"
					+"			from tb_member																			"
					+"			where member_no <> ?																	"
					+"			and member_no not in ((select member_no 												"
					+"									from tb_friend 													"
					+"									where (member_no = ?											"
					+"										or friend_no = ?))											"
					+"									union															"
					+"									(select friend_no 												"
					+"									from tb_friend 													"
					+"									where (member_no = ?											"
					+"										or friend_no = ?)))											"
					+"		)																							"
					+"select member_no, member_id, member_name, member_photo, member_distance							"
					+"from around_people																				"
					+"where member_distance < 5																			"
					+"order by member_distance asc";
		
		Connection conn = ConnectionUtil.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setDouble(1, memberLat);
		pstmt.setDouble(2, memberLng);
		pstmt.setInt(3, memberNo);
		pstmt.setInt(4, memberNo);
		pstmt.setInt(5, memberNo);
		pstmt.setInt(6, memberNo);
		pstmt.setInt(7, memberNo);
		ResultSet rs = pstmt.executeQuery();
		
		
		ArrayList<MemberVO> memberList = new ArrayList<>();
		while (rs.next()) {
			MemberVO member = new MemberVO();
			member.setMemberNo(rs.getInt("member_no"));
			member.setMemberId(rs.getString("member_id"));
			member.setMemberName(rs.getString("member_name"));
			member.setMemberPhoto(rs.getString("member_photo"));
			member.setMemberDistance(rs.getDouble("member_distance"));
			memberList.add(member);
		}

		rs.close();
		pstmt.close();
		conn.close();
		
		return memberList;
	}
	
	// 내 주변의 회원 조회하기(5km 이내)
	@SuppressWarnings("unchecked")
	public JSONArray getAroundPeopleJson(double memberLat, double memberLng, int memberNo) throws Exception {
		
		String sql = "with																							"
				+"	around_people as(																				"
				+"			select member_no, member_lat, member_lng, member_id, member_name, member_photo, 		"
				+"				   DISTANCE_MINI(member_lat, member_lng, ?, ?) as member_distance					"
				+"			from tb_member																			"
				+"			where member_no <> ?																	"
				+"			and member_no not in ((select member_no 												"
				+"									from tb_friend 													"
				+"									where (member_no = ?											"
				+"										or friend_no = ?))											"
				+"									union															"
				+"									(select friend_no 												"
				+"									from tb_friend 													"
				+"									where (member_no = ?											"
				+"										or friend_no = ?)))											"
				+"		)																							"
				+"select member_no, member_lat, member_lng, member_id, member_name, member_photo, member_distance	"
				+"from around_people																				"
				+"where member_distance < 5																			"
				+"order by member_distance asc";
		
		Connection conn = ConnectionUtil.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setDouble(1, memberLat);
		pstmt.setDouble(2, memberLng);
		pstmt.setInt(3, memberNo);
		pstmt.setInt(4, memberNo);
		pstmt.setInt(5, memberNo);
		pstmt.setInt(6, memberNo);
		pstmt.setInt(7, memberNo);
		ResultSet rs = pstmt.executeQuery();
		
		JSONArray people = new JSONArray();
		while (rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("memberNo", rs.getInt("member_no"));
			obj.put("memberLat", rs.getString("member_lat"));
			obj.put("memberLng", rs.getString("member_lng"));
			obj.put("memberId", rs.getString("member_id"));
			obj.put("memberName", rs.getString("member_name"));
			obj.put("memberPhoto", rs.getString("member_photo"));
			obj.put("memberDistance", rs.getDouble("member_distance"));
			people.add(obj);
			
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return people;
	}
	
	// 내 주변의 회원 상세조회
	public MemberVO getAroundPerson(int memberNo) throws Exception {
		
		String sql = "select member_no, member_id, member_name, member_photo, member_addr, member_lat, member_lng		"
					+"from tb_member																		"
					+"where member_no = ?";
		
		Connection conn = ConnectionUtil.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberNo);
		ResultSet rs = pstmt.executeQuery();
		
		MemberVO member = new MemberVO();
		if (rs.next()) {
			member.setMemberNo(rs.getInt("member_no"));
			member.setMemberId(rs.getString("member_id"));
			member.setMemberName(rs.getString("member_name"));
			member.setMemberPhoto(rs.getString("member_photo"));
			member.setMemberAddr(rs.getString("member_addr"));
			member.setMemberLat(rs.getDouble("member_lat"));
			member.setMemberLng(rs.getDouble("member_lng"));
		}

		rs.close();
		pstmt.close();
		conn.close();
		
		return member;
	}
	
	
}