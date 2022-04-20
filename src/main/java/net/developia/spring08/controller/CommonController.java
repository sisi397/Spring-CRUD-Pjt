package net.developia.spring08.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
public class CommonController {
	// 로그인 페이지
	@GetMapping("/login")
	public String loginInput(String error, String logout, Model model) {
		log.info("error: "+error);
		log.info("logout: " + logout);
		
		if(error!=null) {
			model.addAttribute("error", "Login Error check your Account");
		}
		
		if(logout != null) {
			model.addAttribute("logout", "LoginOut!!!");
		}
		return "login";
	}
	
	// 로그아웃
	@GetMapping("/logout")
	public void logoutGET() {
		log.info("custom logout");
	}
}
