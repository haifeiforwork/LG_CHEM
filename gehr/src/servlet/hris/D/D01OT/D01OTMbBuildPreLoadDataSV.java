/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 초과근무                                                    */
/*   Program Name : 초과근무 신청 (모바일에서요청)                              */
/*   Program ID   : D01OTMbBuildPreLoadDataSV                              	*/
/*   Description  : 초과근무 신청 초기화면 Road시 초과근무 필요 DATA 및 결재라인 Return  */
/*   Note         :                                                             */
/*   Creation     : 2013-09-24                                                  */
/*   update       : 2018/06/09 rdcamel [CSR ID:3701161] 모바일 초과근무 신청/결재 로직 수정 요청 건                                                                           */
/********************************************************************************/

package servlet.hris.D.D01OT;

import java.util.Vector;
import javax.servlet.http.*;

import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalLineRFC;
import org.jdom.Document;
import org.jdom.Element;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.util.*;
import hris.common.rfc.*;
import hris.D.D03Vocation.D03VocationReasonData;
import hris.D.D03Vocation.rfc.D03VocationAReasonRFC;
import hris.D.D25WorkTime.rfc.D25WorkTimeEmpGubRFC;
import servlet.hris.MobileAutoLoginSV;
import servlet.hris.MobileCommonSV;

public class D01OTMbBuildPreLoadDataSV extends MobileAutoLoginSV {

    private String UPMU_TYPE ="17";
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
     
