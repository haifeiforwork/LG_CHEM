/********************************************************************************/
/*
/*   Program Name : 모바일 인사정보 조회
/*   Program ID   : A01MbSelfDetailNeoSV_m
/*   Description  : 모발일에서 조회 사번을 받아서 인사정보 DATA Return
/*   Note         : 최초작성 [CSR ID:2991671] g-mobile 내 인사정보 조회 기능 추가 개발 요청
/*   Creation     : 2015-12-07
/*   Update       : 2016/02/23 [CSR ID:2992953] g-mobile 內 인사정보조회 관련 수정사항 반영
/*   Update       : 2017/02/16 [CSR ID:3302951] G Mobile 內 HR info 화면 오류 내역 수정 요청의 건
/*   Update       : 2017/07/18 eunha [CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항
/********************************************************************************/

package servlet.hris.N.mssperson;

import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.*;
import hris.A.rfc.*;
import hris.B.B01ValuateDetailData;
import hris.B.rfc.B01ValuateDetailCheckRFC;
import hris.B.rfc.B01ValuateDetailRFC;
import hris.C.C05FtestResult1Data;
import hris.C.rfc.C05FtestResultRFC2;
import hris.common.MappingPernrData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.GetMobileMSSAuthCheckRFC;
import hris.common.rfc.GetPhotoURLRFC;
import hris.common.rfc.MappingPernrRFC;
import hris.common.rfc.PersonInfoRFC;
import org.jdom.Document;
import org.jdom.Element;
import servlet.hris.MobileAutoLoginSV;
import servlet.hris.MobileCommonSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

public class A01SelfDetailMbNeoSV_m extends MobileAutoLoginSV {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

    	try{

        	Logger.debug.println("A01MbSelfDetailNeoSV_m start++++++++++++++++++++++++++++++++++++++" );

        	//로그인처리
        	MobileCommonSV mc = new MobileCommonSV() ;
        	mc.autoLogin(req,res);

            String dest  = "";

            // 결재처리 결과값
            String returnXml = HRInfo(req,res);

            // 결과에 대한 xmlStirng을  저장한다.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);
            Logger.debug.println("A01MbSelfDetailNeoSV_m returnXml++++++++++++++++++++++++++++++++++++++"+returnXml );
            // 3.return URL을 호출한다.
            dest = WebUtil.JspURL+"common/mobileResult.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res,dest );

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
    }

