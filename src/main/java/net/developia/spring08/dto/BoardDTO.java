package net.developia.spring08.dto;

import java.util.Date;
import java.util.List;

import lombok.Data;

// 게시글
@Data
public class BoardDTO {
	private long no;
	private String title;
	private String name;
	private String content;
	private Date regdate;
	private int readcount;
	
	private List<AttachFileDTO> attachList;
}
