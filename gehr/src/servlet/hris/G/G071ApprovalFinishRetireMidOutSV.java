/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : HR ������                                               */
/*   2Depth Name  : �������� �ߵ����� ����                                           */
/*   Program Name : �������� �ߵ����� ����                              */
/*   Program ID   : G071ApprovalFinishRetireMidOutSV                                         */
/*   Description  : �������� �ߵ����� ���� �Ϸ�                             */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 �ڹο�                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E03Retire.E03RetireMidOutInfoData;
import hris.E.E03Retire.rfc.E03RetireMBegdaRFC;
import hris.E.E03Retire.rfc.E03RetireMidOutRFC;
import hris.E.E03Retire.rfc.E03RetireMidOutResnRFC;
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

public class G071ApprovalFinishRetireMidOutSV extends EHRBaseServlet
{
    private String UPMU_TYPE ="53";	//���������ڵ�
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector          vcAppLineData      = null;
            Vector          e03RetireMidOutInfoData_vt = null;
            E03RetireMidOutInfoData e03RetireMidOutInfoData    = null;

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
	           	
	            E03RetireMidOutInfoData    MidOutData    = new E03RetireMidOutInfoData();
	            E03RetireMidOutRFC      rfc       = new E03RetireMidOutRFC();
	            
	            Vector E03RetireMidOutData_vt  = null;
	            
	            //��û ����
	            E03RetireMidOutData_vt = rfc.detail(AINF_SEQN);
	            
	            if(E03RetireMidOutData_vt.size() > 0)
	            	MidOutData = (E03RetireMidOutInfoData)E03RetireMidOutData_vt.get(0);
	            
	            Logger.debug.println(this, "E03RetireMidOutData_vt : " + E03RetireMidOutData_vt.toString());
            	            
	            vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                if(E03RetireMidOutData_vt.size() < 1){
                    String msg = "��ȸ�� �׸��� �����͸� �о���̴� �� ������ �߻��߽��ϴ�.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }else{
                	//�ߵ�������� ����Ʈ
                    Vector ResnList_vt = new E03RetireMidOutResnRFC().getMidOutResnList();
                    // �����ڸ���Ʈ
                    Logger.debug.println(this, "AppLineData_vt : "+ vcAppLineData.toString());
                    
                    PersInfoData  pid = (PersInfoData)new PersInfoWithNoRFC().getApproval(MidOutData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    
                    req.setAttribute("ResnList_vt", ResnList_vt);
                    req.setAttribute("MidOutInfoData", MidOutData);                //�����û ����
                    req.setAttribute("AppLineData_vt", vcAppLineData);

                    dest = WebUtil.JspURL+"G/G071ApprovalFinishRetireMidOut.jsp";
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