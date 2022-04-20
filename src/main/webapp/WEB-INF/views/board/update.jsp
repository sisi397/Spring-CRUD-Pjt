<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="../common/header.jsp" %>
<div class="container" style="margin-top:80px; margin-bottom:80px;">
	<h1>Board Update</h1>
	<hr/>
	<form method="post" action="${contextPath }/update" role="form">
	<input type="hidden" name="pno" value="${pno }"/>
	<input type="hidden" name="no" value="${boardDTO.no }"/>
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }"/>
	<div class="card mb-3" >
		<h5 class="card-header">Board Update</h5>
		<fieldset disabled>
		<div class="form-group m-3">
			<label for="">글번호</label>
			<input class="form-control" type="text" name="bno" value="${boardDTO.no }" readonly="readonly"/>
		</div>
		</fieldset>
		<div class="form-group m-3">
			<label for="">제목</label>
			<input type="text" class="form-control" value="${boardDTO.title }" name="title" autofocus="autofocus" required="required"/>
		</div>
		<div class="form-group m-3">
			<label for="">작성자</label>
			<input type="text" class="form-control" name="name" value="${boardDTO.name }" readonly="readonly"/>
		</div>
		<div class="form-group m-3">
			<label for="">내용</label>
			<textarea name="content" class="form-control" rows="5" cols="40" required="required">${boardDTO.content }</textarea>
		</div>
	</div>
	<div class="card" >
		<h5 class="card-header">File Attach</h5>
		<div class="card-body">
		<div class="panel-body m-3">
			<div class="form-group uploadDiv">
		      <input type="file" name="uploadFile" multiple>
		    </div>
			<div class="uploadResult">
				<ul></ul>
			</div>
		</div>
		<div class="bigPictureWrapper">
			<div class="bigPicture"></div>
		</div>
		</div>
	</div>
	<a class="btn btn-primary float-right m-3" href="${contextPath }/list/${pno}" role="button">List</a>
	<input class="btn btn-primary float-right m-3" type="submit" value="Submit">
	</form>
	
	
	<script>
	function showImage(fileCallPath){
		console.log(fileCallPath);
		$(".bigPictureWrapper").css("display","flex").show();
		fileCallPath = fileCallPath.replace(new RegExp(/\'/g),"&#39");
		
		$(".bigPicture")
		.html("<img src='${contextPath}/display?fileName=/"+encodeURI(fileCallPath)+"'>")
		.animate({width: '100%', height: '100%'}, 1000);
	}
		$(document).ready(function(){
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			var maxSize = 5242880;
			var uploadResult = $(".uploadResult ul");
			var attaches = '${attachList}'
			showUploadFile(${attachList})
			
			function checkExtension(fileName, fileSize){
				if(fileSize >= maxSize){
					alert("파일 사이즈 초과");
					return false;
				}
				
				if(regex.test(fileName)){
					alert("해당 종류의 파일은 업로드할 수 없습니다.");
					return false;
				}
				
				return true;
			}
			
			function showUploadFile(uploadResultArr){
				console.log(uploadResultArr);
				var str = "";
				$(uploadResultArr).each(function(i,obj){
					if(obj.fileType == 0){
						var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
						var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
						fileCallPath = fileCallPath.replace(new RegExp(/\'/g),"&#39");
						str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'><div><a href='${contextPath}/download?fileName=/"+fileCallPath+"'>"
								+"<img src='${contextPath}/resources/img/attach.png'>" + obj.fileName + "</a>"
								+"<span data-file=\'"+fileCallPath+"\' data-type='file'>x</span></div></li>";
					} else{
						//str += "<li>" + obj.fileName + "</li>";
						
						var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
						var originPath = obj.uploadPath+"\\"+obj.uuid+"_"+obj.fileName;
						originPath = originPath.replace(new RegExp(/\\/g),"/");
						originPath = originPath.replace(new RegExp(/\'/g),"\\'");
						console.log(originPath);
						fileCallPath = fileCallPath.replace(new RegExp(/\'/g),"&#39");
						str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'><a href=\"javascript:showImage(\'"+originPath+"\')\">"
								+"<img src='${contextPath}/display?fileName=/"+fileCallPath+"'></a>"
								+"<span data-file=\'"+fileCallPath+"\' data-type='image'>x</span></li>";
					}
				});
				uploadResult.append(str);
			}
			
			var cloneObj = $(".uploadDiv").clone();
			
			$("input[type='file']").change(function(e){
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				var files = inputFile[0].files;
				console.log(files);
				
				for(var i = 0; i < files.length; i++){
					if(!checkExtension(files[i].name, files[i].size)){
						return false;
					}
					formData.append("uploadFile", files[i]);
				}

				//processData : querystring (True), name=aaa&gender=1(False->multipart data 형태)
				
				var csrfHeaderName="${_csrf.headerName}";
				var csrfTokenValue="${_csrf.token}";
				$.ajax({
					url:'${contextPath}/uploadAjaxAction',
					processData : false,
					contentType: false,
					data: formData,
					type: 'POST',
					beforeSend: function(xhr){
						xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
					},
					dataType:'json',
					success: function(result){
						console.log(result);
						
						showUploadFile(result);
						$(".uploadDiv").html(cloneObj.html());
					}
				});
			});
			
			$(".bigPictureWrapper").on("click", function(e){
				$(".bigPicture").animate({width: '0%', height: '0%'},1000);
				setTimeout(function(){
					$('.bigPictureWrapper').hide();
				},1000);
			});
			
			$(".uploadResult").on("click","span",function(e){
				if(confirm("파일을 삭제하시겠습니까?")){
					var targetLi = $(this).closest("li");
					targetLi.remove();
				}
			});
			
			var formObj = $("form[role='form']");
			$("input[type='submit']").on("click", function(e){
				e.preventDefault();
				console.log("submit clicked");
				
				var str = "";
				$(".uploadResult ul li").each(function(i, obj){
					var jobj = $(obj);
					console.log(jobj);
					
					str += "<input type='hidden' name='attachList["+i+"].fileName' value ='"+jobj.data("filename")+"'>"
						+ "<input type='hidden' name='attachList["+i+"].uuid' value ='"+jobj.data("uuid")+"'>"
						+ "<input type='hidden' name='attachList["+i+"].uploadPath' value ='"+jobj.data("path")+"'>"
						+ "<input type='hidden' name='attachList["+i+"].fileType' value ='"+jobj.data("type")+"'>";
				})
				formObj.append(str).submit();
			})
		});
		
	</script>
</div>
</body>
</html>