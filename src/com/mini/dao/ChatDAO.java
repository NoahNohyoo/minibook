package com.mini.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.mini.util.ConnectionUtil;
import com.mini.vo.ChatVO;
import com.mini.vo.MemberVO;


public class ChatDAO {
	
	// 기존 채팅 데이터 가져오기
	@SuppressWarnings("unchecked")
	public JSONArray getText(int chatNo, String memId) throws Exception {
			
		String sql = "select d.chat_no																			"
					+"		, (select member_id from tb_member where member_no = d.member_no) as member_id		"
					+"		, d.chat_text, m.chat_entrance														"
					+"		,to_char(d.chat_regdate,'yyyy-mm-dd') as chat_regdate								"					
					+"		,to_char(d.chat_regdate,'hh:mi') as chat_regtime									"
					+"		,to_char(d.chat_regdate,'am') as chat_regampm										"
					+"		,to_char(d.chat_regdate,'day') as chat_regday										"
					+"		,(select member_photo from tb_member where member_no = d.member_no) as member_photo	"
					+"from tb_chat_data d, tb_chat_room r, tb_chat_member m										"
					+"where d.CHAT_NO = r.chat_no																"
					+"and r.chat_no = m.chat_no																	"
					+"and d.chat_regdate > m.chat_ENTRANCE														"
					+"and r.chat_no = ?																			"
					+"and m.member_no = (select member_no from tb_member where member_id = ?)					"											
					+"order by d.chat_regdate asc";

		Connection conn = ConnectionUtil.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, chatNo);
		pstmt.setString(2, memId);
		ResultSet rs = pstmt.executeQuery();
		
		JSONArray dataList = new JSONArray();
		while (rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("chatNo", rs.getInt("chat_no"));
			obj.put("memberId", rs.getString("member_id"));
			obj.put("chatText", rs.getString("chat_text"));
			obj.put("chatRegdate", rs.getString("chat_regdate"));
			obj.put("chatRegtime", rs.getString("chat_regtime"));
			obj.put("chatRegampm", rs.getString("chat_regampm"));
			obj.put("chatRegday", rs.getString("chat_regday"));
			obj.put("memberPhoto", rs.getString("member_photo"));
			dataList.add(obj);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return dataList;
		
	}
	
