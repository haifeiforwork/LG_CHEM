/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : �����ڱ� ��ȯ��û ����                                      */
/*   Program Name : �����ڱ� ��ȯ��û ����                                      */
/*   Program ID   : G063ApprovalFinishRehouseSV                                 */
/*   Description  : �����ڱ� ��ȯ��û ���� �Ϸ�                                 */
/*   Note         :                                                             */
/*   Creation     : 2005-03-11  ������                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E06Rehouse.E06RehouseData;
import hris.E.E06Rehouse.rfc.E06RehouseRequestRFC;
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

public class G063ApprovalFinishRehouseSV extends EHRBaseServlet
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector         vcAppLineData;
            E06RehouseData e06RehouseData;
            Vector         vc06RehouseData;

            String dest  = "";
            String jobid = "";
            Box box = WebUtil.getBox(req);

            String  AINF_SEQN  = box.get("AINF_SEQN");

            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            jobid = box.get("jobid");
            if(jobid == null || jobid.equals("") ){
                jobid = "search";
            }// end if

            if( jobid.equals("search") ) {

                E06RehouseRequestRFC rfc   = new E06RehouseRequestRFC();
                PersInfoWithNoRFC    piRfc = new PersInfoWithNoRFC();

                vc06RehouseData = rfc.detail( AINF_SEQN );

                e06RehouseData = (E06RehouseData)vc06RehouseData.get(0);
                Logger.debug.println(this, "vc06RehouseData : " + vc06RehouseData.toString());

                vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                if(vc06RehouseData.size() < 1){
                    String msg = "��ȸ�� �׸��� �����͸� �о���̴� �� ������ �߻��߽��ϴ�.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }else{
                    e06RehouseData = (E06RehouseData)vc06RehouseData.get(0);

                    PersInfoData  pid = (PersInfoData)piRfc.getApproval(e06RehouseData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    req.setAttribute("e06RehouseData"       , e06RehouseData);
                    req.setAttribute("vcAppLineData"     , vcAppLineData);

                    dest = WebUtil.JspURL+"G/G063ApprovalFinishRehouse.jsp";
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