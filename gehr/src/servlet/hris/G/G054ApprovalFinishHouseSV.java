/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : �����ڱ� �űԽ�û ����                                      */
/*   Program Name : �����ڱ� �űԽ�û ����                                      */
/*   Program ID   : G054ApprovalFinishHouseSV                                   */
/*   Description  : �����ڱ� �űԽ�û ���� �Ϸ�                                 */
/*   Note         :                                                             */
/*   Creation     : 2005-03-10  ������                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E05House.E05HouseData;
import hris.E.E05House.E05PersInfoData;
import hris.E.E05House.rfc.E05HouseRFC;
import hris.E.E05House.rfc.E05PersInfoRFC;
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

public class G054ApprovalFinishHouseSV extends EHRBaseServlet
{
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Vector       vcAppLineData;
            E05HouseData e05HouseData;
            Vector       vc05HouseData;

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

                E05HouseRFC       rfc   = new E05HouseRFC();
                PersInfoWithNoRFC piRfc = new PersInfoWithNoRFC();

                vc05HouseData = rfc.detail(AINF_SEQN);
                Logger.debug.println(this, " vc05HouseData=["+vc05HouseData);

                vcAppLineData = AppUtil.getAppChangeVt(AINF_SEQN);

                if(vc05HouseData.size() < 1){
                    String msg = "��ȸ�� �׸��� �����͸� �о���̴� �� ������ �߻��߽��ϴ�.";
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL+"common/msg.jsp";
                }else{
                    e05HouseData = (E05HouseData)vc05HouseData.get(0);

                    E05PersInfoData E05PersInfoData = null;

                    // E05PersInfoRFC ���ּ�, �ټӳ��
                    E05PersInfoRFC func1 = new E05PersInfoRFC();
                    E05PersInfoData = (E05PersInfoData)func1.getPersInfo(e05HouseData.PERNR);
                    Logger.debug.println(this, "E05PersInfoData : "+ E05PersInfoData.toString());

                    PersInfoData  pid = (PersInfoData)piRfc.getApproval(e05HouseData.PERNR).get(0);

                    req.setAttribute("PersInfoData" ,pid );
                    req.setAttribute("e05HouseData"   , e05HouseData);
                    req.setAttribute("vcAppLineData"  , vcAppLineData);
                    req.setAttribute("E05PersInfoData", E05PersInfoData);

                    dest = WebUtil.JspURL+"G/G054ApprovalFinishHouse.jsp";
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