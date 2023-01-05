<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>

<script>
	$(function(){
		$('#uploadForm').submit(function(e){
			e.preventDefault();
			//파일 첨부 안 했을 경우
			let image=$('#image')[0];
			if(image.files.length==0){
				alert('이미지 파일을 첨부하세요');
				return;
			}
			
			//파일 업로드시에는 FormData객체에 form객체를 인자로 전달하면 된다.
			let form=$('#uploadForm')[0]; //form객체
			//alert(form);
			let data=new FormData(form); //업로드할 땐 FormData 사용
			let url="cfrCelebrity";
			$.ajax({
				type:'post',
				url:url,
				dataType:'json',
				data:data, //FormData 전달
				processData:false, //"multipart/form-data" 사용하려면 추가, 일반적으로 서버에 전달되는 데이터는 query string 형태이다 이걸 사용 안하겠단 의미
				contentType:false, //"multipart/form-data"로 전송되도록 false 설정. 명시적으로 "multipart/form-data"으로 설정해주면 boundary string이 안 들어가 제대로 동작하지 않는다.
				success:function(res){
					console.log(JSON.stringify(res));
					$('#txt').val(res.result);
					//alert(typeof res.result) ==> string 유형으로 온다
					let json=JSON.parse(res.result); //string 유형을 파싱하여 json객체로 변환해준다.
					$('#result').html("");
					$.each(json.faces, function(i, cel){
						alert(cel.celebrity.value);
						$('#result').append("<h2>"+cel.celebrity.value+"와(과) 닮았어요</h2>")
					})
				},
				error:function(err){
					alert('error: '+err.status);
					console.log(err.responseText);
				}
			})
		})
	})
</script>    

<div id="wrap">
	<h1>CFR Celebrity</h1>
	<p>
	입력받은 이미지로부터 얼굴을 감지하고 감지한 얼굴이 어떤 유명인과 닮았는지 분석하여 그 결과를 반환하는 REST API입니다. 이미지에서 다음과 같은 정보를 분석합니다.
	<br><br>
	감지된 얼굴의 수<br>
	감지된 각 얼굴을 분석한 정보<br>
	닮은 유명인 이름<br>
	해당 유명인을 닮은 정도<br>
	https://api.ncloud-docs.com/docs/ai-naver-clovafacerecognition-celebrity		
	</p>
	<form method="post" enctype="multipart/form-data" id="uploadForm">
		<label for="image">이미지 선택</label>
		<input type="file" name="image" id="image">
		<button>확  인</button>
	</form>
	<hr>
	<div id="result">
	
	</div>
	<textarea id="txt" rows="7" cols="60"></textarea>
</div>