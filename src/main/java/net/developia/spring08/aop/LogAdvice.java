package net.developia.spring08.aop;

import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

// advice
@Aspect
@Log4j
@Component
public class LogAdvice {
	@AfterThrowing(pointcut = "execution(* net.developia.spring08.service.*.*(..))", throwing = "exception")
	public void logException(Exception exception) throws Exception {
		log.info("=== AfterThrowing 실행중... ===");
		log.info(exception.toString());
		throw exception;
	}
}
