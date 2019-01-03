package servlet.hris.D.D07TimeSheet;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D07TimeSheet.D07TimeSheetApproverDataUsa;
import hris.D.D07TimeSheet.D07TimeSheetDetailDataUsa;
import hris.D.D07TimeSheet.rfc.D07TimeSheetRFCUsa;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalInput;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class D07TimeSheetBuildUsaSV extends ApprovalBaseServlet
{
    private String UPMU_TYPE = "15";

    private String UPMU_NAME = "Time Sheet";

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

            final String dest;

            final String jobid = box.get("jobid", "first");

            final String I_DATLO = DataUtil.getCurrentDate();
            String I_PAYDR = box.get("I_PAYDR","CW");
            String I_LCLDT = box.get("I_LCLDT",I_DATLO);
            final String BEGDA = box.get("SUM_BEGDA");

            final String AINF_SEQN = box.get("SUM_AINF_SEQN");
            String APPR_STAT = "";
            String I_APGUB = (String) req.getAttribute("I_APGUB");
            String iframeBuildYn = box.get("iframeBuildYn","false");

            D07TimeSheetDetailDataUsa ts_data = new D07TimeSheetDetailDataUsa();

            Vector D07TimeSheetDataUsa_vt = null;
            Vector D07TimeSheetDeatilDataUsa_vt = null;
            Vector D07TimeSheetSummaryDataUsa_vt = null;
            final String PERNR = getPERNR(box, user); //신청대상자 사번
            Logger.debug.println(this, jobid);
            req.setAttribute("iframeBuildYn", iframeBuildYn);

            if (jobid.equals("first")) {   //제일처음 신청 화면에 들어온경우.
                //결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);

                D07TimeSheetRFCUsa d07TimeSheetRFCUsa = new D07TimeSheetRFCUsa();

                d07TimeSheetRFCUsa.setDetailInput(user.empNo, I_APGUB,"");
                ApprovalInput approvalInput  = d07TimeSheetRFCUsa.getApprovalInput();
                approvalInput.setI_PERNR( PERNR);

                D07TimeSheetDataUsa_vt = d07TimeSheetRFCUsa.getTimeSheetDetail(PERNR, I_PAYDR, I_LCLDT, APPR_STAT);

                if ( !"00000000".equals(d07TimeSheetRFCUsa.getApprovalHeader().PERNR)) {
                    req.setAttribute("approvalHeader", d07TimeSheetRFCUsa.getApprovalHeader());
                    req.setAttribute("approvalLine", d07TimeSheetRFCUsa.getApprovalLine());
                }

                D07TimeSheetDeatilDataUsa_vt =(Vector)D07TimeSheetDataUsa_vt.get(0);
                D07TimeSheetSummaryDataUsa_vt = (Vector)D07TimeSheetDataUsa_vt.get(1);

                String E_MESSAGE = (String)D07TimeSheetDataUsa_vt.get(2);
                String E_BEGDA = (String)D07TimeSheetDataUsa_vt.get(3);
                String E_ENDDA = (String)D07TimeSheetDataUsa_vt.get(4);
                String E_PAYDRX = (String)D07TimeSheetDataUsa_vt.get(5);
                D07TimeSheetApproverDataUsa E_APPROVER = (D07TimeSheetApproverDataUsa)D07TimeSheetDataUsa_vt.get(6);

                req.setAttribute("D07TimeSheetDeatilDataUsa_vt", D07TimeSheetDeatilDataUsa_vt);
                req.setAttribute("approvalHeaderStatus", d07TimeSheetRFCUsa.getApprovalHeader());
                req.setAttribute("D07TimeSheetSummaryDataUsa_vt", D07TimeSheetSummaryDataUsa_vt);
                req.setAttribute("E_MESSAGE", E_MESSAGE);
                req.setAttribute("E_BEGDA", E_BEGDA);
                req.setAttribute("E_ENDDA", E_ENDDA);
                req.setAttribute("E_PAYDRX", E_PAYDRX);
                req.setAttribute("approverData", E_APPROVER);
                req.setAttribute("jobid", jobid);
                req.setAttribute("PERNR", PERNR);
                Logger.debug.println(this, "#####	E_APPROVER = " + E_APPROVER);
                Logger.debug.println(this, "#####	E_ENDDA = " + E_ENDDA);
                Logger.debug.println(this, "#####	E_PAYDRX = " + E_PAYDRX);

                dest = WebUtil.JspURL + "D/D07TimeSheet/D07TimeSheetBuildUsa.jsp";
            }

            else if (jobid.equals("summary"))
            {
                box.copyToEntity(ts_data);
                ts_data.PERNR = PERNR;
                DataUtil.fixNull(ts_data);

                D07TimeSheetRFCUsa rfc = new D07TimeSheetRFCUsa();

                D07TimeSheetDataUsa_vt = rfc.getTimeSheet(PERNR, I_PAYDR, I_LCLDT, APPR_STAT);

                D07TimeSheetSummaryDataUsa_vt = (Vector)(Vector)D07TimeSheetDataUsa_vt.get(1);


                String E_MESSAGE = (String)D07TimeSheetDataUsa_vt.get(2);
                String E_BEGDA = (String)D07TimeSheetDataUsa_vt.get(3);
                String E_ENDDA = (String)D07TimeSheetDataUsa_vt.get(4);
                String E_PAYDRX = (String)D07TimeSheetDataUsa_vt.get(5);

                req.setAttribute("D07TimeSheetSummaryDataUsa_vt", D07TimeSheetSummaryDataUsa_vt);

                req.setAttribute("E_MESSAGE", E_MESSAGE);
                req.setAttribute("E_BEGDA", E_BEGDA);
                req.setAttribute("E_ENDDA", E_ENDDA);
                req.setAttribute("E_PAYDRX", E_PAYDRX);
                req.setAttribute("jobid", jobid);
                req.setAttribute("PERNR", PERNR);


                dest = WebUtil.JspURL + "D/D07TimeSheet/D07TimeSheetSummaryPopUsa.jsp";
            }
            else if (jobid.equals("save"))
            {
                D07TimeSheetRFCUsa rfc = new D07TimeSheetRFCUsa();

                Vector D07TimeSheetDeatilData_vt = new Vector();

                Vector d07_chkValue = box.getVector("chkValue");
                Vector d07_BEGDA = box.getVector("BEGDA");
                Vector d07_WEEKDAY_L = box.getVector("WEEKDAY_L");
                Vector d07_WKDAT = box.getVector("WKDAT");
                Vector d07_WKHRS = box.getVector("WKHRS");
                Vector d07_DYTOT = box.getVector("DYTOT");
                Vector d07_AWART = box.getVector("AWART");
                Vector d07_ATEXT = box.getVector("ATEXT");
                Vector d07_KOSTL = box.getVector("KOSTL");
                Vector d07_PSPNR = box.getVector("PSPNR");
                Vector d07_POSID = box.getVector("POSID");
                Vector d07_AINF_SEQN = box.getVector("I_AINF_SEQN");
                Vector d07_WTEXT = box.getVector("WTEXT");
                Vector d07_WEBFLAG = box.getVector("WEBFLAG");
                Vector d07_SEQNR = box.getVector("SEQNR");

                String chkFlag = "";


                for (int i = 0; i < d07_WEEKDAY_L.size(); i++)
                {
                    D07TimeSheetDetailDataUsa d07TimeSheetDetailData = new D07TimeSheetDetailDataUsa();

                    chkFlag = (String)d07_chkValue.get(i);

                    if (!chkFlag.equals("APP"))
                    {
                        d07TimeSheetDetailData.PERNR = PERNR;
                        d07TimeSheetDetailData.BEGDA = BEGDA;
                        d07TimeSheetDetailData.WEEKDAY_L = ((String)d07_WEEKDAY_L.get(i));
                        d07TimeSheetDetailData.WKDAT = WebUtil.deleteStr((String)d07_WKDAT.get(i), ".");
                        d07TimeSheetDetailData.WKHRS = ((String)d07_WKHRS.get(i));
                        d07TimeSheetDetailData.SEQNR = ((String)d07_SEQNR.get(i));
                        d07TimeSheetDetailData.DYTOT = ((String)d07_DYTOT.get(i));
                        d07TimeSheetDetailData.AWART = ((String)d07_AWART.get(i));
                        d07TimeSheetDetailData.ATEXT = ((String)d07_ATEXT.get(i));
                        d07TimeSheetDetailData.KOSTL = ((String)d07_KOSTL.get(i));
                        d07TimeSheetDetailData.PSPNR = ((String)d07_PSPNR.get(i));
                        d07TimeSheetDetailData.POSID = ((String)d07_POSID.get(i));
                        d07TimeSheetDetailData.AINF_SEQN = ((String)d07_AINF_SEQN.get(i));
                        d07TimeSheetDetailData.TBEGDA = box.get("TBEGDA");
                        d07TimeSheetDetailData.TENDDA = box.get("TENDDA");

                        d07TimeSheetDetailData.WTEXT = ((String)d07_WTEXT.get(i));
                        d07TimeSheetDetailData.APPR_STAT = "";
                        d07TimeSheetDetailData.PERNR_D = PERNR;
                        d07TimeSheetDetailData.AEDTM = I_DATLO;
                        d07TimeSheetDetailData.ZPERNR = user.empNo;
                        d07TimeSheetDetailData.UNAME = user.empNo;
                        d07TimeSheetDetailData.WEBFLAG = ((String)d07_WEBFLAG.get(i));
                    }

                    DataUtil.fixNull(d07TimeSheetDetailData);

                    D07TimeSheetDeatilData_vt.add(i, d07TimeSheetDetailData);
                }

                String msg2 = rfc.save(PERNR, I_PAYDR, I_DATLO, AINF_SEQN, APPR_STAT, D07TimeSheetDeatilData_vt);

                String msg = "";
                String url = "";
                if (msg2.substring(0, 1).equals("E")) {
                    url = "location.href = 'javascript:history.go(-1)';";
                } else {
                    msg2 = "Saved.";
                    url = "location.href = '" + WebUtil.ServletURL +
                            "hris.D.D07TimeSheet.D07TimeSheetBuildUsaSV?I_PAYDR=" + I_PAYDR + "&PERNR=" + PERNR  + "&iframeBuildYn=" + iframeBuildYn +"&I_LCLDT=" + box.get("TBEGDA") + "';";
                }

                req.setAttribute("msg", msg);
                req.setAttribute("msg2", msg2);
                req.setAttribute("url", url);
                req.setAttribute("PERNR", PERNR);

                dest = WebUtil.JspURL + "common/msg.jsp";

            } else if (jobid.equals("cancle")) {	// 결재요청 취소 (결재진행중일 경우에만 한함.)

                final D07TimeSheetRFCUsa d07TimeSheetRFCUsa = new D07TimeSheetRFCUsa();
                d07TimeSheetRFCUsa.setDetailInput(user.empNo, I_APGUB, AINF_SEQN);
                String PERNR1 = box.get("PERNR",user.empNo);

                d07TimeSheetRFCUsa.getTimeSheetDetail(PERNR1, I_PAYDR, I_LCLDT, APPR_STAT);

                final RFCReturnEntity[] returnEntity = new RFCReturnEntity[1];

                dest = deleteApproval(req, box, d07TimeSheetRFCUsa, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        D07TimeSheetRFCUsa deleteRFC = new D07TimeSheetRFCUsa();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, d07TimeSheetRFCUsa.getApprovalHeader().AINF_SEQN);
                        ApprovalInput approvalInput = deleteRFC.getApprovalInput();
                        approvalInput.setI_PERNR(PERNR);

                        returnEntity[0] = deleteRFC.delete();

                        if (!returnEntity[0].isSuccess()) {
                            throw new GeneralException(returnEntity[0].MSGTX);
                        }

                        return true;
                    }
                });

			/*String msg2 = rfc.cancle(PERNR, AINF_SEQN);*/

                String msg = "";
                String url = "";
                if (returnEntity[0] == null || !returnEntity[0].isSuccess()) {
                    url = "location.href = 'javascript:history.go(-1)';";
                } else {
				/*req.setAttribute("msg2", g.getMessage("MSG.COMMON.0011"));*/
                    url = "location.href = '" + WebUtil.ServletURL
                            + "hris.D.D07TimeSheet.D07TimeSheetBuildUsaSV?I_PAYDR=" + I_PAYDR  + "&PERNR=" + PERNR + "&iframeBuildYn=" + iframeBuildYn +"&I_LCLDT=" + box.get("TBEGDA") + "';";
                }

			/*req.setAttribute("msg", msg);
			req.setAttribute("msg2", msg2);*/
                req.setAttribute("url", url);
                req.setAttribute("PERNR", PERNR);

                //dest = WebUtil.JspURL + "common/msg.jsp";


            }
            else if (jobid.equals("create")) {

          /* 실제 신청 부분 */
                dest = requestApproval(req, box, D07TimeSheetDetailDataUsa.class, new RequestFunction<D07TimeSheetDetailDataUsa>() {
                    public String porcess(D07TimeSheetDetailDataUsa inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {


                  /* 결재 신청 RFC 호출 */
                        D07TimeSheetRFCUsa d07TimeSheetRFCUsa = new D07TimeSheetRFCUsa();
                        d07TimeSheetRFCUsa.setRequestInput(user.empNo, UPMU_TYPE);

                        //-------------------------------------------------------------------------

                        Vector D07TimeSheetDeatilData_vt = new Vector();

                        int rowcount = box.getInt("RowCount");


                        Logger.debug.println(this, "#####	저장으로");

                        Vector d07_BEGDA 		= box.getVector("BEGDA");
                        Vector d07_WEEKDAY_L= box.getVector("WEEKDAY_L");
                        Vector d07_WKDAT 		= box.getVector("WKDAT");
                        Vector d07_WKHRS 		= box.getVector("WKHRS");
                        Vector d07_DYTOT 		= box.getVector("DYTOT");
                        Vector d07_AWART 		= box.getVector("AWART");
                        Vector d07_ATEXT 		= box.getVector("ATEXT");
                        Vector d07_KOSTL 		= box.getVector("KOSTL");
                        Vector d07_PSPNR 		= box.getVector("PSPNR");
                        Vector d07_POSID 		= box.getVector("POSID");
                        Vector d07_AINF_SEQN = box.getVector("I_AINF_SEQN");
                        Vector d07_WTEXT 		= box.getVector("WTEXT");
                        Vector d07_WEBFLAG 	= box.getVector("WEBFLAG");
                        Vector d07_SEQNR 		= box.getVector("SEQNR");

                        String ainfSeanFlag = "";

                        for (int i = 0; i < d07_WEEKDAY_L.size(); i++) {

                            D07TimeSheetDetailDataUsa d07TimeSheetDetailData = new D07TimeSheetDetailDataUsa();

                            ainfSeanFlag = (String)d07_AINF_SEQN.get(i);

                            // 미결재 신청 문서에 대해 신청 저장함.
                            if (ainfSeanFlag.equals("")) {
                                // 여러행 자료 입력(Web)
                                d07TimeSheetDetailData.PERNR 			= PERNR;
                                d07TimeSheetDetailData.BEGDA 			= BEGDA;
                                d07TimeSheetDetailData.WEEKDAY_L	= (String)d07_WEEKDAY_L.get(i);
                                d07TimeSheetDetailData.WKDAT 		= WebUtil.deleteStr((String)d07_WKDAT.get(i), ".");
                                d07TimeSheetDetailData.WKHRS 			= (String)d07_WKHRS.get(i);
                                d07TimeSheetDetailData.SEQNR 			= (String)d07_SEQNR.get(i);
                                d07TimeSheetDetailData.DYTOT 			= (String)d07_DYTOT.get(i);
                                d07TimeSheetDetailData.AWART 		= (String)d07_AWART.get(i);
                                d07TimeSheetDetailData.ATEXT 			= (String)d07_ATEXT.get(i);
                                d07TimeSheetDetailData.KOSTL 			= (String)d07_KOSTL.get(i);
                                d07TimeSheetDetailData.PSPNR 			= (String)d07_PSPNR.get(i);
                                d07TimeSheetDetailData.POSID			= (String)d07_POSID.get(i);
                                d07TimeSheetDetailData.TBEGDA			= box.get("TBEGDA");
                                d07TimeSheetDetailData.TENDDA 		= box.get("TENDDA");
                                //d07TimeSheetDetailData.WEEKNO		= (String)d07_WEEKNO.get(i);
                                //d07TimeSheetDetailData.OTHRS 		= (String)d07_OTHRS.get(i);
                                d07TimeSheetDetailData.WTEXT 		= (String)d07_WTEXT.get(i);
                                d07TimeSheetDetailData.APPR_STAT 	= "";											// 신청저장은 결재상태 ""
                                d07TimeSheetDetailData.PERNR_D 		= PERNR;
                                d07TimeSheetDetailData.AEDTM 			= I_DATLO;
                                d07TimeSheetDetailData.ZPERNR 		= user.empNo; 							// 신청자 사번(대리신청, 본인 신청)
                                d07TimeSheetDetailData.UNAME 			= user.empNo; 							// 신청자 사번(대리신청, 본인 신청)
                                d07TimeSheetDetailData.WEBFLAG 		= (String)d07_WEBFLAG.get(i);
                                d07TimeSheetDetailData.ZPERNR 		= user.empNo;
                                d07TimeSheetDetailData.UNAME 		= user.empNo;
                                d07TimeSheetDetailData.AEDTM 		= DataUtil.getCurrentDate(req);
                                Utils.setFieldValue(inputData, "ZPERNR", user.empNo);   //신청자 사번 설정(대리신청 ,본인 신청)
                                Utils.setFieldValue(inputData, "UNAME", user.empNo);    //신청자 사번 설정(대리신청 ,본인 신청)
                                Utils.setFieldValue(inputData, "AEDTM", DataUtil.getCurrentDate(req));   // 변경일(현재날짜) - 지역시간
                            }

                            DataUtil.fixNull(d07TimeSheetDetailData);

                            D07TimeSheetDeatilData_vt.add(i, d07TimeSheetDetailData);
                            //Logger.debug.println(this, "#####	D07TimeSheetDeatilData_vt	[Application]	:	"  + D07TimeSheetDeatilData_vt.toString() + "\n");
                        }


                        String AINF_SEQN = d07TimeSheetRFCUsa.build(D07TimeSheetDeatilData_vt, box, req);

                        if(!d07TimeSheetRFCUsa.getReturn().isSuccess()) {
                            throw new GeneralException(d07TimeSheetRFCUsa.getReturn().MSGTX);
                        };

                        return AINF_SEQN;

                  /* 개발자 작성 부분 끝 */
                    }
                });
            } else {
                throw new GeneralException(g.getMessage("MSG.COMMON.0016"));    //"내부명령(jobid)이 올바르지 않습니다. "
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}
