/**
 * 
 */
console.log("Comments Module.....");
const contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/",2));


var commentsService = (function(){
	
	function add(comments, sec1, sec2, callback, error){
		console.log("reply.....");
		
		$.ajax({
			type:'post',
			url:contextPath+'/comments/new',
			beforeSend: function(xhr){
				xhr.setRequestHeader(sec1, sec2);
			},
			data: JSON.stringify(comments),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr){
				if(callback){
					callback(result);
				}
			},
			error: function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		})
	}
	
	function getList(param, callback, error){
		var bno = param.bno;
		var pno = param.pno || 1;
		
		$.ajax({
			type:'get',
			url:contextPath+'/comments/list/'+bno+'/'+pno,
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr){
				if(callback){
					callback(result);
				}
				console.log(result);
			},
			error: function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		})
	}
	
	function remove(cno, sec1, sec2, callback, error){
		
		$.ajax({
			type:'delete',
			url:'/spring08/comments/'+cno,
			beforeSend: function(xhr){
				xhr.setRequestHeader(sec1, sec2);
			},
			success: function(result, status, xhr){
				if(callback){
					callback(result);
				}
			},
			error: function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		})
	}
	
	function update(comments, sec1, sec2, callback, error){
		
		$.ajax({
			type:'put',
			url:'/spring08/comments/'+comments.cno,
			beforeSend: function(xhr){
				xhr.setRequestHeader(sec1, sec2);
			},
			data : JSON.stringify(comments),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr){
				if(callback){
					callback(result);
				}
			},
			error: function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		})
	}
	
	function displayTime(timeValue){
		var today = new Date();
		
		var gap = today.getTime() - timeValue;
		
		var dateObj = new Date(timeValue);
		var str = "";
		
		if(gap < (1000*60*60*24)){
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
			return [(hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi, ':', (ss > 9 ? '' : '0') + ss].join('');
		} else{
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1;
			var dd = dateObj.getDate();
			
			return [yy, '-', (mm > 9 ? '': '0') + mm, '-', (dd > 9? '' : '0')+dd].join('');
		}
	}
	
	return {
		add:add,
		getList:getList,
		remove:remove,
		update:update,
		displayTime:displayTime,
	};
})();