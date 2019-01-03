/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ʰ��ٹ�                                                    */
/*   Program Name : �ʰ��ٹ� ��û (����Ͽ�����û)                              */
/*   Program ID   : D01OTMbBuildPreLoadDataSV                              	*/
/*   Description  : �ʰ��ٹ� ��û �ʱ�ȭ�� Road�� �ʰ��ٹ� �ʿ� DATA �� ������� Return  */
/*   Note         :                                                             */
/*   Creation     : 2013-09-24                                                  */
/*   update       : 2018/06/09 rdcamel [CSR ID:3701161] ����� �ʰ��ٹ� ��û/���� ���� ���� ��û ��                                                                           */
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
        	
        	//�α���ó��
        	MobileCommonSV mc = new MobileCommonSV() ;
        	mc.autoLogin(req,res);
        	        	
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            Box box = WebUtil.getBox(req);
          
         
            String empNo     = box.get("empNo"); //��� 
            Logger.debug.println(" D01OTMbBuildPreLoadDataSV decrypt before"+     empNo.length());    
            empNo = EncryptionTool.decrypt(empNo);

            Logger.debug.println(" D01OTMbBuildPreLoadDataSV empNo.length()======>"+     empNo.length());    
            if (empNo.length()<9) {
            	empNo = DataUtil.fixEndZero( empNo ,8);
            }
            Logger.debug.println(" D01OTMbBuildPreLoadDataSV empNo======>"+     empNo);     

            // ����ó�� �����
            String returnXml = apprItem(req,res);

            // ����� ���� xmlStirng��  �����Ѵ�.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);
            Logger.debug.println("D01OTMbBuildPreLoadDataSV returnXml++++++++++++++++++++++++++++++++++++++"+returnXml );
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
         * �ܿ��ʰ��ٹ��� �� ������θ� XML���·� �����´�.
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
          
            Logger.debug.println("D01OTMbBuildPreLoadDataSV apprItem JMK+++++" ); 
            
            //��û������
            PersonInfoRFC numfunc        = new PersonInfoRFC();
            PersonData phonenumdata   = new PersonData();
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
                
        
            //Logger.debug.println("D01OTMbBuildPreLoadDataSV apprItem P_REMAIN++++++++++++++++"+d03RemainVocationData.P_REMAIN);  
            
            
            // �����ΰ�� �����ڵ忡 0�� �����Ѵ�.
            if (phonenumdata != null ){
    	        XmlUtil.addChildElement(items, "returnDesc", "");
    	        XmlUtil.addChildElement(items, "returnCode", "0");            
                

                String eName = phonenumdata.E_ENAME ;
                String eOrgtx = phonenumdata.E_ORGTX ;   
	            	
		        // ��û�ںμ� �� �̸�
		        XmlUtil.addChildElement(items, "apprRequestEmpDept", eOrgtx);
		        XmlUtil.addChildElement(items, "apprRequestEmpName", eName);            
	
		        // ���ϱٹ�,����Ư�� �� üũ���� �����GET �繫������(S):����Ư��,����Ư�ٽ�û���� ,������ûüũ , �������(T) : ������û����
		        String E_PERSKG  = (new D03VocationAReasonRFC()).getE_PERSKG(user.companyCode ,PERNR, "2005", DataUtil.getCurrentDate());
		        //21  ���λ��  ,22  �繫��  , 24  �����  
		        if (phonenumdata.E_PERSK.equals("21")||phonenumdata.E_PERSK.equals("22")||phonenumdata.E_PERSK.equals("24") ){
		        	E_PERSKG="S";
		        }else{
		        	E_PERSKG="T";
		        }
		        XmlUtil.addChildElement(items, "apprRequestPERSKG", E_PERSKG);  
		        
		        //C20100812_18478 ���ϱٹ� ��û ����� ���� :����̸� ��û����
		        String OTbuildYn  = (new D03VocationAReasonRFC()).getE_OVTYN(user.companyCode,  PERNR, "2005",DataUtil.getCurrentDate());
		        // BBIA ���ֻ�������ܷ��� ���� 
		        String E_BTRTL  = (new D03VocationAReasonRFC()).getE_BTRTL(user.companyCode, PERNR, "2005",DataUtil.getCurrentDate());
		        XmlUtil.addChildElement(items, "apprRequestbuildYn", OTbuildYn);  
		        XmlUtil.addChildElement(items, "apprRequestBTRTL", E_BTRTL);  
	            Logger.debug.println("D01OTMbBuildPreLoadDataSV E_BTRTL++++++++++++++++"+E_BTRTL);  
	            Logger.debug.println("D01OTMbBuildPreLoadDataSV OTbuildYn++++++++++++++++"+OTbuildYn);  
	            Logger.debug.println("D01OTMbBuildPreLoadDataSV E_BTRTL++++++++++++++++"+E_BTRTL);  
	            
	            //[CSR ID:3701161] apprRequestEmpNtmGubn �߰� : A : �繫�� ���� ȭ��, B, ������ ����ȭ��, C : �繫�� ����ȭ��, D : ������ ����ȭ��
	            Vector empGub_vt  = (new D25WorkTimeEmpGubRFC()).getEmpGub(user.empNo, DataUtil.getCurrentDate());//ZGHR_RFC_NTM_GET_EMPGUB ȣ��
	            if( empGub_vt != null && empGub_vt.get(0).equals("S")){
	            	XmlUtil.addChildElement(items, "apprRequestEmpNtmGubn",  empGub_vt.get(3)+"");
	            	//XmlUtil.addChildElement(items, "apprRequestHolidayNtmGubn", empGub_vt.get(4)+"");��û ��¥�� ������ üũ�ؾ� �ϴµ� ����Ͽ����� load ��Ų ��¥ ������ X ���� üũ�ϹǷ� �ǹ� ����.
	            }else{
	            	errorCode = MobileCodeErrVO.ERROR_CODE_600;
	                errorMsg = MobileCodeErrVO.ERROR_MSG_600+empGub_vt.get(1);
			        xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
		            return xmlString;
	            }

	            // ������� �˻��� ������� �̿��Ͽ� row �����Ϳ� ���� XML element�� �����Ѵ�.
	            /*Vector  appTargetList = null;
	            appTargetList = AppUtil.getAppVector( PERNR, UPMU_TYPE );*/
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
	             
	             //����
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
		        XmlUtil.addChildElement(items, "returnDesc", "����� Ȯ���ϼ���.");
		        XmlUtil.addChildElement(items, "returnCode", "-1");  
            }
	        // XML�� �����Ѵ�.
	        XmlUtil.addChildElement(waitResponse, items);
	        XmlUtil.addChildElement(body, waitResponse);
	        XmlUtil.addChildElement(envelope, body);
	
	        // ���������� XML Document�� XML String�� ��ȯ�Ѵ�.
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
