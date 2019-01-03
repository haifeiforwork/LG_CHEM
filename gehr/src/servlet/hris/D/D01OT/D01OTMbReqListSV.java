/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                                                                     */
/*   2Depth Name  : 초과근무                                                                                                                 */
/*   Program Name : 초과근무 신청 LIST (모바일에서요청)                                       */
/*   Program ID   : D01OTMbBuildPreLoadDataSV                              */
/*   Description  : 초과근무를     신청 초기화면 Road시 초과근무잔여일 및 결재라인 Return            */
/*   Note         :                                                             */
/*   Creation     : 2013-09-24  김도신                                                                                      */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D01OT;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.MobileCodeErrVO;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.G.G001Approval.ApprovalDocList;
import hris.G.G001Approval.ApprovalListKey;
import hris.G.G001Approval.rfc.G001ApprovalDocListRFC;
import hris.common.WebUserData;
import org.jdom.Document;
import org.jdom.Element;
import servlet.hris.MobileAutoLoginSV;
import servlet.hris.MobileCommonSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

public class D01OTMbReqListSV extends MobileAutoLoginSV {

	private String UPMU_TYPE ="17";   // 결재 업무타입(초과근무신청)
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
     
    	try{
    		
        	Logger.debug.println("D01OTMbReqListSV start++++++++++++++++++++++++++++++++++++++" ); 
        	
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
                       
            // 결재처리 결과값
            String returnXml = apprItem(req,res);

            // 결과에 대한 xmlStirng을  저장한다.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);

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
         * @return
         */
    public String apprItem( HttpServletRequest req, HttpServletResponse res){
          
    	Element envelope = null;

        String xmlString = "";
        String itemsName = "apprLists";
        String docStatus = "";

        String errorCode = "";
        String errorMsg = "";
        
        try{
        	Logger.debug.println("D01OTMbReqListSV apprItem Strart++++++++++++++++++++++++++++++++++++++" ); 
        	
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
           
            Box box = WebUtil.getBox(req);
            String empNo     = box.get("empNo"); //사번 
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);
            String PERNR = empNo;
            
            String fromDate  = DataUtil.delDateGubn(box.get("fromDate"));//시작일자
            String toDate    = DataUtil.delDateGubn(box.get("toDate")); //완료일자
            String apprApproveStatus = box.get("apprApproveStatus"); //결재상태
            
            com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
		    boolean isDev = conf.getBoolean("com.sns.jdf.eloffice.ISDEVELOP");
            String mUrl = "http://"+conf.getString("com.sns.jdf.eloffice.ResponseURL")+WebUtil.ServletURL+"hris.MobileDetailSV?AINF_SEQN="; //
            String mobileUrl ="";
            
            // 1.Envelop XML을 생성한다.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML을 생성한다.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE 를 생성한다.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.결과값을 생성한다.
            Element items = XmlUtil.createItems(itemsName);
                  
            Logger.debug.println(this, "[PERNR] = "+PERNR + " [user] : "+user.toString());       
                       
	     
	        //초과근무리스트
	        ApprovalListKey aplk     =   new ApprovalListKey();
            Vector vcApprovalDocList = null;
             
            if (fromDate.equals("")){
	            aplk.I_BEGDA  =   DataUtil.getAfterDate( DataUtil.getCurrentDate() , -7);
	            aplk.I_ENDDA  =   DataUtil.getCurrentDate();
        	}else{
        		aplk.I_BEGDA  =   fromDate;
	            aplk.I_ENDDA  =   toDate ;
        	}
        
            //GUBUN; // 구분   1 결재해야할문서 ,2 결재진행중 문서 ,3 결재완료문서
            aplk.I_AGUBN  =   "2";
            aplk.I_PERNR  =   PERNR;
            aplk.I_UPMU_TYPE = "17";// 초과근무만 LISTUP
            // STAT_TYPE;    // 상태   "1 신청 ,2 결재진행중 ,3 결재완료 ,4 반려"
	                    
            //초과근무신청LIST
            G001ApprovalDocListRFC aplRFC = new G001ApprovalDocListRFC();
            vcApprovalDocList = aplRFC.getApprovalDocList(aplk);
           
            // 초과근무결재 신청 목록 
            Logger.debug.println("D01OTMbReqListSV vcApprovalDocList.size()  JMK+++++"+vcApprovalDocList.size() ); 
            for(int i=0; i< vcApprovalDocList.size(); i++){
            	
            	ApprovalDocList apl = (ApprovalDocList)vcApprovalDocList.get(i);
               
            	mobileUrl=mUrl+ "&empNo="+WebUtil.encode(EncryptionTool.encrypt(empNo))+"&apprDocID="+apl.AINF_SEQN;
            	
                Element item = XmlUtil.createElement("apprHolidayList");
                XmlUtil.addChildElement(item, "apprSystemID", "EHR");
                XmlUtil.addChildElement(item, "apprSystemName","인사");
                XmlUtil.addChildElement(item, "apprDocID", apl.AINF_SEQN);
                XmlUtil.addChildElement(item, "apprTypeID", "EHR-" + apl.AINF_SEQN);
                XmlUtil.addChildElement(item, "apprCategory","초과근무신청");
                XmlUtil.addChildElement(item, "subject", apl.UPMU_NAME +" "+apl.STEXT);
                XmlUtil.addChildElement(item, "linkUrl", mobileUrl);
                XmlUtil.addChildElement(item, "apprRequestEmpNo", apl.PERNR);
                XmlUtil.addChildElement(item, "apprRequestEmpName", apl.ENAME); //승인,반려만 있음
                XmlUtil.addChildElement(item, "apprRequestEmpDept", apl.STEXT);
                XmlUtil.addChildElement(item, "apprRequestEmpTitle", user.e_titel);
                XmlUtil.addChildElement(item, "apprRequestDate", apl.BEGDA);
                
                XmlUtil.addChildElement(items, item);
                Logger.debug.println("D01OTMbReqListSV apl)  JMK+++++++++++>"+apl.toString() ); 
            }
 
            // 성공인경우 리턴코드에 0을 세팅한다.+
            if (vcApprovalDocList.size()>0) {
    	        XmlUtil.addChildElement(items, "returnDesc", "");
		        XmlUtil.addChildElement(items, "returnCode",Integer.toString(vcApprovalDocList.size()));  
            }else{
		        XmlUtil.addChildElement(items, "returnDesc", "DATA가 존재하지 않습니다.");
    	        XmlUtil.addChildElement(items, "returnCode", "0");              	
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
