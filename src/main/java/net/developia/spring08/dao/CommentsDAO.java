package net.developia.spring08.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import net.developia.spring08.dto.CommentsDTO;

public interface CommentsDAO {
	
	public int insert(CommentsDTO dto);
	
	public CommentsDTO read(Long cno);
	
	public int delete(Long cno);
	
	public int update(CommentsDTO comments);
	
	public List<CommentsDTO> getCommentsList(@Param("bno") Long bno);
}
