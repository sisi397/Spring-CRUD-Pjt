<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp" %>
	<script type="text/javascript" src="<c:url value="/webjars/jquery-ui/1.13.0/jquery-ui.js"/>"></script>
	<link rel="stylesheet" href="<c:url value="/webjars/jquery-ui/1.13.0/jquery-ui.css"/>"/>

<div class="container" style="margin-top:80px; margin-bottom:80px;">
	<h1 style="display:inline-block;">자유 게시판</h1>
	<div class="float-right" id="searchBox">
		<small class="float-left" style="margin-left:20px;">Best Keyword</small>
		<div id="contain">
			<div class="mt-1" id="box">
			</div>
		</div>
	</div>
	<hr/>
	<div class="float-right mb-3">
		<form id="searchForm" action="${contextPath }/list/1" method="get">
			<select name="type">
				<option value=""
					<c:out value="${criteria.type == null ? 'selected' : '' }"/>>--</option>
				<option value="T"
					<c:out value="${criteria.type eq 'T' ? 'selected' : '' }"/>>제목</option>
				<option value="C"
					<c:out value="${criteria.type eq 'C' ? 'selected' : '' }"/>>내용</option>
				<option value="W"
					<c:out value="${criteria.type eq 'W' ? 'selected' : '' }"/>>작성자</option>
				<option value="TC"
					<c:out value="${criteria.type eq 'TC' ? 'selected' : '' }"/>>제목 또는 내용</option>
			</select>
			<input type="text" class="keyword" name="keyword"
				value="<c:out value='${criteria.keyword}'/>"/>
			<button type="button" class="btn-s btn-secondary">Search</button>
		</form>
	</div>	
	<table class="table table-bordered table-hover" border="1" style="text-align:center">
		<thead class="thead-dark">
		<tr>
			<th width="150">번호</th>
			<th>제목</th>
			<th width="200">작성자</th>
			<th width="200">작성일</th>
			<th width="150">조회수</th>
		</tr>
		</thead>
		<tbody>
		<c:forEach items="${list }" var="dto" varStatus="status">
		<tr>
			<td>${pagingDTO.totalCount - (status.index+(pno-1)*10)}</td>
			<td>
				<a href="${contextPath }/detail/${dto.no}/${pno}">${dto.title }</a>
			</td>
			<td>${dto.name }</td>
			<td>
			<c:set var="regdate"><fmt:formatDate value="${dto.regdate }" type="date" pattern="yyyy-MM-dd"/></c:set>
			<c:set var="today"><fmt:formatDate value="${date }" type="date" pattern="yyyy-MM-dd"/></c:set>
			<c:if test="${regdate eq today }">
				<fmt:formatDate value="${dto.regdate }" type="date" pattern="HH:mm:ss"/>
			</c:if>
			<c:if test="${regdate ne today }">
				<fmt:formatDate value="${dto.regdate }" type="date" pattern="yyyy-MM-dd"/>
			</c:if>
			</td>
			<td>${dto.readcount }</td>
		</tr>
		</c:forEach>
		</tbody>
	</table><br/>
	<!-- pagination -->
	<nav aria-label="Page navigation example">
	  <ul class="pagination justify-content-center">
	  <c:if test="${pagingDTO.beginPageNumber > pagingDTO.pagePerList}">
	    <li class="page-item">
	      <a class="page-link" href="${contextPath }/list/${pagingDTO.beginPageNumber - 1}?search=${param.search}&type=${criteria.type}&keyword=${criteria.keyword}" aria-label="Previous">
	        <span aria-hidden="true">&laquo;</span>
	      </a>
	    </li>
	    </c:if>
	    <c:forEach begin="${pagingDTO.beginPageNumber }" end="${pagingDTO.endPageNumber }" var="pno">
	    <li class="page-item"><a class="page-link" href="${contextPath }/list/${pno}?search=${param.search}&type=${criteria.type}&keyword=${criteria.keyword}">${pno }</a></li>
	    </c:forEach>
		<c:if test="${pagingDTO.endPageNumber < pagingDTO.totalPage}">
	    <li class="page-item">
	      <a class="page-link" href="${contextPath }/list/${pagingDTO.endPageNumber + 1}?search=${param.search}&type=${criteria.type}&keyword=${criteria.keyword}" aria-label="Next">
	        <span aria-hidden="true">&raquo;</span>
	      </a>
	    </li>
	    </c:if>
	  </ul>
	</nav>
	<a class="btn btn-secondary float-right" href="${contextPath }/insert">글쓰기</a>
	<br/>
</div>
<script>
$(document).ready(function(){
	var str = "";
	$.ajax({
		  type:'get',
		  url: '${contextPath}/bestKeyword',
		  dataType:'json',
		  success:function(data){
			  for(var i = 1; i <= data.length; i++){
				  str += "<p style='display:none'>"+ i + ". <a href='${contextPath}/list/1?type=TC&keyword=" + data[i-1] + "'>"+data[i-1]+"</a></p>"
			  }
			  $("#box").append(str);
			  $("#box p:first").show();
		  }
	  });
	  
	setInterval("play()", 800);

	$("#searchForm button").on("click", function(e){
		if(!$("#searchForm").find("option:selected").val()){
			alert("검색종류를 선택하세요");
			return false;
		}
		if(!$("#searchForm").find("input[name='keyword']").val()){
			alert("키워드를 입력하세요");
			return false;
		}
		e.preventDefault();
		searchForm.submit();
	});
	
	$( ".keyword" ).autocomplete({
	      source: function(request, response){
	    	  $.ajax({
	    		  type:'get',
	    		  url: '${contextPath}/autocomplete_data',
	    		  dataType:'json',
	    		  data:{
	    			  keyword:$(".keyword").val(),
	    			  type:$("#searchForm").find("option:selected").val()
	    			 },
	    		  success:function(data){
	    			  response(
	    				$.map(data, function(item){
	    					return{
	    						label: item,
	    						value: item
	    					}
	    				})	  
	    			  )
	    		  }
	    	  })
	      },
	      minLength : 2,
	      delay : 300,
	      select : function(evet,ui){  
	      },
	      response: function(event, ui){
	    	  console.log(ui);
	      }
	    });
});
</script>
<script>
	function play(){
		$("#box").delay(2000).animate({top:-40},function(){
			$("#box p:first").appendTo("#box");
			$("#box").css({top:0});
			$("#box p:not(first)").hide();
			$("#box p:first").show();
		})
	}
</script>
</body>
</html>