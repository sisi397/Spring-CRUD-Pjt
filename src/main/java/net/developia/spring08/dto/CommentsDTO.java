package net.developia.spring08.dto;

import java.util.Date;

import lombok.Data;

// 댓글
@Data
public class CommentsDTO {
	private Long cno;
	private Long bno;
	private String comments;
	private String name;
	private Date regDate;
	private Date updateDate;
}
