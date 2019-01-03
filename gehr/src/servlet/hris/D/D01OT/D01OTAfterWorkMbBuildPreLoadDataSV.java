package servlet.hris.D.D01OT;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.ObjectUtils;
import org.jdom.Document;
import org.jdom.Element;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTAfterWorkTimeDATA;
import hris.D.D01OT.D01OTRealWorkDATA;
import hris.D.D01OT.rfc.D01OTAfterWorkTimeListRFC;
import hris.D.D01OT.rfc.D01OTRealWrokListRFC;
import hris.common.EmpGubunData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalLineRFC;
import hris.common.rfc.GetEmpGubunRFC;
import hris.common.rfc.PersonInfoRFC;
import servlet.hris.MobileAutoLoginSV;
import servlet.hris.MobileCommonSV;

public class D01OTAfterWorkMbBuildPreLoadDataSV extends MobileAutoLoginSV {
	
	private String UPMU_TYPE ="44";
	
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
     
    	try{
    		
        	Logger.debug.println("D01OTAfterWorkMbBuildPreLoadDataSV start++++++++++++++++++++++++++++++++++++++" ); 
        	
        	//로그인처리
        	MobileCommonSV mc = new MobileCommonSV() ;
        	mc.autoLogin(req,res);
        	        	
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            Box box = WebUtil.getBox(req);
          
            String empNo     = box.get("empNo"); //사번 
            Logger.debug.println(" D01OTAfterWorkMbBuildPreLoadDataSV decrypt before"+     empNo.length());    
            empNo = EncryptionTool.decrypt(empNo);

            Logger.debug.println(" D01OTAfterWorkMbBuildPreLoadDataSV empNo.length()======>"+     empNo.length());    
            if (empNo.length()<9) {
            	empNo = DataUtil.fixEndZero( empNo ,8);
            }
            Logger.debug.println(" D01OTAfterWorkMbBuildPreLoadDataSV empNo======>"+     empNo);     

            // 결재처리 결과값
            String returnXml = apprItem(req,res);

            // 결과에 대한 xmlStirng을  저장한다.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);
            Logger.debug.println("D01OTAfterWorkMbBuildPreLoadDataSV returnXml++++++++++++++++++++++++++++++++++++++"+returnXml );
            // 3.return URL을 호출한다.
            dest = WebUtil.JspURL+"common/mobileResult.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res,dest );
                        
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
           
        }
    }
	
	public String apprItem( HttpServletRequest req, HttpServletResponse res){
        
    	Element envelope = null;

        String xmlString = "";
        String itemsName = "apprItem"; 

        String errorCode = "";
        String errorMsg = "";

        try{
        	Logger.debug.println("D01OTAfterWorkMbBuildPreLoadDataSV apprItem Strart++++++++++++++++++++++++++++++++++++++" ); 
        	
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
           
            Box box = WebUtil.getBox(req);
            String empNo     = box.get("empNo"); //사번 
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);
            String PERNR = empNo;
            boolean isUpdate = box.getBoolean("isUpdate");
            
            // WorkTime52 Start
            String EMPGUB = "";
            String TPGUB = "";
            
            String curdate = DataUtil.getCurrentDate();
            // WorkTime52 End
            
            // 1.Envelop XML을 생성한다.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML을 생성한다.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE 를 생성한다.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.결과값을 생성한다.
            Element items = XmlUtil.createItems(itemsName);
                    
            Logger.debug.println(this, "[PERNR] = "+PERNR + " [user] : "+user.toString());       
          
            Logger.debug.println("D01OTAfterWorkMbBuildPreLoadDataSV apprItem JMK+++++" ); 
            
            //요청자정보
            PersonInfoRFC numfunc        = new PersonInfoRFC();
            PersonData phonenumdata   = new PersonData();
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            
            // 대리 신청 추가
            XmlUtil.addChildElement(items, "isUpdate", String.valueOf(isUpdate)); // [결재]등록 수정 여부 <- 수정쪽에는 반드시 필요함
            XmlUtil.addChildElement(items, "PERNR", PERNR);
            XmlUtil.addChildElement(items, "committed", "N");
            Element persondataItem = XmlUtil.createElement("PersonData");
            XmlUtil.addChildElement(persondataItem, "persondataE_MOLG", phonenumdata.E_MOLGA);
            XmlUtil.addChildElement(persondataItem, "persondataE_PERN", phonenumdata.E_PERNR);
            XmlUtil.addChildElement(persondataItem, "persondataE_ENAM", phonenumdata.E_ENAME);
            XmlUtil.addChildElement(persondataItem, "persondataE_BUKR", phonenumdata.E_BUKRS);
            XmlUtil.addChildElement(persondataItem, "persondataE_WERK", phonenumdata.E_WERKS);
            XmlUtil.addChildElement(persondataItem, "persondataE_BTRT", phonenumdata.E_BTRTL);
            XmlUtil.addChildElement(persondataItem, "persondataE_ORGE", phonenumdata.E_ORGEH);
            XmlUtil.addChildElement(persondataItem, "persondataE_ORGT", phonenumdata.E_ORGTX);
            XmlUtil.addChildElement(persondataItem, "persondataE_PERS", phonenumdata.E_PERSG);
            XmlUtil.addChildElement(persondataItem, "persondataE_PERS", phonenumdata.E_PERSK);
            XmlUtil.addChildElement(persondataItem, "persondataE_OBJI", phonenumdata.E_OBJID);
            XmlUtil.addChildElement(persondataItem, "persondataE_OBJT", phonenumdata.E_OBJTX);
            XmlUtil.addChildElement(persondataItem, "persondataE_DAT0", phonenumdata.E_DAT02);
            XmlUtil.addChildElement(persondataItem, "persondataE_PHONE_NUM", phonenumdata.E_PHONE_NUM);
            XmlUtil.addChildElement(persondataItem, "persondataE_CELL_PHONE", phonenumdata.E_CELL_PHONE);
            XmlUtil.addChildElement(persondataItem, "persondataE_MAIL", phonenumdata.E_MAIL);
            XmlUtil.addChildElement(persondataItem, "persondataE_TIMEADMIN", phonenumdata.E_TIMEADMIN);
            XmlUtil.addChildElement(persondataItem, "persondataE_REPRESENTATIVE", phonenumdata.E_REPRESENTATIVE);
            XmlUtil.addChildElement(persondataItem, "persondataE_AUTHORIZATION", phonenumdata.E_AUTHORIZATION);
            XmlUtil.addChildElement(persondataItem, "persondataE_AUTHORIZATION2", phonenumdata.E_AUTHORIZATION2);
            XmlUtil.addChildElement(persondataItem, "persondataE_DEPTC", phonenumdata.E_DEPTC);
            XmlUtil.addChildElement(persondataItem, "persondataE_RETIR", phonenumdata.E_RETIR);
            XmlUtil.addChildElement(persondataItem, "persondataE_REDAY", phonenumdata.E_REDAY);
            XmlUtil.addChildElement(persondataItem, "persondataE_IS_CHIEF", phonenumdata.E_IS_CHIEF);
            XmlUtil.addChildElement(persondataItem, "persondataE_GANSA", phonenumdata.E_GANSA);
            XmlUtil.addChildElement(persondataItem, "persondataE_OVERSEA", phonenumdata.E_OVERSEA);
            XmlUtil.addChildElement(persondataItem, "persondataE_RECON", phonenumdata.E_RECON);
            XmlUtil.addChildElement(persondataItem, "persondataE_GBDAT", phonenumdata.E_GBDAT);
            XmlUtil.addChildElement(persondataItem, "persondataE_GRUP_NUMB", phonenumdata.E_GRUP_NUMB);
            XmlUtil.addChildElement(persondataItem, "persondataE_JIKWE", phonenumdata.E_JIKWE);
            XmlUtil.addChildElement(persondataItem, "persondataE_JIKWT", phonenumdata.E_JIKWT);
            XmlUtil.addChildElement(persondataItem, "persondataE_JIKKB", phonenumdata.E_JIKKB);
            XmlUtil.addChildElement(persondataItem, "persondataE_JIKK", phonenumdata.E_JIKKT);
            XmlUtil.addChildElement(persondataItem, "persondataE_REGN", phonenumdata.E_REGNO);
            XmlUtil.addChildElement(persondataItem, "persondataE_TRFA", phonenumdata.E_TRFAR);
            XmlUtil.addChildElement(persondataItem, "persondataE_TRFG", phonenumdata.E_TRFGR);
            XmlUtil.addChildElement(persondataItem, "persondataE_TRFS", phonenumdata.E_TRFST);
            XmlUtil.addChildElement(persondataItem, "persondataE_VGLG", phonenumdata.E_VGLGR);
            XmlUtil.addChildElement(persondataItem, "persondataE_VGLS", phonenumdata.E_VGLST);
            XmlUtil.addChildElement(persondataItem, "persondataE_STRA", phonenumdata.E_STRAS);
            XmlUtil.addChildElement(persondataItem, "persondataE_LOCA", phonenumdata.E_LOCAT);
            XmlUtil.addChildElement(persondataItem, "persondataE_JIKC", phonenumdata.E_JIKCH);
            XmlUtil.addChildElement(persondataItem, "persondataE_JIKC", phonenumdata.E_JIKCT);
            XmlUtil.addChildElement(persondataItem, "persondataE_EXPI", phonenumdata.E_EXPIR);
            XmlUtil.addChildElement(persondataItem, "persondataE_PTEXT", phonenumdata.E_PTEXT);
            XmlUtil.addChildElement(persondataItem, "persondataE_BTEXT", phonenumdata.E_BTEXT);
            
            XmlUtil.addChildElement(items, persondataItem);
        
            // 성공인경우 리턴코드에 0을 세팅한다.
            if (phonenumdata != null ){
    	        XmlUtil.addChildElement(items, "returnDesc", "");
    	        XmlUtil.addChildElement(items, "returnCode", "0");            
                
                String eName = phonenumdata.E_ENAME ;
                String eOrgtx = phonenumdata.E_ORGTX ;   
	            
		        // 요청자부서 및 이름
		        XmlUtil.addChildElement(items, "apprRequestEmpDept", eOrgtx);
		        XmlUtil.addChildElement(items, "apprRequestEmpName", eName);
		        
		        // 사원 구분 조회(사무직:S / 현장직:H) => [변경 :2018-06-07 : A(사무직-일반), B(현장직-일반), C(사무직-선택근로제), D(현장직-탄력근로제)
		        GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
                Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(PERNR);
                if (empGubunRFC.getReturn().isSuccess()) EMPGUB = tpInfo.get(0).getEMPGUB();
                if (empGubunRFC.getReturn().isSuccess()) TPGUB = tpInfo.get(0).getTPGUB();
                
                String I_DATE = (req.getParameter("DATUM") == null || req.getParameter("DATUM").equals("")) ? curdate : req.getParameter("DATUM");
                String I_VTKEN = ObjectUtils.toString(req.getAttribute("VTKEN"));
                
                if (EMPGUB.equals("S")) {    // 사무직-일반
                	// 실근무시간 조회[info Table]
                    D01OTRealWrokListRFC realworkfunc = new D01OTRealWrokListRFC();
                    // 실근무/신청가능...
                    D01OTAfterWorkTimeListRFC rfcaf = new D01OTAfterWorkTimeListRFC();
                    
                    final D01OTRealWorkDATA WorkData = realworkfunc.getResult(EMPGUB, PERNR, I_DATE, I_VTKEN, "", "");
                    final D01OTAfterWorkTimeDATA AfterData = rfcaf.getResult("1", PERNR, I_DATE, I_VTKEN, "", curdate, "");

                    if (realworkfunc.getReturn().isSuccess()) {
                        Element workdataItem = XmlUtil.createElement("workdata");
                        XmlUtil.addChildElement(workdataItem, "workdataPERNR", WorkData.PERNR);
                        XmlUtil.addChildElement(workdataItem, "workdataBASTM", WorkData.BASTM);
                        XmlUtil.addChildElement(workdataItem, "workdataMAXTM", WorkData.MAXTM);
                        XmlUtil.addChildElement(workdataItem, "workdataPWDWK", WorkData.PWDWK);
                        XmlUtil.addChildElement(workdataItem, "workdataPWEWK", WorkData.PWEWK);
                        XmlUtil.addChildElement(workdataItem, "workdataCWDWK", WorkData.CWDWK);
                        XmlUtil.addChildElement(workdataItem, "workdataCWEWK", WorkData.CWEWK);
                        XmlUtil.addChildElement(workdataItem, "workdataPWTOT", WorkData.PWTOT);
                        XmlUtil.addChildElement(workdataItem, "workdataCWTOT", WorkData.CWTOT);
                        XmlUtil.addChildElement(workdataItem, "workdataRWKTM", WorkData.RWKTM);
                        XmlUtil.addChildElement(workdataItem, "workdataWKLMT", WorkData.WKLMT);
                        XmlUtil.addChildElement(workdataItem, "workdataNORTM", WorkData.NORTM);
                        XmlUtil.addChildElement(workdataItem, "workdataOVRTM", WorkData.OVRTM);
                        XmlUtil.addChildElement(workdataItem, "workdataBRKTM", WorkData.BRKTM);
                        XmlUtil.addChildElement(workdataItem, "workdataNWKTM", WorkData.NWKTM);
                        
                        XmlUtil.addChildElement(items, workdataItem);
                    } else {
                        Logger.debug.println(this, "실근무시간 조회 에러!!");
                    }

                    if (rfcaf.getReturn().isSuccess()) {
                        Element afterdataItem = XmlUtil.createElement("afterdata");
                        XmlUtil.addChildElement(afterdataItem, "afterdataPERNR", AfterData.PERNR);
                        XmlUtil.addChildElement(afterdataItem, "afterdataAINF_SEQN", AfterData.AINF_SEQN);
                        XmlUtil.addChildElement(afterdataItem, "afterdataBUKRS", AfterData.BUKRS);
                        XmlUtil.addChildElement(afterdataItem, "afterdataEMPGUB", AfterData.EMPGUB);
                        XmlUtil.addChildElement(afterdataItem, "afterdataTPGUB", AfterData.TPGUB);
                        XmlUtil.addChildElement(afterdataItem, "afterdataWKDAT", AfterData.WKDAT);
                        XmlUtil.addChildElement(afterdataItem, "afterdataBEGUZ", AfterData.BEGUZ);
                        XmlUtil.addChildElement(afterdataItem, "afterdataENDUZ", AfterData.ENDUZ);
                        XmlUtil.addChildElement(afterdataItem, "afterdataABEGUZ01", AfterData.ABEGUZ01);
                        XmlUtil.addChildElement(afterdataItem, "afterdataAENDUZ01", AfterData.AENDUZ01);
                        XmlUtil.addChildElement(afterdataItem, "afterdataAREWK01", AfterData.AREWK01);
                        XmlUtil.addChildElement(afterdataItem, "afterdataABEGUZ02", AfterData.ABEGUZ02);
                        XmlUtil.addChildElement(afterdataItem, "afterdataAENDUZ02", AfterData.AENDUZ02);
                        XmlUtil.addChildElement(afterdataItem, "afterdataAREWK02", AfterData.AREWK02);
                        XmlUtil.addChildElement(afterdataItem, "afterdataBASTM", AfterData.BASTM);
                        XmlUtil.addChildElement(afterdataItem, "afterdataMAXTM", AfterData.MAXTM);
                        XmlUtil.addChildElement(afterdataItem, "afterdataPDUNB", AfterData.PDUNB);
                        XmlUtil.addChildElement(afterdataItem, "afterdataABSTD", AfterData.ABSTD);
                        XmlUtil.addChildElement(afterdataItem, "afterdataPDABS", AfterData.PDABS);
                        XmlUtil.addChildElement(afterdataItem, "afterdataSTDAZ", AfterData.STDAZ);
                        XmlUtil.addChildElement(afterdataItem, "afterdataAREWK", AfterData.AREWK);
                        XmlUtil.addChildElement(afterdataItem, "afterdataTOTAL", AfterData.TOTAL);
                        XmlUtil.addChildElement(afterdataItem, "afterdataNRQPST", AfterData.NRQPST);
                        XmlUtil.addChildElement(afterdataItem, "afterdataRRQPST", AfterData.RRQPST);
                        XmlUtil.addChildElement(afterdataItem, "afterdataRQPST", AfterData.RQPST);
                        XmlUtil.addChildElement(afterdataItem, "afterdataCPDUNB", AfterData.CPDUNB);
                        XmlUtil.addChildElement(afterdataItem, "afterdataCABSTD", AfterData.CABSTD);
                        XmlUtil.addChildElement(afterdataItem, "afterdataCPDABS", AfterData.CPDABS);
                        XmlUtil.addChildElement(afterdataItem, "afterdataCSTDAZ", AfterData.CSTDAZ);
                        XmlUtil.addChildElement(afterdataItem, "afterdataCAREWK", AfterData.CAREWK);
                        XmlUtil.addChildElement(afterdataItem, "afterdataCTOTAL", AfterData.CTOTAL);
                        XmlUtil.addChildElement(afterdataItem, "afterdataCNRQPST", AfterData.CNRQPST);
                        XmlUtil.addChildElement(afterdataItem, "afterdataCRRQPST", AfterData.CRRQPST);
                        XmlUtil.addChildElement(afterdataItem, "afterdataCRQPST", AfterData.CRQPST);
                        XmlUtil.addChildElement(afterdataItem, "afterdataNRFLGG", AfterData.NRFLGG);
                        XmlUtil.addChildElement(afterdataItem, "afterdataR01FLG", AfterData.R01FLG);
                        XmlUtil.addChildElement(afterdataItem, "afterdataR02FLG", AfterData.R02FLG);
                        XmlUtil.addChildElement(afterdataItem, "afterdataZOVTYP", AfterData.ZOVTYP);
                        XmlUtil.addChildElement(afterdataItem, "afterdataE_EMPGUB", AfterData.E_EMPGUB);
                        XmlUtil.addChildElement(afterdataItem, "afterdataE_TPGUB", AfterData.E_TPGUB);
                        XmlUtil.addChildElement(afterdataItem, "afterdataE_WKDYN", AfterData.E_WKDYN);
                        XmlUtil.addChildElement(afterdataItem, "afterdataE_PRECHECK", AfterData.E_PRECHECK);
                        
                        XmlUtil.addChildElement(items, afterdataItem);
                    } else {
                        Logger.debug.println(this, "AF 실근무시간 조회 에러!!");
                    }

                    Logger.debug.println(this, "WorkData[사무직] : " + WorkData.toString());
                    Logger.debug.println(this, "AfterData[사무직 사후근로신청 실근무정보] : " + AfterData.toString());

                    XmlUtil.addChildElement(items, "EMPGUB", EMPGUB);
                    XmlUtil.addChildElement(items, "TPGUB", TPGUB);
                    XmlUtil.addChildElement(items, "DATUM", I_DATE);

                }
	
	            // 결재라인 검색된 결과값을 이용하여 row 데이터에 대한 XML element를 생성한다.
	            /*Vector  appTargetList = null;
	            appTargetList = AppUtil.getAppVector( PERNR, UPMU_TYPE );*/
				ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC();
				Vector<ApprovalLineData> appTargetList = approvalLineRFC.getApprovalLine(UPMU_TYPE, PERNR);

	            String APPL_APPR_STAT = "";
	            for(int i=0; i< appTargetList.size(); i++){

					ApprovalLineData appLineData = (ApprovalLineData)appTargetList.get(i);
	
	                if (appLineData.APPR_STAT.equals("A")) {
	                    APPL_APPR_STAT ="승인";
	                } else if (appLineData.APPR_STAT.equals("R")) {
	                    APPL_APPR_STAT ="반려";
	                } else {
	                    APPL_APPR_STAT ="미결";
	                }
	               
	                Element item = XmlUtil.createElement("approver");
	                XmlUtil.addChildElement(item, "apprApproveEmpNo", appLineData.PERNR);
	                XmlUtil.addChildElement(item, "apprApproveEmpName", appLineData.ENAME);
	                XmlUtil.addChildElement(item, "apprApproveEmpDept", appLineData.APPU_NAME);
	                XmlUtil.addChildElement(item, "apprApproveEmpTitle", appLineData.JIKWT);
	                XmlUtil.addChildElement(item, "apprApproveEmpEmail", " ");
	                XmlUtil.addChildElement(item, "apprApproveEmpOffice", appLineData.PHONE_NUM);
	                XmlUtil.addChildElement(item, "apprApproveEmpMobile", " ");
	                //XmlUtil.addChildElement(item, "apprApproveCompanyKorName", appLineData.PERNR);
	                XmlUtil.addChildElement(item, "apprApproveDate", appLineData.APPR_DATE);
	                XmlUtil.addChildElement(item, "apprApproveType", "APPROVAL"); //승인,반려만 있음
	                XmlUtil.addChildElement(item, "apprComment", appLineData.BIGO_TEXT);
	                XmlUtil.addChildElement(item, "apprType", APPL_APPR_STAT);
	                
	                XmlUtil.addChildElement(items, item);
	                
	            }
            }else{
		        XmlUtil.addChildElement(items, "returnDesc", "사번을 확인하세요.");
		        XmlUtil.addChildElement(items, "returnCode", "-1");  
            }
	        // XML을 조합한다.
	        XmlUtil.addChildElement(waitResponse, items);
	        XmlUtil.addChildElement(body, waitResponse);
	        XmlUtil.addChildElement(envelope, body);
	
	        // 최종적으로 XML Document를 XML String을 변환한다.
	        xmlString = XmlUtil.convertString(new Document(envelope));
        
	    } catch(Exception e) {
	    	
	    	errorCode = MobileCodeErrVO.ERROR_CODE_600;
            errorMsg  = MobileCodeErrVO.ERROR_MSG_600+  e.getMessage();
            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
            Logger.error(e);
            return xmlString;
	        
	    } finally {
	        
	    }
	    return xmlString;
    }

}