    	try{
    		
        	Logger.debug.println("D01OTMbBuildPreLoadDataSV start++++++++++++++++++++++++++++++++++++++" ); 
        	
        	//로그인처리
        	MobileCommonSV mc = new MobileCommonSV() ;
        	mc.autoLogin(req,res);
        	        	
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            Box box = WebUtil.getBox(req);
          
         
            String empNo     = box.get("empNo"); //사번 
            Logger.debug.println(" D01OTMbBuildPreLoadDataSV decrypt before"+     empNo.length());    
            empNo = EncryptionTool.decrypt(empNo);

            Logger.debug.println(" D01OTMbBuildPreLoadDataSV empNo.length()======>"+     empNo.length());    
            if (empNo.length()<9) {
            	empNo = DataUtil.fixEndZero( empNo ,8);
            }
            Logger.debug.println(" D01OTMbBuildPreLoadDataSV empNo======>"+     empNo);     

            // 결재처리 결과값
            String returnXml = apprItem(req,res);

            // 결과에 대한 xmlStirng을  저장한다.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);
            Logger.debug.println("D01OTMbBuildPreLoadDataSV returnXml++++++++++++++++++++++++++++++++++++++"+returnXml );
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
         * 잔여초과근무일 및 결재라인를 XML형태로 가져온다.
         * @param input  
         * @return
         */
    public String apprItem( HttpServletRequest req, HttpServletResponse res){
          
    	Element envelope = null;

        String xmlString = "";
        String itemsName = "apprItem"; 

        String errorCode = "";
        String errorMsg = "";

        try{
        	Logger.debug.println("D01OTMbBuildPreLoadDataSV apprItem Strart++++++++++++++++++++++++++++++++++++++" ); 
        	
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
           
            Box box = WebUtil.getBox(req);
            String empNo     = box.get("empNo"); //사번 
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);
            String PERNR = empNo;
            
            // 1.Envelop XML을 생성한다.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML을 생성한다.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE 를 생성한다.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.결과값을 생성한다.
            Element items = XmlUtil.createItems(itemsName);
            
                    
            Logger.debug.println(this, "[PERNR] = "+PERNR + " [user] : "+user.toString());       
          
            Logger.debug.println("D01OTMbBuildPreLoadDataSV apprItem JMK+++++" ); 
            
            //요청자정보
            PersonInfoRFC numfunc        = new PersonInfoRFC();
            PersonData phonenumdata   = new PersonData();
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
                
        
            //Logger.debug.println("D01OTMbBuildPreLoadDataSV apprItem P_REMAIN++++++++++++++++"+d03RemainVocationData.P_REMAIN);  
            
            
            // 성공인경우 리턴코드에 0을 세팅한다.
            if (phonenumdata != null ){
    	        XmlUtil.addChildElement(items, "returnDesc", "");
    	        XmlUtil.addChildElement(items, "returnCode", "0");            
                

                String eName = phonenumdata.E_ENAME ;
                String eOrgtx = phonenumdata.E_ORGTX ;   
	            	
		        // 요청자부서 및 이름
		        XmlUtil.addChildElement(items, "apprRequestEmpDept", eOrgtx);
		        XmlUtil.addChildElement(items, "apprRequestEmpName", eName);            
	
		        // 휴일근무,반일특근 및 체크로직 대상자GET 사무지도직(S):휴일특근,반일특근신청가능 ,사전신청체크 , 전문기능(T) : 사전신청가능
		        String E_PERSKG  = (new D03VocationAReasonRFC()).getE_PERSKG(user.companyCode ,PERNR, "2005", DataUtil.getCurrentDate());
		        //21  간부사원  ,22  사무직  , 24  계약직  
		        if (phonenumdata.E_PERSK.equals("21")||phonenumdata.E_PERSK.equals("22")||phonenumdata.E_PERSK.equals("24") ){
		        	E_PERSKG="S";
		        }else{
		        	E_PERSKG="T";
		        }
		        XmlUtil.addChildElement(items, "apprRequestPERSKG", E_PERSKG);  
		        
		        //C20100812_18478 휴일근무 신청 대상자 조정 :팀장미만 신청가능
		        String OTbuildYn  = (new D03VocationAReasonRFC()).getE_OVTYN(user.companyCode,  PERNR, "2005",DataUtil.getCurrentDate());
		        // BBIA 파주사업장제외로직 구현 
		        String E_BTRTL  = (new D03VocationAReasonRFC()).getE_BTRTL(user.companyCode, PERNR, "2005",DataUtil.getCurrentDate());
		        XmlUtil.addChildElement(items, "apprRequestbuildYn", OTbuildYn);  
		        XmlUtil.addChildElement(items, "apprRequestBTRTL", E_BTRTL);  
	            Logger.debug.println("D01OTMbBuildPreLoadDataSV E_BTRTL++++++++++++++++"+E_BTRTL);  
	            Logger.debug.println("D01OTMbBuildPreLoadDataSV OTbuildYn++++++++++++++++"+OTbuildYn);  
	            Logger.debug.println("D01OTMbBuildPreLoadDataSV E_BTRTL++++++++++++++++"+E_BTRTL);  
	            
	            //[CSR ID:3701161] apprRequestEmpNtmGubn 추가 : A : 사무직 기존 화면, B, 생산직 기존화면, C : 사무직 변경화면, D : 생산직 변경화면
	            Vector empGub_vt  = (new D25WorkTimeEmpGubRFC()).getEmpGub(user.empNo, DataUtil.getCurrentDate());//ZGHR_RFC_NTM_GET_EMPGUB 호출
	            if( empGub_vt != null && empGub_vt.get(0).equals("S")){
	            	XmlUtil.addChildElement(items, "apprRequestEmpNtmGubn",  empGub_vt.get(3)+"");
	            	//XmlUtil.addChildElement(items, "apprRequestHolidayNtmGubn", empGub_vt.get(4)+"");신청 날짜를 가지고 체크해야 하는데 모바일에서는 load 시킨 날짜 값으로 X 여부 체크하므로 의미 없음.
	            }else{
	            	errorCode = MobileCodeErrVO.ERROR_CODE_600;
	                errorMsg = MobileCodeErrVO.ERROR_MSG_600+empGub_vt.get(1);
			        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
		            return xmlString;
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
	             
	             //사유
	            Vector D03VocationAReason_vt  = (new D03VocationAReasonRFC()).getSubtyCode(user.companyCode,  PERNR, "2005",DataUtil.getCurrentDate());
	            for( int i = 0 ; i < D03VocationAReason_vt.size() ; i++ ){
	                D03VocationReasonData old_data = (D03VocationReasonData)D03VocationAReason_vt.get(i); 
	                Element item = XmlUtil.createElement("Reason");
	                XmlUtil.addChildElement(item, "ReasonSCODE", old_data.SCODE);
	                XmlUtil.addChildElement(item, "ReasonSTEXT", old_data.STEXT); 
	                XmlUtil.addChildElement(items, item); 
	            }              
	
	             Logger.debug.println("D01OTMbBuildPreLoadDataSV D03VocationAReason_vt++++++++++++++++"+D03VocationAReason_vt.toString());  
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
