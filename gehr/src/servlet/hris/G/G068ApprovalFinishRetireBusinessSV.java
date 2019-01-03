/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : HR ������                                               */
/*   2Depth Name  : �������� ����� ���� ����                                           */
/*   Program Name : �������� ����� ���� ����                              */
/*   Program ID   : G068ApprovalFinishRetireBusinessSV                                         */
/*   Description  : �������� ����� ���� ���� �Ϸ�                               */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E03Retire.E03RetireBusinessInfoData;
import hris.E.E03Retire.rfc.E03RetireBusinessInfoRFC;
import hris.E.E03Retire.rfc.E03RetireBusinessListRFC;
import hris.E.E03Retire.rfc.E03RetireBusinessRFC;
import hris.E.E03Retire.rfc.E03RetireMBegdaRFC;
import hris.common.PersInfoData;
import hris.common.WebUserData;
import hris.common.rfc.PersInfoWithNoRFC;
import hris.common.util.AppUtil;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class G068ApprovalFinishRetireBusinessSV extends EHRBaseServlet
{
    private String UPMU_TYPE ="50";	//���������ڵ�
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector          vcAppLineData      = null;
            Vector          e03RetireBusinessInfoData_vt = null;
            E03RetireBusinessInfoData e03RetireBusinessInfoData    = null;

            String dest  = "";
            String jobid = "";

            Box box = WebUtil.getBox(req);
            String  AINF_SEQN  = box.get("AINF_SEQN");

            // ó�� �� ���� �� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            jobid = box.get("jobid");

            if(jobid == null || jobid.equals("") ){
                jobid = "search";
            }// end if
            
            if( jobid.equals("search") ) {
	           	//������ �Է¶� ��/��
	           	String m_begda = new E03RetireMBegdaRFC().getRetireMBegdaInfo(UPMU_TYPE);
	           	req.setAttribute("m_begda" ,m_begda );
	           	
	            E03RetireBusinessInfoData    businessData    = new E03RetireBusinessInfoData();
	            E03RetireBusinessRFC      rfc       = new E03RetireBusinessRFC();
	            
	            Vector E03RetireBusinessData_vt  = null;
	            
	            //��û ����
	            E03RetireBusinessData_vt = rfc.detail(AINF_SEQN);
	            
	            if(E03RetireBusinessData_vt.size() > 0)
	            	businessData = (E03RetireBusinessInfoData)E03RetireBusinessData_vt.get(0);
	            
	            Logger.debug.println(this, "E03RetireBusinessData_vt : " + E03RetireBusinessData_vt.toString());
            	            
	            vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                if(E03RetireBusinessData_vt.size() < 1){
                    String msg = "��ȸ�� �׸��� �����͸� �о���̴� �� ������ �߻��߽��ϴ�.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }else{
                	//���� ����� ����Ʈ
                    Vector BusinessList_vt = new E03RetireBusinessListRFC().getRetireBusinessList(user.companyCode);
                    //���� ������� ���ݻ���� ����
                    E03RetireBusinessInfoData businessInfo = new E03RetireBusinessInfoRFC().getRetireBusinessInfo(user.empNo);
                    // �����ڸ���Ʈ
                    Logger.debug.println(this, "AppLineData_vt : "+ vcAppLineData.toString());
                    
                    PersInfoData  pid = (PersInfoData)new PersInfoWithNoRFC().getApproval(businessData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    
                    req.setAttribute("BusinessList_vt", BusinessList_vt);
                    req.setAttribute("cur_insu_code", businessInfo.E_INSU_CODE);
                    req.setAttribute("BusinessInfoData", businessData);                //�����û ����
                    req.setAttribute("AppLineData_vt", vcAppLineData);

                    dest = WebUtil.JspURL+"G/G068ApprovalFinishRetireBusiness.jsp";
                } // end if
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        } finally {

        }
    }
}