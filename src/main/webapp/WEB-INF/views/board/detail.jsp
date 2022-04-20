<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/header.jsp" %>
	<script type="text/javascript" src="<c:url value="/resources/js/comments.js"/>"></script>
	<script>
		var bnoValue;
		var commentsUL;
		$(document).ready(function(){
			$(".newComments").hide();
			bnoValue = ${boardDTO.no};
			console.log(bnoValue);
			commentsUL = $(".chat");

			showList(1);
			
			$(".regBtn").on("click", function(e){
				var comments = {
					name:$("input[name='name']").val(),
					comments: $("textarea[name='comments']").val(),
					bno: bnoValue
				};

				var csrfHeaderName="${_csrf.headerName}";
				var csrfTokenValue="${_csrf.token}";
				commentsService.add(comments, csrfHeaderName, csrfTokenValue, function(result){
					alert("등록 완료");
					showList(1);
				})
			})
		});

		function showList(pno){
			commentsService.getList({bno:bnoValue, pno:pno||1}, function(list){
				var str ="";
				
				if(list == null || list.length == 0){
					commentsUL.html("");
					
					return;
				}
				<sec:authorize access='isAuthenticated()'>
				var replyer='<sec:authentication property="principal.username"/>';
				</sec:authorize>
				
				for(var i = 0, len = list.length||0; i < len; i++){
					var originReplyer = list[i].name;
					console.log(list[i]);
					console.log(replyer, originReplyer)
					str += "<div style='border-bottom:1px solid rgba(0,0,0,.125); padding:10px;' id="+list[i].cno+">"
						+ "<h6 class='card-title'>"+list[i].name;
						if(replyer == originReplyer){
						str += "<div class='float-right'><button class='btn-sm btn-primary px-1 py-0' onclick='updateToggle("+list[i].cno+")'>수정</button> <button class='btn-sm btn-primary px-1 py-0' onclick='deleteCmt("+list[i].cno+")'>삭제</button></div>"
						}
					str += "</h6><div style='float:right'>"+commentsService.displayTime(list[i].regDate)+"</div>"
						+ "<textarea name='comments' class='form-control' rows='2' cols='40' required='required' style='display: none;'>"+list[i].comments+"</textarea>"
						+ "<div style='text-align:right; margin-top:10px;'><button class='btn btn-secondary mb-1 px-1 py-0' onclick='updateCmt("+list[i].cno+")' style='display: none;'>등록</button>"
						+ "<button class='btn btn-secondary mb-1 px-1 py-0' onclick='cancelUpdate("+list[i].cno+")' style='display: none;'>취소</button></div>"
						+ "<p class='card-text'>"+list[i].comments+"</p></div>";
				}
				console.log(str);
				commentsUL.html(str);
			});
		}
		
		function newToggle(){
			$(".newComments").toggle();
		}
		
		function cancelUpdate(cno){
			$("div[id='"+cno+"'] > p").show();
			$("div[id='"+cno+"'] > textarea").hide();
			$("div[id='"+cno+"'] > div > button").hide();
		}
		function updateToggle(cno){
			$("div[id='"+cno+"'] > p").hide();
			$("div[id='"+cno+"'] > textarea").show();
			$("div[id='"+cno+"'] > div > button").show();
		}
		
		function updateCmt(cno){
			var comments={
					cno:cno,
					comments:$("div[id='"+cno+"'] > textarea").val(),
					bno:bnoValue
			}

			var csrfHeaderName="${_csrf.headerName}";
			var csrfTokenValue="${_csrf.token}";
			commentsService.update(comments,csrfHeaderName, csrfTokenValue, function(result){
				if(result === "success"){
					alert("수정되었습니다.");
					showList(1);
				}
			});
		}
		function deleteCmt(cno){

			var csrfHeaderName="${_csrf.headerName}";
			var csrfTokenValue="${_csrf.token}";
			commentsService.remove(cno, csrfHeaderName, csrfTokenValue, function(result){
				if(result === "success"){
					alert("삭제되었습니다.");
					showList(1);
				}
			})
		}
		function download(uploadPath, uuid, fileName, fileType){
			var fileCallPath = encodeURIComponent(uploadPath+"/"+uuid+"_"+fileName);
			location.href='${contextPath}/download?fileName=/'+fileCallPath;
		}
		
		function deleteBoard(){
			console.log("delete");
			var csrfHeaderName="${_csrf.headerName}";
			var csrfTokenValue="${_csrf.token}";
			
			$.ajax({
				url:'${contextPath}/delete',
				type:'POST',
				beforeSend: function(xhr){
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				data:{
					no:${boardDTO.no},
					writer:'${boardDTO.name}'
				},
				success: function(result){
					alert("삭제되었습니다.");
					location.href="${contextPath }/list/1";
				}
			})
		}
		
	</script>
<div class="container" style="margin-top:80px; margin-bottom:80px;">
	<h1>Board Detail</h1>
	<hr/>
	<div class="card mb-3" >
		<h5 class="card-header"><span class="float-left">[${boardDTO.no }]</span>${boardDTO.title } <span class="float-right">${boardDTO.readcount }</span></h5>
	  	<div class="card-body">
		<table class="table table-bordered">
		  <tbody>
		    <tr>
		      <th scope="row">작성자</th>
		      <td>${boardDTO.name }</td>
		    </tr>
		    <tr>
		      <th scope="row">작성일</th>
		      <td>
		      	<c:set var="regdate"><fmt:formatDate value="${boardDTO.regdate }" type="date" pattern="yyyy-MM-dd"/></c:set>
				<c:set var="today"><fmt:formatDate value="${date }" type="date" pattern="yyyy-MM-dd"/></c:set>
				<c:if test="${regdate eq today }">
					<fmt:formatDate value="${boardDTO.regdate }" type="date" pattern="hh:mm:ss"/>
				</c:if>
				<c:if test="${regdate ne today }">
					<fmt:formatDate value="${boardDTO.regdate }" type="date" pattern="yyyy-MM-dd"/>
				</c:if>
		      </td>
		    </tr>
		    <tr>
		      <th scope="row">내용</th>
		      <td>${boardDTO.content }</td>
		    </tr>
		    <tr>
		      <th scope="row">첨부파일</th><td>
				<c:forEach items="${boardDTO.attachList }" var="attach" varStatus="status">
				 <div onclick="download('${attach.uploadPath}', '${attach.uuid }', '${attach.fileName}', ${attach.fileType })" style="cursor:pointer;">${attach.fileName}</div>
		     	</c:forEach>
		     	</td>
		    </tr>
		  </tbody>
		</table>
		<div class="float-right">
			<a class="btn btn-secondary float-right m-1" href="${contextPath }/list/${pno }">리스트</a>
			
			<sec:authorize access="isAuthenticated()">
			<c:if test="${pinfo.username eq boardDTO.name }">
			<a class="btn btn-secondary float-right m-1" href="${contextPath }/update/${boardDTO.no }/${pno}">수정</a>
			<a class="btn btn-secondary float-right m-1" onclick="deleteBoard()">삭제</a>
			</c:if>
			</sec:authorize>
		</div>
		</div>
	</div>
	<br/>
	<div class="card mb-3">
	  <div class="card-header">
	    <div style="display:inline-block; height:100%; margin-top:10px;">댓글</div>
		<sec:authorize access="isAuthenticated()">
	    <div class="float-right"><button class="btn btn-secondary" onclick="newToggle()">New</button></div>
	    </sec:authorize>
	  </div>
	  <sec:authorize access="isAuthenticated()">
	  <div class="card-body newComments"> 
	  	<form>
			<div class="form-group m-3">
				<label for="">이름</label>
				<input type="text" class="form-control" name="name" value='<sec:authentication property="principal.username"/>' readonly="readonly"/>
			</div>
			<div class="form-group m-3">
				<label for="">내용</label>
				<textarea name="comments" class="form-control" rows="2" cols="40" required="required"></textarea>
			</div>
			<input class="btn btn-primary float-right m-3 regBtn" type="submit" value="Submit">
		</form>
	  </div>
	  </sec:authorize>
	  <div class="card-body chat">
	  </div>
	</div>
</div>
</body>
</html>