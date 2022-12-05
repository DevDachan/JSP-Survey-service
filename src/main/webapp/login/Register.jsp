<%@ page language="java" contentType="text/html; charset=UTF-8" 
pageEncoding="UTF-8"  %>

<%@ page import='java.io.PrintWriter' %>
<%@ page import='user.UserDAO' %>
<%@ page import='java.net.URLEncoder' %>


<%UserDAO userDAO = new UserDAO(application); %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Tyep" content="text/html" charset="UTF-8">
	<!-- meta data add  -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no"> 
	
	<title>Survey Service</title>
	<!-- Bootstrap insert -->
	<link rel="stylesheet" href="../css/bootstrap.min.css">
	<!-- custom CSS insert -->
	<link rel="stylesheet" href="../css/custom.css?ver=1">
	<script>
	function sendCode(){
		userEmail = document.getElementById('useremail').value;// input data
		document.getElementById("codeError").style.display = "none";
		if(userEmail == null || userEmail == ""){
			document.getElementById("sendCodeBtn").innerText = "이메일을 입력해주세요";	
		}
		check = 0;
		document.getElementById("sendCodeBtn").innerText = "전송 중입니다. 잠시만 기다려주세요";
		$.ajax({
    	 	type:'post',
      	 	async:false, //false가 기본값임 - 비동기
       		url:'http://localhost:8080/Survey_project/login/codeSendAction.jsp',
        	dataType:'text',
        	data:{
        		userEmail:userEmail
        		},
        	success: function(res) {
        		result = res.split('{')[1].split("}")[0];  		
        		if(result.includes("Success")){
        			check = 1;
        			document.getElementById("sendCodeBtn").innerText = "전송 완료(재전송을 원하시면 눌러주세요)";	
        		}else{
        			document.getElementById("sendCodeBtn").innerText = "전송 실패 (올바른 이메일을 입력해주세요.)";	
        		}
        	},
       		error:function (data, textStatus) {
            	console.log('error');
      	  	}
  	  	})
  	  	if(check == 1){
  			document.getElementById('code-title').style.display = "block";
  			document.getElementById('code-input').style.display = "block";	
  	  	}	
		
	}
	
	
	function init_modal(){
		document.getElementById('code-title').style.display = "none";
		document.getElementById('code-input').style.display = "none";
	}
	
	function codeCheck(){	
		inputCode = document.getElementById('code_input_value').value;// input data
		userEmail = document.getElementById('useremail').value;// input data
		check = 0;
		$.ajax({
    	 	type:'post',
      	 	async:false, //false가 기본값임 - 비동기
       		url:'http://localhost:8080/Survey_project/login/codeCheckAction.jsp',
        	dataType:'text',
        	data:{
        		inputCode:inputCode,
        		userEmail:userEmail
        		},
        	success: function(res) {
        		result = res.split('{')[1].split("}")[0];  		
        		if(result.includes("Success")){
        			check = 1;
        		}else{
        			document.getElementById("codeError").style.display = "block";
        		}
        	},
        error:function (data, textStatus) {
            console.log('error');
        }
  	  })
  	  
  	  	if(check == 1){
  			document.getElementById('code-title').style.display = "block";
  			document.getElementById('code-input').style.display = "block";
			document.getElementById('email_auth_label').style.display = "block";
  			document.getElementById('userEmail').value = userEmail;
  			document.getElementById('email_auth_label').innerText = userEmail;
  			document.getElementById('close_modal').click();
  	  	}	
		
		
	}
	</script>
	
</head>
<body>

<% 
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String) session.getAttribute("userID");
	
%>
		<jsp:include page='../alert.jsp'> 
				<jsp:param name="title" value="<%=URLEncoder.encode(\"안내\", \"UTF-8\") %>" />
				<jsp:param name="content" value="<%=URLEncoder.encode(\"로그인 정보가 존재합니다.\", \"UTF-8\") %>" />
				<jsp:param name="url" value="location.href = '../index.jsp';"/>
		</jsp:include>	
<% 					
				
	}


