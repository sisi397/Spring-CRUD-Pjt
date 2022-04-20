package net.developia.spring08.dao;

import java.util.List;

import net.developia.spring08.dto.AttachFileDTO;

public interface AttachFileDAO {
	
	public int insert(AttachFileDTO dto);
	
	public int delete(String uuid);
	
	public List<AttachFileDTO> findByBno(Long bno);

	public int deleteAll(long no);
	
	public List<AttachFileDTO> getOldFiles();
}
