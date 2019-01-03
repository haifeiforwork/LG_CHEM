/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ������ ����                                                 */
/*   Program Name : ������ ���� ��û                                            */
/*   Program ID   : E25InfoBuildSV                                              */
/*   Description  : ������ ���� ��û�� �� �ְ� �ϴ� Class                       */
/*   Note         :                                                             */
/*   Creation     : 2002-01-04  ������                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E25Infojoin;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.E.E25Infojoin.E25InfoJoinData;
import hris.E.E25Infojoin.rfc.E25InfoJoinRFC;
import hris.E.E25Infojoin.rfc.InfoListRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class E25InfoBuildSV extends ApprovalBaseServlet {

    private String UPMU_NAME = "������ ����";

    private String UPMU_TYPE = "19";     // ���� ����Ÿ��(������ ����)


    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }
    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");
            if (jobid.equals("first")) {   //����ó�� ��û ȭ�鿡 ���°��.
                String PERNR = getPERNR(box, user); //��û����� ���

                //�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);
                Vector InfoListData_vt = new Vector();
                InfoListData_vt = (new InfoListRFC()).getInfoList(PERNR);

                Logger.debug.println(this,"InfoListData_vt" + InfoListData_vt.toString());

                req.setAttribute("InfoListData_vt", InfoListData_vt);

                dest = WebUtil.JspURL+"E/E25Infojoin/E25InfojoinBuild.jsp";

            }else if (jobid.equals("create")) {
                /* ���� ��û �κ� */
                dest = requestApproval(req, box, E25InfoJoinData.class, new RequestFunction<E25InfoJoinData>() {
                    public String porcess(E25InfoJoinData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                    	  if(box.get("PERN_NUMB").trim()==null ||box.get("PERN_NUMB").trim().equals("00000000")|| box.get("PERN_NUMB").trim().equals("") ){
                    		  throw new GeneralException("���簡 �����Ǿ� ���� �ʽ��ϴ�.");

                          }

                        /* ���� ��û RFC ȣ�� */
                    	  E25InfoJoinRFC e25InfoJoinRFC = new E25InfoJoinRFC();
                    	  e25InfoJoinRFC.setRequestInput(user.empNo, UPMU_TYPE);
                    	  String AINF_SEQN = e25InfoJoinRFC.build(Utils.asVector(inputData), box, req);

                        if(!e25InfoJoinRFC.getReturn().isSuccess()) {
                            throw new GeneralException(e25InfoJoinRFC.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });
            } else {
                throw new GeneralException(g.getMessage("MSG.COMMON.0016"));
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}