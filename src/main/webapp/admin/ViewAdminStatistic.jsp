<%@ page language="java" contentType="text/html; charset=UTF-8" 
pageEncoding="UTF-8"  %>

<%@ page import='java.io.PrintWriter' %>
<%@ page import='survey.SurveyDAO' %>
<%@ page import='history.HistoryDAO' %>
<%@ page import='history.HistoryCountDTO' %>
<%@ page import='history.HistoryListDTO' %>
<%@ page import='survey.OptionDetailDTO' %>

<%@ page import='java.net.URLEncoder' %>




<%	int viewType = 0; %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Tyep" content="text/html" charset="UTF-8">
	<!-- meta data add  -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no"> 
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
	<title>Survey Service</title>
	<!-- Bootstrap insert -->
	<link rel="stylesheet" href="../css/bootstrap.min.css">
	<!-- custom CSS insert -->
	<link rel="stylesheet" href="../css/custom.css">
	<style type="text/css">
		a, a:hover{
			color: #000000;
			text-decoration: none;
		}
	</style>
	<script>
		function changeView(type){
			
			if(type == "changeResponse"){
				document.getElementById("viewStatistic").style.display = "none";
				document.getElementById("viewEach").style.display = "block";
				
				document.getElementById("changeResponse").style.borderBottom = "2px solid blue";
				document.getElementById("changeStatistic").style.borderBottom = "0px";
					
			}else{
				document.getElementById("viewEach").style.display = "none";
				document.getElementById("viewStatistic").style.display = "block";

				document.getElementById("changeStatistic").style.borderBottom = "2px solid blue";
				document.getElementById("changeResponse").style.borderBottom = "0px";
			}
			
		}
	</script>
</head>
<body>
<% 
	request.setCharacterEncoding("UTF-8");
	String userID = null;	
	if(session.getAttribute("userID") != null){
		userID = (String) session.getAttribute("userID");
	}else{
%>
		<jsp:include page='../alert.jsp'> 
				<jsp:param name="title" value="<%=URLEncoder.encode(\"로그인\", \"UTF-8\") %>" />
				<jsp:param name="content" value="<%=URLEncoder.encode(\"세션 정보가 존재하지 않습니다.\", \"UTF-8\") %>" />
				<jsp:param name="url" value="location.href = '../login/ViewLogin.jsp';" />
		</jsp:include>	
<% 				
		
	}
	int sid = 0;
	if(request.getParameter("sid") != null){
		sid = Integer.parseInt(request.getParameter("sid"));	
	}else{
%>
		<jsp:include page='../alert.jsp'> 
				<jsp:param name="title" value="<%=URLEncoder.encode(\"안내\", \"UTF-8\") %>" />
				<jsp:param name="content" value="<%=URLEncoder.encode(\"설문조사 정보가 존재하지 않습니다.\", \"UTF-8\") %>" />
				<jsp:param name="url" value="history.back();" />
		</jsp:include>	
<% 				
		
	}
%>

		<nav class="navbar navbar-expand-lg navbar-light nav-background" >
		<a class="navbar-brand" href="../index.jsp" style="color:white; text-weight:bold;">설문 서비스 </a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="../index.jsp" style="color:white;">메인 화면</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdowm-toggle" id="dropdown" data-toggle="dropdown" style="color:white;">
						회원 관리	
					</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
					
<%
	if(userID == null){
		
%>
						<a class="dropdown-item" href="../login/ViewLogin.jsp">로그인</a>
						<a class="dropdown-item" href="../login/ViewRegister.jsp">회원가입</a>
<% 
	}
	else{
		
%>
						<a class="dropdown-item" href="../login/ActionLogout.jsp">로그아웃</a>
<%
	}
%>
					</div>
				</li>	
			</ul>
		</div>
	</nav>
	
	<section class="container mt-3" style="max-width: 500px;">

<div style="display:grid; width:50%; margin:auto; margin-bottom:20px;	grid-template-columns: 1fr 1fr;">
	<button class="bt-change-history" type="button" id="changeStatistic" onClick="changeView('changeStatistic')" style="border-bottom:2px solid blue;">통계 보기</button>
	<button class="bt-change-history" type="button" id="changeResponse" onClick="changeView('changeResponse')">개인 응답</button>
</div>

<%
	
	HistoryDAO historyDAO = new HistoryDAO(application);
	SurveyDAO surveyDAO = new SurveyDAO(application);
	OptionDetailDTO[] option = surveyDAO.getOption(sid);
%>