	// 채팅 데이터 저장하기
	public void saveText(int chatNo, String memId, String chatText) throws Exception {
		
		String sql = "insert into TB_CHAT_DATA(chat_no, member_no, chat_text)	"
					+"values(?, (select member_no from tb_member where member_id = ?), ?)";
		
		
		Connection conn = ConnectionUtil.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, chatNo);
		pstmt.setString(2, memId);
		pstmt.setString(3, chatText);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
	}
	
	// 새로운 채팅 생성
	public void createNewChat(String memId, String chatTitle) throws Exception {
		
		String sql1 = "insert into tb_chat_room(chat_no, chat_title)	"
					 +"values(seq_chat_no.nextval, ?)";
		
		Connection conn = ConnectionUtil.getConnection();
		PreparedStatement pstmt1 = conn.prepareStatement(sql1);
		pstmt1.setString(1, chatTitle);
		pstmt1.executeUpdate();
		
		
		String sql2 = "insert into tb_chat_member(chat_no, member_no)									 "
					 +"values(seq_chat_no.currval, (select member_no from tb_member where member_id = ?))";
		
		PreparedStatement pstmt2 = conn.prepareStatement(sql2);
		pstmt2.setString(1, memId);
		pstmt2.executeUpdate();
		
		pstmt1.close();
		pstmt2.close();
		conn.close();
		
	}
	
	// 생성한 채팅방 번호 가져오기
	public int getNewChatNo(String memId) throws Exception {
		
		String sql = "select max(chat_no) as chat_no										"	
					+"from tb_chat_member													"
					+"where member_no = (select member_no from tb_member where member_id = ?)";
		
		Connection conn = ConnectionUtil.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, memId);
		ResultSet rs = pstmt.executeQuery();
		
		int result = 0;
		if (rs.next()) {
			result = rs.getInt("chat_no");
		}

		rs.close();
		pstmt.close();
		conn.close();
		
		return result;
	}
	
	// 해당 채팅방 나가기 처리
	public void outChat(int chatNo, String memId) throws Exception {
		
		String sql = "delete from tb_chat_member											"
					+"where chat_no = ?														"
					+"and member_no = (select member_no from tb_member where member_id = ?)";
		
		Connection conn = ConnectionUtil.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, chatNo);
		pstmt.setString(2, memId);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
		
	}
	
	// 내가 참여중인 채팅목록 가져오기
	public ArrayList<ChatVO> loadChatList(String memId) throws Exception {
		
		String sql = "select r.chat_no, r.chat_title											"
					+"from tb_chat_member m, tb_chat_room r										"
					+"where m.chat_no = r.chat_no												"
					+"and m.member_no = (select member_no from tb_member where member_id = ?)	"			
					+"order by r.chat_no desc";

		Connection conn = ConnectionUtil.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, memId);
		ResultSet rs = pstmt.executeQuery();
		
		ArrayList<ChatVO> chatList = new ArrayList<>();
		while (rs.next()) {
			ChatVO chat = new ChatVO();
			chat.setChatNo(rs.getInt("chat_no"));
			chat.setChatTitle(rs.getString("chat_title"));
			chatList.add(chat);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return chatList;
	}
	
	// 채팅방에서 친구 초대하기
	public void inviteChat(int chatNo, String friend) throws Exception {
		
		String sql = "insert into tb_chat_member(chat_no, member_no)				  "
					+"values(?, (select member_no from tb_member where member_id = ?))";
		
		Connection conn = ConnectionUtil.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, chatNo);
		pstmt.setString(2, friend);
		pstmt.executeUpdate();
		
		pstmt.close();
		conn.close();
		
	}
	
	// 채팅창에서 초대 가능한 친구목록 가져오기
	@SuppressWarnings("unchecked")
	public JSONArray loadFriends(int memberNo, int chatNo) throws Exception {
		
		String sql = "with																										"
					+"	friends as (																							"
					+"				(select distinct(f.friend_no)																"
					+"					, (select member_id from tb_member where member_no = f.friend_no) as friend_id			"
					+"					, (select member_name from tb_member where member_no = f.friend_no) as friend_name		"
					+"				from tb_friend f																			"
					+"				where (f.member_no = ? or f.friend_no = ?)													"
					+"				and f.friend_agree = 'Y'																	"
					+"				and (f.friend_no not in(select member_no from tb_chat_member where chat_no = ?)				"
					+"					or f.member_no not in(select member_no from tb_chat_member where chat_no = ?)))			"
					+"				union																						"
					+"				(select distinct(f.member_no) as friend_no													"
					+"					, (select member_id from tb_member where member_no = f.member_no) as friend_id			"
					+"					, (select member_name from tb_member where member_no = f.member_no) as friend_name		"
					+"				from tb_friend f																			"
					+"				where (f.member_no = ? or f.friend_no = ?)													"
					+"				and f.friend_agree = 'Y'																	"
					+"				and (f.friend_no not in(select member_no from tb_chat_member where chat_no = ?)				"
					+"					or f.member_no not in(select member_no from tb_chat_member where chat_no = ?)))			"
					+"		)																									"
					+"select friend_no, friend_id, friend_name																	"
					+"from friends																								"
					+"where friend_no <> ?																						"
					+"order by friend_id asc";

		Connection conn = ConnectionUtil.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, memberNo);
		pstmt.setInt(2, memberNo);
		pstmt.setInt(3, chatNo);
		pstmt.setInt(4, chatNo);
		pstmt.setInt(5, memberNo);
		pstmt.setInt(6, memberNo);
		pstmt.setInt(7, chatNo);
		pstmt.setInt(8, chatNo);
		pstmt.setInt(9, memberNo);
		ResultSet rs = pstmt.executeQuery();
		
		
		JSONArray friends = new JSONArray();
		while (rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("friendId", rs.getString("friend_id"));
			obj.put("friendName", rs.getString("friend_name"));
			friends.add(obj);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return friends;
	}
	
	// 채팅창 멤버 가져오기
	@SuppressWarnings("unchecked")
	public JSONArray loadChatMembers(int chatNo) throws Exception {
		
		String sql = "select member_no, member_id, member_name, member_photo	"
					+"from tb_member											"
					+"where member_no in (select member_no						"
					+"					from tb_chat_member						"
					+"					where chat_no = ?)";
		
		Connection conn = ConnectionUtil.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, chatNo);
		ResultSet rs = pstmt.executeQuery();
		
		
		JSONArray members = new JSONArray();
		while (rs.next()) {
			JSONObject obj = new JSONObject();
			obj.put("memberNo", rs.getInt("member_no"));
			obj.put("memberId", rs.getString("member_id"));
			obj.put("memberName", rs.getString("member_name"));
			obj.put("memberPhoto", rs.getString("member_photo"));
			members.add(obj);
		}
		
		rs.close();
		pstmt.close();
		conn.close();
		
		return members;
	}
	
}