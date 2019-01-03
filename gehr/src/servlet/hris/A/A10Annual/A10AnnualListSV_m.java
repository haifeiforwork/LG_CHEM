package	servlet.hris.A.A10Annual;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.A10Annual.A10AnnualData;
import hris.A.A10Annual.rfc.A10AnnualAgreementRFC;
import hris.A.A10Annual.rfc.A10AnnualRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * A10AnnualListSV_m.java
 * 연봉계약을 조회 하고 연봉계약서를 볼수 있도록 하는 Class
 *(임원 용으로만 쓰게 용도 변경)
 * @author 박영락
 * @version 1.0, 2002/01/10
 *                    : 2016-03-09      [CSR ID:3006173] 임원 연봉계약서 Online화를 위한 시스템 구축 요청
 *                    : 2017-04-07      eunha [CSR ID:3348752] 임원 연봉계약 및 집행임원서약서 온라인 징구 관련 지원 요청의 건
 *                    : 2018-03-09	   cykim [CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件
 *                      2018-05-25  rdcamel //[CSR ID:3687969] 인사기록부상 해외법인명 한글병기 요청의 건
 */
public class A10AnnualListSV_m extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            HttpSession session = req.getSession(false);

            WebUserData user_m = WebUtil.getSessionMSSUser(req);
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            String dest   = "";
            String jobid  = "";    // 2개의 값 page처리시 page, 상세조회시 - search
            String page   = "";    //paging 처리
            String imgURL = "";    //image경로 설정

            jobid = box.get("jobid");
            page  = box.get("page");

            if( jobid.equals("") || page == null ) {
                jobid = "page";
            }

            if( page.equals("") || page == null ){ //페이지 설정
                page = "1";
            }
//          @웹취약성 추가
			if(!checkAuthorization(req, res)) return ;

            if ( user_m != null ) {

	            Logger.debug.println(this, "[jobid] = "+jobid + " [user_m] : "+user_m.toString()+"  servlet Page : " + page);

	            if( jobid.equals("page") ){
	            	//[CSR ID:3687969] 인사기록부상 해외법인명 한글병기 요청의 건
	               //Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualList( user_m.empNo );//사번, 현재날짜
	            	Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualListLong( user_m.empNo );
	//                    if ( A10AnnualData_vt.size() == 0 ) {
	//                        Logger.debug.println(this, "Data Not Found");
	//                        String msg = "msg004";
	//                        //String url = "history.back();";
	//                        req.setAttribute("msg", msg);
	//                        //req.setAttribute("url", url);
	//                        dest = WebUtil.JspURL+"common/caution.jsp";
	//                    } else {
	                req.setAttribute( "page", page );
	                req.setAttribute( "A10AnnualData_vt", A10AnnualData_vt );
	                dest = WebUtil.JspURL+"A/A10Annual/A10AnnualList_m.jsp";
	//                    }
	              //  }
	            } else if( jobid.equals("search") ) { //해당연도 데이타만을 받는다.
	                String ZYEAR = box.get("ZYEAR");
	                //temp
	                //ZYEAR = "2014";
	                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.A.A10Annual.A10AnnualListSV_m?jobid=print&ZYEAR="+ZYEAR );
	                dest = WebUtil.JspURL+"common/printFrame.jsp";
	                Logger.debug.println(this, WebUtil.ServletURL+"hris.A.A10Annual.A10AnnualListSV_m?jobid=print&ZYEAR="+ZYEAR );

	            } else if( jobid.equals("print") ) {
	                String ZYEAR = box.get("ZYEAR");
	                A10AnnualData a10AnnualData = new A10AnnualData();

	                Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualList( user_m.empNo );//사번, 현재날짜
	                for( int i = A10AnnualData_vt.size()-1; i >=0 ; i-- ){
	                    A10AnnualData data = (A10AnnualData)A10AnnualData_vt.get(i);
	                    if( ZYEAR.equals( data.ZYEAR ) ){
	                        a10AnnualData = data;
	                    }
	                }
	                req.setAttribute( "A10AnnualData_vt", A10AnnualData_vt );
	                req.setAttribute( "a10AnnualData", a10AnnualData );
	                req.setAttribute( "ZYEAR", ZYEAR );
	                Logger.debug.println(this, "a10AnnualData::"+ a10AnnualData.toString() );

	                if( (user_m.companyCode).equals("C100") ){ //test중
	                    //@v1.0 강찬진요청 07.06.21 년도별 년봉계약서의 이력관리를 하기로 함
	                    if(  Integer.parseInt(a10AnnualData.ZYEAR) >2007 ) {
	                    	// [CSR ID:3006173] 임원 연봉계약서 Online화를 위한 시스템 구축 요청
	                    	if(user_m.e_persk.equals("11")||user_m.e_persk.equals("12")){
	                    		//2017-04-07    eunha  [CSR ID:3348752] 임원 연봉계약 및 집행임원서약서 온라인 징구 관련 지원 요청의 건(URL오류수정) start
	                    		//dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/A20AnnualDetail.jsp&type=M";
	                    		dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/A20AnnualDetail.jsp?type=M";
	                    		//2017-04-07    eunha  [CSR ID:3348752] 임원 연봉계약 및 집행임원서약서 온라인 징구 관련 지원 요청의 건(URL오류수정) end
	                            imgURL = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/";
	                    	}else{//임원 연봉 계약서 용으로만 사용. 사무직 거도 쓰려면 이걸 바꿔야 함.
	                    		//2017-04-07    eunha  [CSR ID:3348752] 임원 연봉계약 및 집행임원서약서 온라인 징구 관련 지원 요청의 건(URL오류수정) start
	                    		//dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/A20AnnualDetail.jsp&type=M";
	                    		//dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/A20AnnualDetail.jsp?type=M";

	                    		//[CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件 start
	                    		dest = WebUtil.JspURL+"A/A10Annual/C100/"+a10AnnualData.ZYEAR+"/A10AnnualDetail.jsp?type=M";
		                        imgURL = WebUtil.JspURL+"A/A10Annual/C100/"+a10AnnualData.ZYEAR+"/";
	                    		//[CSR ID:3628833] 연봉계약서 조회 기능 개발 요청의 件 end

	                    		//2017-04-07    eunha  [CSR ID:3348752] 임원 연봉계약 및 집행임원서약서 온라인 징구 관련 지원 요청의 건(URL오류수정) end
		                        //imgURL = WebUtil.JspURL+"A/A10Annual/C100/"+a10AnnualData.ZYEAR+"/";
	                    		//req.setAttribute("msg", "임원 연봉계약서 조회 대상이 아닙니다.");
	                    		//dest = WebUtil.JspURL+"common/caution.jsp";
	                    		//printJspPage(req, res, dest);
	                    	}
	                    } else {
	                        dest = WebUtil.JspURL+"A/A10Annual/C100/A10AnnualDetail.jsp";
	                        imgURL = WebUtil.JspURL+"A/A10Annual/C100/";
	                    }
	                }/* else {
	                    if( (a10AnnualData.ZYEAR).equals("2001") ) {
	                        char compChar = (a10AnnualData.TRFGR).charAt(0);
	                        Logger.debug.println( this, "직급구분 첫문자 : "+compChar );
	                        if( compChar == 'Ⅰ' || compChar == 'Ⅱ' ){//LG석유 직급구분값.....
	                            dest = WebUtil.JspURL+"A/A10Annual/N100/A10AnnualDetail02.jsp";//간부
	                        } else {
	                            dest = WebUtil.JspURL+"A/A10Annual/N100/A10AnnualDetail.jsp";//사원
	                        }
	//                  2004년 연봉계약서의 경우 2004년 상세조회 리스트를 조회한다.
	                    } else if( (a10AnnualData.ZYEAR).equals("2004") ) {
	                        Vector A10AnnualDetail_vt = ( new A10AnnualRFC() ).getAnnualDetail( user.empNo );//사번, 현재날짜

	                        req.setAttribute( "A10AnnualDetail_vt", A10AnnualDetail_vt );

	                        dest = WebUtil.JspURL+"A/A10Annual/N100/A10AnnualDetail04.jsp";
	                    } else {
	                        dest = WebUtil.JspURL+"A/A10Annual/N100/A10AnnualDetail.jsp";
	                    }
	                    imgURL = WebUtil.JspURL+"A/A10Annual/N100/";
	                }*/

	            }
	            else if( jobid.equals("agree") ) { //@v1.0 07.06.21합의 버튼 클릭시
	                String ZYEAR = box.get("I_YEAR");

	                A10AnnualData a10AnnualData = new A10AnnualData();

	                Vector A10AnnualData_vt = ( new A10AnnualRFC() ).getAnnualList( user_m.empNo );//사번, 현재날짜
	                for( int i = A10AnnualData_vt.size()-1; i >=0 ; i-- ){
	                    A10AnnualData data = (A10AnnualData)A10AnnualData_vt.get(i);
	                    if( ZYEAR.equals( data.ZYEAR ) ){
	                        a10AnnualData = data;
	                    }
	                }
	                req.setAttribute( "a10AnnualData", a10AnnualData );
	                req.setAttribute( "A10AnnualData_vt", A10AnnualData_vt );
	                req.setAttribute( "ZYEAR", ZYEAR );

	                //합의저장
	                Vector              ret            = new Vector();

	                ret = ( new A10AnnualAgreementRFC() ).getAnnualAgreeYn( user_m.empNo ,"2",ZYEAR,user_m.companyCode );

	                String AGRE_FLAG = (String)ret.get(0);
	                String E_BETRG = (String)ret.get(1);
	                String msg = "";

	                if(AGRE_FLAG.equals("Y")){
		                msg = "연봉계약 합의가 완료되었습니다.";
	                }else{
	                	msg = "처리 실패입니다.";
	                }

	                req.setAttribute("msg", msg);


	                //@v1.0 강찬진요청 07.06.21 년도별 년봉계약서의 이력관리를 하기로 함
	                if(  Integer.parseInt(a10AnnualData.ZYEAR) >2007  ) {
	                	if(user_m.e_persk.equals("11")||user_m.e_persk.equals("12")){
	                		// [CSR ID:3006173] 임원 연봉계약서 Online화를 위한 시스템 구축 요청
	                		dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/A20AnnualDetail.jsp?type=M";
	                        imgURL = WebUtil.JspURL+"A/A20AnnualBoard/C100/"+a10AnnualData.ZYEAR+"/";
	                	}else{
		                    //dest = WebUtil.JspURL+"A/A10Annual/C100/"+a10AnnualData.ZYEAR+"/A10AnnualDetail.jsp";
		                    //imgURL = WebUtil.JspURL+"A/A10Annual/C100/"+a10AnnualData.ZYEAR+"/";
	                		req.setAttribute("msg", "임원 연봉계약서 조회 대상이 아닙니다.");
	                		dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/A20AnnualDetail.jsp?type=M";
                    		printJspPage(req, res, dest);
	                	}
	                }// else {
	                  //  dest = WebUtil.JspURL+"A/A10Annual/C100/A10AnnualDetail.jsp";
	                  //  imgURL = WebUtil.JspURL+"A/A10Annual/C100/";
	               // }

	            }
            }else{
	           	 req.setAttribute( "a10AnnualData", null );
	           	 dest = WebUtil.JspURL+"A/A20AnnualBoard/C100/A20AnnualDetail.jsp?type=M";
	             imgURL = WebUtil.JspURL+"A/A20AnnualBoard/C100/";
           }
            req.setAttribute( "imgURL", imgURL );
            Logger.debug.println( this, " destributed = " + dest );
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}