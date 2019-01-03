/*
 * 작성된 날짜: 2005. 1. 28.
 *
 */
package servlet.hris;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.G.G001Approval.ApprovalDocList;
import hris.G.G001Approval.ApprovalListKey;
import hris.G.G001Approval.rfc.G001ApprovalDocListRFC;
import hris.common.DraftDocForEloffice;
import hris.common.ElofficInterfaceData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalLineInput;
import hris.common.approval.ApprovalLineRFC;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * @author 이승희
 */
public class SyncApprovalListSV extends EHRBaseServlet {

    /* (비Javadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void performTask(HttpServletRequest req, HttpServletResponse res)
            throws GeneralException {

        try {
            req.setAttribute("isLocal", WebUtil.isLocal(req));
            String dest  = "";

            WebUserData user = WebUtil.getSessionUser(req);
            if(user == null) user = new WebUserData();

            ApprovalListKey aplk = new ApprovalListKey();

            Box box = WebUtil.getBox(req);
            String jobid = box.get("jobid", "search");


            user.empNo = box.get("PERNR", user.empNo);

            if (jobid.equals("search")) {

                if (StringUtils.isBlank(req.getParameter("jobid"))) {
                    aplk.I_BEGDA = DataUtil.getAfterDate(DataUtil.getCurrentDate(), -30);
                    aplk.I_ENDDA = DataUtil.getCurrentDate();
                } else {
                    box.copyToEntity(aplk);
                } // end if

                aplk.I_AGUBN = "3";
                aplk.I_PERNR = user.empNo;

                G001ApprovalDocListRFC aplRFC = new G001ApprovalDocListRFC();
                Vector<ApprovalDocList> resultList = aplRFC.getApprovalDocList(aplk);

                req.setAttribute("resultList", resultList);
                req.setAttribute("inputData", aplk);

                Map<String, Vector<ApprovalLineData>> approvalLineMap = new HashMap<String, Vector<ApprovalLineData>>();
                for(ApprovalDocList row : resultList) {
                    ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC();
                    ApprovalLineInput inputData = new ApprovalLineInput();
                    inputData.I_AINF_SEQN = row.AINF_SEQN;
                    inputData.I_PERNR = user.empNo;
                    Vector<ApprovalLineData> approvalLine = approvalLineRFC.getApprovalLine(inputData);
                    approvalLineMap.put(row.AINF_SEQN, approvalLine);
                }

                req.setAttribute("approvalLineMap", approvalLineMap);


                printJspPage(req, res, WebUtil.JspURL + "syncApproval.jsp");

            } else if (jobid.equals("save")) {

                String msg = "msg009";
                String msg2 = "";

                Vector<ApprovalDocList> vcApprovalDocList = box.getVector(ApprovalDocList.class);

                String[] seqns = req.getParameterValues("approvalSeq");

                if(seqns == null || Utils.getSize(vcApprovalDocList) == 0) {
                    moveMsgPage(req, res, g.getMessage("MSG.APPROVAL.NO.DATA"), "history.back();");
                    return;
                }

                List<String> seqnList = new ArrayList<String>();
                CollectionUtils.addAll(seqnList, seqns);

                Vector vcElofficInterfaceData = new Vector();

                for(final ApprovalDocList row : vcApprovalDocList) {

                    boolean exist = CollectionUtils.exists(seqnList, new Predicate() {
                        public boolean evaluate(Object o) {
                            return row.AINF_SEQN.equals(o);
                        }
                    });

                    if(exist) {
                        try {

                            /* reqDate */
                            String reqDate = null;

                            /* 싱크 로직 */
                            /*
                            * 1. 결재
                            *
                            * */


                            if (!row.UPMU_TYPE.equals("23")) {
                                DraftDocForEloffice ddfe = new DraftDocForEloffice();
                                ElofficInterfaceData eof;
                                Logger.debug.println(this, "====chem [[신청시 결재자 ]]:apl.APPU_NUMB" + row.APPU_NUMB + "로그인결재자  user.empNo:" + user.empNo);


                                if (!row.APPU_NUMB.equals(user.empNo)) {
                                    Logger.debug.println(this, "==== [[신청시 결재자가 현재 결재자와 다른경우  ]]:apl.APPU_NUMB" + row.APPU_NUMB + "로그인결재자  user.empNo:" + user.empNo);
                                    //결재올려진 결재자 외의 테스크를 가지고 있는 결재자가 결재할때 처리:현재 전자결재에 들어가있는 DATA를 삭제후 다시 처리
                                    ElofficInterfaceData eofD = ddfe.makeDocForDelete(row.AINF_SEQN, user.SServer, row.PERNR, row.getUPMU_NAME(), row.APPU_NUMB);
                                    eofD.REQ_DATE = reqDate;
                                    vcElofficInterfaceData.add(eofD);
                                    ElofficInterfaceData eofI = ddfe.makeDocForInsert(row.AINF_SEQN, user.SServer, row.PERNR, row.UPMU_NAME);
                                    eofI.REQ_DATE = reqDate;
                                    vcElofficInterfaceData.add(eofI);
                                    Logger.debug.println(this, "==== [[vcElofficInterfaceData ]]: " + vcElofficInterfaceData.toString());
                                }
                                Logger.debug.println(this, "일괄결재 전 ]]:vcElofficInterfaceData:" + vcElofficInterfaceData.toString());

                                eof = ddfe.makeDocContents(row.AINF_SEQN, user.SServer, row.UPMU_NAME);
                                eof.REQ_DATE = reqDate;
                                vcElofficInterfaceData.add(eof);
                                Logger.debug.println(this, "일괄결재목록:vcElofficInterfaceData:" + vcElofficInterfaceData.toString());

                            } // end if
                        } catch (Exception e) {
                            msg2 = msg2 + g.getMessage("MSG.COMMON.0020") +"\\n";  //Eloffice 연동 실패
                        } // end try

                    }
                }

                String url = "location.href = '" + g.getRequestPageName(req) + "';";
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, this.getClass().getName());



        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        } finally {

        }
    }

    private ApprovalDocList findApproval(Vector<ApprovalDocList> vcApprovalDocList, String AINF_SEQN ) {

        for(ApprovalDocList row : vcApprovalDocList) {
            if(StringUtils.equals(row.AINF_SEQN, AINF_SEQN)) return row;
        }

        return null;
    }
}
