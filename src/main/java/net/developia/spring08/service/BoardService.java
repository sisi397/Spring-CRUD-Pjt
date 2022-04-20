package net.developia.spring08.service;

import java.util.List;

import net.developia.spring08.dto.BoardDTO;
import net.developia.spring08.dto.Criteria;
import net.developia.spring08.dto.PagingDTO;

public interface BoardService {

	void insertBoard(BoardDTO boardDTO) throws Exception;

	List<BoardDTO> getBoardList(int pno, Criteria criteria) throws Exception;

	BoardDTO getDetail(long no) throws Exception;

	void deleteBoard(int no) throws Exception;

	void updateBoard(BoardDTO boardDTO) throws Exception;

	PagingDTO getPage(int pno, Criteria criteria) throws Exception;
	
	List<String> getWords(String keyword) throws Exception;

	void insertSearch(String keyword) throws Exception;

	List<String> bestKeyword() throws Exception;
	
}
