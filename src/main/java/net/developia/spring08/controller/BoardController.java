package net.developia.spring08.controller;

import java.util.List;

import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.log4j.Log4j;
import net.developia.spring08.dto.BoardDTO;
import net.developia.spring08.dto.Criteria;
import net.developia.spring08.dto.PagingDTO;
import net.developia.spring08.service.BoardService;
import net.sf.json.JSONArray;

@Log4j
@Controller
public class BoardController {
	
	private BoardService boardService;

	public BoardController(BoardService boardService) {
		this.boardService = boardService;
	}

	@PreAuthorize("isAuthenticated()")
	@GetMapping("insert")
	public String insertBoard() {
		return "board/insert";
	}

	// 게시글 삽입
	@PreAuthorize("isAuthenticated()")
	@PostMapping("insert")
	public String insertBoard(@ModelAttribute BoardDTO boardDTO, Model model) {
		log.info("insert boardDTO : " + boardDTO);
		try {
			boardService.insertBoard(boardDTO);
			return "redirect:list/1";
		} catch (Exception e) {
			model.addAttribute("msg", "입력 에러");
			model.addAttribute("url","javascript:history.back();");
			return "result";
		}
	}

	// 게시글 리스트 불러오기
	@GetMapping("list/{pno}")
	public String listBoard(@PathVariable("pno") int pno, @ModelAttribute Criteria criteria , Model model) throws Exception {
		try {
			List<BoardDTO> list = boardService.getBoardList(pno, criteria);
			model.addAttribute("list", list);

			// keyword 입력 시 검색어 저장
			if(criteria.getType() != null && criteria.getKeyword() != null && criteria.getKeyword() != "" && pno == 1) {
				boardService.insertSearch(criteria.getKeyword());
			}
			
			// 페이징
			PagingDTO page = boardService.getPage(pno, criteria);
			model.addAttribute("pagingDTO", page);
			model.addAttribute("pno", pno);
			return "board/list";
		} catch (Exception e) {
			model.addAttribute("msg", "list 출력 에러");
			model.addAttribute("url","index");
			return "result";
		}
	}

	// 게시글 상세보기
	@GetMapping("detail/{no}/{pno}")
	public String detail(@PathVariable("no") long no, @PathVariable("pno") int pno, Model model) throws Exception {
		try {
			BoardDTO boardDTO = boardService.getDetail(no);
			log.info("detail : " + boardDTO);
			model.addAttribute("boardDTO", boardDTO);
			model.addAttribute("pno", pno);
			return "board/detail";
		} catch(RuntimeException e) {
			model.addAttribute("msg", e.getMessage());
			model.addAttribute("url","../../list/"+pno);
			return "result";
		} catch (Exception e) {
			model.addAttribute("msg", "상세보기 에러");
			model.addAttribute("url","../../list/"+pno);
			return "result";
		}
	}

	@PreAuthorize("isAuthenticated()")
	@GetMapping("delete/{no}/{pno}")
	public String delete(@PathVariable("no") long no, @PathVariable("pno") int pno, Model model) throws Exception {
		model.addAttribute("no", no);
		model.addAttribute("pno", pno);
		return "board/delete";
	}

	// 작성자와 사용자가 같을 경우 게시글 삭제
	@PreAuthorize("principal.username == #writer")
	@PostMapping("delete")
	public String delete(@RequestParam int no, String writer, Model model) throws Exception {
		try{
			boardService.deleteBoard(no);
			return "redirect:list/1";
		} catch (Exception e) {
			model.addAttribute("msg", e.getMessage());
			model.addAttribute("url", "javascript:history.back();");
			return "result";
		}
	}

	@PreAuthorize("isAuthenticated()")
	@GetMapping("update/{no}/{pno}")
	public String update(@PathVariable("no") long no, @PathVariable("pno") int pno, Model model) throws Exception {
		try {
			BoardDTO boardDTO = boardService.getDetail(no);
			model.addAttribute("pno",pno);
			model.addAttribute("boardDTO", boardDTO);
			model.addAttribute("attachList", JSONArray.fromObject(boardDTO.getAttachList()));
			return "board/update";
		} catch (Exception e) {
			model.addAttribute("msg", "수정 에러");
			model.addAttribute("url","list/1");
			return "result";
		}
	}


	// 작성자와 사용자가 같을 경우 게시글 수정
	@PreAuthorize("principal.username == #boardDTO.name")
	@PostMapping("update")
	public String update(@ModelAttribute BoardDTO boardDTO, @RequestParam int pno ,Model model) throws Exception {
		try{
			log.info("dto : " + boardDTO);
			boardService.updateBoard(boardDTO);
			return "redirect:detail/"+boardDTO.getNo()+"/"+pno;
		} catch (Exception e) {
			model.addAttribute("msg", e.getMessage());
			model.addAttribute("url","list/1");
			return "result";
		}
	}

	// 자동완성 기능
	@GetMapping(value="autocomplete_data", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<String> autocomplete_data(@RequestParam String keyword,@RequestParam String type) throws Exception {
		if(type.contains("T")) {
			List<String> list = boardService.getWords(keyword);
			return list;
		}else {
			return null;
		}
	}

	// best keyword 기능
	@GetMapping(value="bestKeyword", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<String> bestKeyword() throws Exception {
		List<String> list = boardService.bestKeyword();
		return list;
	}
}
