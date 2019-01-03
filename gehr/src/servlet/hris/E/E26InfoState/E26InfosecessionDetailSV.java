/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 인포멀가입현황                                              */
/*   Program Name : 인포멀가입현황                                              */
/*   Program ID   : E26InfosecessionDetailSV                                    */
/*   Description  : 인포멀 탈퇴신청에 대한 상세정보를 가져와 jsp로 넘겨주는Class*/
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  이형석                                          */
/*   Update       : 2005-03-02  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E26InfoState;

import java.sql.*;
import java.util.Properties;
import java.util.Vector;
import javax.servlet.http.*;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalBaseServlet.DeleteFunction;
import hris.common.db.*;
import hris.common.rfc.*;

import hris.E.E25Infojoin.*;
import hris.E.E25Infojoin.rfc.*;
import hris.E.E26InfoState.E26InfoStateData;
import hris.E.E26InfoState.rfc.*;

public class E26InfosecessionDetailSV extends ApprovalBaseServlet {

    private String UPMU_NAME = "인포멀 탈퇴";

    private String UPMU_TYPE = "27";     // 결재 업무타입(인포멀 가입)


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
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            final E26InfosecessionRFC e26InfosecessionRFC = new E26InfosecessionRFC();
            e26InfosecessionRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E26InfoStateData> resultJoinList = e26InfosecessionRFC.getDetail(); //결과 데이타

            final E25InfoSettRFC e25InfoSettRFC = new E25InfoSettRFC();
            e25InfoSettRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E25InfoSettData> resultSettList = e25InfoSettRFC.getDetail(); //결과 데이타

            if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.

                req.setAttribute("e26InfoStateData", Utils.indexOf(resultJoinList, 0));
                req.setAttribute("e25InfoSettData", Utils.indexOf(resultSettList, 0));

                if (!detailApporval(req, res, e26InfosecessionRFC))
                    return;

                printJspPage(req, res, WebUtil.JspURL + "E/E26InfoState/E26InfosecessionDetail.jsp");

            } else if (jobid.equals("delete")) {           //제일처음 신청 화면에 들어온경우.

                String dest = deleteApproval(req, box, e26InfosecessionRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E26InfosecessionRFC deleteJoinRFC = new E26InfosecessionRFC();
                    	deleteJoinRFC.setDeleteInput(user.empNo, UPMU_TYPE, e26InfosecessionRFC.getApprovalHeader().AINF_SEQN);

                    	RFCReturnEntity returnJoinEntity = deleteJoinRFC.delete();
                        if(!returnJoinEntity.isSuccess()) {
                            throw new GeneralException(returnJoinEntity.MSGTX);
                        }
                        return true;
                    }
                });

                printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

}
