/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ������ ����                                                 */
/*   Program Name : ������ ���� ��ȸ                                            */
/*   Program ID   : E25InfoDetailSV                                             */
/*   Description  : �����ֽ�û�� ���� �������� �������� Class                 */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  ������                                          */
/*   Update       : 2005-03-02  ������                                          */
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

    private String UPMU_NAME = "������ ����";

    private String UPMU_TYPE = "19";     // ���� ����Ÿ��(������ ����)


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

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            final E25InfoJoinRFC e25InfoJoinRFC = new E25InfoJoinRFC();
            e25InfoJoinRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E25InfoJoinData> resultJoinList = e25InfoJoinRFC.getDetail(); //��� ����Ÿ

            final E25InfoSettRFC e25InfoSettRFC = new E25InfoSettRFC();
            e25InfoSettRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector<E25InfoSettData> resultSettList = e25InfoSettRFC.getDetail(); //��� ����Ÿ

            if (jobid.equals("first")) {           //����ó�� ��û ȭ�鿡 ���°��.
            	E25InfoJoinData e25InfoJoinData = new E25InfoJoinData();
            	e25InfoJoinData = Utils.indexOf(resultJoinList, 0);
            	e25InfoJoinData.BETRG   =   DataUtil.changeLocalAmount(e25InfoJoinData.BETRG, user.area);
                req.setAttribute("e25InfoJoinData", e25InfoJoinData);
                req.setAttribute("e25InfoSettData", Utils.indexOf(resultSettList, 0));

                if (!detailApporval(req, res, e25InfoJoinRFC))
                    return;

                printJspPage(req, res, WebUtil.JspURL + "E/E25Infojoin/E25InfojoinDetail.jsp");

            } else if (jobid.equals("delete")) {           //����ó�� ��û ȭ�鿡 ���°��.

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


