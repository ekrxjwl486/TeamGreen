<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions"%>  
<%
 response.setHeader("Cache-Control","no-cache");
 response.setHeader("Pragma","no-cache");
 response.setDateHeader("Expires",0);
%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">

<title>모임화면</title>
<link rel="shortcut icon" type="image/x-icon" href="/img/favicon.ico" />
<link rel="stylesheet" href="/css/common.css" />
<style>
   h2 { margin : 20px;  }
</style>
<script src="https://code.jquery.com/jquery-3.6.1.min.js"> </script>
<script>

$(document).ready(function(){

	let user_id = $('[name=user_id]').val(); // 유저아이디 들고오기

	let obj={ // 넘겨줄 데이터
			"moim_idx" : $('[name=moim_idx]').val(),
			"user_id" : $('[name=user_id]').val()
		};

	$.ajax({
		url : "regcheck",
		type : "POST",
		data : obj,
		success : function(chk){ // 가입자 -> 탈퇴출력, 미가입자 -> 가입출력
			if(chk==0){
				var showReg =  '<button onclick="myFunction()">　가입　</button>';
				$('#showReg').html( showReg );
			} else {
				var boardView  = '<a href="/Pds/List?menu_idx=1&nowpage=1&pagecount=10&pagegrpnum=1"   style="float: left">자유게시판</a><br>';
				    boardView += '<a href="/Pds/1/Album" style="float: left">사진첩</a><br>';
				    boardView += '<a href="/Pds/hi?moim_idx=${moimVo.moim_idx}" style="float: left">가입인사_게시판</a>';
				var   showReg  =  '<button onclick="myFunction2()">　탈퇴　</button>';
					 	
				$('#boardView').html( boardView );
				$('#showReg').html( showReg );
			}
		},
		error : function() {
			alert("요청실패");
		}
	})

});

</script>
</head>
<body>
  <div id="main">
	<button type="button" style="float: right" onclick="location.href='/Mypage?user_id=${ sessionScope.login.user_id }';">마이페이지</button>
	
	<hr />
	<!-- 
	<img onclick="javascript:location.href='/';" src = "img/tennis.jpg" 
	     alt="tennis" height="350" width="600" style="cursor:pointer;"/>
	 -->
<input type="hidden" name="user_id" value="${ sessionScope.login.user_id }"/>
<input type="hidden" name="moim_idx" value="${ moimVo.moim_idx }"/>
<input type="hidden" name="moim_name" value="${ moimVo.moim_name }"/>

<%--  모임 화면 나오면 전부수정 !!!!!!!!!!!!!!!!--%>
	<h1>${ moimVo.moim_name }</h1>
	<h2>${ moimVo.moim_intro }</h2> 
	<h3>모임장 : ${ moimVo.user_name }</h3>
	<br>
	<img class="NO-CACHE" name="thumbnail" src="/img/${moimVo.moim_name}_thumbnail.jpg" width="400" height="200" border="3">
	
	<a href="/Pds/List?menu_idx=2&nowpage=1&pagecount=10&pagegrpnum=1"   style="float: left">Q & A</a><br>
	<p id="boardView"></p>
	<!-- 
	<a href="/Pds/List?menu_idx=1&nowpage=1&pagecount=10&pagegrpnum=1"   style="float: left">자유게시판</a><br>
	<a href="/Pds/1/Album" style="float: left">사진첩</a><br>   <%-- 중간 1 자리에 MOIM_IDX 가 들어가야함 !!! --%>
	<a href="/Pds/hi?moim_idx=${moimVo.moim_idx}" style="float: left">가입인사_게시판</a>
	 -->
	 
	<hr />

	<p id="showReg"></p> <!-- 가입 or 탈퇴 버튼 출력 -->
	<script>
	function myFunction() {
	  let text = "가입하시겠습니까?";
	  if (confirm(text) == true) { 
		  
		  let user_id = $('[name=user_id]').val();
		  let addr = "/Moim/sign_up_moim?moim_idx=${ moimVo.moim_idx }&user_id=";
		  location = addr+user_id;
	  }
	}

	function myFunction2() {
	  let text = "탈퇴하시겠습니까?";
	  if (confirm(text) == true) {
	    location = "/Delete_moimuser?user_id=${ sessionScope.login.user_id }&moim_idx=${ moimVo.moim_idx }"
		alert("탈퇴되었습니다.")
	  }
	}
	</script>
	
  </div>	
</body>
</html>