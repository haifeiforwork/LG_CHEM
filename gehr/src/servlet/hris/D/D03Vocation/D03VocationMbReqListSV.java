/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                                                                     */
/*   2Depth Name  : �ް�                                                                                                                 */
/*   Program Name : �ް� ��û LIST (����Ͽ�����û)                                       */
/*   Program ID   : D03VocationMbBuildRemainDateSV                              */
/*   Description  : �ް���     ��û �ʱ�ȭ�� Road�� �ް��ܿ��� �� ������� Return            */
/*   Note         :                                                             */
/*   Creation     : 2011-05-18  �赵��                                                                                      */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D03Vocation;

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

public class D03VocationMbReqListSV extends MobileAutoLoginSV {

	private String UPMU_TYPE ="18";   // ���� ����Ÿ��(�ް���û)
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
     
    	try{
    		
        	Logger.debug.println("D03VocationMbReqListSV start++++++++++++++++++++++++++++++++++++++" ); 
        	
        	//�α���ó��
        	MobileCommonSV mc = new MobileCommonSV() ;
        	mc.autoLogin(req,res);
        	        	
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            Box box = WebUtil.getBox(req);
          
         
            String empNo     = box.get("empNo"); //��� 
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);
                       
            // ����ó�� �����
            String returnXml = apprItem(req,res);

            // ����� ���� xmlStirng��  �����Ѵ�.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);

            // 3.return URL�� ȣ���Ѵ�.
            dest = WebUtil.JspURL+"common/mobileResult.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res,dest );
                        
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
           
        }
    }
        /**
         * �ܿ��ް��� �� ������θ� XML���·� �����´�.
         * @param
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
        	Logger.debug.println("D03VocationMbReqListSV apprItem Strart++++++++++++++++++++++++++++++++++++++" ); 
        	
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
           
            Box box = WebUtil.getBox(req);
            String empNo     = box.get("empNo"); //��� 
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);
            String PERNR = empNo;
            
            String fromDate  = DataUtil.delDateGubn(box.get("fromDate"));//��������
            String toDate    = DataUtil.delDateGubn(box.get("toDate")); //�Ϸ�����
            String apprApproveStatus = box.get("apprApproveStatus"); //�������
            
            com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
		    boolean isDev = conf.getBoolean("com.sns.jdf.eloffice.ISDEVELOP");
            String mUrl = "http://"+conf.getString("com.sns.jdf.eloffice.ResponseURL")+WebUtil.ServletURL+"hris.MobileDetailSV?AINF_SEQN="; //
            String mobileUrl ="";
            
            // 1.Envelop XML�� �����Ѵ�.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML�� �����Ѵ�.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE �� �����Ѵ�.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.������� �����Ѵ�.
            Element items = XmlUtil.createItems(itemsName);
                  
            Logger.debug.println(this, "[PERNR] = "+PERNR + " [user] : "+user.toString());       
                  
            // �����ΰ�� �����ڵ忡 0�� �����Ѵ�.+
	        XmlUtil.addChildElement(items, "returnDesc", "");
	        XmlUtil.addChildElement(items, "returnCode", "0");                 
	     
	        //�ް�����Ʈ
	        ApprovalListKey aplk     =   new ApprovalListKey();
            Vector vcApprovalDocList = null;
             
            if (fromDate.equals("")){
	            aplk.I_BEGDA  =   DataUtil.getAfterDate( DataUtil.getCurrentDate() , -7);
	            aplk.I_ENDDA  =   DataUtil.getCurrentDate();
        	}else{
        		aplk.I_BEGDA  =   fromDate;
	            aplk.I_ENDDA  =   toDate ;
        	}
        
            //GUBUN; // ����   1 �����ؾ��ҹ��� ,2 ���������� ���� ,3 ����ϷṮ��
            aplk.I_AGUBN  =   "2";
            aplk.I_PERNR  =   PERNR;
            aplk.I_UPMU_TYPE = "18";// �ް��� LISTUP
            // STAT_TYPE;    // ����   "1 ��û ,2 ���������� ,3 ����Ϸ� ,4 �ݷ�"
	                    
            //�ް���ûLIST
            G001ApprovalDocListRFC aplRFC = new G001ApprovalDocListRFC();
            vcApprovalDocList = aplRFC.getApprovalDocList(aplk);
           
            // �ް����� ��û ��� 
            Logger.debug.println("D03VocationMbReqListSV vcApprovalDocList.size()  JMK+++++"+vcApprovalDocList.size() ); 
            for(int i=0; i< vcApprovalDocList.size(); i++){
            	
            	ApprovalDocList apl = (ApprovalDocList)vcApprovalDocList.get(i);
               
            	mobileUrl=mUrl+ "&empNo="+WebUtil.encode(EncryptionTool.encrypt(empNo))+"&apprDocID="+apl.AINF_SEQN;
            	
                Element item = XmlUtil.createElement("apprHolidayList");
                XmlUtil.addChildElement(item, "apprSystemID", "EHR");
                XmlUtil.addChildElement(item, "apprSystemName","�λ�");
                XmlUtil.addChildElement(item, "apprDocID", apl.AINF_SEQN);
                XmlUtil.addChildElement(item, "apprTypeID", "EHR-" + apl.AINF_SEQN);
                XmlUtil.addChildElement(item, "apprCategory","�ް���û");
                XmlUtil.addChildElement(item, "subject", apl.UPMU_NAME +" "+apl.STEXT);
                XmlUtil.addChildElement(item, "linkUrl", mobileUrl);
                XmlUtil.addChildElement(item, "apprRequestEmpNo", apl.PERNR);
                XmlUtil.addChildElement(item, "apprRequestEmpName", apl.ENAME); //����,�ݷ��� ����
                XmlUtil.addChildElement(item, "apprRequestEmpDept", apl.STEXT);
                XmlUtil.addChildElement(item, "apprRequestEmpTitle", user.e_titel);
                XmlUtil.addChildElement(item, "apprRequestDate", apl.BEGDA);
                
                XmlUtil.addChildElement(items, item);
                Logger.debug.println("D03VocationMbReqListSV apl)  JMK+++++++++++>"+apl.toString() ); 
            }
            
	        // XML�� �����Ѵ�.
	        XmlUtil.addChildElement(waitResponse, items);
	        XmlUtil.addChildElement(body, waitResponse);
	        XmlUtil.addChildElement(envelope, body);
	
	        // ���������� XML Document�� XML String�� ��ȯ�Ѵ�.
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