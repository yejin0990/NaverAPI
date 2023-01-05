<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>speech recognition</title>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.1/dist/jquery.min.js"></script>
<script>
	$(function(){
		$('#uploadForm').submit(function(){
			event.preventDefault();
			let file=$('#mp3file')[0];
			//alert($('#mp3file').val().split("\\").pop())
			
			let auFile=$('#mp3file').val().split("\\").pop();//첨부한 오디오 파일명
			$('#sttAudio').prop("src","${pageContext.request.contextPath}/file/"+auFile);
			
			console.log("${pageContext.request.contextPath}/file/"+auFile);
			//servlet-context.xml에 resource등록 해야 함
			if(file.files.length==0){
				alert('음성 파일을 업로드 하세요');
				return;
			}
			let form=$('#uploadForm')[0];
			let formData=new FormData(form);
			let url="csr_speech";
			$.ajax({
				type:'post',
				data:formData,
				dataType:'json',
				url:url,
				cache:false,
				processData:false,
				contentType:false,
				success:function(res){
					//alert(typeof res.result)
					let jsonObj=JSON.parse(res.result);
					
					$('#result').html("<h3>"+jsonObj.text+"</h3>");
					//$('#sttAudio').prop("autoplay",true);
				},
				error:function(err){
					alert('error: '+err.status);
				}
				
			})
			
		})
	})
</script>
</head>
<body>
<div id="wrap">
	<h1>Clova Speech Recognition</h1>
	<form method="post" enctype="multipart/form-data" id="uploadForm">
		<select name="language">
			<option value="Kor">한국어</option>
			<option value="Eng">영어</option>
			<option value="Jpn">일본어</option>
			<option value="Chn">중국어</option>
		</select><br><br>
		<label for="mp3file">MP3 파일 선택</label>
		<input type="file" name="mp3file" id="mp3file">
		<button>확   인</button>
	</form>
	<hr>
	<div>
		<h2>STT: 음성을 텍스트로 변환한 결과</h2>
		<audio id="sttAudio" preload="auto" controls></audio>
	</div>
	<div id="result">
	</div>

</div>

</body>
</html>