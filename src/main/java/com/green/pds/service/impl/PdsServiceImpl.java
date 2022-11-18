package com.green.pds.service.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.green.pds.dao.PdsDao;
import com.green.pds.service.PdsService;
import com.green.pds.vo.CommentsVo;
import com.green.pds.vo.FilesVo;
import com.green.pds.vo.PdsPagingVo;
import com.green.pds.vo.PdsVo;

@Service("pdsService")
public class PdsServiceImpl implements PdsService {

	@Autowired
	private	 PdsDao  pdsDao;
	
	@Override
	public void setWrite(HashMap<String, Object> map,
			HttpServletRequest request) {
		// 1. request 처리 - 넘어온 파일 저장, 
		//   저장된 파일정보(sfilename) -> map 에 돌려받아옴
		// 파라미터 map 은 객체type 이라 call by  reference 방식으로 인자를 처리
		// 인자 호출하는 곳과 함수에 공유한다 inout 파라미터처럼 쓰인다
//		PdsFile.save(map, request);  // 별도  클래스 생성
		
		// 2. 넘어온 정보 db 저장
		// map 은 fileList가 추가된 map
		pdsDao.setWrite( map );

	}

	@Override
	public List<PdsVo> getPdsList(HashMap<String, Object> map) {

		List<PdsVo>  pdsList  =  pdsDao.getPdsList( map );		
		
		System.out.println("PdsServiceImpl :" + pdsList);
		
		return       pdsList;
		
	}
	
	// 페이징을 위해 getPdsList() 수정
		@Override
		public List<PdsPagingVo> getPdsPagingList(HashMap<String, Object> map) {
			
			List<PdsPagingVo> pdsPagingList = pdsDao.getPdsPagingList( map );
			
			
			//                                     pagetotalcount
			// [이전] 1 2 3 4 5 6 7 8 9 10 [다음]     10
			// [이전] 1 2 3 4 5            [다음]      5		
			//  화면에 보야질 페이지 번호의 갯수
			int pagetotalcount = 2;  
			
			// 한 페이지에 보여줄 라인수 :조회된 결과 라인수
			int pagecount = Integer.parseInt( 
				String.valueOf(	map.get("pagecount") ) );   // 2
			
			// 현재 페이지 정보 :  nowpage
		    int nowpage    = Integer.parseInt( 
		    	String.valueOf( map.get("nowpage") ) );
			
		    // pagegrpnum : 
		       //  1     [이전]    1  2  3  4  5  6  7  8  9 10 [다음]
		       //  2     [이전]   11 12 13 14 15 16 17 18 19 20 [다음]
		       //  3     [이전]   21 22 23 24 25 26 		
		    int pagegrpnum = Integer.parseInt(
		    		String.valueOf( map.get("pagegrpnum") ) );
			
			// 전체자료수 : totalcount  - 스토어드 프로시져의 out 파라미터 값
			int totalcount = Integer.parseInt(
					String.valueOf( map.get("totalcount") ) );
			
			// 출력할 paging.jsp를 위힌 정보 준비
			BoardPaging     bp  =  new BoardPaging(
					nowpage, pagecount, totalcount,
					pagetotalcount, pagegrpnum);
			
			PdsPagingVo        vo  = bp.getPdsPagingInfo();
			
			vo.setMenu_idx(Integer.parseInt( String.valueOf(map.get("menu_idx"))));
			
			map.put("pagePdsVo", vo);
			
			return   pdsPagingList;
		}

	@Override
	public PdsVo getPds(HashMap<String, Object> map) {
		
		PdsVo   pdsVo  =  pdsDao.getPds( map );  
		
		return  pdsVo;
	}

	
	@Override
	public PdsVo getPds2(HashMap<String, Object> map) {
		
		PdsVo   pdsVo  =  pdsDao.getPds( map );  
		
		return  pdsVo;
	}
	
	
	@Override
	public List<FilesVo> getFilesList(HashMap<String, Object> map) {
		
		List<FilesVo>  filesList  =  pdsDao.getFilesList( map );		
		return         filesList;
		
	}

