/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 인포멀 가입                                                 */
/*   Program Name : 인포멀 가입 조회                                            */
/*   Program ID   : E25InfoDetailSV                                             */
/*   Description  : 인포멀신청에 대한 상세정보를 가져오는 Class                 */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  이형석                                          */
/*   Update       : 2005-03-02  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E25Infojoin;

import hris.E.E25Infojoin.E25InfoJoinData;
import hris.E.E25Infojoin.E25InfoSettData;
import hris.E.E25Infojoin.rfc.E25InfoJoinRFC;
import hris.E.E25Infojoin.rfc.E25InfoSettRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E25InfoDetailSV extends ApprovalBaseServlet {

    private String UPMU_NAME = "인포멀 가입";

    private String UPMU_TYPE = "19";     // 결재 업무타입(인포멀 가입)


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

            final E25InfoJoinRFC e25InfoJoinRFC = new E25InfoJoinRFC();
            e25InfoJoinRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E25InfoJoinData> resultJoinList = e25InfoJoinRFC.getDetail(); //결과 데이타

            final E25InfoSettRFC e25InfoSettRFC = new E25InfoSettRFC();
            e25InfoSettRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E25InfoSettData> resultSettList = e25InfoSettRFC.getDetail(); //결과 데이타

            if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.
            	E25InfoJoinData e25InfoJoinData = new E25InfoJoinData();
            	e25InfoJoinData = Utils.indexOf(resultJoinList, 0);
            	e25InfoJoinData.BETRG   =   DataUtil.changeLocalAmount(e25InfoJoinData.BETRG, user.area);
                req.setAttribute("e25InfoJoinData", e25InfoJoinData);
                req.setAttribute("e25InfoSettData", Utils.indexOf(resultSettList, 0));

                if (!detailApporval(req, res, e25InfoJoinRFC))
                    return;

                printJspPage(req, res, WebUtil.JspURL + "E/E25Infojoin/E25InfojoinDetail.jsp");

            } else if (jobid.equals("delete")) {           //제일처음 신청 화면에 들어온경우.

                String dest = deleteApproval(req, box, e25InfoJoinRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                    	E25InfoJoinRFC deleteJoinRFC = new E25InfoJoinRFC();
                    	deleteJoinRFC.setDeleteInput(user.empNo, UPMU_TYPE, e25InfoJoinRFC.getApprovalHeader().AINF_SEQN);

                    	E25InfoSettRFC deleteSettRFC = new E25InfoSettRFC();
                    	deleteSettRFC.setDeleteInput(user.empNo, UPMU_TYPE, e25InfoJoinRFC.getApprovalHeader().AINF_SEQN);

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


