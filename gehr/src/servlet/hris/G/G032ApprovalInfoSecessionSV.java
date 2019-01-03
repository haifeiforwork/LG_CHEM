/********************************************************************************/
/*                                                                              */
/*   System Name  :  e-HR                                                        */
/*   1Depth Name  : HR ������                                                   */
/*   2Depth Name  : ���� �ؾ��� ����                                            */
/*   Program Name : ������ Ż�� ��û                                            */
/*   Program ID   : G032ApprovalInfoSecessionSV                                 */
/*   Description  : ������ Ż�� ���� ����/�ݷ�                                  */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-14  �̽���                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E26InfoState.E26InfoStateData;
import hris.E.E26InfoState.rfc.E26InfosecessionRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;


public class G032ApprovalInfoSecessionSV extends ApprovalBaseServlet
{
    private String UPMU_NAME = "������ Ż��";

    private String UPMU_TYPE = "27";     // ���� ����Ÿ��(������ ����)


    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

        final WebUserData user = WebUtil.getSessionUser(req);

        String dest  = "";

        final Box box = WebUtil.getBox(req);

        String  AINF_SEQN  = box.get("AINF_SEQN");

        String jobid = box.get("jobid");
        /* ���� �ݷ� �� */

        final E26InfosecessionRFC e26InfosecessionRFC = new E26InfosecessionRFC();
        e26InfosecessionRFC.setDetailInput(user.empNo, "1", AINF_SEQN);
        final E26InfoStateData e26InfoStateData = Utils.indexOf(e26InfosecessionRFC.getDetail(), 0); //��� ����Ÿ

        /* ���� �� */
        if("A".equals(jobid)) {
            /* ������ ���� �� */
            dest = accept(req, box, "", e26InfoStateData, e26InfosecessionRFC, new ApprovalFunction<E26InfoStateData>() {
                public boolean porcess(E26InfoStateData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                    /* ������ ���� ���� */


                    return true;
                }
            });

        /* �ݷ��� */
        } else if("R".equals(jobid)) {
            dest = reject(req, box, "", e26InfoStateData, e26InfosecessionRFC, null);
        } else if("C".equals(jobid)) {
            dest = cancel(req, box, "", e26InfoStateData, e26InfosecessionRFC, null);
        }else {
            throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
        }

        Logger.debug.println(this, " destributed = " + dest);
        printJspPage(req, res, dest);

    } catch(Exception e) {
        Logger.err.println(DataUtil.getStackTrace(e));
        throw new GeneralException(e);
    }
}
}
