<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri= "http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri= "http://java.sun.com/jsp/jstl/functions" %>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="shortcut icon" type="image/x-icon" href="/img/favicon.ico" />
<link rel="stylesheet" href="/css/common.css" />
<style>
  #PdsView td:nth-of-type(1) {  width : 150px; text-align: center;   }
  #PdsView td:nth-of-type(2) {  width : 400px; text-align: center;   }
  #PdsView td:nth-of-type(3) {  width : 150px; text-align: center;   }
  #PdsView td:nth-of-type(4) {  width : 400px; text-align: center;   }
  
  #PdsView td[colspan]                 { text-align: left; }
  #PdsView tr:last-child td[colspan]   { text-align: center; }
  
  #PdsView tr:nth-of-type(4) { height: 400px;}
  #PdsView tr:nth-of-type(5) { height: 120px;}
  
  input[type=text]  { width:100%; }
  textarea          { width:100%; height:400px; }
  
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  $(function() {
	  let  num = 1;
	  $('#btnAddFile').on('click', function(e) {
		  // <button> submit 능력을 제거
		  e.preventDefault();
		  e.stopPropagation();
		  let tag = '<input type="file" name="file' + num + '" /><br />';
		  $('#tdfile').append( tag );
		  num++;		  
	  });
	  
	  $('form').on('submit', function(e) {
		  if( $('[name=title]').val().trim() == '') {
			  alert('제목을 입력하세요');
			  $('[name=title]').focus();
			  return false;
		  }
	  });



	  $('#tdfile').on('click','.aDelete',  function( e ) {
		  // a tag 기본 이벤트 제거 href 로 이동하는 것 방지
		  e.preventDefault();
		  e.stopPropagation();
		  
		  let  aDelete = e.target;  // == let  aDelete = this;
		  let  href    = aDelete.href;
		  
		  $.ajax({
			  url     : href,
			  method  : 'GET', 
			  success : function(data) {
				  alert('삭제 완료');	
				  $(aDelete).parent().remove();  // 부모 element 제거
			  },
			  error : function(xhr) {
				  alert(xhr.status + ':' + xhr.textStatus);
			  }
		  })
		  
	  })
  });
</script>
</head>
<body>
  <div id="main">
  
    <form  action="/Pds/Update" method="POST">

    <input  type="hidden"  name="board_idx" value="${ pdsVo.board_idx }" />
     <input  type="hidden"  name="moim_idx" value="${ pdsVo.moim_idx }" />
   <input  type="hidden"  name="menu_idx" value="${ pdsVo.menu_idx }" />
<%--     <input type="hidden" name="nowpage"      value="${ map.nowpage }" />
    <input type="hidden" name="pagecount"    value="${ map.pagecount }" />          
    <input type="hidden" name="pagegrpnum"   value="${ map.pagegrpnum }" />    --%>
    <!-- 자료실 pdsList -->   
    <table id="PdsView">
      <caption><h2> 수정하기 </h2></caption>
      <tr>
         <td>작성자</td>
         <td>${ pdsVo.user_id }</td>
         <td>작성일</td>
         <td>${ pdsVo.board_regdate }</td>
       </tr> 
       <tr>
         <td>글번호</td>
         <td>${ pdsVo.board_idx }</td>
         <td>조회수</td>
         <td>${ pdsVo.readcount }</td>
       </tr> 
       <tr>
         <td>글제목</td>
         <td  colspan="3">
           <input type="text" name="board_title" value="${ pdsVo.board_title }" />
         </td>
       </tr> 
       <tr>
         <td>내용</td>
         <td  colspan="3">
           <textarea name="board_cont">${ pdsVo.board_cont }</textarea>
         </td>
       </tr> 
       
       <tr>
         <td  colspan="4">
           <input type="submit" value="수정" />
           <input type="button" id="btnList" value="목록" onclick="location.href='http://localhost:8080/Pds/board';" />
         </td>
       </tr> 
       
    
    </table>
    
    </form>
    
    <div style="height: 300px;"></div>
  </div>
</body>
</html>








