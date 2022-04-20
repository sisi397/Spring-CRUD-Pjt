package net.developia.spring08.dao;

import java.sql.SQLException;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import net.developia.spring08.dto.BoardDTO;
import net.developia.spring08.dto.Criteria;

public interface BoardDAO {

	void insertBoard(BoardDTO boardDTO) throws SQLException;

	List<BoardDTO> getBoardList(@Param("beginRow") int beginRow, @Param("endRow") int endRow, @Param("criteria") Criteria criteria) throws SQLException;

	BoardDTO getDetail(long no) throws SQLException;

	int updateReadCount(long no) throws SQLException;

	int deleteBoard(int no) throws SQLException;

	int updateBoard(BoardDTO boardDTO) throws SQLException;

	int getTotalCount( @Param("criteria") Criteria criteria) throws SQLException;

	List<String> getWords(String keyword) throws SQLException;

	int insertSearch(String keyword) throws SQLException;

	int countKeyword(String keyword) throws SQLException;

	int updateSearch(String keyword) throws SQLException;

	List<String> bestKeyword() throws SQLException;

}
