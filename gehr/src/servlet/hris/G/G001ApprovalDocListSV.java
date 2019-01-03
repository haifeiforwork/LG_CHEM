/* �ۼ��� ��¥ : 2005. 1. 28.*/
/*				   :  2017-04-03 ������  [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ����*/
/*				   :  2017-04-19 ������  [CSR ID:3359686]   ���� ���� 5������*/
/*				   :  2017-06-29 eunha [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�*/
/*				   :  2017-10-20 eunha [CSR ID:3500559] �Ƿ������ ���� ���濡 ���� ��û�� ��*/
/*				   :  2018-03-19 ������  @PJ.������ ����(G570) Roll-Out */
/*				   :  2018-08-01 ������  @PJ.��ù���(G620) Roll-out */
package servlet.hris.G;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.PageUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D01OT.D01OTData;
import hris.D.D01OT.rfc.D010TOvertimeGlobalRFC;
import hris.D.D01OT.rfc.D01OTCheckGlobalRFC;
import hris.D.D01OT.rfc.D01OTRFC;
import hris.D.D03Vocation.D03VocationData;
import hris.D.D03Vocation.rfc.D03VocationGlobalRFC;
import hris.D.D19Duty.rfc.D19DutyRFC;
import hris.D.rfc.D20ActTimeCardRFC;
import hris.G.ApprovalReturnState;
import hris.G.G001Approval.ApprovalDocList;
import hris.G.G001Approval.ApprovalListKey;
import hris.G.G001Approval.rfc.G001ApprovalDocListRFC;
import hris.G.rfc.G001ApprovalProcessRFC;
import hris.common.*;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalLineInput;
import hris.common.approval.ApprovalLineRFC;
import hris.common.rfc.PersonInfoRFC;
import hris.common.rfc.UpmuCodeRFC;
import hris.common.util.AppUtil;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * @author �̽���
 */
public class G001ApprovalDocListSV extends EHRBaseServlet {

    /* (��Javadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void performTask(HttpServletRequest req, HttpServletResponse res)
            throws GeneralException {


        try {

            req.setAttribute("isLocal", WebUtil.isLocal(req));
            String dest  = "";
            /*HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            String jobid = "";
            ApprovalDocList adl = null;

            ApprovalListKey aplk    =   new ApprovalListKey();
            Vector vcApprovalDocList = null;

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");

            String page  = box.get("page");

            if( jobid ==null || jobid.equals("login") || jobid.equals("")){
                jobid = "search";
                aplk.I_BEGDA  =   DataUtil.getAfterDate( DataUtil.getCurrentDate() , -30);
                aplk.I_ENDDA  =   DataUtil.getCurrentDate();
            } else {
                box.copyToEntity(aplk);
            } // end if

            aplk.I_AGUBN  =   "1";
            aplk.I_PERNR  =   user.empNo;

            //    Logger.debug.println(this ," jobid:"+jobid+"#############  user.empNo:"+  aplk.PERNR);*/
            WebUserData user = WebUtil.getSessionUser(req);

            ApprovalListKey aplk = new ApprovalListKey();

            Box box = WebUtil.getBox(req);
            String jobid = box.get("jobid", "search");
            String page = box.get("page");

