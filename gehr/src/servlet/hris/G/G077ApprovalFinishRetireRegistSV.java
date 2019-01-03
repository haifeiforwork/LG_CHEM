/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : HR ������                                               */
/*   2Depth Name  : �������� ��û ����                                           */
/*   Program Name : �������� ��û ����                              */
/*   Program ID   : G077ApprovalFinishRetireRegistSV                                         */
/*   Description  : �������� ��û ���� �Ϸ�                             */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E03Retire.E03RetireRegistInfoData;
import hris.E.E03Retire.rfc.E03RetireBusinessListRFC;
import hris.E.E03Retire.rfc.E03RetireMBegdaRFC;
import hris.E.E03Retire.rfc.E03RetireRegistRFC;
import hris.E.E03Retire.rfc.E03RetireRegistResnRFC;
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

public class G077ApprovalFinishRetireRegistSV extends EHRBaseServlet
{
    private String UPMU_TYPE ="51";	//���������ڵ�
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector          vcAppLineData      = null;
            Vector          e03RetireRegistInfoData_vt = null;
            E03RetireRegistInfoData e03RetireRegistInfoData    = null;

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
            	
	            E03RetireRegistInfoData    RegistData    = new E03RetireRegistInfoData();
	            E03RetireRegistRFC      rfc       = new E03RetireRegistRFC();
	            
	            Vector E03RetireRegistData_vt  = null;
	            
	            //��û ����
	            E03RetireRegistData_vt = rfc.detail(AINF_SEQN);
	            
	            if(E03RetireRegistData_vt.size() > 0)
	            	RegistData = (E03RetireRegistInfoData)E03RetireRegistData_vt.get(0);
	            
	            Logger.debug.println(this, "E03RetireRegistData_vt : " + E03RetireRegistData_vt.toString());
            	            
	            vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                if(E03RetireRegistData_vt.size() < 1){
                    String msg = "��ȸ�� �׸��� �����͸� �о���̴� �� ������ �߻��߽��ϴ�.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }else{
                	//�������� �ڵ� ����Ʈ
                    Vector ResnList_vt = new E03RetireRegistResnRFC().getRetireTypeList();
                    // �����ڸ���Ʈ
                    Logger.debug.println(this, "AppLineData_vt : "+ vcAppLineData.toString());
                    
                    PersInfoData  pid = (PersInfoData)new PersInfoWithNoRFC().getApproval(RegistData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    
                    req.setAttribute("ResnList_vt", ResnList_vt);
                    req.setAttribute("RegistInfoData", RegistData);                //�����û ����
                    req.setAttribute("AppLineData_vt", vcAppLineData);

    	          	//DC�� ��� �����ϴ� ���� ����� ����Ʈ
                    Vector BusinessList_vt = new E03RetireBusinessListRFC().getRetireBusinessList(user.companyCode);   
                    req.setAttribute("BusinessList_vt", BusinessList_vt);      
                    
                    dest = WebUtil.JspURL+"G/G077ApprovalFinishRetireRegist.jsp";
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