    /**
     * 인사정보를 XML형태로 가져온다.
     * @return
     */
    public String HRInfo( HttpServletRequest req, HttpServletResponse res){

    	Element envelope = null;

        String xmlString = "";
        String itemsName = "HRInfo";

        String errorCode = "";
        String errorMsg = "";

        try{
        	Logger.debug.println("A01MbSelfDetailNeoSV_m HRInfo Strart++++++++++++++++++++++++++++++++++++++" );

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            WebUserData user_m  = null;

            Box box = WebUtil.getBox(req);

            // 1.Envelop XML을 생성한다.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML을 생성한다.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE 를 생성한다.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.결과값을 생성한다.
            Element items = XmlUtil.createItems(itemsName);


            String empNo_m = box.get("empNo_m"); //사번

            if(empNo_m.equals("")){
            	empNo_m = user.empNo; // 검색 사번이 없을 경우 본인 사번으로 대체한다.
            }else{
            	empNo_m = EncryptionTool.decrypt(empNo_m);
            	empNo_m = DataUtil.fixEndZero( empNo_m ,8);
            }

    		//2. 웹보안진단 marco257
    		box.put("I_DEPT", user.empNo); //로그인 사번
        	box.put("I_PERNR", empNo_m);   // 조회사번
        	box.put("I_RETIR", ""); //재직자만 조회됨 - 기존 로직

           	/*String functionName = "ZHRA_RFC_CHECK_BELONG2";

        	EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
	    	String reCode = comRFC.setImportInsert(box, functionName, "RETURN");*/
            String mbAuth = (new GetMobileMSSAuthCheckRFC()).getMbMssAuthChk(user.empNo);

            boolean isBelong = checkBelongPerson(req, res, empNo_m, box.get("I_RETIR"));

            //권한 체크
            if(mbAuth.equals("Y")){
    	    	if(isBelong){ //조회 가능
    	    		SetUserSession(empNo_m, req);
    	    		user_m  = (WebUserData)session.getAttribute("user_m");
    	    		errorCode = "0";
    	            errorMsg  = "success";
    	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
    	    	}else{
    	    		//1.검색권한 없음
    		    	errorCode = "1";
    	            errorMsg  = "검색권한 없음";
    	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
    	            return xmlString;
    	    	}
    	    	//@웹취약성 추가
                if ( user.e_authorization.equals("E")) {
                	//1.검색권한 없음
    		    	errorCode = "1";
    	            errorMsg  = "검색권한 없음";
    	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
    	            return xmlString;
                }

            }else{
            	errorCode = "1";
	            errorMsg  = "검색권한 없음";
	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	            return xmlString;
            }//권한 체크 종료

	    	/*
	    	 * 아래부분 지워야 함 test 용!!!!
	    	 *
	    	 */
	    	//user.empNo = "00206319";
	    	//empNo_m = "00028213";
	    	//isBelong=true;

	    	if(isBelong){ //조회 가능
	    		SetUserSession(empNo_m, req);
	    		user_m  = (WebUserData)session.getAttribute("user_m");
	    	}else{
	    		//1.검색권한 없음
		    	errorCode = "1";
	            errorMsg  = "검색권한 없음";
	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	            return xmlString;
	    	}


	    	//@웹취약성 추가
            if ( user.e_authorization.equals("E")) {
            	//1.검색권한 없음
		    	errorCode = "1";
	            errorMsg  = "검색권한 없음";
	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	            return xmlString;
            }


            String imgUrl ="";
            GetPhotoURLRFC      photofunc = null;  // 사진
            A01SelfDetailRFC    funcA01  = null;  // 개인사항
//            A08LicenseDetailRFC funcA08 = null;  // 자격사항
            A02SchoolDetailRFC  funcA02 = null;  // 학력사항
            A04FamilyDetailRFC  funcA04 = null;  // 가족사항
            Vector a01SelfDetailData_vt   = new Vector();
            Vector a08LicenseDetail_vt    = new Vector();
            Vector a02SchoolData_vt       = new Vector();
            Vector a04FamilyDetailData_vt = new Vector();
            A01SelfDetailData dataA01   	  = null;

	        // 사진링크
            photofunc = new GetPhotoURLRFC();
            imgUrl = photofunc.getPhotoURL( user_m.empNo );

            // A01SelfDetailRFC 개인인적사항 조회
            funcA01 = new A01SelfDetailRFC();
            // [CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18 start
            //a01SelfDetailData_vt = funcA01.getPersInfo(user_m.empNo, user.area.getMolga(), "");
            a01SelfDetailData_vt = funcA01.getPersInfoM(user_m.empNo, user.area.getMolga(), "");
            // [CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18 end
            if (a01SelfDetailData_vt != null && a01SelfDetailData_vt.size() > 0 ) {
            	dataA01 = (A01SelfDetailData)a01SelfDetailData_vt.get(0);
            }

            // 0:성공 1.검색권한 없음, 2.동일이름으로 여러명 있음 3.결과 없음 99.시스템 에러
            if (true) {

            	XmlUtil.addChildElement(items, "returnCode", "0");
				XmlUtil.addChildElement(items, "returnDesc", "success");
			}else{
				//3.결과 없음
		    	errorCode = "3";
	            errorMsg  = "조회 결과가 없습니다.";
	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	            return xmlString;
			}

	        Element item = XmlUtil.createElement("A01SelfDetailData");

	        XmlUtil.addChildElement(item, "IMAGEURL", imgUrl);  			// 사진링크
	        XmlUtil.addChildElement(item, "ORGTX", dataA01.ORGTX);  		// 팀명
	        XmlUtil.addChildElement(item, "KNAME", dataA01.ENAME);  		// 한글이름
	     // [CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18 start
	        //XmlUtil.addChildElement(item, "TITEL", dataA01.JIKWT);  		// 직위
	        XmlUtil.addChildElement(item, "TITEL", dataA01.JIK_M);  		// 직위
	     // [CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18 end
	        XmlUtil.addChildElement(item, "GBDAT", dataA01.GBDAT);  		// 생년월일
	        XmlUtil.addChildElement(item, "DAT02", dataA01.DAT01);  		// 그룹입사일    DAT01
	        XmlUtil.addChildElement(item, "DAT03", dataA01.DAT02);  		// 자사입사일    DAT02
	        XmlUtil.addChildElement(item, "TITL2", dataA01.JIKKT);  		// 직책
	        XmlUtil.addChildElement(item, "VGLST", dataA01.VGLST);  		// 직급/연차

            /*DAT01	ZEHRDAT01	DATS	8	0	그룹입사일
            DAT02	ZEHRDAT02	DATS	8	0	회사입사일
            DAT03	ZEHRDAT03	DATS	8	0	현직위승진일*/
            XmlUtil.addChildElement(items, item);

            // 학력사항
            funcA02 = new A02SchoolDetailRFC();
            a02SchoolData_vt = funcA02.getSchoolDetail(user_m.empNo, user_m.area.getMolga(), "");

            for ( int i = 0 ; i < a02SchoolData_vt.size() ; i++ ) {
            	A02SchoolData dataA02 = (A02SchoolData)a02SchoolData_vt.get(i);

            	item = XmlUtil.createElement("A02SchoolData");

            	XmlUtil.addChildElement(item, "LART_TEXT", dataA02.SCHTX);    	//학교명
            	XmlUtil.addChildElement(item, "FTEXT", dataA02.SLTP1X);    			//전공
            	XmlUtil.addChildElement(item, "PERIOD", dataA02.PERIOD);    		//기간
            	XmlUtil.addChildElement(item, "SLART_TEXT", dataA02.SLATX);    		//구분



            	XmlUtil.addChildElement(items, item);
            }


            // 가족사항
            funcA04 = new A04FamilyDetailRFC();
            a04FamilyDetailData_vt = funcA04.getFamilyDetail(box) ;
            Logger.debug.println(this, "a04FamilyDetailData_vt : "+ a04FamilyDetailData_vt.toString());

            for ( int i = 0 ; i < a04FamilyDetailData_vt.size() ; i++ ) {
                A04FamilyDetailData dataA04 = (A04FamilyDetailData)a04FamilyDetailData_vt.get(i);

            	item = XmlUtil.createElement("A04FamilyDetailData");
            	XmlUtil.addChildElement(item, "STEXT", dataA04.STEXT);   // 유형
            	XmlUtil.addChildElement(item, "LNMHG", dataA04.LNMHG);   // 이름(성)
            	XmlUtil.addChildElement(item, "FNMHG", dataA04.FNMHG);   // 이름(명)
            	XmlUtil.addChildElement(item, "FGBDT", dataA04.FGBDT);   // 생년월일
            	XmlUtil.addChildElement(item, "FAJOB", dataA04.FAJOB);   // 직업

            	XmlUtil.addChildElement(items, item);

            }

            // 발령
            Vector A05AppointDetail1Data_vt = new Vector() ;
            A05AppointDetail1RFC funcA051 = null ;

            MappingPernrRFC  mapfunc = null ;
            MappingPernrData mapData = new MappingPernrData();
            Vector mapData_vt = new Vector() ;
            Vector appData1_vt = new Vector() ;

            mapfunc = new MappingPernrRFC() ;
            mapData_vt = mapfunc.getPernr( user_m.empNo ) ;

            A05AppointDetail1Data dataA051 = new A05AppointDetail1Data();



            if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    // AppointDetail1 - ZHRA_RFC_GET_IT0000_ETC - 발령
                    funcA051 = new A05AppointDetail1RFC() ;
                    appData1_vt = funcA051.getAppointDetail1M( mapData.PERNR, "" ) ;
                    appData1_vt = SortUtil.sort( appData1_vt, "BEGDA", "desc" );

                    for( int j = 0 ; j < appData1_vt.size() ; j++ ) {
                        dataA051 = (A05AppointDetail1Data)appData1_vt.get(j);

                    	item = XmlUtil.createElement("A05AppointDetail1Data");
                    	XmlUtil.addChildElement(item, "MNTXT", dataA051.MNTXT);      // 발령유형
                    	XmlUtil.addChildElement(item, "BEGDA", dataA051.BEGDA);      // 발령일자
                    	XmlUtil.addChildElement(item, "ORGTX", dataA051.ORGTX);      // 소속
                    	// [CSR ID:3302951] G Mobile 內 HR info 화면 오류 내역 수정 요청의 건 begin
                    	//XmlUtil.addChildElement(item, "TITEL", dataA051.JIKWE);      // 직위코드
                    	// [CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18 start
                    	//XmlUtil.addChildElement(item, "TITEL", dataA051.JIKWT);      // 직위
                    	XmlUtil.addChildElement(item, "TITEL", dataA051.JIK_M);      // 직위
                    	// [CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18 end
                    	// [CSR ID:3302951] G Mobile 內 HR info 화면 오류 내역 수정 요청의 건 end

                    	XmlUtil.addChildElement(items, item);

                    }

                }

            } else {
                // AppointDetail1 - ZHRA_RFC_GET_IT0000_ETC - 발령
                funcA051 = new A05AppointDetail1RFC() ;
                A05AppointDetail1Data_vt = funcA051.getAppointDetail1( user_m.empNo, "" ) ;

                for( int j = 0 ; j < A05AppointDetail1Data_vt.size() ; j++ ) {
                    dataA051 = (A05AppointDetail1Data)A05AppointDetail1Data_vt.get(j);

                    item = XmlUtil.createElement("A05AppointDetail1Data");
                	XmlUtil.addChildElement(item, "MNTXT", dataA051.MNTXT);      // 발령유형
                	XmlUtil.addChildElement(item, "BEGDA", dataA051.BEGDA);      // 발령일자
                	XmlUtil.addChildElement(item, "ORGTX", dataA051.ORGTX);      // 소속
                	// [CSR ID:3302951] G Mobile 內 HR info 화면 오류 내역 수정 요청의 건 begin
                	//XmlUtil.addChildElement(item, "TITEL", dataA051.JIKWE);      // 직위코드
                	// [CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18 start
                	//XmlUtil.addChildElement(item, "TITEL", dataA051.JIKWT);      // 직위
                	XmlUtil.addChildElement(item, "TITEL", dataA051.JIK_M);      // 직위
                	// [CSR ID:3436191] G Mobile 인사정보 메뉴 수정사항  eunha 2017-07-18 end
                	// [CSR ID:3302951] G Mobile 內 HR info 화면 오류 내역 수정 요청의 건 end

                	XmlUtil.addChildElement(items, item);
                }

            }


