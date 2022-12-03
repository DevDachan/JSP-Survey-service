<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="user.UserDTO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import='java.net.URLEncoder' %>

<%
	//사용자로부터 입력받는 것은 모두 UTF-8을 사용하겠다.
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	String userPassword = null;
	String userEmail = null;
	
	// 만약 사용자에게 data가 올바르게 들어왔을 경우(request) 해당 data를 local instance에 넣기
	if(request.getParameter("userID")!= null ){
		userID = request.getParameter("userID");			
	}
	if(request.getParameter("userPWD")!= null ){
		userPassword = request.getParameter("userPWD");			
	}
	if(request.getParameter("userEmail")!= null ){
		userEmail = request.getParameter("userEmail");			
	}
	// 하나라도 옳지 않은 내용이 존재하거나 null값이 존재 할 경우에는 오류 alert와 함께 이전 페이지로
	if(userID == null || userPassword == null || userEmail == null){
%>
		<jsp:include page='alert.jsp'> 
				<jsp:param name="title" value="<%=URLEncoder.encode(\"안내\", \"UTF-8\") %>" />
				<jsp:param name="content" value="<%=URLEncoder.encode(\"입력이 안 된 사항이 있습니다.\", \"UTF-8\") %>" />
				<jsp:param name="url" value="history.back();"/>
		</jsp:include>	
<% 							
	}
	
	UserDAO userDAO = new UserDAO(application);
	int result = userDAO.registerUser(userID, userPassword,userEmail);
	
	if(result == 1){
		session.setAttribute("userID",userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'index.jsp';");
		script.println("</script>");
		script.close();
	}else if (result == 2){
%>
		<jsp:include page='alert.jsp'> 
				<jsp:param name="title" value="<%=URLEncoder.encode(\"안내\", \"UTF-8\") %>" />
				<jsp:param name="content" value="<%=URLEncoder.encode(\"이미 존재하는 아이디입니다.\", \"UTF-8\") %>" />
				<jsp:param name="url" value="history.back();"/>
		</jsp:include>	
<% 				
		
	}else if (result == 3){
%>
		<jsp:include page='alert.jsp'> 
				<jsp:param name="title" value="<%=URLEncoder.encode(\"안내\", \"UTF-8\") %>" />
				<jsp:param name="content" value="<%=URLEncoder.encode(\"이미 존재하는 Email입니다.\", \"UTF-8\") %>" />
				<jsp:param name="url" value="history.back();"/>
		</jsp:include>	
<% 						
	}else{
%>
		<jsp:include page='alert.jsp'> 
				<jsp:param name="title" value="<%=URLEncoder.encode(\"ERROR\", \"UTF-8\") %>" />
				<jsp:param name="content" value="<%=URLEncoder.encode(\"DB 오류가 발생했습니다.\", \"UTF-8\") %>" />
				<jsp:param name="url" value="history.back();"/>
		</jsp:include>	
<% 	
	}
%>
