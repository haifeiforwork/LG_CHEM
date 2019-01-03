/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재해신청                                                    */
/*   Program Name : 재해피해신고서                                              */
/*   Program ID   : E19ReportControlSV                                          */
/*   Description  : 재해피해신고서를 작성/추가/삭제 할수 있도록 하는 Class      */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-18  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E19Disaster;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.rfc.PersonInfoRFC;
import hris.E.E19Disaster.E19CongcondData;
import hris.E.E19Disaster.E19DisasterData;
import hris.E.E19Disaster.rfc.*;

public class E19ReportControlSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="09";  // 결재 업무타입(경조금)
    private String UPMU_NAME = "재해";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";

            String fromJsp = "";


            Box box = WebUtil.getBox(req);
            String jobid = box.get("jobid", "first");
            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            fromJsp = box.get("fromJsp");

            final String PERNR = getPERNR(box, user); //신청대상자 사번

            Logger.debug.println(this, "[PERNR] = "+PERNR);
            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData" , phonenumdata );

//          최종 돌아갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            req.setAttribute("isUpdate", box.get("isUpdate"));
            Vector E19CongcondData_vt = new Vector();
            E19CongcondData e19CongcondData = new E19CongcondData();


            String I_APGUB = (String) req.getAttribute("I_APGUB");
            final E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();

            if (box.get("isUpdate").equals("true")){
                e19CongraRequestRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
                Logger.debug.println(this, "Detail조회------------------------------------------------------------------");
                Vector resultList = e19CongraRequestRFC.getDetail(); //결과 데이타
                E19CongcondData_vt = (Vector)resultList.get(0);
            	detailApporval(req, res, e19CongraRequestRFC);
                for( int i = 0 ; i < E19CongcondData_vt.size() ; i++ ){
                    e19CongcondData = (E19CongcondData)E19CongcondData_vt.get(i);
                    e19CongcondData.WAGE_WONX = Double.toString(Double.parseDouble(e19CongcondData.WAGE_WONX) * 100.0 ) ;  // 통상임금
                    e19CongcondData.CONG_WONX = Double.toString(Double.parseDouble(e19CongcondData.CONG_WONX) * 100.0 ) ;  // 경조금
                }
            }else{
            	getApprovalInfo(req, PERNR);

            }

            box.copyToEntity(e19CongcondData);
            Logger.debug.println(this, box.toString());

            e19CongcondData.PERNR = PERNR;
            e19CongcondData.AINF_SEQN =box.get("AINF_SEQN");
            Logger.debug.println(this, e19CongcondData.toString());

            Logger.debug.println(this, "e19CongcondData---"+E19CongcondData_vt.toString());

            Vector  E19DisasterData_vt   = new Vector();
            Vector  E19DisasterData_rate = new Vector();
            Vector  E19DisasterData_rat2 = new Vector();  // CYH 20030918추가
            String  ainf_seqn            = box.get("AINF_SEQN");
            //String  ainf_seqn          = func.getNumberGetNext();

            // 재해위로금지급기준
            E19DisasterData_rate = (new E19DisaRateRFC()).getDisaRate(user.companyCode);
            // 20030918 cyh 추가사항
            //-----------------------------------------------------------------------//
            E19DisasterData_rat2 = (new E19DisaRat2RFC()).getDisaRat2(PERNR);

            Logger.debug.println(this, E19DisasterData_rat2.toString());
            //-----------------------------------------------------------------------//
            Logger.debug.println(this, "E19DisasterData_rate####"+E19DisasterData_rate.toString());



            // 재해피해신고서
            int rowcount_report = box.getInt("RowCount_report");
            for( int i = 0; i < rowcount_report; i++) {
                E19DisasterData e19DisasterData = new E19DisasterData();
                String          idx             = Integer.toString(i);

                if( box.get("use_flag"+idx).equals("N") ) continue;

                e19DisasterData.DISA_RESN  = box.get("DISA_RESN"+idx);   // 재해내역코드20030922추가cyh
                e19DisasterData.DISA_CODE  = box.get("DISA_CODE"+idx);   // 재해구분코드
                e19DisasterData.DREL_CODE  = box.get("DREL_CODE"+idx);   // 재해대상자 관계코드
                e19DisasterData.DISA_RATE  = box.get("DISA_RATE"+idx);   // 지급율
                e19DisasterData.CONG_DATE  = box.get("CONG_DATE"+idx);   // 경조발생일
                e19DisasterData.DISA_DESC1 = box.get("DISA_DESC1"+idx);  // 재해내용1
                e19DisasterData.DISA_DESC2 = box.get("DISA_DESC2"+idx);  // 재해내용2
                e19DisasterData.DISA_DESC3 = box.get("DISA_DESC3"+idx);  // 재해내용3
                e19DisasterData.DISA_DESC4 = box.get("DISA_DESC4"+idx);  // 재해내용4
                e19DisasterData.DISA_DESC5 = box.get("DISA_DESC5"+idx);  // 재해내용5
                e19DisasterData.EREL_NAME  = box.get("EREL_NAME"+idx);   // 경조대상성명
                e19DisasterData.INDX_NUMB  = box.get("INDX_NUMB"+idx);   // 순번
                e19DisasterData.PERNR      = box.get("PERNR"+idx);       // 사번
                e19DisasterData.REGNO      = box.get("REGNO"+idx);       // 한국등록번호
                e19DisasterData.STRAS      = box.get("STRAS"+idx);       // 주소
                e19DisasterData.AINF_SEQN  = ainf_seqn;                  // 결재정보 일련번호
                e19DisasterData.DREL_NAME = getDREL_NAME(e19DisasterData.DISA_CODE,e19DisasterData.DREL_CODE,user.companyCode); // 재해대상자 관계코드명
                e19DisasterData.DISA_NAME = getDISA_NAME(e19DisasterData.DISA_CODE,user.companyCode);      // 경조내역코드명

                E19DisasterData_vt.addElement(e19DisasterData);
            }
            Logger.debug.println(this, E19DisasterData_vt.toString());



            /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
            Vector AccountData_pers_vt = new Vector();
            int AccountData_pers_RowCount = box.getInt("AccountData_pers_RowCount");
            for( int i = 0; i < AccountData_pers_RowCount ; i++) {
                AccountData accountData = new AccountData();
                String      idx         = Integer.toString(i);
                accountData.LIFNR = box.get("p_LIFNR"+idx);
                accountData.BANKN = box.get("p_BANKN"+idx);
                accountData.BANKA = box.get("p_BANKA"+idx);
                accountData.BANKL = box.get("p_BANKL"+idx);

                AccountData_pers_vt.addElement(accountData);
            }

            AccountData AccountData_hidden = new AccountData();
            AccountData_hidden.LIFNR = box.get("h_LIFNR");
            AccountData_hidden.BANKN = box.get("h_BANKN");
            AccountData_hidden.BANKA = box.get("h_BANKA");
            AccountData_hidden.BANKL = box.get("h_BANKL");

            req.setAttribute("AccountData_hidden" , AccountData_hidden );

            Logger.debug.println(this, AccountData_pers_vt.toString());
            req.setAttribute("AccountData_pers_vt", AccountData_pers_vt);
            /**** 계좌정보(계좌번호,은행명)를 새로가져온다.****/


            req.setAttribute("resultData", e19CongcondData);
            req.setAttribute("E19DisasterData_vt", E19DisasterData_vt);
            req.setAttribute("fromJsp", fromJsp);
            req.setAttribute("E19DisasterData_rate", E19DisasterData_rate);
            req.setAttribute("E19DisasterData_rat2", E19DisasterData_rat2);

            Logger.debug.println(this, "E19DisasterData_vt.toString(); = " + E19DisasterData_vt.toString());

            if( jobid.equals("first") ) {

                dest = WebUtil.JspURL+"E/E19Disaster/E19ReportBuild.jsp";

            } else if( jobid.equals("back_build") ) {

                dest = WebUtil.JspURL+"E/E19Disaster/" + fromJsp;

            } else if( jobid.equals("add") ) {

                dest = WebUtil.JspURL+"E/E19Disaster/E19ReportBuild.jsp";

            } else if( jobid.equals("delete") ) {

                dest = WebUtil.JspURL+"E/E19Disaster/E19ReportBuild.jsp";
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
    }

    private String getDREL_NAME(String DISA_CODE, String DREL_CODE, String companyCode) throws GeneralException{
       Vector vt = (new E19DisaRelaRFC()).getDisaRela(companyCode);
        String ret = "";
        for( int i = 0 ; i < vt.size() ; i++ ){
            E19DisasterData data = (E19DisasterData)vt.get(i);
            if( DISA_CODE.equals(data.DISA_CODE) && DREL_CODE.equals(data.DREL_CODE)){
                ret = data.DREL_NAME;
            }
        }
        return ret;
    }
    private String getDISA_NAME(String DISA_CODE, String companyCode) throws GeneralException{
        Vector vt = (new E19DisaCodeRFC()).getDisaCode(companyCode);
        String ret = "";
        for( int i = 0 ; i < vt.size() ; i++ ){
            com.sns.jdf.util.CodeEntity data = (com.sns.jdf.util.CodeEntity)vt.get(i);
            if( DISA_CODE.equals(data.code) ){
                ret = data.value;
            }
        }
        return ret;
    }
}