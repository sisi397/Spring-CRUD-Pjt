package net.developia.spring08.dto;

import lombok.Data;
import lombok.ToString;

// 검색
@ToString
@Data
public class Criteria {
	private String type;
	private String keyword;
	
	public String[] getTypeArr() {
		return type == null ? new String[] {} : type.split("");
	}
}
