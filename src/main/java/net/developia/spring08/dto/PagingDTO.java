package net.developia.spring08.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// 페이징
@Data
@AllArgsConstructor
@NoArgsConstructor
public class PagingDTO {
	private int beginPageNumber;
	private int endPageNumber;
	private int pagePerList;
	private int totalPage;
	private int totalCount;
}
