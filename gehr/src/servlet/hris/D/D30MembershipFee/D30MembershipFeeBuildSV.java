/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �ڰݸ�����                                                */
/*   Program Name : �ڰݸ����� ��û                                           */
/*   Program ID   : D30MembershipFeeBuildSV                                           */
/*   Description  : �ڰ������㸦 ��û�� �� �ֵ��� �ϴ� Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-11  �ֿ�ȣ                                          */
/*   Update       : 2005-02-15  ������                                          */
/*   Update       : 2005-02-23  �����                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D30MembershipFee;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D15EmpPayInfo.rfc.D15EmpPayTypeGlobalRFC;
import hris.D.D30MembershipFee.D30MembershipFeeData;
import hris.D.D30MembershipFee.rfc.D30MembershipFeeRFC;
import hris.D.D30MembershipFee.rfc.D30MembershipFeeTypeRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class D30MembershipFeeBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "18";     // ���� ����Ÿ��(�ڰݸ�����)
    private String UPMU_NAME = "ȸ��";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            D15EmpPayTypeGlobalRFC empPayTypeGlobalRFC = new D15EmpPayTypeGlobalRFC();

            if(!"X".equals(empPayTypeGlobalRFC.enableMemberFee(WebUtil.getSessionUser(req).empNo))) {
                moveMsgPage(req, res, g.getMessage("MSG.COMMON.0060"), "history.back();");
                return;
            }

            String dest;

            String jobid = box.get("jobid", "first");

            if (jobid.equals("first")) {   //����ó�� ��û ȭ�鿡 ���°��.
                String PERNR = getPERNR(box, user); //��û����� ���

                //�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);

                D30MembershipFeeTypeRFC rfc = new D30MembershipFeeTypeRFC();
                req.setAttribute("payTypeList", rfc.getMembershipType(user.empNo, DataUtil.getCurrentYear() + DataUtil.getCurrentMonth()));


                Vector<CodeEntity> monthList = DataUtil.getYearMonthList(3);
                Vector<CodeEntity> yearmonthList = new Vector<CodeEntity>();
                D01OTCheckGlobalRFC checkGlobalRFC = new D01OTCheckGlobalRFC();

                for(CodeEntity yearMonth : monthList) {
                    String flag = checkGlobalRFC.check1(user.empNo, yearMonth.getCode() + "20", getUPMU_TYPE());        // ��û�ڻ��, ��û��¥, ����Ÿ��
                    if (!"Y".equals(flag)) {
                        continue;
//                        yearMonth.setValue1("disabled"); //���� �Ұ��� ��¥check
                    }
                    yearmonthList.add(yearMonth);
                }

                req.setAttribute("yearMonthList", yearmonthList);

                dest = WebUtil.JspURL + "D/D30MembershipFee/D30MembershipFeeBuild.jsp";

            } else if (jobid.equals("create")) {

                /* ���� ��û �κ� */
                dest = requestApproval(req, box, D30MembershipFeeData.class, new RequestFunction<D30MembershipFeeData>() {
                    public String porcess(D30MembershipFeeData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        D01OTCheckGlobalRFC checkGlobalRFC = new D01OTCheckGlobalRFC();
                        if(!"Y".equals(checkGlobalRFC.check1(user.empNo, box.get("I_YYYYMM") + "20", getUPMU_TYPE()))){
                            throw new GeneralException("You can not apply this data");
                        }

                        /* ���� ��û RFC ȣ�� */
                        D30MembershipFeeRFC membershipFeeRFC = new D30MembershipFeeRFC();
                        membershipFeeRFC.setRequestInput(user.empNo, UPMU_TYPE);

                        Vector<D30MembershipFeeData> inputList = box.getVector(D30MembershipFeeData.class, "LIST_");

                        String AINF_SEQN = membershipFeeRFC.build(inputList, box, req);

                        if(!membershipFeeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(membershipFeeRFC.getReturn().MSGTX);
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
