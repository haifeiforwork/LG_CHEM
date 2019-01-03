/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                                                                     */
/*   2Depth Name  : 휴가                                                                                                                 */
/*   Program Name : 휴가 신청 (모바일에서요청)                                       */
/*   Program ID   : D03VocationMbBuildRemainDateSV                              */
/*   Description  : 휴가를     신청 초기화면 Road시 휴가잔여일 및 결재라인 Return            */
/*   Note         :                                                             */
/*   Creation     : 2011-05-18     
 *   update        : 2018/06/08 rdcamel [CSR ID:3700538] 보상휴가제 도입에 따른 Mobile 휴가신청 및 결재화면 수정 요청 건                                                                                    */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D03Vocation;

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
import hris.D.D03Vocation.rfc.*;

import servlet.hris.MobileAutoLoginSV;
import servlet.hris.MobileCommonSV;

public class D03VocationMbBuildReamainDateSV extends MobileAutoLoginSV {

	private String UPMU_TYPE ="18";   // 결재 업무타입(휴가신청)
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
     
    	try{
    		
        	Logger.debug.println("D03VocationMbBuildRemainDateSV start++++++++++++++++++++++++++++++++++++++" ); 
        	
        	//로그인처리
        	MobileCommonSV mc = new MobileCommonSV() ;
        	mc.autoLogin(req,res);
        	        	
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            Box box = WebUtil.getBox(req);
          
         
            String empNo     = box.get("empNo"); //사번 
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);
            
            Logger.debug.println(" D03VocationMbBuildRemainDateSV empNo======>"+     empNo);     
            // 결재처리 결과값
            String returnXml = apprItem(req,res);

            // 결과에 대한 xmlStirng을  저장한다.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);
            Logger.debug.println("D03VocationMbBuildRemainDateSV returnXml++++++++++++++++++++++++++++++++++++++"+returnXml );
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
         * 잔여휴가일 및 결재라인를 XML형태로 가져온다.
         * @param input  
         * @return
         */
    public String apprItem( HttpServletRequest req, HttpServletResponse res){
          
    	Element envelope = null;

        String xmlString = "";
        String itemsName = "apprItem";
        String docStatus = "";

        String errorCode = "";
        String errorMsg = "";
        
       //통합결재연동 결과값
    	MobileReturnData retunMsgEL = new MobileReturnData();
        
        try{
        	Logger.debug.println("D03VocationMbBuildRemainDateSV apprItem Strart++++++++++++++++++++++++++++++++++++++" ); 
        	
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
          
            Logger.debug.println("D03VocationMbBuildRemainDateSV apprItem JMK+++++" ); 
            
            //요청자정보
            PersonInfoRFC numfunc        = new PersonInfoRFC();
            PersonData phonenumdata   = new PersonData();
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            String eName = phonenumdata.E_ENAME ;
            String eOrgtx = phonenumdata.E_ORGTX ;   
                
            //잔여휴가일
            //D03GetWorkdayRFC func = new D03GetWorkdayRFC();
            D03GetWorkdayOfficeRFC func = new D03GetWorkdayOfficeRFC();
            Object D03GetWorkdayData_vt = func.getWorkday( PERNR, DataUtil.getCurrentDate(), "M" );//A : 연차휴가, B : 보상휴가, C : 전체휴가(Report 전용), M 모바일용 휴가조회
            String ZKVRB = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB"); 
            //[CSR ID:3700538]
            String REMAINT = DataUtil.getValue(D03GetWorkdayData_vt, "REMAINT"); 
            
            //Logger.debug.println("D03VocationMbBuildRemainDateSV apprItem P_REMAIN++++++++++++++++"+d03RemainVocationData.P_REMAIN); 
            Logger.debug.println("D03VocationMbBuildRemainDateSV apprItem ZKVRB+++++++++++++++++++"+ZKVRB);
            
            
            // 성공인경우 리턴코드에 0을 세팅한다.
	        XmlUtil.addChildElement(items, "returnDesc", "");
	        XmlUtil.addChildElement(items, "returnCode", "0");                 
	     
	        // 요청자부서 및 이름
	        XmlUtil.addChildElement(items, "apprRequestEmpDept", eOrgtx);
	        XmlUtil.addChildElement(items, "apprRequestEmpName", eName);
	        //잔여휴가일 Setting
	        XmlUtil.addChildElement(items, "applyHolidayRemainDate", ZKVRB);
	        XmlUtil.addChildElement(items, "applyHolidayRemainDateText", REMAINT);// [CSR ID:3700538] ex)연차 14.00일, 보상 : 3.5일(28.0시간) 
            
            // 결재라인 검색된 결과값을 이용하여 row 데이터에 대한 XML element를 생성한다.
            /*Vector  appTargetList = null;*/

            /*appTargetList = AppUtil.getAppVector( PERNR, UPMU_TYPE );*/
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
            
	        // XML을 조합한다.
	        XmlUtil.addChildElement(waitResponse, items);
	        XmlUtil.addChildElement(body, waitResponse);
	        XmlUtil.addChildElement(envelope, body);
	
	        // 최종적으로 XML Document를 XML String을 변환한다.
	        xmlString = XmlUtil.convertString(new Document(envelope));
        
	    } catch(Exception e) {
	    	
	    	errorCode = MobileCodeErrVO.ERROR_CODE_500;
            errorMsg  = MobileCodeErrVO.ERROR_MSG_500+  e.getMessage();
            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
            Logger.error(e);
            return xmlString;
	        
	    } finally {
	        
	    }
	    return xmlString;
    }
}