	   @Override
	   public void boardDelete(HashMap<String, Object> map) {
	      
	      // 파일 정상 삭제시 카운트 증가
	      int success_cnt = 0;
	      
	      /*
	      // map:{board_idx=21} 해당 보드 인덱스의 파일 이름 가져오기
	      List<FilesVo>  filesList  =  pdsDao.getFilesList( map );

	      // 파일명 가지고 오고, 삭제까지 진행되는 반복문 
	      for (FilesVo filesVo : filesList) {
	         
	         String  delFile =  filesVo.getSfilename();
	         File  file  =  new File("c:\\upload\\" + delFile);
	         
	         if( file.exists() ) {
	            if(file.delete() == true) { // 파일 삭제가 정상이면
	               success_cnt += 1; // 성공여부 카운트 1 증가
	            }
	         }
	         
	      }
	      
	      // 파일삭제 정상일 때 디비 데이터 삭제 진행
	      if (success_cnt > 0) {
	         pdsDao.deleteFileData(map);
	         pdsDao.deleteBoardData(map);
	      }

	      */
	      
	      //pdsDao.deleteFileData(map);
	      pdsDao.deleteBoardData(map);
	   }
	
	@Override
	public void setUpdate(HashMap<String, Object> map) {
		// 1. request 넘어온 파일만 저장 : C:\\UPLOAD\\ 
		System.out.println("Pds Service setUpdate() map:" + map);
		
		pdsDao.setUpdate( map );
	}

	@Override
	public void deleteUploadedFile(
			HashMap<String, Object> map) {
		// map { file_num, sfilename }
		
		// 1. c:\\upload\\  에서 해당 파일 삭제
		String  sfilename  =  (String)  map.get("sfilename");
		String  filePath   =  "c:\\upload\\";
		File    file       =  new File(filePath + sfilename);
		if ( file.exists()  )
			file.delete();
		
		// 2. Files table 에서 file_num 에 해당하는 파일정보 삭제
		pdsDao.deleteUploadedFile( map ); // {file_num, sfilename}
		
	}

	@Override
	public void pdsInsert(PdsVo pdsVo) {
		pdsDao.pdsInsert( pdsVo );
		
	}

	@Override
	public void ImageUpload(PdsVo pdsVo,String imageFileName) {

		int boardIdx =  pdsDao.selectBoardIdx();
		pdsVo.setBoard_idx(boardIdx);
		int result = pdsDao.BoardImageUpload(pdsVo);

		System.out.println("ImageUpload pdsVo:"+pdsVo);
		if(result > 0){
			FilesVo filesVo = new FilesVo();
			filesVo.setboard_idx(boardIdx);
			filesVo.setFilename(pdsVo.getFile().getOriginalFilename());
			filesVo.setFileext(pdsVo.getFile().getContentType());
			filesVo.setSfilename(imageFileName);

			int result2  = pdsDao.FileImageUpload(filesVo);
		}

	}

	@Override
	public List<FilesVo> selectImage(PdsVo pdsVo) {
		return pdsDao.selectImage(pdsVo);
	}

	@Override
	public void setWrite(HashMap<String, Object> map) {
		
		pdsDao.setWrite( map );

	}
	@Override
	public List<CommentsVo> getCommentsList(int board_idx) {
		List<CommentsVo> CommentsList = pdsDao.getCommentsList(board_idx);
		return CommentsList;
	}

	@Override
	public void InputComments(Map<String, Object> map) {
		pdsDao.InputComments(map);
		
	}

	@Override
	public List<PdsVo> getHiBoardList(String moim_idx) {
		List<PdsVo> pdsVo = pdsDao.getHiBoardList(moim_idx);
		return pdsVo;
	}
}





