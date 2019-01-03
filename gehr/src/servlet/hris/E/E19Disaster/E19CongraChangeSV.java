/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재해신청                                                    */
/*   Program Name : 재해신청 수정                                               */
/*   Program ID   : E19CongraChangeSV                                           */
/*   Description  : 재해 신청을 수정할 수 있도록 하는 Class                     */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-25  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E19Disaster;

import hris.A.A17Licence.A17LicenceData;
import hris.A.A17Licence.rfc.A17LicenceGradeRFC;
import hris.A.A17Licence.rfc.A17LicenceRFC;
import hris.E.E19Disaster.E19CongcondData;
import hris.E.E19Disaster.E19DisasterData;
import hris.E.E19Disaster.rfc.E19CongRateRFC;
import hris.E.E19Disaster.rfc.E19CongraRequestRFC;
import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ChangeFunction;
import hris.common.db.AppLineDB;
import hris.common.rfc.PersonInfoRFC;
import hris.common.util.AppUtil;

import java.sql.Connection;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import servlet.hris.A.A17Licence.A17LicenceBuildSV;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E19CongraChangeSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="09";  // 결재 업무타입(경조금)
    private String UPMU_NAME = "재해";

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
            final String AINF_SEQN = box.get("AINF_SEQN");

            //**********수정 끝.****************************

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서


            final E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();
            e19CongraRequestRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            Vector resultList = e19CongraRequestRFC.getDetail(); //결과 데이타
            E19CongcondData     e19CongcondData = null;
            Vector E19CongcondData_vt = (Vector)resultList.get(0);
            for( int i = 0 ; i < E19CongcondData_vt.size() ; i++ ){
                e19CongcondData = (E19CongcondData)E19CongcondData_vt.get(i);
                e19CongcondData.WAGE_WONX = Double.toString(Double.parseDouble(e19CongcondData.WAGE_WONX) * 100.0 ) ;  // 통상임금
                e19CongcondData.CONG_WONX = Double.toString(Double.parseDouble(e19CongcondData.CONG_WONX) * 100.0 ) ;  // 경조금
            }

            final String PERNR = e19CongcondData.PERNR; //신청대상자 사번

            Vector E19DisasterData_vt = (Vector)resultList.get(1);
            Logger.debug.println(this, "E19CongcondData_vt---"+E19CongcondData_vt.toString());
            Logger.debug.println(this, "E19DisasterData_vt---"+E19DisasterData_vt.toString());



            if( jobid.equals("first") ) {  //제일처음 수정 화면에 들어온경우.
                /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                Vector AccountData_pers_vt = accountInfoRFC.getPersAccountInfo(PERNR);

                AccountData AccountData_hidden = new AccountData();
                DataUtil.fixNull(AccountData_hidden);
                req.setAttribute("e19CongcondData", e19CongcondData);
                req.setAttribute("E19DisasterData_vt", E19DisasterData_vt);
                req.setAttribute("resultData", e19CongcondData);
                req.setAttribute("AccountData_hidden" , AccountData_hidden );
                req.setAttribute("AccountData_pers_vt", AccountData_pers_vt);
                req.setAttribute("PERNR",PERNR);
                req.setAttribute("isUpdate", true); //등록 수정 여부

                /**** 계좌정보(계좌번호,은행명)를 새로가져온다.****/
                detailApporval(req, res, e19CongraRequestRFC);

                printJspPage(req, res, WebUtil.JspURL + "E/E19Disaster/E19CongraBuild.jsp");

            } else if( jobid.equals("change") ) {

                /* 실제 신청 부분 */
                dest = changeApproval(req, box, E19CongcondData.class, e19CongraRequestRFC, new ChangeFunction<E19CongcondData>(){

                    public String porcess(E19CongcondData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {
                        /* 결재 신청 RFC 호출 */
                    	E19CongraRequestRFC changeRFC = new E19CongraRequestRFC();
                        changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        Logger.debug("-------- AINF_SEQN " + inputData.AINF_SEQN);
                    	   // 재해피해신고서
                        int rowcount_report = box.getInt("RowCount_report");
                        Vector E19DisasterData_vt = new Vector();

                        for( int i = 0; i < rowcount_report; i++ ) {
                            E19DisasterData e19DisasterData = new E19DisasterData();
                            String          idx             = Integer.toString(i);
                            e19DisasterData.AINF_SEQN  =AINF_SEQN;   // 재해내역코드20030922추가cyh
                            e19DisasterData.DISA_RESN  = box.get("DISA_RESN"+idx);   // 재해내역코드20030922추가cyh
                            e19DisasterData.DISA_CODE  = box.get("DISA_CODE"+idx);   // 재해구분코드
                            e19DisasterData.DREL_CODE  = box.get("DREL_CODE"+idx);   // 재해대상자 관계코드
                            e19DisasterData.DISA_RATE  = box.get("DISA_RATE"+idx);   // 지급율
                            e19DisasterData.CONG_DATE  = box.get("CONG_DATE");       // 경조발생일
                            e19DisasterData.DISA_DESC1 = box.get("DISA_DESC1"+idx);  // 재해내용1
                            e19DisasterData.DISA_DESC2 = box.get("DISA_DESC2"+idx);  // 재해내용2
                            e19DisasterData.DISA_DESC3 = box.get("DISA_DESC3"+idx);  // 재해내용3
                            e19DisasterData.DISA_DESC4 = box.get("DISA_DESC4"+idx);  // 재해내용4
                            e19DisasterData.DISA_DESC5 = box.get("DISA_DESC5"+idx);  // 재해내용5
                            e19DisasterData.EREL_NAME  = box.get("EREL_NAME"+idx);   // 경조대상성명
                            e19DisasterData.INDX_NUMB  = (i+1)+"";                   // 순번
                            e19DisasterData.PERNR      = PERNR;                      // 사번
                            e19DisasterData.REGNO      = box.get("REGNO"+idx);       // 한국등록번호
                            e19DisasterData.STRAS      = box.get("STRAS"+idx);       // 주소
                            E19DisasterData_vt.addElement(e19DisasterData);

                        }
                        Logger.debug.println("rowcount_report----"+rowcount_report);
                        Logger.debug.println("재해신청서 size1----"+E19DisasterData_vt.size());
                        if(Utils.getFieldValue(inputData,"CONG_CODE").equals("0007") ){
                            /**** 신청된금액이 입금될 계좌정보가 있는지 체크 **************************************/
                            hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                            if( ! accountInfoRFC.hasDepartAccount((String)Utils.getFieldValue(inputData,"LIFNR")) ){
                            	 throw new GeneralException("계좌번호가 등록되어 있지 않습니다.");
                            }
                            /**** 신청된금액이 입금될 계좌정보가 있는지 체크 **************************************/
                        } else {
                            /**** 신청된금액이 입금될 계좌정보가 있는지 체크 **************************************/
                            hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                            if( ! accountInfoRFC.hasPersAccount(PERNR) ){
                            	throw new GeneralException("계좌번호가 등록되어 있지 않습니다.");
                            }
                            /**** 신청된금액이 입금될 계좌정보가 있는지 체크 **************************************/
                        }

                        changeRFC.build(E19DisasterData_vt,inputData, box, req);

                        if(!changeRFC.getReturn().isSuccess()) {
                            throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }
                        Logger.debug.println(this, "inputData.AINF_SEQN : " + inputData.AINF_SEQN);
                        return inputData.AINF_SEQN;
                        /* 개발자 작성 부분 끝 */
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
