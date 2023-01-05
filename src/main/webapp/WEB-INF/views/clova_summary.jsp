<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.1/dist/jquery.min.js"></script>
<script>
	$(function(){
		$('#btnSummary').click(function(){
			let title=$('#title').val();
			let content=$('#content').val();
			if(!title||!content){
				alert('제목과 글 내용을 입력하세요');
				return;
			}
			let url="summaryEnd";
			$.ajax({
				type:'post',
				url:url,
				dataType:'text',
				data:{
					title:title,
					content:content
				},
				success:function(res){
					//alert(res);
					$('#result').html("<h4>"+res+"</h4>");
				},
				error:function(err){
					alert('err: '+err.status);
				}
			})
			
		})
	})
</script>
</head>
<body>
<div id="wrap">
	<h1>Naver Clova Summary</h1>
	제목: <input type="text" id="title" name="title" style="width:70%">
	<br><br>
	글내용: <textarea rows="20" cols="100" name="content" id="content"></textarea>
	<br><br>
	<button id="btnSummary">문장 요약하기</button>
	<hr color='red'>
	<div id="result"></div>
</div>

</body>
</html>