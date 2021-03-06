package com.mini.dao;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.mini.util.ConnectionUtil;
import com.mini.vo.MemberVO;

import com.mini.vo.BoardVO;

public class BoardDAO {
	public ArrayList<BoardVO> getBoardListForPaging(int begin, int end, int member_no) throws Exception {
		ArrayList<BoardVO> boards = new ArrayList<>();
		String sql = " SELECT BOARD_NO, BOARD_FILE, BOARD_TAG, "
				+ " BOARD_CONTENT, BOARD_LIKE_CNT, BOARD_LEVEL, "
				+ " BOARD_REGDATE, MEMBER_NO "
				+ "	FROM ( "
				+ "			SELECT ROW_NUMBER() OVER (ORDER BY BOARD_NO DESC) RN, BOARD_NO, BOARD_FILE, BOARD_TAG, BOARD_CONTENT, BOARD_LIKE_CNT, BOARD_LEVEL, BOARD_REGDATE, MEMBER_NO "
				+ "			FROM TB_BOARD "
				+ "			WHERE MEMBER_NO = ?) "
				+ " WHERE RN>= ? AND RN <= ? ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, member_no);
		pstmt.setInt(2, begin);
		pstmt.setInt(3, end);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			BoardVO board = new BoardVO();
			board.setBoard_no(rs.getInt("BOARD_NO"));
			board.setBoard_file(rs.getString("BOARD_FILE"));
			board.setBoard_tag(rs.getString("BOARD_TAG"));
			board.setBoard_content(rs.getString("BOARD_CONTENT"));
			board.setBoard_like_cnt(rs.getInt("BOARD_LIKE_CNT"));
			board.setBoard_level(rs.getInt("BOARD_LEVEL"));
			board.setBoard_regdate(rs.getDate("BOARD_REGDATE"));
			board.setMember_no(rs.getInt("MEMBER_NO"));
			boards.add(board);	
		}
		rs.close();
		pstmt.close();
		con.close();
		
