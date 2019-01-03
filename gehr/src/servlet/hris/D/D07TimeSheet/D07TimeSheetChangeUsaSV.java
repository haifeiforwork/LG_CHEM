package servlet.hris.D.D07TimeSheet;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D07TimeSheet.D07TimeSheetDetailDataUsa;
import hris.D.D07TimeSheet.rfc.D07TimeSheetRFCUsa;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalInput;
import hris.common.approval.ApprovalLineData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class D07TimeSheetChangeUsaSV extends ApprovalBaseServlet
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

          final String AINF_SEQN = box.get("SUM_AINF_SEQN");
          String APPR_STAT = "";
          String I_APGUB = (String) req.getAttribute("I_APGUB");



        D07TimeSheetDetailDataUsa ts_data = new D07TimeSheetDetailDataUsa();

        Vector D07TimeSheetDataUsa_vt = null;
        Vector D07TimeSheetDeatilDataUsa_vt = null;
        Vector D07TimeSheetSummaryDataUsa_vt = null;
        final String PERNR = box.get("PERNR", user.empNo); //신청대상자 사번
        final String BEGDA = box.get("BEGDA");
        D07TimeSheetRFCUsa d07TimeSheetRFCUsa = new D07TimeSheetRFCUsa();

        d07TimeSheetRFCUsa.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
        ApprovalInput approvalInput  = d07TimeSheetRFCUsa.getApprovalInput();
		  approvalInput.setI_PERNR( PERNR);
        Logger.debug.println(this, jobid);
        getApprovalInfo(req, PERNR);
        D07TimeSheetDataUsa_vt = d07TimeSheetRFCUsa.getTimeSheetDetail(PERNR, I_PAYDR, I_LCLDT,APPR_STAT);

          if (jobid.equals("first")) {   //제일처음 신청 화면에 들어온경우.
              //결재라인, 결재 헤더 정보 조회

              D07TimeSheetDeatilDataUsa_vt =(Vector)D07TimeSheetDataUsa_vt.get(0);
              D07TimeSheetSummaryDataUsa_vt = (Vector)D07TimeSheetDataUsa_vt.get(1);

              String E_MESSAGE = (String)D07TimeSheetDataUsa_vt.get(2);
              String E_BEGDA = (String)D07TimeSheetDataUsa_vt.get(3);
              String E_ENDDA = (String)D07TimeSheetDataUsa_vt.get(4);
              String E_PAYDRX = (String)D07TimeSheetDataUsa_vt.get(5);
              detailApporval(req, res, d07TimeSheetRFCUsa);
              req.setAttribute("isUpdate", true);
              req.setAttribute("D07TimeSheetDeatilDataUsa_vt", D07TimeSheetDeatilDataUsa_vt);
              req.setAttribute("D07TimeSheetSummaryDataUsa_vt", D07TimeSheetSummaryDataUsa_vt);
              req.setAttribute("approvalHeaderStatus", d07TimeSheetRFCUsa.getApprovalHeader());
              req.setAttribute("E_MESSAGE", E_MESSAGE);
              req.setAttribute("E_BEGDA", E_BEGDA);
              req.setAttribute("E_ENDDA", E_ENDDA);
              req.setAttribute("E_PAYDRX", E_PAYDRX);
              req.setAttribute("jobid", jobid);
              req.setAttribute("PERNR", PERNR);
              Logger.debug.println(this, "#####	D07TimeSheetDeatilDataUsa_vt = " + D07TimeSheetDeatilDataUsa_vt);
              Logger.debug.println(this, "#####	E_ENDDA = " + E_ENDDA);
              Logger.debug.println(this, "#####	E_PAYDRX = " + E_PAYDRX);

              dest = WebUtil.JspURL + "D/D07TimeSheet/D07TimeSheetBuildUsa.jsp";
          }

      else if (jobid.equals("change")) {

          /* 실제 신청 부분 */

          dest = changeApproval(req, box, D07TimeSheetDetailDataUsa.class, d07TimeSheetRFCUsa,new ChangeFunction<D07TimeSheetDetailDataUsa>() {
              public String porcess(D07TimeSheetDetailDataUsa inputData, ApprovalHeader approvalHeader,Vector<ApprovalLineData> approvalLine) throws GeneralException {



                  /* 결재 신청 RFC 호출 */
            	  D07TimeSheetRFCUsa d07TimeSheetRFCUsa = new D07TimeSheetRFCUsa();
            	  d07TimeSheetRFCUsa.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);
                  ApprovalInput approvalInput  = d07TimeSheetRFCUsa.getApprovalInput();
        		  approvalInput.setI_PERNR( PERNR);
            	  //-------------------------------------------------------------------------

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

    	                String AINF_SEQN = d07TimeSheetRFCUsa.build(D07TimeSheetDeatilData_vt, box, req);
    	                Logger.debug.println(this, "AINF_SEQN----"+AINF_SEQN);


                  if(!d07TimeSheetRFCUsa.getReturn().isSuccess()) {
                      throw new GeneralException(d07TimeSheetRFCUsa.getReturn().MSGTX);
                  };

                  return approvalHeader.AINF_SEQN;

                  /* 개발자 작성 부분 끝 */
              }
          });
      } else {
          throw new GeneralException("내부명령(jobid)이 올바르지 않습니다. ");
      }
      Logger.debug.println(this, " destributed = " + dest);
      printJspPage(req, res, dest);

  } catch (Exception e) {
      Logger.error(e);
      throw new GeneralException(e);
  }
  }
}
