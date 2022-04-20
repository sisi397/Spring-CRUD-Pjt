package net.developia.spring08.service;

import java.util.List;

import net.developia.spring08.dto.CommentsDTO;

public interface CommentsService {

	int insert(CommentsDTO dto);

	List<CommentsDTO> getCommentsList(Long bno);

	int delete(Long cno);

	int update(CommentsDTO dto);

}