		return boards;
	}
	public int getSearchBoardRows(String keyword) throws Exception {
		int totalRows = 0;
		String sql = " SELECT COUNT(*) CNT "
				+ " FROM TB_BOARD "
				+ " WHERE BOARD_LEVEL = 0 "
				+ " AND BOARD_CONTENT LIKE '%' || ? || '%' "
				+ " OR BOARD_TAG LIKE '%' || ? || '%' ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, keyword);
		pstmt.setString(2, keyword);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			totalRows = rs.getInt("CNT");
		}
		rs.close();
		pstmt.close();
		con.close();
		
		return totalRows;
	}
	
	public int getAllBoardRows(int no) throws Exception {
		int totalRows = 0;
		String sql = "SELECT COUNT(*) CNT "
				+ " FROM TB_BOARD "
				+ " WHERE BOARD_LEVEL = 0 ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			totalRows = rs.getInt("CNT");
		}
		rs.close();
		pstmt.close();
		con.close();
		
		return totalRows;
	}
	
	public int getMeBoardRows(int no) throws Exception {
		int totalRows = 0;
		String sql = " SELECT COUNT(*) CNT "
					+ "	FROM TB_BOARD "
					+ "	WHERE MEMBER_NO IN ( SELECT DISTINCT FRIEND_NO "
					+ "						FROM TB_FRIEND "
					+ "						WHERE MEMBER_NO = ? "
					+ "						OR FRIEND_NO = ? ) "
					+ " AND BOARD_LEVEL = 0 ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, no);
		pstmt.setInt(2, no);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			totalRows = rs.getInt("CNT");
		}
		rs.close();
		pstmt.close();
		con.close();
		
		return totalRows;
	}
	
	public int getSubsBoardRows(int no) throws Exception {
		int totalRows = 0;
		String sql = " SELECT COUNT(*) CNT "
				+ " FROM TB_BOARD "
				+ " WHERE BOARD_NO IN (SELECT BOARD_NO "
				+ "						FROM TB_FAVORITE "
				+ "						WHERE MEMBER_NO = ?) ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, no);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			totalRows = rs.getInt("CNT");
		}
		rs.close();
		pstmt.close();
		con.close();
		
		return totalRows;
	}
	
	public void updateNewBoard(BoardVO board) throws Exception {
		String sql = " INSERT INTO TB_BOARD "
				+ " (BOARD_NO, BOARD_FILE, BOARD_TAG, BOARD_CONTENT, "
				+ " MEMBER_NO) "
				+ " VALUES(SEQ_BOARD_NO.NEXTVAL, ?, ?, ?, ?) ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, board.getBoard_file());
		pstmt.setString(2, board.getBoard_tag());
		pstmt.setString(3, board.getBoard_content());
		pstmt.setInt(4, board.getMember_no());	
		pstmt.executeUpdate();		
		
		pstmt.close();
		con.close();
	}
	
	public ArrayList<BoardVO> findBoardsOnSearch(int begin, int end, String keyword) throws Exception {
		ArrayList<BoardVO> boards = new ArrayList<>();
		String sql = " SELECT RM, BOARD_NO, BOARD_FILE, BOARD_TAG, BOARD_CONTENT, "
				+ " 		  BOARD_LIKE_CNT, BOARD_LEVEL, BOARD_REGDATE, MEMBER_NO, "
				+ "			  MEMBER_NAME, MEMBER_PHOTO "
				+ " FROM ( SELECT ROW_NUMBER() OVER (ORDER BY A.BOARD_NO DESC) RM, A.BOARD_NO BOARD_NO, "
				+ " 			  A.BOARD_FILE BOARD_FILE, A.BOARD_TAG BOARD_TAG, A.BOARD_CONTENT BOARD_CONTENT, "
				+ " 			  A.BOARD_LIKE_CNT BOARD_LIKE_CNT, A.BOARD_LEVEL BOARD_LEVEL, A.BOARD_REGDATE BOARD_REGDATE, "
				+ " 		 	  B.MEMBER_NO MEMBER_NO, B.MEMBER_NAME MEMBER_NAME, B.MEMBER_PHOTO MEMBER_PHOTO "
				+ " 		FROM TB_BOARD A, TB_MEMBER B "
				+ "			WHERE A.MEMBER_NO = B.MEMBER_NO "
				+ " 		AND BOARD_LEVEL = 0 "
				+ "  		AND (BOARD_CONTENT LIKE '%' || ? || '%'  OR BOARD_TAG LIKE '%' || ? || '%' ) ) "
				+ " WHERE RM >= ? AND RM <= ? ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, keyword);
		pstmt.setString(2, keyword);
		pstmt.setInt(3, begin);
		pstmt.setInt(4, end);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			BoardVO board = new BoardVO();
			board.setBoard_no(rs.getInt("BOARD_NO"));
			board.setBoard_file(rs.getString("BOARD_FILE"));
			board.setBoard_tag(rs.getString("BOARD_TAG"));
			board.setBoard_content(rs.getString("BOARD_CONTENT"));
			board.setBoard_like_cnt(rs.getInt("BOARD_LIKE_CNT"));
			board.setBoard_level(rs.getInt("BOARD_LEVEL"));
			board.setBoard_regdate(rs.getDate("BOARD_REGDATE"));
			board.setMember_no(rs.getInt("MEMBER_NO"));
			board.setMember_name(rs.getString("MEMBER_NAME"));
			board.setMember_photo(rs.getString("MEMBER_PHOTO"));
			boards.add(board);
		}
		rs.close();
		pstmt.close();
		con.close();
		
		return boards;
	}
	
	public ArrayList<BoardVO> findBoardsOnMe(int begin, int end, MemberVO member) throws Exception {
		ArrayList<BoardVO> boards = new ArrayList<>();
		String sql = "SELECT RM, BOARD_NO, BOARD_FILE, BOARD_TAG, "
				+ " BOARD_CONTENT, BOARD_LIKE_CNT, BOARD_LEVEL, "
				+ " BOARD_REGDATE, MEMBER_NO, MEMBER_NAME, MEMBER_PHOTO "
				+ " FROM (SELECT ROW_NUMBER() OVER(ORDER BY A.BOARD_NO DESC) RM, "
				+ " 		A.BOARD_NO BOARD_NO, A.BOARD_FILE BOARD_FILE, A.BOARD_TAG BOARD_TAG, "
				+ " 		A.BOARD_CONTENT BOARD_CONTENT, A.BOARD_LIKE_CNT BOARD_LIKE_CNT, "
				+ " 		A.BOARD_LEVEL BOARD_LEVEL, A.BOARD_REGDATE BOARD_REGDATE, A.MEMBER_NO MEMBER_NO, "
				+ " 		B.MEMBER_NAME MEMBER_NAME, B.MEMBER_PHOTO MEMBER_PHOTO "
				+ " 		FROM TB_BOARD A, TB_MEMBER B "
				+ " 		WHERE A.MEMBER_NO = B.MEMBER_NO "
				+ "			AND A.BOARD_LEVEL = 0 "
				+ "			AND (A.MEMBER_NO IN (( SELECT FRIEND_NO "
				+ "									FROM TB_FRIEND "
				+ "									WHERE MEMBER_NO= ? "
				+ "									AND FRIEND_AGREE = 'Y')) "
				+ "			OR A.MEMBER_NO = ?)) "
				+ "	WHERE RM >= ? AND RM <= ? ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, member.getMemberNo());
		pstmt.setInt(2, member.getMemberNo());
		pstmt.setInt(3, begin);
		pstmt.setInt(4, end);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			BoardVO board = new BoardVO();
			board.setBoard_no(rs.getInt("BOARD_NO"));
			board.setBoard_file(rs.getString("BOARD_FILE"));
			board.setBoard_tag(rs.getString("BOARD_TAG"));
			board.setBoard_content(rs.getString("BOARD_CONTENT"));
			board.setBoard_like_cnt(rs.getInt("BOARD_LIKE_CNT"));
			board.setBoard_level(rs.getInt("BOARD_LEVEL"));
			board.setBoard_regdate(rs.getDate("BOARD_REGDATE"));
			board.setMember_no(rs.getInt("MEMBER_NO"));
			board.setMember_name(rs.getString("MEMBER_NAME"));
			board.setMember_photo(rs.getString("MEMBER_PHOTO"));
			boards.add(board);
		}
		rs.close();
		pstmt.close();
		con.close();
		return boards;
	}
	
	public ArrayList<BoardVO> findMySubscribedBoards(int begin, int end, MemberVO member) throws Exception {
		ArrayList<BoardVO> boards = new ArrayList<>();
		String sql = " SELECT RM, BOARD_NO, BOARD_FILE, BOARD_TAG, BOARD_CONTENT, BOARD_LIKE_CNT, "
				+ " BOARD_LEVEL, BOARD_REGDATE, MEMBER_NO, MEMBER_NAME, MEMBER_PHOTO "
				+ " FROM ( SELECT ROW_NUMBER() OVER (ORDER BY A.BOARD_NO DESC) RM, "
				+ "			A.BOARD_NO BOARD_NO, A.BOARD_FILE BOARD_FILE, "
				+ "			A.BOARD_TAG BOARD_TAG, A.BOARD_CONTENT BOARD_CONTENT, "
				+ "			A.BOARD_LIKE_CNT BOARD_LIKE_CNT, A.BOARD_LEVEL BOARD_LEVEL, "
				+ "			A.BOARD_REGDATE BOARD_REGDATE, A.MEMBER_NO MEMBER_NO, "
				+ "			B.MEMBER_NAME MEMBER_NAME, B.MEMBER_PHOTO MEMBER_PHOTO "
				+ "			FROM TB_BOARD A, TB_MEMBER B "
				+ "			WHERE A.MEMBER_NO = B.MEMBER_NO "
				+ "			AND A.BOARD_NO IN (SELECT BOARD_NO "
				+ "								FROM TB_FAVORITE "
				+ "								WHERE MEMBER_NO = ? )) "
				+ " WHERE RM >= ? AND RM <= ? ";

		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, member.getMemberNo());
		pstmt.setInt(2, begin);
		pstmt.setInt(3, end);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			BoardVO board = new BoardVO();
			board.setBoard_no(rs.getInt("BOARD_NO"));
			board.setBoard_file(rs.getString("BOARD_FILE"));
			board.setBoard_tag(rs.getString("BOARD_TAG"));
			board.setBoard_content(rs.getString("BOARD_CONTENT"));
			board.setBoard_like_cnt(rs.getInt("BOARD_LIKE_CNT"));
			board.setBoard_level(rs.getInt("BOARD_LEVEL"));
			board.setBoard_regdate(rs.getDate("BOARD_REGDATE"));
			board.setMember_no(rs.getInt("MEMBER_NO"));
			board.setMember_name(rs.getString("MEMBER_NAME"));
			board.setMember_photo(rs.getString("MEMBER_PHOTO"));
			boards.add(board);
		}
		rs.close();
		pstmt.close();
		con.close();
		return boards;
	}
	/*
	public ArrayList<BoardVO> findBoardsOnMe(MemberVO member) throws Exception {
		ArrayList<BoardVO> boards = new ArrayList<>();
		String sql = " SELECT BOARD_NO, BOARD_FILE, "
				+ " BOARD_TAG, BOARD_CONTENT, "
				+ " BOARD_LIKE_CNT, BOARD_LEVEL, "
				+ " BOARD_REGDATE, MEMBER_NO "
				+ " FROM TB_BOARD "
				+ " WHERE MEMBER_NO = ? "
				+ " AND BOARD_LEVEL = 0 "
				+ " ORDER BY BOARD_NO DESC ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, member.getMemberNo());
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			BoardVO board = new BoardVO();
			board.setBoard_no(rs.getInt("BOARD_NO"));
			board.setBoard_file(rs.getString("BOARD_FILE"));
			board.setBoard_tag(rs.getString("BOARD_TAG"));
			board.setBoard_content(rs.getString("BOARD_CONTENT"));
			board.setBoard_like_cnt(rs.getInt("BOARD_LIKE_CNT"));
			board.setBoard_level(rs.getInt("BOARD_LEVEL"));
			board.setBoard_regdate(rs.getDate("BOARD_REGDATE"));
			board.setMember_no(rs.getInt("MEMBER_NO"));
			boards.add(board);
		}
		rs.close();
		pstmt.close();
		con.close();
		return boards;
	}
	/*
	 	public ArrayList<BoardVO> findAllBoards(MemberVO member) throws Exception {
		ArrayList<BoardVO> boards = new ArrayList<>();
		String sql = " SELECT A.BOARD_NO BOARD_NO, A.BOARD_FILE BOARD_FILE, A.BOARD_TAG BOARD_TAG, A.BOARD_CONTENT BOARD_CONTENT, A.BOARD_LIKE_CNT BOARD_LIKE_CNT, A.BOARD_LEVEL BOARD_LEVEL, A.BOARD_REGDATE BOARD_REGDATE, A.MEMBER_NO MEMBER_NO, B.MEMBER_NAME MEMBER_NAME, B.MEMBER_PHOTO MEMBER_PHOTO  "
				+ "FROM TB_BOARD A, TB_MEMBER B, (SELECT COUNT(*) FROM TB_LIKE A, TB_BOARD B WHERE A.BOARD_NO = B.BOARD_NO ) "
				+ " WHERE A.MEMBER_NO = B.MEMBER_NO "
				+ " AND A.BOARD_LEVEL = 0 "
				+ " AND (A.MEMBER_NO IN ((SELECT FRIEND_NO FROM TB_FRIEND WHERE MEMBER_NO= ? AND FRIEND_AGREE = 'Y')) "
				+ " OR A.MEMBER_NO = ?) "
				+ " ORDER BY A.BOARD_NO DESC ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, member.getMemberNo());
		pstmt.setInt(2, member.getMemberNo());
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			BoardVO board = new BoardVO();
			board.setBoard_no(rs.getInt("BOARD_NO"));
			board.setBoard_file(rs.getString("BOARD_FILE"));
			board.setBoard_tag(rs.getString("BOARD_TAG"));
			board.setBoard_content(rs.getString("BOARD_CONTENT"));
			board.setBoard_like_cnt(rs.getInt("BOARD_LIKE_CNT"));
			board.setBoard_level(rs.getInt("BOARD_LEVEL"));
			board.setBoard_regdate(rs.getDate("BOARD_REGDATE"));
			board.setMember_no(rs.getInt("MEMBER_NO"));
			board.setMember_name(rs.getString("MEMBER_NAME"));
			board.setMember_photo(rs.getString("MEMBER_PHOTO"));
			boards.add(board);
		}
		rs.close();
		pstmt.close();
		con.close();
		return boards;
	}
	 
	 */
	public ArrayList<BoardVO> findAllBoards(int begin, int end, MemberVO member) throws Exception {
		ArrayList<BoardVO> boards = new ArrayList<>();
		String sql = " SELECT BOARD_NO, BOARD_FILE, BOARD_TAG, BOARD_CONTENT, BOARD_LIKE_CNT, BOARD_LEVEL, BOARD_REGDATE, MEMBER_NO, MEMBER_NAME, MEMBER_PHOTO "
				+ " FROM (SELECT ROW_NUMBER() OVER (ORDER BY A.BOARD_NO DESC) RN, A.BOARD_NO BOARD_NO, A.BOARD_FILE BOARD_FILE, A.BOARD_TAG BOARD_TAG, A.BOARD_CONTENT BOARD_CONTENT, A.BOARD_LIKE_CNT BOARD_LIKE_CNT, A.BOARD_LEVEL BOARD_LEVEL, A.BOARD_REGDATE BOARD_REGDATE, A.MEMBER_NO MEMBER_NO, B.MEMBER_NAME MEMBER_NAME, B.MEMBER_PHOTO MEMBER_PHOTO "
				+ " FROM TB_BOARD A, TB_MEMBER B, (SELECT COUNT(*) "
				+ " FROM TB_LIKE A, TB_BOARD B "
				+ " WHERE A.BOARD_NO = B.BOARD_NO ) "
				+ " WHERE A.MEMBER_NO = B.MEMBER_NO "
				+ "	AND A.BOARD_LEVEL = 0) "
				+ " WHERE RN >= ? AND RN <= ? ";

		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, begin);
		pstmt.setInt(2, end);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			BoardVO board = new BoardVO();
			board.setBoard_no(rs.getInt("BOARD_NO"));
			board.setBoard_file(rs.getString("BOARD_FILE"));
			board.setBoard_tag(rs.getString("BOARD_TAG"));
			board.setBoard_content(rs.getString("BOARD_CONTENT"));
			board.setBoard_like_cnt(rs.getInt("BOARD_LIKE_CNT"));
			board.setBoard_level(rs.getInt("BOARD_LEVEL"));
			board.setBoard_regdate(rs.getDate("BOARD_REGDATE"));
			board.setMember_no(rs.getInt("MEMBER_NO"));
			board.setMember_name(rs.getString("MEMBER_NAME"));
			board.setMember_photo(rs.getString("MEMBER_PHOTO"));
			boards.add(board);
		}
		rs.close();
		pstmt.close();
		con.close();
		return boards;
	}
	
	// ??????, ??????????????, ????, ????, ???? ?????? ????
	public void deleteBoardByNo(int bno) throws Exception {
		// ???? ?????? ??????
		Connection con = ConnectionUtil.getConnection();
		
		String sql1 = " DELETE FROM TB_LIKE WHERE BOARD_NO = ? ";
		PreparedStatement pstmt = con.prepareStatement(sql1);
		pstmt.setInt(1, bno);
		pstmt.executeUpdate();
		pstmt.close();
		
		// ???? ?????????????? ??????
		String sql2 = " DELETE FROM TB_FAVORITE WHERE BOARD_NO = ? ";
		pstmt = con.prepareStatement(sql2);
		pstmt.setInt(1, bno);
		pstmt.executeUpdate();
		pstmt.close();
		
		// ???? ??????(+?????? ?????? ??????)
		String sql3 = " SELECT BOARD_NO FROM TB_BOARD WHERE BOARD_LEVEL = ? ";
		pstmt = con.prepareStatement(sql3);
		pstmt.setInt(1, bno);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			deleteCommentByNo(rs.getInt("BOARD_NO"));
		}
		rs.close();
		pstmt.close();
		
		// ???? ??????
		String fileSql = " SELECT BOARD_FILE FROM TB_BOARD WHERE BOARD_NO = ? ";
		pstmt = con.prepareStatement(fileSql);
		pstmt.setInt(1, bno);
		ResultSet rs2 = pstmt.executeQuery();
		if (rs2.next()) {
			if ("".equals(rs2.getString("BOARD_FILE"))) {
				File file = new File("C:\\Users\\JHTA\\workspace\\mini\\WebContent\\img\\board_img\\"+rs.getString("BOARD_FILE"));
				file.delete();				
			}
		}
		rs2.close();
		pstmt.close();
		
		// ???? ??????
		String sql4 = " DELETE FROM TB_BOARD WHERE BOARD_NO = ? ";
		pstmt = con.prepareStatement(sql4);
		pstmt.setInt(1, bno);
		pstmt.executeUpdate();		
		
		rs.close();
		pstmt.close();
		con.close();
	}
	
	// ??????, ???? ?????? ????
	public void deleteCommentByNo(int cno) throws Exception {
		deleteLikes(cno);
		String sql = " DELETE FROM TB_BOARD WHERE BOARD_NO = ? ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, cno);
		pstmt.executeUpdate();

		pstmt.close();
		con.close();
	}
	
	public void deleteLikes(int board_no) throws Exception {
		String sql = " DELETE FROM TB_LIKE WHERE BOARD_NO = ? ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, board_no);
		pstmt.executeUpdate();
		
		pstmt.close();
		con.close();
	}
	
	public BoardVO callBoardforEdit(int bno) throws Exception {
		BoardVO board = null;
		String sql = " SELECT A.BOARD_NO BOARD_NO, A.BOARD_FILE BOARD_FILE, A.BOARD_TAG BOARD_TAG, A.BOARD_CONTENT BOARD_CONTENT, A.BOARD_LIKE_CNT BOARD_LIKE_CNT, A.BOARD_LEVEL BOARD_LEVEL, A.BOARD_REGDATE BOARD_REGDATE, A.MEMBER_NO MEMBER_NO, B.MEMBER_NAME MEMBER_NAME, B.MEMBER_PHOTO MEMBER_PHOTO "  
					+ " FROM TB_BOARD A, TB_MEMBER B "
					+ " WHERE A.MEMBER_NO = B.MEMBER_NO " 
					+ " AND A.BOARD_NO = ? ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, bno);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			board = new BoardVO();
			board.setBoard_no(rs.getInt("BOARD_NO"));
			board.setBoard_content(rs.getString("BOARD_CONTENT"));
			board.setBoard_like_cnt(rs.getInt("BOARD_LIKE_CNT"));
			board.setBoard_level(rs.getInt("BOARD_LEVEL"));
			board.setBoard_tag(rs.getString("BOARD_TAG"));
			board.setBoard_regdate(rs.getDate("BOARD_REGDATE"));
			board.setMember_no(rs.getInt("MEMBER_NO"));
			board.setMember_name(rs.getString("MEMBER_NAME"));
			board.setMember_photo(rs.getString("MEMBER_PHOTO"));
		}
		
		return board;
	}
	
	public void updateEditedBoard(BoardVO board) throws Exception {
		BoardVO oldBoard = callBoardByNo(board.getBoard_no());
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt;
		String sql;
		
		//???? ???? ?? ????
		if (board.getBoard_content() == null) {
			board.setBoard_content("");
		}
		if (oldBoard.getBoard_content() == null) {
			oldBoard.setBoard_content("");
		}	
		if (!oldBoard.getBoard_content().equals(board.getBoard_content())) {
			sql = " UPDATE TB_BOARD "
					+ " SET BOARD_CONTENT = ? "
					+ " WHERE BOARD_NO = ? ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, board.getBoard_content());
			pstmt.setInt(2, board.getBoard_no());
			pstmt.executeQuery();
			pstmt.close();
		}
		
		
		//???? ???? ?? ????
		if (board.getBoard_tag() == null) {
			board.setBoard_tag("");
		}
		if (oldBoard.getBoard_tag() == null) {
			oldBoard.setBoard_tag("");
		}	
		
		if (!oldBoard.getBoard_tag().equals(board.getBoard_tag())) {
			sql = " UPDATE TB_BOARD "
					+ " SET BOARD_TAG = ? "
					+ " WHERE BOARD_NO = ? ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, board.getBoard_tag());
			pstmt.setInt(2, board.getBoard_no());	
			pstmt.executeQuery();
			pstmt.close();
		}

		
		//???? ???? ?? ????, ???? ?????? ?????????? ???? ???? ????, ???? ?????? ?????? ?????? ?????? ???????? ??????
		if (board.getBoard_file() == null) {
			board.setBoard_file("");
		}
		if (oldBoard.getBoard_file() == null) {
			oldBoard.setBoard_file("");
		}
		
		if ("".equals(board.getBoard_file())) {
			
		} else {
			if (!oldBoard.getBoard_file().equals(board.getBoard_file())) {
				File file = new File("C:\\Users\\JHTA\\workspace\\mini\\WebContent\\img\\board_img\\"+oldBoard.getBoard_file());
				file.delete();				
				sql = " UPDATE TB_BOARD "
						+ " SET BOARD_FILE = ? "
						+ " WHERE BOARD_NO = ? ";		
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, board.getBoard_file());
				pstmt.setInt(2, board.getBoard_no());	
				pstmt.executeQuery();
				pstmt.close();
			}			
		}
		
		
		con.close();
	}
	
	public BoardVO callBoardByNo(int no) throws Exception {
		BoardVO board = null;
		String sql = " SELECT BOARD_CONTENT, BOARD_FILE, BOARD_TAG FROM TB_BOARD WHERE BOARD_NO = ? ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, no);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			board = new BoardVO();
			board.setBoard_content(rs.getString("BOARD_CONTENT"));
			board.setBoard_file(rs.getString("BOARD_FILE"));
			board.setBoard_tag(rs.getString("BOARD_TAG"));
		}
		rs.close();
		pstmt.close();
		con.close();
		
		return board;
	}
	
	public boolean isAlreadyLike(int boardNo, int memberNo) throws Exception {
		boolean checking = false;
		String sql = " SELECT * FROM TB_LIKE WHERE MEMBER_NO = ? AND BOARD_NO = ? ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, memberNo);
		pstmt.setInt(2, boardNo);
		ResultSet rs = pstmt.executeQuery();
		
		if (rs.next()) {
			checking = true;
		}
		
		rs.close();
		pstmt.close();
		con.close();
		return checking;
	}
	
	
	public void likeBoard(int boardNo, int memberNo) throws Exception {
		String sql = " INSERT INTO TB_LIKE "
				+ " (BOARD_NO, MEMBER_NO) "
				+ " VALUES(?, ?) ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, boardNo);
		pstmt.setInt(2, memberNo);	
		pstmt.executeUpdate();		
		
		String sql2 = " UPDATE TB_BOARD SET BOARD_LIKE_CNT = BOARD_LIKE_CNT + 1 WHERE BOARD_NO = ? ";
		PreparedStatement pstmt2 = con.prepareStatement(sql2);
		pstmt2.setInt(1, boardNo);
		pstmt2.executeUpdate();
		
		pstmt2.close();		
		pstmt.close();
		con.close();
	}
	
	public void autoUpdateBoardWhenLike(BoardVO board) throws Exception {
		String sql = " INSERT INTO TB_BOARD(BOARD_NO, BOARD_CONTENT, BOARD_LEVEL, MEMBER_NO) VALUES(SEQ_BOARD_NO.NEXTVAL, ?, ?, ?) ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, board.getMember_name()+" likes it! :)");
		pstmt.setInt(2, board.getBoard_no());
		pstmt.setInt(3, board.getMember_no());
		pstmt.executeQuery();
		
		pstmt.close();
		con.close();
	}
	
	public boolean isAlreadySubscribed(int boardNo, int memberNo) throws Exception {
		boolean checking = false;
		String sql = " SELECT * FROM TB_FAVORITE WHERE MEMBER_NO = ? AND BOARD_NO = ? ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, memberNo);
		pstmt.setInt(2, boardNo);
		ResultSet rs = pstmt.executeQuery();
		
		if (rs.next()) {
			checking = true;
		}
		
		rs.close();
		pstmt.close();
		con.close();
		return checking;	
	}

	public void addBoardToSubscribe(int boardNo, int memberNo) throws Exception {
		String sql = " INSERT INTO TB_FAVORITE "
				+ " (BOARD_NO, MEMBER_NO) "
				+ " VALUES(?, ?) ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, boardNo);
		pstmt.setInt(2, memberNo);	
		pstmt.executeUpdate();		
			
		pstmt.close();
		con.close();
	}	
	
	public void removeBoardFromSubscribe(int boardNo, int memberNo) throws Exception {
		String sql = " DELETE FROM TB_FAVORITE "
				+ " WHERE BOARD_NO = ? AND MEMBER_NO = ? ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, boardNo);
		pstmt.setInt(2, memberNo);	
		pstmt.executeUpdate();	
			
		pstmt.close();
		con.close();
	}
	
	public void addNewComments(BoardVO board) throws Exception {
		String sql = " INSERT INTO TB_BOARD "
				+ " (BOARD_NO, BOARD_TAG, BOARD_CONTENT, "
				+ " MEMBER_NO, BOARD_LEVEL) "
				+ " VALUES(SEQ_BOARD_NO.NEXTVAL,  ?, ?, ?, ?) ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setString(1, board.getBoard_tag());
		pstmt.setString(2, board.getBoard_content());
		pstmt.setInt(3, board.getMember_no());	
		pstmt.setInt(4, board.getBoard_level());
		pstmt.executeUpdate();		
		
		pstmt.close();
		con.close();
	}
	
	public ArrayList<BoardVO> findCommentsByBoardNo(int no) throws Exception {
		ArrayList<BoardVO> boards = new ArrayList<>();
		String sql = " SELECT A.BOARD_NO BOARD_NO, A.BOARD_FILE BOARD_FILE, A.BOARD_TAG BOARD_TAG, B.MEMBER_PHOTO MEMBER_PHOTO, "
				+ " A.BOARD_CONTENT BOARD_CONTENT, A.BOARD_LIKE_CNT BOARD_LIKE_CNT, A.BOARD_LEVEL BOARD_LEVEL, "
				+ " A.BOARD_REGDATE BOARD_REGDATE, A.MEMBER_NO MEMBER_NO, B.MEMBER_NAME MEMBER_NAME "
				+ " FROM TB_BOARD A, TB_MEMBER B "
				+ " WHERE A.BOARD_LEVEL = ? "
				+ " AND A.MEMBER_NO = B.MEMBER_NO "
				+ " ORDER BY BOARD_NO ASC ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, no);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			BoardVO board = new BoardVO();
			board.setBoard_no(rs.getInt("BOARD_NO"));
			board.setBoard_content(rs.getString("BOARD_CONTENT"));
			board.setBoard_like_cnt(rs.getInt("BOARD_LIKE_CNT"));
			board.setBoard_level(rs.getInt("BOARD_LEVEL"));
			board.setBoard_regdate(rs.getDate("BOARD_REGDATE"));
			board.setMember_no(rs.getInt("MEMBER_NO"));
			board.setMember_name(rs.getString("MEMBER_NAME"));
			board.setMember_photo(rs.getString("MEMBER_PHOTO"));
			boards.add(board);
		}
		rs.close();
		pstmt.close();
		con.close();
		return boards;
	}
	
	public int findCommentNo (BoardVO board) throws Exception {
		int result = 0;
		String sql = " SELECT A.BOARD_NO BOARD_NO, A.BOARD_FILE BOARD_FILE, A.BOARD_TAG BOARD_TAG, B.MEMBER_PHOTO MEMBER_PHOTO, "
				+ " A.BOARD_CONTENT BOARD_CONTENT, A.BOARD_LIKE_CNT BOARD_LIKE_CNT, A.BOARD_LEVEL BOARD_LEVEL, "
				+ " A.BOARD_REGDATE BOARD_REGDATE, A.MEMBER_NO MEMBER_NO, B.MEMBER_NAME MEMBER_NAME "
				+ " FROM TB_BOARD A, TB_MEMBER B "
				+ " WHERE A.BOARD_LEVEL = ? "
				+ " AND A.MEMBER_NO = ? "
				+ " AND A.MEMBER_NO = B.MEMBER_NO "
				+ " ORDER BY BOARD_NO DESC ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		
		pstmt.setInt(1, board.getBoard_level());
		pstmt.setInt(2, board.getMember_no());
		ResultSet rs = pstmt.executeQuery();
		rs.next();
		result = rs.getInt("BOARD_NO");
		
		rs.close();
		pstmt.close();
		con.close();
		return result;
	}
	
	public ArrayList<Integer> findLikesByMemberNo(int no) throws Exception {
		ArrayList<Integer> boards = new ArrayList<>();
		String sql = " SELECT BOARD_NO FROM TB_LIKE WHERE MEMBER_NO = ? ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		
		pstmt.setInt(1, no);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			boards.add(rs.getInt("BOARD_NO"));
		}
		
		return boards;
	}
	
	public ArrayList<Integer> findSubscribesByMemberNo(int no) throws Exception {
		ArrayList<Integer> boards = new ArrayList<>();
		String sql = " SELECT BOARD_NO FROM TB_FAVORITE WHERE MEMBER_NO = ? ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		
		pstmt.setInt(1, no);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			boards.add(rs.getInt("BOARD_NO"));
		}
		
		return boards;
	}
	
	public int getNoticeRows() throws Exception {
		int totalRows = 0;
		String sql = " SELECT COUNT(*) CNT "
					+ "	FROM TB_NOTICE ";
		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			totalRows = rs.getInt("CNT");
		}
		rs.close();
		pstmt.close();
		con.close();
		
		return totalRows;
	}
	
	public ArrayList<BoardVO> findNotice(int begin, int end) throws Exception {
		ArrayList<BoardVO> boards = new ArrayList<>();
		String sql = " SELECT RN, NOTICE_CONTENT, NOTICE_REGDATE, NOTICE_NO "
				+ " FROM (	SELECT ROW_NUMBER() OVER (ORDER BY NOTICE_NO DESC) RN,  "
				+ "			NOTICE_CONTENT, NOTICE_REGDATE, NOTICE_NO "
				+ "			FROM TB_NOTICE) "
				+ " WHERE RN >= ? AND RN <= ? ";

		Connection con = ConnectionUtil.getConnection();
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, begin);
		pstmt.setInt(2, end);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			BoardVO board = new BoardVO();
			board.setBoard_no(rs.getInt("NOTICE_NO"));
			board.setBoard_file(rs.getString("NOTICE_CONTENT"));
			board.setBoard_regdate(rs.getDate("NOTICE_REGDATE"));
			boards.add(board);
		}
		rs.close();
		pstmt.close();
		con.close();
		return boards;
	}

}