            if (jobid.equals("search")) {

                if (StringUtils.isBlank(req.getParameter("jobid"))) {
                    aplk.I_BEGDA = DataUtil.getAfterDate(DataUtil.getCurrentDate(), -30);
                    aplk.I_ENDDA = DataUtil.getCurrentDate();
                } else {
                    box.copyToEntity(aplk);
                } // end if

                aplk.I_AGUBN = "1";
                aplk.I_PERNR = user.empNo;

                G001ApprovalDocListRFC aplRFC = new G001ApprovalDocListRFC();
                Vector<ApprovalDocList> resultList = aplRFC.getApprovalDocList(aplk);

                Vector<UpmuCode> upmuList = ((new UpmuCodeRFC()).getUpmuCode(user.companyCode, user.empNo));

                PageUtil pu = new PageUtil(Utils.getSize(resultList), page, 10, 10);

                if(g.getSapType().isLocal()) {
                    //�������ϱݽ�û:05,���ο��ݽ�û:02,���ο����ؾ��û:26,���������û:24,���������ؾ��û:29
                    if(upmuList != null) {
                        List<String> exceptList = Arrays.asList("05", "02", "26", "24", "29");
                        Vector<UpmuCode> removeList = new Vector<UpmuCode>();
                        for (UpmuCode code : upmuList) {
                            if (exceptList.contains(code.getUPMU_TYPE())) {
                                removeList.add(code);
                            }
                        }
                        upmuList.removeAll(removeList);
                    }
                    //[CSR ID:3500559] �Ƿ������ ���� ���濡 ���� ��û�� �� start
                    for (ApprovalDocList approvalDocList : resultList) {
                        if ("03".equals(approvalDocList.UPMU_TYPE) && !"01".equals(approvalDocList.APPU_TYPE)) {
                        	req.setAttribute("isHospital", true);
                        }
                    }
                    //[CSR ID:3500559] �Ƿ������ ���� ���濡 ���� ��û�� �� end
                } else {
                    //*******************************************************************************
                    // BOHAI���� �빮�ð� üũ.		2009-12-23		jungin		@v1.3 [C20091222_81370]
                    // DAGU���� �빮�ð� üũ.  	2010-04-28		jungin		@v1.4 [C20100427_55533]
                    // BOTIAN���� �빮�ð� üũ.  	2011-01-19		liukuo		@v1.5 [C20110118_09919]
                    // ���������(G570) �߰�           2018-03-19    ������     @PJ.������ ����(G570) Roll-Out

                    // begin="${pu.from}" end="${pu.to > 0 ? pu.to - 1 : pu.to} �� �����ؾ� ��
                	for(ApprovalDocList row : resultList) {
                		// 2018-03-12 KDM  @@PJ.������ ����(G570) Roll-Out Start
                		// 2018-08-01 ������ @PJ.��ù���(G620) Roll-out
                        if ( (row.BUKRS.equals("G110") || row.BUKRS.equals("G180") ||  row.BUKRS.equals("G280") || row.BUKRS.equals("G370") || row.BUKRS.equals("G570") || row.BUKRS.equals("G620"))
                                && (row.UPMU_TYPE.equals("01") || row.UPMU_TYPE.equals("07") || row.UPMU_TYPE.equals("08")) ) {
                        // 2018-03-12 KDM  @@PJ.������ ����(G570) Roll-Out Start
                            String I_TYPE = "";
                            if (row.UPMU_TYPE.equals("01")) {
                                I_TYPE = "O";
                            }else{
                                I_TYPE = "D";
                            }

                            Vector vc20ActTimeCardData = null;

                            D20ActTimeCardRFC rfc3 = new D20ActTimeCardRFC();
                            vc20ActTimeCardData = rfc3.getActTimeCard(row.PERNR, row.APPL_DATE, row.BEGUZ, row.ENDUZ, I_TYPE);

                            row.I_BEGTIME = (String)vc20ActTimeCardData.get(0);
                            row.I_ENDTIME = (String)vc20ActTimeCardData.get(1);
                            row.I_BEGDATE = (String)vc20ActTimeCardData.get(2);
                            row.I_ENDDATE = (String)vc20ActTimeCardData.get(3);
                        }
                      //[CSR ID:3359686]   ���� ���� 5������ START
                        if( row.BUKRS.equals("G180")){

                        	D01OTCheckGlobalRFC  d01OTCheckGlobalRFC           = new D01OTCheckGlobalRFC();
                        	D03VocationGlobalRFC rfc = new D03VocationGlobalRFC();
                        	if("01".equals(row.UPMU_TYPE)) {
                        		 d01OTCheckGlobalRFC.checkApprovalPeriod(req,row.PERNR,"A",row.APPL_DATE,   row.UPMU_TYPE,"" );
                                 row.E_7OVER_NOT_APPROVAL =  d01OTCheckGlobalRFC.getReturn().MSGTY;
                        	}else if(StringUtils.startsWith(row.UPMU_TYPE,"02")) {
                        		 rfc.setDetailInput(row.PERNR, "1", row.AINF_SEQN);
                        		 D03VocationData d03VocationData = Utils.indexOf(rfc.getVocation(row.PERNR, row.AINF_SEQN), 0);
                        	    d01OTCheckGlobalRFC.checkApprovalPeriod(req,row.PERNR,"A",row.APPL_DATE,   row.UPMU_TYPE,  d03VocationData.AWART );
                        	    row.E_7OVER_NOT_APPROVAL =  d01OTCheckGlobalRFC.getReturn().MSGTY;
                        	 }
                        }
                      //[CSR ID:3359686]   ���� ���� 5������ END

                        if( row.BUKRS.equals("G110")||row.BUKRS.equals("G220")) {
                            if("01".equals(row.UPMU_TYPE)) {
                                row.IFlag = "Y";        // ��û�ô� 'N', �����ô� 'Y'

                                D010TOvertimeGlobalRFC rfc1 = new D010TOvertimeGlobalRFC();
                                row.E_ANZHL = rfc1.check(row.PERNR, row.APPL_DATE, row.IFlag);        // ��û�ڻ��, ��û��, ����Y

                                // ������ ���а�
                                Vector AppLineData_vt = AppUtil.getAppVector(row.PERNR, row.UPMU_TYPE, row.APPL_DATE, row.E_ANZHL);
                                row.SHIFT = (String) AppLineData_vt.get(1);
                                D01OTRFC rfc = new D01OTRFC();
                                rfc.setDetailInput(row.PERNR, "1", row.AINF_SEQN);
                                row.d01OTData = Utils.indexOf(rfc.getDetail(row.AINF_SEQN, row.PERNR), 0);
                              //2017-04-03 ������  [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ���� START
                                D01OTCheckGlobalRFC  d01OTCheckGlobalRFC           = new D01OTCheckGlobalRFC();
                                d01OTCheckGlobalRFC.checkOvertimeTp46Hours(req, row.d01OTData.PERNR,  "A", row.d01OTData.AINF_SEQN , row.d01OTData.WORK_DATE,  row.d01OTData.STDAZ );
                                row.E_46OVER_NOT_APPROVAL =  d01OTCheckGlobalRFC.getReturn().MSGTY;
                                //2017-04-03 ������  [CSR ID:3340999]  �븸 ������±Ⱓ���� 46�ð� ���� END
                                // ��������
                                row.personData = (new PersonInfoRFC()).getPersonInfo(row.PERNR);
                            } else if("02".equals(row.UPMU_TYPE) || "07".equals(row.UPMU_TYPE) || "08".equals(row.UPMU_TYPE)) {

                            }
                        }
                        if( row.BUKRS.equals("G110") && row.UPMU_TYPE.equals("01") ) {    // DAGU���� OVerTime
                            //2016-04-19 pang xiaolin @v2.2 [C20160324_18938]��������ʥleave������?������ end
                            Vector vcAppLineData;

                            vcAppLineData = AppUtil.getAppChangeVt(row.AINF_SEQN);
                            AppLineData appLineData = (AppLineData) vcAppLineData.get(0);
                            DataUtil.fixNull(appLineData);

                            if( appLineData.APPL_PERNR .equals(user.empNo)){
                                row.no = "1";
                            }else{
                                row.no = "2";
                            }

                            D19DutyRFC rfc = new D19DutyRFC();
                            row.d19DutyData = Utils.indexOf(rfc.getDetail1( row.AINF_SEQN, row.PERNR, row.no), 0);
                        }



                    }
                }

                req.setAttribute("upmuList", upmuList);

                req.setAttribute("resultList", resultList);
                req.setAttribute("inputData", aplk);
                req.setAttribute("page", page);

                req.setAttribute("pu", pu);

                if(g.getSapType().isLocal())
                    printJspPage(req, res, WebUtil.JspURL + "G/G001ApprovalDocList.jsp");
                else
                    printJspPage(req, res, WebUtil.JspURL + "G/G001ApprovalDocList_GLOBAL.jsp");

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

                Vector vcAppLineData = new Vector();

                for(final ApprovalDocList row : vcApprovalDocList) {

                    boolean exist = CollectionUtils.exists(seqnList, new Predicate() {
                        public boolean evaluate(Object o) {
                            return row.AINF_SEQN.equals(o);
                        }
                    });

                    if(exist) {

                        Logger.debug(row);
                        /* �ϰ� ���� ���� ���� Ȯ�� */
                        if(!WebUtil.isMultiApproval(g.getSapType(), row.UPMU_TYPE, row.APPU_TYPE, row.APPR_SEQN)) {
                            moveMsgPage(req, res, g.getMessage("MSG.APPROVAL.MULTIAPPROVAL.DISABLE"), "history.back();");
                            return;
                        }

                        if(!g.getSapType().isLocal() &&
                                ("01".equals(row.UPMU_TYPE) || "07".equals(row.UPMU_TYPE) || "08".equals(row.UPMU_TYPE))) {

                            String flag = (new D01OTCheckGlobalRFC()).check1(row.APPU_NUMB, DataUtil.removeSeparate(row.APPR_DATE), row.UPMU_TYPE);        // ��û�ڻ��, ��û��¥, ����Ÿ��

                            if (!"Y".equals(flag)) {        // ���¸����� Y�� ���
                                msg = "You can not apply this data in payroll period.";
                                continue;
                            }
                         }

                        AppLineData    appLine  	=   new AppLineData();
                        appLine.APPL_BUKRS      	=   row.BUKRS;
                        appLine.APPL_PERNR      	=   row.PERNR;
                        appLine.APPL_BEGDA      	=   row.BEGDA;
                        appLine.APPL_AINF_SEQN	=   row.AINF_SEQN;
                        appLine.APPL_APPU_TYPE	=   row.APPU_TYPE;
                        appLine.APPL_APPR_SEQN	=   row.APPR_SEQN;
                        appLine.APPL_APPU_NUMB	=   user.empNo;
                        appLine.APPL_APPR_DATE  =   DataUtil.getCurrentDate(req);
                        appLine.APPL_APPR_TIME  =   DataUtil.getDate(req);
                        appLine.APPL_APPR_STAT	=   "A";
                        appLine.APPL_BIGO_TEXT	=   "";

                        vcAppLineData.addElement(appLine);
                    }
                }


                G001ApprovalProcessRFC Apr = new G001ApprovalProcessRFC();
                Vector vcRet = Apr.setApprovalStatutsList(vcAppLineData);
                Logger.debug.println(this, vcRet);


                Vector vcElofficInterfaceData = new Vector();

                String reqDate = DateFormatUtils.format(DataUtil.getDate(req), "yyyyMMddHHmm");

                for (int i = 0; i < vcRet.size(); i++) {

                    ApprovalReturnState ars = (ApprovalReturnState) vcRet.get(i);
                    if (ars.E_RETURN.equals("S")) {

                        /*ApprovalDocList apl = (ApprovalDocList) vcApprovalDocList.get(i);*/
                        ApprovalDocList apl = findApproval(vcApprovalDocList, ars.E_AINF_SEQN);
                        if(apl == null) continue;

                        /* ��������� �о�� ������ ���� ������ �����Ѵ�. ���� ���� ��� ��û�� ���� */
                        /* �⺻������ �����Ϸ� �� ��� */
                        String toEmpNo = apl.PERNR;
                     // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha start
                        String fileName = g.getSapType().isLocal() ? "NoticeMail2.html" : "NoticeMail2_GLOBAL.html";

                        String title = g.getMessage("MSG.APPROVAL.0004", apl.getUPMU_NAME()); //{0}���� {1}�� ���� �ϼ̽��ϴ�.
                     // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha end
                        ApprovalLineRFC approvalLineRFC = new ApprovalLineRFC();
                        ApprovalLineInput approvalLineInput = new ApprovalLineInput();
                        approvalLineInput.I_AINF_SEQN = apl.AINF_SEQN;
                        approvalLineInput.I_PERNR = apl.PERNR;
                        Vector<ApprovalLineData> approvalLine = approvalLineRFC.getApprovalLine(approvalLineInput);

                        ApprovalLineData approvalNext = null;
                            /* ���� ������ �������� */
                        for(ApprovalLineData approvalLineData : approvalLine) {
                            if(StringUtils.isBlank(approvalLineData.APPR_STAT)) {
                                approvalNext = approvalLineData;
                                break;
                            }
                        }
                        if(approvalNext != null) {
                            //���� ������
                        	//���ڰ��� UI���� eunha start
                            toEmpNo = approvalNext.APPU_NUMB;
                            fileName = g.getSapType().isLocal() ? "NoticeMail1.html" : "NoticeMail1_GLOBAL.html";
                            title = g.getMessage("MSG.APPROVAL.0002",apl.getUPMU_NAME());  //[HR] �����û ({0})
                        }

                        Properties ptMailBody = new Properties();
                        ptMailBody.setProperty("SServer", user.SServer);                 // ElOffice ���� ����
                        ptMailBody.setProperty("from_empNo", user.empNo);               // �� �߼��� ���
                        ptMailBody.setProperty("to_empNo", toEmpNo);                  // �� ������ ���

                        ptMailBody.setProperty("ename", apl.ENAME);                     // (��)��û�ڸ�
                        ptMailBody.setProperty("empno", apl.PERNR);                     // (��)��û�� ���

                        ptMailBody.setProperty("UPMU_NAME", apl.UPMU_NAME);                  // ���� �̸�
                        ptMailBody.setProperty("AINF_SEQN", apl.AINF_SEQN);             // ��û�� ����

                        ptMailBody.setProperty("FileName", fileName);

                        // �� ����
                        StringBuffer sbSubject = new StringBuffer(512);

                        // [CSR ID:3420113] �λ�ý��� ��û �� ���� ���� UI ǥ���۾�  2017-06-29 eunha
                        // sbSubject.append("[" + ptMailBody.getProperty("UPMU_NAME") + "] "); //
                        sbSubject.append(title); //���� ���� �ϼ̽��ϴ�.

                        ptMailBody.setProperty("subject", sbSubject.toString());    // �� ���� ����
                        MailSendToEloffic maTe = new MailSendToEloffic(ptMailBody);

                        if (!maTe.process()) {
                            msg2 = maTe.getMessage() + " \\n";
                        } // end if

                        try {
                            if (!apl.UPMU_TYPE.equals("23")) {
                                DraftDocForEloffice ddfe = new DraftDocForEloffice();
                                ElofficInterfaceData eof;
                                Logger.debug.println(this, "====chem [[��û�� ������ ]]:apl.APPU_NUMB" + apl.APPU_NUMB + "�α��ΰ�����  user.empNo:" + user.empNo);
                                Logger.debug.println(this, "===i:" + i + "   [[[apl" + apl.toString());


                                if (!apl.APPU_NUMB.equals(user.empNo)) {
                                    Logger.debug.println(this, "==== [[��û�� �����ڰ� ���� �����ڿ� �ٸ����  ]]:apl.APPU_NUMB" + apl.APPU_NUMB + "�α��ΰ�����  user.empNo:" + user.empNo);
                                    //����÷��� ������ ���� �׽�ũ�� ������ �ִ� �����ڰ� �����Ҷ� ó��:���� ���ڰ��翡 ���ִ� DATA�� ������ �ٽ� ó��
                                    ElofficInterfaceData eofD = ddfe.makeDocForDelete(apl.AINF_SEQN, user.SServer, apl.PERNR, ptMailBody.getProperty("UPMU_NAME"), apl.APPU_NUMB);
                                    eofD.REQ_DATE = reqDate;
                                    vcElofficInterfaceData.add(eofD);
                                    ElofficInterfaceData eofI = ddfe.makeDocForInsert(apl.AINF_SEQN, user.SServer, apl.PERNR, ptMailBody.getProperty("UPMU_NAME"));
                                    eofI.REQ_DATE = reqDate;
                                    vcElofficInterfaceData.add(eofI);
                                    Logger.debug.println(this, "==== [[vcElofficInterfaceData ]]: " + vcElofficInterfaceData.toString());
                                }
                                Logger.debug.println(this, "�ϰ����� �� ]]:vcElofficInterfaceData:" + vcElofficInterfaceData.toString());

                                eof = ddfe.makeDocContents(apl.AINF_SEQN, user.SServer, ptMailBody.getProperty("UPMU_NAME"));
                                eof.REQ_DATE = reqDate;
                                vcElofficInterfaceData.add(eof);
                                Logger.debug.println(this, "�ϰ�������:vcElofficInterfaceData:" + vcElofficInterfaceData.toString());

                            } // end if
                        } catch (Exception e) {
                            msg2 = msg2 + g.getMessage("MSG.COMMON.0020") +"\\n";  //Eloffice ���� ����
                        } // end try
                    } else {
                        msg2 = msg2 + ars.E_MESSAGE + "\\n";
                    } // end if
                } // end for
                String url = "location.href = '" + g.getRequestPageName(req) + "';";
                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);

                if (vcElofficInterfaceData.size() > 0) {
                    // ���� ������� �������� ����
                    //req.setAttribute("vcElofficInterfaceData", vcElofficInterfaceData);
                    //dest = WebUtil.JspURL+"common/ElOfficeInterface.jsp";


                    //���հ��� ���������� ���� ������������ ������  2012.11.07
                    try {


                        SendToESB esb = new SendToESB();
                        String esbmsg = esb.process(vcElofficInterfaceData);
                        Logger.debug.println(this, "[�ϰ� ���� esbmsg]  :" + esbmsg);
                        req.setAttribute("message", esbmsg);
                        dest = WebUtil.JspURL + "common/EsbResult.jsp";

                    } catch (Exception e) {
                        dest = WebUtil.JspURL + "common/msg.jsp";
                        msg2 += "\\n" + "esb.process Eloffice fail";
                    }


                } else {
                    dest = WebUtil.JspURL + "common/msg.jsp";
                } // end if

                printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            Logger.debug.println(this, this.getClass().getName());

            Logger.debug.println(this, " destributed = " + dest);

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
