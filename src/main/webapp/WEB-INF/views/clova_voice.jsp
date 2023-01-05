<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>clova_voice</title>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<script>
	$(function(){
		$('#voiceBtn').click(()=>{
			let str=$('#text').val();
			//alert(str);
			if(!str){
				alert('내용을 입력하세요');
				$('#text').focus();
				return;
			}
			let url="voiceEnd";
			$.ajax({
				type:'post',
				url:url,
				data:{
					text:str
				},
				contentType:'application/x-www-form-urlencoded; charset=UTF-8',
				dataType:'text', //네이버 클라우드 응답 유형은 바이너리 데이터 유형 => blob => 컨트롤러에서 blob유형을 받아 파일로 저장한 뒤에 해당 파일명을 반환할 예정
				success:function(res){
					//alert('success: '+res);
					$('#tts').prop("src", "file/"+res);
				},
				error:function(err){
					alert('err: '+err.status+", responseText: "+err.responseText);
				}
			})
		})//click
	})//$() end
</script>
</head>
<body>
<div id="wrap">
	<h1>CVP - 텍스트를 음성으로 변환하는 서비스</h1>
	<textarea rows="7" cols="60" name="text" id="text" placeholder="입력한 내용이 음성으로 나와요."></textarea>
	<button id="voiceBtn">음성 확인</button>
	<hr>
	<audio id="tts" preload="auto" controls="controls"></audio>
	

</div>

</body>
</html>