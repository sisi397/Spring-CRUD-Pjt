<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<c:set var="date" value="<%=new Date() %>"/>
<sec:authentication property="principal" var="pinfo"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css" integrity="sha384-zCbKRCUGaJDkqS1kPbPd7TveP5iyJE0EjAuZQTgFLD2ylzuqKfdKlfG/eSrtxUkn" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-fQybjgWLrvvRgtW6bFlB7jaZrFsaBXjsOMm/tB9LTS58ONXgqbR9W8oWht/amnpF" crossorigin="anonymous"></script>
	<script type="text/javascript" src="<c:url value="/webjars/jquery/3.6.0/dist/jquery.js"/>"></script>
	<link rel="stylesheet" href="<c:url value="/resources/css/common.css"/>"/>
	
	<script>
		$(document).ready(function(){
			$()
		})
	</script>
</head>
<body>
<script>
	function logout(){
		var csrfHeaderName="${_csrf.headerName}";
		var csrfTokenValue="${_csrf.token}";
		$.ajax({
			url:'${contextPath }/logout',
			type:'post',
			beforeSend: function(xhr){
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			success: function(result){
				alert("로그아웃되었습니다.");
				location.href="${contextPath }/";
			}
		})
	}
</script>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
	<a class="navbar-brand" href="#">Spring CRUD Project</a>
	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
	  <span class="navbar-toggler-icon"></span>
	</button>
	 <div class="collapse navbar-collapse" id="navbarSupportedContent">
	  <ul class="navbar-nav mr-auto">
	    <li class="nav-item active">
	      <a class="nav-link" href="${contextPath }/">Home <span class="sr-only">(current)</span></a>
	   </li>
	   <li class="nav-item active">
	     <a class="nav-link" href="${contextPath }/list/1">Board</a>
	    </li>
	  </ul>
	</div>
	<ul class="navbar-nav ml-md-auto">
	<sec:authorize access="isAuthenticated()">
	 <li class="nav-item">
	 	<span style="color:white;display:inline-block;">${pinfo.username }님 반갑습니다.</span>
	    <span style="display:inline-block;"><a class="nav-link" href="" onclick="logout()">Logout</a></span>
	 </li>
	 </sec:authorize>
	<sec:authorize access="isAnonymous()">
	 <li class="nav-item">
	   <a class="nav-link" href="${contextPath }/login">Login</a>
	 </li>
	 </sec:authorize>
	</ul>
</nav>