            //평가
            B01ValuateDetailRFC funcB01 = null ;
            B01ValuateDetailCheckRFC funcB01Check =  new B01ValuateDetailCheckRFC() ;
            Vector B01ValuateDetailData_vt = new Vector();
            Vector detailData_vt = new Vector() ;
            String checkYn = "";

            //// 재입사자 사번을 가져오는 RFC - 2004.11.19 YJH

            checkYn = funcB01Check.getValuateDetailCheck(user.empNo, user_m.empNo, "A01", "M");//CSR ID:2703351 평가의 경우 A를 구분자로 줌.

            if( checkYn.equals("Y")){//20141125 권한여부 check [CSR ID:2651528] 인사권한 추가 및 메뉴조회 기능 변경
                if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // 재입사자 처리
                    B01ValuateDetailData dataB01 = new B01ValuateDetailData();

                    for ( int i=0; i < mapData_vt.size(); i++) {
                        mapData = (MappingPernrData)mapData_vt.get(i);

                        funcB01 = new B01ValuateDetailRFC() ;
                        detailData_vt = funcB01.getValuateDetail( mapData.PERNR ,"Y",user_m.empNo, "", null) ;

                        for( int j = 0 ; j < detailData_vt.size() ; j++ ) {
                        	dataB01 = (B01ValuateDetailData)detailData_vt.get(j);
                            item = XmlUtil.createElement("B01ValuateDetailData");

                            XmlUtil.addChildElement(item, "YEAR1", dataB01.YEAR1);         // 년도
                            XmlUtil.addChildElement(item, "ORGTX", dataB01.ORGTX);         // 근무부서
                            XmlUtil.addChildElement(item, "RTEXT1", dataB01.RTEXT1);       // 평가
                            XmlUtil.addChildElement(item, "BOSS_NAME", dataB01.BOSS_NAME); // 평가자

                            XmlUtil.addChildElement(items, item);
                        }
                    }

                } else {
                    // ValuateDetail - ZHRD_RFC_APPRAISAL_LIST - 평가 사항
                	funcB01 = new B01ValuateDetailRFC() ;
                    B01ValuateDetailData_vt = funcB01.getValuateDetail( user_m.empNo,"Y",user_m.empNo, "", null ) ;
                    B01ValuateDetailData dataB01 = new B01ValuateDetailData();

                    for( int j = 0 ; j < B01ValuateDetailData_vt.size() ; j++ ) {
                    	dataB01 = (B01ValuateDetailData)B01ValuateDetailData_vt.get(j);

                    	item = XmlUtil.createElement("B01ValuateDetailData");

                        XmlUtil.addChildElement(item, "YEAR1", dataB01.YEAR1);         // 년도
                        XmlUtil.addChildElement(item, "ORGTX", dataB01.ORGTX);         // 근무부서
                        XmlUtil.addChildElement(item, "RTEXT1", dataB01.RTEXT1);       // 평가
                        XmlUtil.addChildElement(item, "BOSS_NAME", dataB01.BOSS_NAME); // 평가자

                        XmlUtil.addChildElement(items, item);
                    }

                }
            }else{
//            	retnMsg = "해당 권한이 없습니다.";
            }


            //어학  ZHRE_RFC_LANGUAGE_ABILITY2
            C05FtestResultRFC2 funcC05= null;
            Vector c05FtestResult1Data_vt = new Vector();
            Vector ftestData_vt = new Vector() ;

            if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // 재입사자 처리
                C05FtestResult1Data dataC05 = new C05FtestResult1Data();

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    funcC05 = new C05FtestResultRFC2() ;
                    ftestData_vt = funcC05.getFtestResult( mapData.PERNR, "1");  // 어학능력

                    for( int j = 0 ; j < ftestData_vt.size() ; j++ ) {
                    	dataC05 = (C05FtestResult1Data)ftestData_vt.get(j);

                    	item = XmlUtil.createElement("c05FtestResult1Data");

                    	XmlUtil.addChildElement(item, "LANG_TYPE", dataC05.LANG_TYPE);   // 시험구분
                    	XmlUtil.addChildElement(item, "BEGDA", dataC05.BEGDA);       	 // 검정일
                    	XmlUtil.addChildElement(item, "STEXT", dataC05.STEXT);   // 시험명
                    	XmlUtil.addChildElement(item, "TOTL_SCOR", dataC05.TOTL_SCOR);   // TOTAL점수

	                	XmlUtil.addChildElement(items, item);

                    }
                }

            } else {
            	funcC05 = new C05FtestResultRFC2();
                c05FtestResult1Data_vt = funcC05.getFtestResult(user_m.empNo, "1");  // 어학능력
                C05FtestResult1Data dataC05 = new C05FtestResult1Data();

                for( int j = 0 ; j < c05FtestResult1Data_vt.size() ; j++ ) {
                	dataC05 = (C05FtestResult1Data)c05FtestResult1Data_vt.get(j);

                	item = XmlUtil.createElement("c05FtestResult1Data");

                	XmlUtil.addChildElement(item, "LANG_TYPE", dataC05.LANG_TYPE);   // 시험구분
                	XmlUtil.addChildElement(item, "BEGDA", dataC05.BEGDA);       	 // 검정일
                	XmlUtil.addChildElement(item, "STEXT", dataC05.STEXT);   // 시험명
                	XmlUtil.addChildElement(item, "TOTL_SCOR", dataC05.TOTL_SCOR);   // TOTAL점수

                	XmlUtil.addChildElement(items, item);

                }
            }

            //육성
            //TODO
            A10RaiseResultRFC funcA10 = null ;
            Vector A10RaiseResultData_vt = new Vector() ;
            Vector RsResultData_vt = new Vector() ;

            if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // 재입사자 처리
            	A10RaiseResultData dataA10 = new A10RaiseResultData();

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    funcA10 = new A10RaiseResultRFC() ;
                    RsResultData_vt = funcA10.getRaise(mapData.PERNR);

                    for( int j = 0 ; j < RsResultData_vt.size() ; j++ ) {
                    	dataA10 = (A10RaiseResultData)RsResultData_vt.get(j);

                    	item = XmlUtil.createElement("a10RaiseResultData");

                    	XmlUtil.addChildElement(item, "STEXT", dataA10.STEXT);   // 구분
                    	XmlUtil.addChildElement(item, "ENDDA", dataA10.ENDDA);       	 // 검정일
                    	XmlUtil.addChildElement(item, "BEGDA", dataA10.BEGDA);   // 인정점수 FLAG
                    	XmlUtil.addChildElement(item, "RES_DEVE", dataA10.RES_DEVE);   // TOTAL점수
                    	XmlUtil.addChildElement(item, "LANDX", dataA10.LANDX);   // 등급

	                	XmlUtil.addChildElement(items, item);

                    }
                }

            } else {
            	funcA10 = new A10RaiseResultRFC() ;
            	A10RaiseResultData_vt = funcA10.getRaise(mapData.PERNR);
            	A10RaiseResultData dataA10 = new A10RaiseResultData();

                for( int j = 0 ; j < A10RaiseResultData_vt.size() ; j++ ) {
                	dataA10 = (A10RaiseResultData)A10RaiseResultData_vt.get(j);

                	item = XmlUtil.createElement("a10RaiseResultData");

                	XmlUtil.addChildElement(item, "STEXT", dataA10.STEXT);   // 구분
                	XmlUtil.addChildElement(item, "ENDDA", dataA10.ENDDA);       	 // 검정일
                	XmlUtil.addChildElement(item, "BEGDA", dataA10.BEGDA);   // 인정점수 FLAG
                	XmlUtil.addChildElement(item, "RES_DEVE", dataA10.RES_DEVE);   // TOTAL점수
                	XmlUtil.addChildElement(item, "LANDX", dataA10.LANDX);   // 등급

                	XmlUtil.addChildElement(items, item);

                }
            }

          //징계
            A07PunishResultRFC funcA07 = null;
            Vector PunishData_vt = new Vector();
            Vector puData_vt = new Vector() ;

            checkYn = funcB01Check.getValuateDetailCheck(user.empNo, user_m.empNo,"A02", "M");//CSR ID:2703351 포상/징계의 경우 B를 구분자로 줌.

	        if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // 재입사자 처리

                A07PunishResultData dataA07 = new A07PunishResultData();

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    funcA07 = new A07PunishResultRFC() ;
//                    puData_vt = funcA07.getPunish( mapData.PERNR, checkYn); -> tab check로 변경
                    puData_vt = funcA07.getPunish( mapData.PERNR, "");

                    for( int j = 0 ; j < puData_vt.size() ; j++ ) {
                    	dataA07 = (A07PunishResultData)puData_vt.get(j);

                    	item = XmlUtil.createElement("A07PunishResultData");

                    	XmlUtil.addChildElement(item, "PUNTX", dataA07.PUNTX);       // 징계유형(text)[CSR ID:2992953]
                    	XmlUtil.addChildElement(item, "BEGDA", dataA07.BEGDA);       // 시작일
                    	XmlUtil.addChildElement(item, "ENDDA", dataA07.ENDDA);       // 종료일
                    	XmlUtil.addChildElement(item, "PUNRS", dataA07.PUNRS);       // 징계내역

	                	XmlUtil.addChildElement(items, item);
                    }
                }

            } else {

                funcA07 = new A07PunishResultRFC() ;
                PunishData_vt = funcA07.getPunish(user_m.empNo, "");

                A07PunishResultData dataA07 = new A07PunishResultData();

                for( int j = 0 ; j < PunishData_vt.size() ; j++ ) {
                	dataA07 = (A07PunishResultData)PunishData_vt.get(j);

                	item = XmlUtil.createElement("A07PunishResultData");

                	XmlUtil.addChildElement(item, "PUNTY", dataA07.PUNTY);       // 징계유형
                	XmlUtil.addChildElement(item, "BEGDA", dataA07.BEGDA);       // 시작일
                	XmlUtil.addChildElement(item, "ENDDA", dataA07.ENDDA);       // 종료일
                	XmlUtil.addChildElement(item, "PUNRS", dataA07.PUNRS);       // 징계내역

                	XmlUtil.addChildElement(items, item);
                }
            }

	        //김불휘
	        //경력사항
	        A09CareerDetailRFC funcA09 = null;
            Vector CareerData_vt = new Vector();
            Vector carData_vt = new Vector() ;

	        if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // 재입사자 처리

	        	A09CareerDetailData dataA09 = new A09CareerDetailData();

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    funcA09 = new A09CareerDetailRFC() ;
                    carData_vt = funcA09.getCareerDetail( mapData.PERNR,"" );

                    for( int j = 0 ; j < carData_vt.size() ; j++ ) {
                    	dataA09 = (A09CareerDetailData)carData_vt.get(j);

                    	item = XmlUtil.createElement("A09CareerDetailData");
                    	XmlUtil.addChildElement(item, "BEGDA", dataA09.BEGDA);       // 시작일
                    	XmlUtil.addChildElement(item, "ENDDA", dataA09.ENDDA);       // 종료일
                    	XmlUtil.addChildElement(item, "TOTAL", dataA09.PERIOD);       // 근무기간
                    	XmlUtil.addChildElement(item, "ARBGB", dataA09.ARBGB);		// 근무처
                    	XmlUtil.addChildElement(item, "TITL_TEXT", dataA09.JIKWT);		// 직위
                    	XmlUtil.addChildElement(item, "JOBB_TEXT", dataA09.STLTX);		// 직무

	                	XmlUtil.addChildElement(items, item);
                    }
                }

            } else {

                funcA09 = new A09CareerDetailRFC() ;
                CareerData_vt = funcA09.getCareerDetail( user_m.empNo, "" );

                A09CareerDetailData dataA09 = new A09CareerDetailData();

                for( int j = 0 ; j < CareerData_vt.size() ; j++ ) {
                	dataA09 = (A09CareerDetailData)CareerData_vt.get(j);

                	item = XmlUtil.createElement("A09CareerDetailData");

                	XmlUtil.addChildElement(item, "BEGDA", dataA09.BEGDA);       // 시작일
                	XmlUtil.addChildElement(item, "ENDDA", dataA09.ENDDA);       // 종료일
                    XmlUtil.addChildElement(item, "TOTAL", dataA09.PERIOD);       // 근무기간
                    XmlUtil.addChildElement(item, "ARBGB", dataA09.ARBGB);		// 근무처
                    XmlUtil.addChildElement(item, "TITL_TEXT", dataA09.JIKWT);		// 직위
                    XmlUtil.addChildElement(item, "JOBB_TEXT", dataA09.STLTX);		// 직무

                	XmlUtil.addChildElement(items, item);
                }
            }
	        //경력사항 끝


	        // XML을 조합한다.
	        XmlUtil.addChildElement(waitResponse, items);
	        XmlUtil.addChildElement(body, waitResponse);
	        XmlUtil.addChildElement(envelope, body);

	        // 최종적으로 XML Document를 XML String을 변환한다.
	        xmlString = XmlUtil.convertString(new Document(envelope));


	    } catch(Exception e) {

	    	//99.시스템 에러
	    	errorCode = "99";
            errorMsg  = "시스템 담당자에게 문의하시기 바랍니다.: ";
            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
            Logger.error(e);
            return xmlString;

	    } finally {

	    }
	    return xmlString;
    }

	public void SetUserSession(String empno, HttpServletRequest req) throws Exception{

		WebUserData user_m     = new WebUserData();

	    PersonInfoRFC personInfoRFC        = new PersonInfoRFC();
	    PersonData personData   = new PersonData();

	    personData = (PersonData)personInfoRFC.getPersonInfo(empno);

	    user_m.login_stat   = "Y";
	    user_m.companyCode  = personData.E_BUKRS ;

	    Config conf         = new Configuration();
	    user_m.clientNo     = conf.get("com.sns.jdf.sap.SAP_CLIENT");

	    user_m.empNo        = empno ;

		personInfoRFC.setSessionUserData(personData, user_m);
        user_m.e_mss = "X";

		DataUtil.fixNull(user_m);

	    HttpSession session = req.getSession(true);

	    int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
	    session.setMaxInactiveInterval(maxSessionTime);

	    session.setAttribute("user_m",user_m);
	}
}
