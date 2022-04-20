package net.developia.spring08.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import lombok.extern.log4j.Log4j;

// 로그인 성공 시 페이지 이동
@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

   @Override
   public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication auth)
         throws IOException, ServletException {

      String contextPath = request.getContextPath();
      List<String> roleNames = new ArrayList<>();

      
      for(GrantedAuthority authority : auth.getAuthorities()) {
         log.info("GrantedAuthority :::::> " + authority);
         roleNames.add(authority.getAuthority());
      }

      if (roleNames.contains("ROLE_ADMIN")) {
         response.sendRedirect(contextPath + "/list/1");
         return;
      }

      if (roleNames.contains("ROLE_MEMBER")) {
         response.sendRedirect(contextPath + "/list/1");
         return;
      }

      if (roleNames.contains("ROLE_USER")) {
         response.sendRedirect(contextPath + "/list/1");
         return;
      }

      response.sendRedirect(contextPath + "/");
   }
}