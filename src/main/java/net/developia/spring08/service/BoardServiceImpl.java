package net.developia.spring08.service;

import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import net.developia.spring08.dao.AttachFileDAO;
import net.developia.spring08.dao.BoardDAO;
import net.developia.spring08.dto.AttachFileDTO;
import net.developia.spring08.dto.BoardDTO;
import net.developia.spring08.dto.Criteria;
import net.developia.spring08.dto.PagingDTO;

@Log4j
@Service
public class BoardServiceImpl implements BoardService{

	private BoardDAO boardDAO;
	private AttachFileDAO attachFileDAO;

	public BoardServiceImpl(BoardDAO boardDAO, AttachFileDAO attachFileDAO) {
		this.boardDAO = boardDAO;
		this.attachFileDAO = attachFileDAO;
	}

	// 게시글 저장
	@Transactional
	@Override
	public void insertBoard(BoardDTO boardDTO) throws Exception {
		boardDAO.insertBoard(boardDTO);
		
		if(boardDTO.getAttachList() != null && boardDTO.getAttachList().size() > 0) {
			boardDTO.getAttachList().forEach(attach -> {
				attach.setBno(boardDTO.getNo());
				attachFileDAO.insert(attach);
			});
		}
	}

	private int pagePerList = 5; // 한 페이지 당 보여줄 페이지 수
	private int listPerPage = 10;  // 한 페이지 당 보여줄 게시글 수
	
	// 게시판 리스트
	@Override
	public List<BoardDTO> getBoardList(int pno, Criteria criteria) throws Exception {
		// 불러올 게시판의 시작 번호, 끝 번호 구하기
		int beginRow = 0;
		int endRow = 0;
		int totalCount = boardDAO.getTotalCount(criteria);
		
		beginRow = (pno - 1) * listPerPage + 1;
		endRow = beginRow + listPerPage - 1;
		if(endRow > totalCount) endRow = totalCount;
		
		return boardDAO.getBoardList(beginRow, endRow, criteria); 
	}
	
	// 페이지 번호
	@Override
	public PagingDTO getPage(int pno, Criteria criteria) throws Exception {
		int totalCount = boardDAO.getTotalCount(criteria);
		int pageNumber = pno; // 현재 페이지 번호
		int totalPage = totalCount%listPerPage==0 ? totalCount/listPerPage : totalCount/listPerPage+1; //전체 페이지 수
		
		// 페이지 시작 번호, 끝 번호
		int beginPageNumber = (pageNumber - 1)/pagePerList*pagePerList + 1;
		int endPageNumber = beginPageNumber + pagePerList - 1;
		if(endPageNumber > totalPage)
			endPageNumber = totalPage;

		PagingDTO pagingDTO = new PagingDTO(beginPageNumber, endPageNumber, pagePerList, totalPage, totalCount);	
		
		return pagingDTO;
	}
	
	// 게시글 상세보기
	@Override
	public BoardDTO getDetail(long no) throws Exception {
		if(no == -1) {
			throw new RuntimeException("잘못된 접근입니다.");
		}
		
		// 조회수 증가
		boardDAO.updateReadCount(no);
		BoardDTO boardDTO = boardDAO.getDetail(no);
		if(boardDTO == null) {
			throw new RuntimeException(no + "번 글이 존재하지 않습니다.");
		}
		
		//첨부파일 가져오기
		boardDTO.setAttachList(attachFileDAO.findByBno(no));
		return boardDTO;
	}

	// 게시글 삭제
	@Override
	public void deleteBoard(int no) throws Exception {
		if(boardDAO.deleteBoard(no) == 0) {
			throw new RuntimeException("해당하는 게시물이 없습니다.");
		}
	}

	// 게시글 수정
	@Transactional
	@Override
	public void updateBoard(BoardDTO boardDTO) throws Exception {
		// 첨부파일 모두 지우기
		int temp = attachFileDAO.deleteAll(boardDTO.getNo());
		
		// 게시글 업데이트
		boolean modifyResult = boardDAO.updateBoard(boardDTO) == 1;
		
		if(!modifyResult) {
			throw new RuntimeException("해당하는 게시물이 없습니다.");
		}
		
		// 첨부파일 다시 insert
		if(modifyResult&&boardDTO.getAttachList() != null && boardDTO.getAttachList().size() > 0) {
			boardDTO.getAttachList().forEach(attach -> {
				attach.setBno(boardDTO.getNo());
				attachFileDAO.insert(attach);
			});
		}
	}

	// autoComplete
	@Override
	public List<String> getWords(String keyword) throws SQLException {
		List<String> list = boardDAO.getWords(keyword);
		return list;
	}
	
	// 검색어 저장
	@Override
	public void insertSearch(String keyword) throws Exception {
		if(boardDAO.countKeyword(keyword) == 0) {
			int insert = boardDAO.insertSearch(keyword); // keyword 새로 추가
		}else { 
			int update = boardDAO.updateSearch(keyword); //keyword 검색수 업데이트
		}
	}

	// best keyword 10개 가져오기
	@Override
	public List<String> bestKeyword() throws Exception {
		List<String> list = boardDAO.bestKeyword();
		return list;
	}
}
