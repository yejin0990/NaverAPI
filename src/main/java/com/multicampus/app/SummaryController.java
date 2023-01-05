package com.multicampus.app;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

import org.json.JSONObject;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.log4j.Log4j;

/* 요청시 보내야할 데이터 형식
 * {
  "document": {
    "title": "'하루 2000억' 판 커지는 간편송금 시장",
    "content": "간편송금 이용금액이 하루 평균 2000억원을 넘어섰다. 한국은행이 17일 발표한 '2019년 상반기중 전자지급서비스 이용 현황'에 따르면 올해 상반기 간편송금서비스 이용금액(일평균)은 지난해 하반기 대비 60.7% 증가한 2005억원으로 집계됐다. 같은 기간 이용건수(일평균)는 34.8% 늘어난 218만건이었다. 간편 송금 시장에는 선불전자지급서비스를 제공하는 전자금융업자와 금융기관 등이 참여하고 있다. 이용금액은 전자금융업자가 하루평균 1879억원, 금융기관이 126억원이었다. 한은은 카카오페이, 토스 등 간편송금 서비스를 제공하는 업체 간 경쟁이 심화되면서 이용규모가 크게 확대됐다고 분석했다. 국회 정무위원회 소속 바른미래당 유의동 의원에 따르면 카카오페이, 토스 등 선불전자지급서비스 제공업체는 지난해 마케팅 비용으로 1000억원 이상을 지출했다. 마케팅 비용 지출규모는 카카오페이가 491억원, 비바리퍼블리카(토스)가 134억원 등 순으로 많았다."
  },
  "option": {
    "language": "ko",
    "model": "news",
    "tone": 2,
    "summaryCount": 3
  }
}
*/

//ajax로 요청보낼거임
@RestController
@Log4j
public class SummaryController {
	
	@GetMapping("/summaryform")
	public ModelAndView summaryForm() {
		ModelAndView mv=new ModelAndView("clova_summary");
		//WEB-INF/views/clova_summary.jsp
		return mv;
	}

	//produces : 내보내는 유형 지정
	@PostMapping(value="/summaryEnd", produces="text/plain; charset=UTF-8")
	public String summaryEnd(@RequestParam("title") String title, @RequestParam("content") String content)
			throws Exception {
		log.info("title==="+title+", cotent==="+content);
		String clientId="clientId";
		String clientSecret="clientSecret";
		String urlStr="https://naveropenapi.apigw.ntruss.com/text-summary/v1/summarize";
		
		URL url=new URL(urlStr);
		URLConnection urlCon=url.openConnection();
		HttpURLConnection con=(HttpURLConnection)urlCon;
		
		StringBuffer response=new StringBuffer();
		
		con.setRequestMethod("POST"); //요청방식 설정
		con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
		con.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);
		con.setRequestProperty("Content-Type", "application/json"); //요청데이터 - json
		
		//전송할 데이터를 json형식으로 만들자
		JSONObject doc=new JSONObject();
		doc.put("title", title);
		doc.put("content", content);
		
		JSONObject option=new JSONObject();
		option.put("language", "ko");
		option.put("model", "news");
		option.put("tone", "3"); //어조
		option.put("summaryCount", "3"); //문장을 3문장으로 요약
		
		JSONObject root=new JSONObject();
		root.put("document", doc);
		root.put("option", option);
		
		String params=root.toString();
		log.info("params===="+params);
		con.setUseCaches(false);
		con.setDoOutput(true);
		con.setDoInput(true);
		
		//네이버 클라우드 서버로 요청 파라미터 데이터를 전송하기 위한 스트림 생성
		OutputStream os=con.getOutputStream();
		BufferedWriter bw=new BufferedWriter(new OutputStreamWriter(os, "UTF-8"));
		bw.write(params);
		bw.flush();
		bw.close();
		os.close();
		int responseCode=con.getResponseCode();
		log.info("responseCode==="+responseCode);
		
		//응답 데이터 추출
		BufferedReader br;
		if(responseCode==200) {
			br=new BufferedReader(new InputStreamReader(con.getInputStream(),"UTF-8"));
		}else {
			log.info("Error발생: "+responseCode);
			br=new BufferedReader(new InputStreamReader(con.getErrorStream(),"UTF-8"));
		}
		String line="";
		if(br!=null) {
			while((line=br.readLine())!=null) {
				response.append(line);
			}
			br.close();
		}
		log.info("response==="+response.toString());
		JSONObject json=new JSONObject(response.toString());
		String summary=json.getString("summary");
		
		return summary; //==res => success:function(res)의 res
	}
}
