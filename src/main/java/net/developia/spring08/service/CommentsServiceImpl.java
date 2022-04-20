package net.developia.spring08.service;

import java.util.List;

import org.springframework.stereotype.Service;

import jdk.internal.org.jline.utils.Log;
import lombok.extern.log4j.Log4j;
import net.developia.spring08.dao.CommentsDAO;
import net.developia.spring08.dto.CommentsDTO;

@Log4j
@Service
public class CommentsServiceImpl implements CommentsService{

	private CommentsDAO commentsDAO;

	public CommentsServiceImpl(CommentsDAO commentsDAO) {
		this.commentsDAO = commentsDAO;
	}
	
	// 댓글 저장
	@Override
	public int insert(CommentsDTO dto) {
		int result = commentsDAO.insert(dto);
		return result;
	}

	// 댓글 리스트
	@Override
	public List<CommentsDTO> getCommentsList(Long bno) {
		return commentsDAO.getCommentsList(bno);
	}

	// 댓글 삭제
	@Override
	public int delete(Long cno) {
		return commentsDAO.delete(cno);
	}

	// 댓글 수정
	@Override
	public int update(CommentsDTO dto) {
		return commentsDAO.update(dto);
	}

}
