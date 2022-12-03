<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="survey.SurveyDAO" %>

<%@ page import="java.io.PrintWriter" %>
<%@ page import='java.net.URLEncoder' %>


<%
	//사용자로부터 입력받는 것은 모두 UTF-8을 사용하겠다.
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	int sid = 0;
	int hid = 0;
	
	// 만약 사용자에게 data가 올바르게 들어왔을 경우(request) 해당 data를 local instance에 넣기
	if(session.getAttribute("userID")!= null ){
		userID = (String) session.getAttribute("userID");			
	}
	if(request.getParameter("sid")!= null){
		sid = Integer.parseInt(request.getParameter("sid"));
	}
	if(request.getParameter("hid")!= null){
		hid = Integer.parseInt(request.getParameter("hid"));
	}
	// 하나라도 옳지 않은 내용이 존재하거나 null값이 존재 할 경우에는 오류 alert와 함께 이전 페이지로
	if(userID == null || sid == 0 || hid == 0){
%>
		<jsp:include page='alert.jsp'> 
				<jsp:param name="title" value="<%=URLEncoder.encode(\"로그인\", \"UTF-8\") %>" />
				<jsp:param name="content" value="<%=URLEncoder.encode(\"세션 정보가 존재하지 않습니다.\", \"UTF-8\") %>" />
				<jsp:param name="url" value="location.href = 'Login.jsp';" />
		</jsp:include>	
<% 				
	}
	
	SurveyDAO surveyDAO = new SurveyDAO(application);
	int result = surveyDAO.deleteHistory(userID,sid,hid);
	
	if(result != 0){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
	}else{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	}
	
%>