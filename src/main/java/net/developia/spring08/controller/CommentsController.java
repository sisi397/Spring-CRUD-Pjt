package net.developia.spring08.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.log4j.Log4j;
import net.developia.spring08.dto.CommentsDTO;
import net.developia.spring08.service.CommentsService;

@Log4j
@RestController
@RequestMapping("/comments/")
public class CommentsController {
	
	private CommentsService commentsService;

	public CommentsController(CommentsService commentsService) {
		this.commentsService = commentsService;
	}
	
	//댓글 등록
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value="/new", consumes="application/json", produces=MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity<String> create(@RequestBody CommentsDTO dto){
		log.info("CommentsDTO : " + dto);
		int insertCount = commentsService.insert(dto);
		return insertCount == 1 ? new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	// 댓글 리스트
	@GetMapping(value="/list/{bno}/{pno}", produces= MediaType.APPLICATION_JSON_UTF8_VALUE)
	public ResponseEntity<List<CommentsDTO>> getCommentsList(@PathVariable("bno") Long bno, @PathVariable int pno){
		return new ResponseEntity<>(commentsService.getCommentsList(bno), HttpStatus.OK);
	}
	
	// 댓글 삭제
	@PreAuthorize("isAuthenticated()")
	@DeleteMapping(value="/{cno}", produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> delete(@PathVariable("cno") Long cno){
		return commentsService.delete(cno) == 1 ? new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	// 댓글 수정
	@PreAuthorize("isAuthenticated()")
	@PutMapping(value="/{cno}", consumes="application/json", produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> update(@RequestBody CommentsDTO dto, @PathVariable("cno") Long cno){
		dto.setCno(cno);
		return commentsService.update(dto) == 1 ? new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
