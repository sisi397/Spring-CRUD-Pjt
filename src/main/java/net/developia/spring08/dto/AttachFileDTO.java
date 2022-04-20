package net.developia.spring08.dto;

import lombok.Data;

// 첨부파일
@Data
public class AttachFileDTO {
	private String uuid;
	private String uploadPath;
	private String fileName;
	private int fileType;
	private Long bno;
}
