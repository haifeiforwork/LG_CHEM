/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재해신청                                                    */
/*   Program Name : 재해피해신고서                                              */
/*   Program ID   : E19ReportDetailSV                                           */
/*   Description  : 재해피해신고서를 조회 할수 있도록 하는 Class                */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-28  윤정현                                          */
/*   Update       : 2005-03-02  이승희(retPage 추가)                            */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E19Disaster;

import hris.E.E19Disaster.E19CongcondData;
import hris.E.E19Disaster.E19DisasterData;
import hris.E.E19Disaster.rfc.E19DisaCodeRFC;
import hris.E.E19Disaster.rfc.E19DisaRelaRFC;
import hris.E.E19Disaster.rfc.E19DisaResnRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.DocumentInfo;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class E19ReportDetailSV extends EHRBaseServlet
{
    private String UPMU_TYPE ="09";

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try {
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            String dest  = "";
            Box box = WebUtil.getBox(req);

            String PERNR     = box.get("PERNR");
            String ainf_seqn = box.get("AINF_SEQN");

            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if
            Logger.debug.println(this, "[PERNR] = "+PERNR);
            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            req.setAttribute("PersonData" , phonenumdata );

//          최종 돌아갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            // 돌아 가기 버튼
            String retPage = box.get("retPage");
            String I_APGUB = box.get("I_APGUB");//'1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
            if (I_APGUB.equals("2")) {
            	retPage =  g.getServlet() +"hris.G.G002ApprovalIngDetailSV?"+StringUtils.substringAfter(retPage, "?");
            }else if (I_APGUB.equals("1")) {
            	retPage =  g.getServlet() +"hris.G.G000ApprovalDetailSV?"+StringUtils.substringAfter(retPage, "?");
            }else if (I_APGUB.equals("3")) {
            	retPage =  g.getServlet() +"hris.G.G003ApprovalFinishDetailSV?"+StringUtils.substringAfter(retPage, "?");
            }
            req.setAttribute("retPage", retPage);


//          경조금
            E19CongcondData     e19CongcondData = new E19CongcondData();

            box.copyToEntity(e19CongcondData);

            e19CongcondData.PERNR = PERNR;
            e19CongcondData.AINF_SEQN = ainf_seqn;
            req.setAttribute("e19CongcondData", e19CongcondData);
            Logger.debug.println(this, e19CongcondData.toString());

            Vector E19DisasterData_vt = new Vector();

            // 재해피해신고서
            int rowcount_report = box.getInt("RowCount_report");
            for( int i = 0; i < rowcount_report; i++) {
                E19DisasterData e19DisasterData = new E19DisasterData();
                String          idx             = Integer.toString(i);

                e19DisasterData.DISA_RESN  = box.get("DISA_RESN"+idx);    // 재해내역코드
                e19DisasterData.DISA_CODE  = box.get("DISA_CODE"+idx);    // 재해구분코드
                e19DisasterData.DREL_CODE  = box.get("DREL_CODE"+idx);    // 재해대상자 관계코드
                e19DisasterData.DISA_RATE  = box.get("DISA_RATE"+idx);    // 지급율
                e19DisasterData.CONG_DATE  = box.get("CONG_DATE"+idx);    // 경조발생일
                e19DisasterData.DISA_DESC1 = box.get("DISA_DESC1"+idx);   // 재해내용1
                e19DisasterData.DISA_DESC2 = box.get("DISA_DESC2"+idx);   // 재해내용2
                e19DisasterData.DISA_DESC3 = box.get("DISA_DESC3"+idx);   // 재해내용3
                e19DisasterData.DISA_DESC4 = box.get("DISA_DESC4"+idx);   // 재해내용4
                e19DisasterData.DISA_DESC5 = box.get("DISA_DESC5"+idx);   // 재해내용5
                e19DisasterData.EREL_NAME  = box.get("EREL_NAME"+idx);    // 경조대상성명
                e19DisasterData.INDX_NUMB  = box.get("INDX_NUMB"+idx);    // 순번
                e19DisasterData.PERNR      = box.get("PERNR"+idx);        // 사번
                e19DisasterData.REGNO      = box.get("REGNO"+idx);        // 한국등록번호
                e19DisasterData.STRAS      = box.get("STRAS"+idx);        // 주소
                e19DisasterData.AINF_SEQN  = box.get("AINF_SEQN"+idx);    // 결재정보 일련번호

                e19DisasterData.DREL_NAME = getDREL_NAME(e19DisasterData.DISA_CODE,e19DisasterData.DREL_CODE,user.companyCode); // 재해대상자 관계코드명
                e19DisasterData.DISA_NAME = getDISA_NAME(e19DisasterData.DISA_CODE,user.companyCode);      // 경조내역코드명
                e19DisasterData.RESN_NAME = getRESN_NAME(e19DisasterData.DISA_RESN,user.companyCode);      // 경조내역원인코드명20030910 CYH

                E19DisasterData_vt.addElement(e19DisasterData);
            }
            Logger.debug.println(this, E19DisasterData_vt.toString());
            req.setAttribute( "E19DisasterData_vt", E19DisasterData_vt );

            dest = WebUtil.JspURL+"E/E19Disaster/E19ReportDetail.jsp";

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
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

    private String getRESN_NAME(String DISA_RESN, String companyCode) throws GeneralException{
        Vector vt = (new E19DisaResnRFC()).getDisaResn(companyCode);
        String ret = "";

        for( int i = 0 ; i < vt.size() ; i++ ){
            com.sns.jdf.util.CodeEntity data = (com.sns.jdf.util.CodeEntity)vt.get(i);
            if( DISA_RESN.equals(data.code) ){
                ret = data.value;
            }
        }
        return ret;
    }
}