<div id="viewStatistic">
	<%
		for(int i = 0; i<option.length; i++ ){
	
			if(option[i].getType().equals("text")){
				String temp = "";
				String[] history = historyDAO.getHistoryText(sid, option[i].getOptionNum());
				if(history != null){
					temp += "<div class='option mt-4' >";
						temp += "<div class='option-content' style='font-size:20px; border-bottom: 2px solid black;'>"+ option[i].getOptionTitle() +"</div>";
						temp += "<div class='form-row'>";
					for(int k = 0; k<history.length; k++){
						temp += "<div class='form-group col-sm-1' style='border-right:2px solid black;'>"+(k+1) +"</div>";
						temp += "<div class='form-group col-sm-11'>"+history[k]+"</div>";
					}
						temp += "</div>";
					temp += "</div>";	
				}
				else{
					temp += "<div class='option mt-4'>";
						temp += "<div class='option-content' style='font-size:20px; border-bottom: 2px solid black;'>"+ option[i].getOptionTitle() +"</div>";
						temp += "<div class='form-row'>";
						temp += "<div class='form-group col-sm-12' style='border-right:2px solid black;'> 아직 설문 내용이 없습니다 </div>";
						temp += "</div>";
					temp += "</div>";	
				}
				%>
				<%= temp %>
				<% 		
			}else{
				HistoryCountDTO[] history= historyDAO.getHistoryCount(sid, option[i].getOptionNum());		
				String optionLabels = "";
				String optionData = "";
				String color = "";
				int totalCount = 0;
				for(int step = 0; step < history.length; step++){
					totalCount += history[step].getCount();
				}
				
				if(history != null && totalCount > 0){
					for(int k = 0; k<history.length; k++){
						optionData += history[k].getCount();
						optionLabels += "'"+history[k].getComponentContent()+"'";
						int RGB_1 = (int)Math.floor(Math.random() * (255 + 1));
						int RGB_2 = (int)Math.floor(Math.random() * (255 + 1));
						int RGB_3 = (int)Math.floor(Math.random() * (255 + 1));
						color += "'rgba(' + "+RGB_1+" + ',' + "+RGB_2+" + ',' + "+RGB_3+" + ',0.3)'";
						
						if(k != history.length-1){
							optionData +=",";
							optionLabels += ",";
							color += ",";
						}
						
					}
					optionData = "["+optionData+"]";
					optionLabels = "["+optionLabels+"]";
					color = "["+color+"]";		
				}else{
					int RGB_1 = (int) Math.floor(Math.random() * (255 + 1));
					int RGB_2 = (int)Math.floor(Math.random() * (255 + 1));
					int RGB_3 = (int)Math.floor(Math.random() * (255 + 1));
					optionLabels = "['Empty']";
					optionData = "[1]";
					color = "['rgba(' + "+RGB_1+" + ',' + "+RGB_2+" + ',' + "+RGB_3+" + ',0.3)']";
						
				}
			
				%>
				<canvas id="<%=option[i].getOptionNum()%>chart" width="200" height="200"></canvas>
				<script>
					new Chart(document.getElementById("<%=option[i].getOptionNum()%>chart"), {
					    type: 'pie',
					    data: {
					      labels: <%= optionLabels%>,
					      datasets: [{
					        label: "명",
					        backgroundColor: <%=color%>,
					        data: <%=optionData%>
					      }]
					    },
					    options: {
					      title: {
					        display: true,
					        text: "<%= option[i].getOptionTitle()%>"
					      }
					    }
					});
				</script>
				
				<%
			}
		}
	%>
	</div>
	<div id="viewEach" style="display:none;">	
	<div class="list mb-5">
		<div class="list-content">
			<div class="list-option">
				<div class="list-option-item">
					날짜
			 	</div>
				<div class="list-option-item">
					ID
			 	</div>	
				<div class="list-option-item" style="grid-column-end: span 2;">
					수정
				</div>
			 	<div class="list-option-item">
			 		삭제 
				</div> 
			</div>
		<%
		HistoryListDTO[] historyListDTO = historyDAO.getAllHistoryList(sid);
		String historyList ="";
		
		for(int step = 0; step<historyListDTO.length; step++) {
				historyList +="<div class=\"list-rows\" >\n"+
						"<div class=\"list-item\">\n"+
								historyListDTO[step].getSurveyDate()+ "\n"+
						"</div>\n"+
						"<div class=\"list-item\">\n"+
							historyListDTO[step].getUserID()+ "\n"+
						"</div>\n"+		
						"<div class=\"list-item\" style=\"grid-column-end: span 2\">\n"+
							"<a href='./ViewUserResponse.jsp?sid="+historyListDTO[step].getSurveyID()+"&&hid="+historyListDTO[step].getHistoryID()+" ' class='btn btn-primary'>응답 보기</a>\n"+
						"</div>\n"+
						"<div class=\"list-item\">\n"+
							"<a href='./ViewUserResponse.jsp?sid="+historyListDTO[step].getSurveyID()+"&&hid="+historyListDTO[step].getHistoryID()+"' class='btn btn-delete' >삭제</a>\n"+
						"</div>\n"+
				   "</div>";				
			
		}
		%>
		<%= historyList %>
		</div>
	</div>
	
		
	</div>



	
	<a href="../index.jsp" class="btn btn-primary mt-5" style="width:100%;">뒤로 가기</a>
	
	
	</section>
	
	<br/>

	<footer class="bg-dark mt-4 p-5 text-center" style="color:#FFFFFF; ">
		Copyright &copy; 2022 서다찬 All Rights Reserved
	</footer>	
	<!-- JQuery Java Script Add -->
	<script src="../js/jquery.min.js" ></script>
	<!-- Popper Java Script Add -->
	<script src="../js/popper.min.js" ></script>
	<!-- Bootstrap Java Script Add -->
	<script src="../js/bootstrap.min.js" ></script>
	
	
</body>
</html>