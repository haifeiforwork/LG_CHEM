/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                                                                     */
/*   2Depth Name  : �ް�                                                                                                                 */
/*   Program Name : �ް� ��û (����Ͽ�����û)                                       */
/*   Program ID   : D03VocationMbBuildRemainDateSV                              */
/*   Description  : �ް���     ��û �ʱ�ȭ�� Road�� �ް��ܿ��� �� ������� Return            */
/*   Note         :                                                             */
/*   Creation     : 2011-05-18     
 *   update        : 2018/06/08 rdcamel [CSR ID:3700538] �����ް��� ���Կ� ���� Mobile �ް���û �� ����ȭ�� ���� ��û ��                                                                                    */
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

	private String UPMU_TYPE ="18";   // ���� ����Ÿ��(�ް���û)
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
     
    	try{
    		
        	Logger.debug.println("D03VocationMbBuildRemainDateSV start++++++++++++++++++++++++++++++++++++++" ); 
        	
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
            
            Logger.debug.println(" D03VocationMbBuildRemainDateSV empNo======>"+     empNo);     
            // ����ó�� �����
            String returnXml = apprItem(req,res);

            // ����� ���� xmlStirng��  �����Ѵ�.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);
            Logger.debug.println("D03VocationMbBuildRemainDateSV returnXml++++++++++++++++++++++++++++++++++++++"+returnXml );
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
        
       //���հ��翬�� �����
    	MobileReturnData retunMsgEL = new MobileReturnData();
        
        try{
        	Logger.debug.println("D03VocationMbBuildRemainDateSV apprItem Strart++++++++++++++++++++++++++++++++++++++" ); 
        	
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
           
            Box box = WebUtil.getBox(req);
            String empNo     = box.get("empNo"); //��� 
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);
            String PERNR = empNo;
            
            // 1.Envelop XML�� �����Ѵ�.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML�� �����Ѵ�.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE �� �����Ѵ�.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.������� �����Ѵ�.
            Element items = XmlUtil.createItems(itemsName);
            
                    
            Logger.debug.println(this, "[PERNR] = "+PERNR + " [user] : "+user.toString());       
          
            Logger.debug.println("D03VocationMbBuildRemainDateSV apprItem JMK+++++" ); 
            
            //��û������
            PersonInfoRFC numfunc        = new PersonInfoRFC();
            PersonData phonenumdata   = new PersonData();
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            String eName = phonenumdata.E_ENAME ;
            String eOrgtx = phonenumdata.E_ORGTX ;   
                
            //�ܿ��ް���
            //D03GetWorkdayRFC func = new D03GetWorkdayRFC();
            D03GetWorkdayOfficeRFC func = new D03GetWorkdayOfficeRFC();
            Object D03GetWorkdayData_vt = func.getWorkday( PERNR, DataUtil.getCurrentDate(), "M" );//A : �����ް�, B : �����ް�, C : ��ü�ް�(Report ����), M ����Ͽ� �ް���ȸ
            String ZKVRB = DataUtil.getValue(D03GetWorkdayData_vt, "ZKVRB"); 
            //[CSR ID:3700538]
            String REMAINT = DataUtil.getValue(D03GetWorkdayData_vt, "REMAINT"); 
            
            //Logger.debug.println("D03VocationMbBuildRemainDateSV apprItem P_REMAIN++++++++++++++++"+d03RemainVocationData.P_REMAIN); 
            Logger.debug.println("D03VocationMbBuildRemainDateSV apprItem ZKVRB+++++++++++++++++++"+ZKVRB);
            
            
            // �����ΰ�� �����ڵ忡 0�� �����Ѵ�.
	        XmlUtil.addChildElement(items, "returnDesc", "");
	        XmlUtil.addChildElement(items, "returnCode", "0");                 
	     
	        // ��û�ںμ� �� �̸�
	        XmlUtil.addChildElement(items, "apprRequestEmpDept", eOrgtx);
	        XmlUtil.addChildElement(items, "apprRequestEmpName", eName);
	        //�ܿ��ް��� Setting
	        XmlUtil.addChildElement(items, "applyHolidayRemainDate", ZKVRB);
	        XmlUtil.addChildElement(items, "applyHolidayRemainDateText", REMAINT);// [CSR ID:3700538] ex)���� 14.00��, ���� : 3.5��(28.0�ð�) 
            
            // ������� �˻��� ������� �̿��Ͽ� row �����Ϳ� ���� XML element�� �����Ѵ�.
            /*Vector  appTargetList = null;*/

            /*appTargetList = AppUtil.getAppVector( PERNR, UPMU_TYPE );*/
            ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC();
            Vector<ApprovalLineData> appTargetList = approvalLineRFC.getApprovalLine(UPMU_TYPE, PERNR);

            String APPL_APPR_STAT = "";
            for(int i=0; i< appTargetList.size(); i++){

                ApprovalLineData appLineData = (ApprovalLineData)appTargetList.get(i);

                if (appLineData.APPR_STAT.equals("A")) {
                    APPL_APPR_STAT ="����";
                } else if (appLineData.APPR_STAT.equals("R")) {
                    APPL_APPR_STAT ="�ݷ�";
                } else {
                    APPL_APPR_STAT ="�̰�";
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
                XmlUtil.addChildElement(item, "apprApproveType", "APPROVAL"); //����,�ݷ��� ����
                XmlUtil.addChildElement(item, "apprComment", appLineData.BIGO_TEXT);
                XmlUtil.addChildElement(item, "apprType", APPL_APPR_STAT);
                
                XmlUtil.addChildElement(items, item);
                
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
