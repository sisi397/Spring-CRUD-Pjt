<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./common/header.jsp" %>
<script>
$(document).ready(function(){
	var msg = '${param.msg }'
	if(msg != null && msg != "" && msg != defined){
		alert(msg);
	}
})
</script>
<div style="text-align:center">
<p>Spring CRUD Project - 김시은</p>
<hr/>
</div>

<div class="container" style="margin-left:30%; margin-top: 100px">
<div class="card m-4" style="width: 33rem;">
  <div class="card-body">
    <h5 class="card-title">로그인 후 이용해 주세요!</h5>
    <p class="card-text">로그인하러 가기</p>
    <a href="login" class="btn btn-primary">Go Login</a>
  </div>
</div>
<div class="card m-4" style="width: 33rem;">
  <div class="card-body">
    <h5 class="card-title">자유 게시판 입니다~~</h5>
    <p class="card-text">자유 게시판</p>
    <a href="list/1" class="btn btn-primary">Go Go!!</a>
  </div>
</div>
</div>
</body>
</html>
