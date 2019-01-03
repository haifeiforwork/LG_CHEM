/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ��û                                                        */
/*   2Depth Name  : ���λ���                                                    */
/*   Program Name : �ڰݸ���                                                    */
/*   Program ID   : A13AddressApprovalChangeSV                                          */
/*   Description  : �ڰݸ��㸦 ���� �Ҽ� �ֵ��� �ϴ� Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-14  �ֿ�ȣ                                          */
/*   Update       : 2005-02-25  �����                                          */
/*                                                                              */
/********************************************************************************/
package servlet.hris.D.D30MembershipFee;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D15EmpPayInfo.D15EmpPayTypeData;
import hris.D.D30MembershipFee.D30MembershipFeeData;
import hris.D.D30MembershipFee.rfc.D30MembershipFeeRFC;
import hris.D.D30MembershipFee.rfc.D30MembershipFeeTypeRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import org.apache.commons.collections.map.HashedMap;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Vector;

public class D30MembershipFeeChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE = "18";     // ���� ����Ÿ��(�ڰݸ�����)
    private String UPMU_NAME = "ȸ��";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            String dest;

            String jobid = box.get("jobid", "first");
            String AINF_SEQN = box.get("AINF_SEQN");

            //**********���� ��.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //��� ���������� �Գ�? '1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            /* ���� ��ȸ */
            final D30MembershipFeeRFC membershipFeeRFC = new D30MembershipFeeRFC();
            membershipFeeRFC.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);

            Vector<D30MembershipFeeData> resultList = membershipFeeRFC.getDetail(); //��� ����Ÿ
            D30MembershipFeeData resultData = Utils.indexOf(resultList, 0);


            if( jobid.equals("first") ) {  //����ó�� ���� ȭ�鿡 ���°��.
                //����� payTypeMap ��������
                Map<String, Vector<D15EmpPayTypeData>> payTypeMap = new HashedMap();
                D30MembershipFeeTypeRFC rfc = new D30MembershipFeeTypeRFC();
                req.setAttribute("payTypeList", rfc.getMembershipType(user.empNo, Utils.indexOf(resultList, 0).YYYYMM));


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

                req.setAttribute("resultList", resultList);
                req.setAttribute("resultData", resultData);

                req.setAttribute("currentYear", StringUtils.substring(resultData.getYYYYMM(), 0, 4));
                req.setAttribute("currentMonth", StringUtils.substring(resultData.getYYYYMM(), 4));
                req.setAttribute("isUpdate", true); //��� ���� ����

                detailApporval(req, res, membershipFeeRFC);

                printJspPage(req, res, WebUtil.JspURL + "D/D30MembershipFee/D30MembershipFeeBuild.jsp");

            } else if( jobid.equals("change") ) {

                /* ���� ��û �κ� */
                dest = changeApproval(req, box, D30MembershipFeeData.class, membershipFeeRFC, new ChangeFunction<D30MembershipFeeData>(){

                    public String porcess(D30MembershipFeeData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                        D01OTCheckGlobalRFC checkGlobalRFC = new D01OTCheckGlobalRFC();
                        if(!"Y".equals(checkGlobalRFC.check1(user.empNo, box.get("I_YYYYMM") + "20", getUPMU_TYPE()))){
                            throw new GeneralException("You can not apply this data");
                        }

                        /* ���� ��û RFC ȣ�� */
                        D30MembershipFeeRFC changeRFC = new D30MembershipFeeRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);

                        Vector<D30MembershipFeeData> inputList = box.getVector(D30MembershipFeeData.class, "LIST_");

                        /**
                         * �ʿ�� resultData ���� ����Ÿ�� ����
                         */


                        changeRFC.build(inputList, box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }

                        return inputData.AINF_SEQN;
                        /* ������ �ۼ� �κ� �� */
                    }
                });

                printJspPage(req, res, dest);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}