%>

	
	<nav class="navbar navbar-expand-lg navbar-light" style="background: #6DEDFE; border-radius: 0px 0px 20px 20px;">
		<a class="navbar-brand" href="../index.jsp" style="color:white; text-weight:bold;">설문 서비스 </a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="./Login.jsp" style="color:white;">로그인</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdowm-toggle" id="dropdown" data-toggle="dropdown" style="color:white;">
						회원 관리	
					</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
					
<%
	if(userID == null){
		
%>
						<a class="dropdown-item" href="./Login.jsp">로그인</a>
						<a class="dropdown-item" href="./Register.jsp">회원가입</a>
<% 
	}else{
		
%>
						<a class="dropdown-item" href="./LogoutAction.jsp">로그아웃</a>
<%
	}
%>
					</div>
				</li>	
			</ul>
		</div>
	</nav>
	
	<section class="container mt-3" style="max-width: 500px;">
		<form method="post" action="./RegisterAction.jsp">
		<div class="form-row">
			<div class="col-sm-12">
				<div class="form-row" >
					<div class="form-group col-sm-2">
						ID
					</div>
					<div class="form-group col-sm-10">
						<input type="text" name="userID" class="form-control" required placeholder="ID">
					</div>
				</div>
				<div class="form-row" >
					<div class="form-group col-sm-2 ">
						<p class="mr-3" >PWD</p>
					</div>
					<div class="form-group col-sm-10">
						<input type="password" name="userPWD" class="form-control" required placeholder="Password">
					</div>
				</div>
				<div class="form-row" >	
					<div class="form-group col-sm-6">
						<label class="form-control" id="email_auth_label" style="text-align:center;display:none;">No</label>
						<input type="hidden" id="userEmail" name="userEmail" value="Not">
					</div>			
					<div class="form-group col-sm-6">
						<a class="btn btn-primary mx-1 " style="width:100%;" data-toggle="modal" href="#reportModal">이메일 인증하기</a>
					</div>	
				</div>
			</div>	
			<div class="col-sm-12">
				<button type="submit" class="btn" style="background:#FF8484; width:100%; height:90%; color:white;">가입하기</button>
			</div>
		</div>
		</form>
	</section>
	

	<%-- tabindex: 키보드 포커싱 제외, Tab을 눌렀을때 이동하지 않도록 --%>
	<div class="modal fade" id="reportModal" tabindex="-1" data-backdrop="static" data-keyboard="false" role="dialog" aria-labelledby="modal" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id ="modal">이메일 인증 하기</h5>
						<button type="button" class="close" data-dismiss="modal" onClick="init_modal()" aria-label="Close" >
							<span aria-hidden="true">&times;</span>
						</button>	
					</div>
					<div class="modal-body">
							<div class="form-row">
						
								<div class="form-group col-sm-4">
									<label>Email</label>
								</div>
								<div class="form-group col-sm-8">
									<input type="email" name="userEmail" id="useremail" class="form-control" 
									pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$"placeholder="example@gmail.com" maxlength="30">	
								</div>
								<div class="form-group col-sm-12 mb-5">
									<button type="button" id="sendCodeBtn" class="btn btn-primary" style="width:100%;" onClick='sendCode()'>인증 코드 보내기</button>
								</div>
								<div class="form-group col-sm-4">
									<div id="code-title" style="display:none;"><label >코드</label></div>
								</div>
								<div class="form-group col-sm-8">
									<div id="code-input" style="display:none;"><input type="text" id="code_input_value" class="form-control" maxlength="30" required></div>	
								</div>
								<div class="form-group col-sm-12" style="color:red;">
									<label id="codeError" style="text-align:center;display:none;" > 올바른 코드를 입력해주세요 </label>
								</div>
								
								<div class="modal-footer col-sm-12">
									<div class="form-group col-sm-6">
										<button type="button" class="btn btn-danger" onClick="codeCheck()" style="width:100%;">확인</button>
									</div>
									<div class="form-group col-sm-6">
										<button type="button" id="close_modal" class="btn btn-secondary" style="width:100%;" data-dismiss="modal" onClick="init_modal()">취소</button>
									</div>
								</div>
							</div>
					</div>
				</div>
			</div>
		</div> 

	
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

<%userDAO.endclose();%>