/**
 * June-26 Friday
 * 사업가 후보 Presentation System.
 * marco257
 * update 2017-10-19 eunha  [CSR ID:3504688] Global Academy 교육이력 I/F 관련 요청
 *
 */
package servlet.hris.N.bsnrmd;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;

import hris.C.C03LearnDetailData;
import hris.C.db.C03LearnDetailDB;
import hris.C.db.C03MapPernrData;
import hris.N.AES.AESgenerUtil;
import hris.N.EHRComCRUDInterfaceRFC;
import hris.common.MappingPernrData;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import servlet.hris.C.C03LearnDetailSV;

import java.util.HashMap;
import java.util.Vector;

public class BusinRecommendPTSV   extends  EHRBaseServlet {


	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String searchPrsn = box.get("searchPrsn");

//         암호화 -> 복호화 작업 2015-07-27

    		searchPrsn                =  AESgenerUtil.decryptAES(searchPrsn, req);

            String I_ORGEH = box.get("I_ORGEH");
            EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
           	String functionName = "ZGHR_RFC_GET_PSINFO";


        	//담당자 리스트
        	box.put("I_PERNR",searchPrsn);
        	String command = WebUtil.nvl(box.get("command"));


        	String dest = WebUtil.JspURL+"N/bsnrmd/devel_hr_tab01_p.jsp";
        	String reField ="RETURN";
        	if(command.equals("SUP")){
        		functionName="ZGHR_RFC_GET_PSINFO2";
        		reField = "E_HIRDT";
        		dest = WebUtil.JspURL+"N/bsnrmd/devel_hr_tab02_p.jsp";
        	}else if(command.equals("CDP")){ //도표 확인 하기
        		functionName="ZGHR_RFC_GET_PSINFO2";
        		box.put("I_GRAPH","X");

        		reField = "E_HIRDT";
        		dest = WebUtil.JspURL+"N/bsnrmd/cdpchart.jsp";
        	}else if(command.equals("PST")){

        		box.put("I_ORGEH",I_ORGEH);
        		functionName="ZGHR_RFC_GET_PSINFO3";
        		reField = "E_ORGTX";
        		dest = WebUtil.JspURL+"N/bsnrmd/devel_hr_tab03_p.jsp";
        	}else if(command.equals("G")){
        		box.put("I_ORGEH",I_ORGEH);
        		functionName="ZGHR_RFC_GET_PSINFO3";
        		reField = "E_ORGTX";
        		dest = WebUtil.JspURL+"N/bsnrmd/BusinGradeView_p.jsp";
        	}
//        	Logger.debug("I_ORGEH >>>>>>>>>> "+ I_ORGEH );
//        	Logger.debug("functionName >>>>>>>>>> "+ functionName );
//        	Logger.debug("reField >>>>>>>>>> "+ reField );
            HashMap resultVT = comRFC.getExecutAllTable(box, functionName, reField);
            req.setAttribute("resultVT", resultVT);
            // [CSR ID:3504688] Global Academy 교육이력 I/F 관련 요청  start
            if(command.equals("SUP")){
            /*
             * 1) 사업가 후보 정보 조회
   					- 핵심인재관리 마스터 내 장기연수파견,연구소학위파견,지역전문가
   					  - SORT :  시작일 DESCENDING
				2) 교육이력 조회 (3개년 이력 조회)
        			I_BEGDA = YYYY(현재년도-3') MMDD(0101) => (ex:20140101)
        			I_ENDDA = '현재일자' (ex:20171001)
  				- 데이터 조건 :  결과 데이터 중 온라인 교육이력 제외
  				- SORT :  종료일 > 시작일 DESCENDING

				3) 결과 조회 기준
  					-  1) + 2) 전체 기준 최신 일정순으로 정렬 (종료일>시작일 DESCENDING )
  					- '1) 사업가후보정보 조회' 건수 포함  MAX 10건임
          				( 10건 초과하는  '2) 교육이력 '건은 삭제 )
          				SORT : 1) + 2) 전체 기준 최신 일정순으로 정렬 (시작일 > 종료일 DESCENDING )
             */
            String curDate = DataUtil.getCurrentDate();
            C03LearnDetailDB c03LearnDetailDB=   new C03LearnDetailDB();
            String I_BEGDA = WebUtil.printDate("19000101");
            String I_ENDDA = WebUtil.printDate(curDate);
            //C03MapPernrData c03MapPernrData = C03LearnDetailSV.getMapPernr(g,  searchPrsn,  I_BEGDA);
            //Vector<C03LearnDetailData> resultList = c03LearnDetailDB.getTrainingList(c03MapPernrData.PERNR, c03MapPernrData.BEGDA, I_ENDDA);
            Vector<C03LearnDetailData> resultList = c03LearnDetailDB.getTrainingList(searchPrsn ,I_BEGDA, I_ENDDA);
            resultList = SortUtil.sort( resultList, "ENDDA, BEGDA", "desc,desc" ); //Vector Sort
            Logger.debug.println("resultList======"+resultList);


           //교육이력 데이타 다시 만들기 (sap)
            Vector<C03LearnDetailData> resultList_vt = new Vector();
            Vector edulVT = (Vector)resultVT.get("T_EDU");
            HashMap<String, String> eduinfo = new HashMap<String, String>();
            for(int k = 0 ; k < edulVT.size() ; k++){
            	C03LearnDetailData c03LearnDetailData = new C03LearnDetailData();
            	eduinfo  = (HashMap)edulVT.get(k);
            	c03LearnDetailData.DVSTX  = eduinfo.get("STEXT_D");
            	c03LearnDetailData.PERIOD  = eduinfo.get("PERIOD");
            	c03LearnDetailData.TESTX    = eduinfo.get("MC_STEXT");
            	c03LearnDetailData.BEGDA    = eduinfo.get("BEGDA");
            	c03LearnDetailData.ENDDA    = eduinfo.get("ENDDA");
            	resultList_vt.add(c03LearnDetailData);
            }


            //교육이력 데이타 다시 만들기 (글로벌아카데키)
            int listCnt = edulVT.size();

            for(int k = 0 ; k < resultList.size() ; k++){
            	C03LearnDetailData c03LearnDetailData = (C03LearnDetailData)resultList.get(k);
            	if (!c03LearnDetailData.TFORM.equals("ON-LINE") &&c03LearnDetailData.STATE_ID.equals("Y") && listCnt<10){
            		Logger.debug.println("k======"+k);
            		Logger.debug.println("listCnt======"+listCnt);
            		Logger.debug.println(k+edulVT.size());
            		Logger.debug.println(c03LearnDetailData);
            		resultList_vt.add(c03LearnDetailData);
            		listCnt = listCnt+1;
            	}
            }


            resultList_vt =  SortUtil.sort( resultList_vt, "BEGDA,ENDDA", "desc,desc" ); //Vector Sort
            Logger.debug.println("resultList_vt======"+resultList_vt);
            req.setAttribute("resultList_vt", resultList_vt);
            }
            //[CSR ID:3504688] Global Academy 교육이력 I/F 관련 요청 end
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}