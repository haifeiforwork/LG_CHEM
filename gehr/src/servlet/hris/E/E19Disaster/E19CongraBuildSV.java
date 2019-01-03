/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재해신청                                                    */
/*   Program Name : 재해신청                                                    */
/*   Program ID   : E19CongraBuildSV                                            */
/*   Description  : 재해를 신청할 수 있도록 하는 Class                          */
/*   Note         :                                                             */
/*   Creation     : 2001-12-19  김성일                                          */
/*   Update       : 2005-02-18  윤정현                                          */
/*  CSR ID : 2511881 재해신청 시스템 수정요청 20140327 이지은D  1) 재해신청일자 < 신청일 validation
 * 																				      2) 신청일이 시작일이 아니고, 재해신청일자가 BEGDA
 * 																					  3) 재해신청일자 입력 화면 변경(재해피해신고서로 옮김)  */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E19Disaster;

import hris.A.A17Licence.A17LicenceData;
import hris.E.E19Disaster.E19CongcondData;
import hris.E.E19Disaster.E19DisasterData;
import hris.E.E19Disaster.rfc.E19CongMoreRelaRFC;
import hris.E.E19Disaster.rfc.E19CongraRequestRFC;
import hris.common.AccountData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class E19CongraBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="09";  // 결재 업무타입(경조금)
    private String UPMU_NAME = "재해";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException
    {
        try{
            final WebUserData user = WebUtil.getSessionUser(req);

            final Box box = WebUtil.getBox(req);

            final String dest;
            final String PERNR = getPERNR(box, user); //신청대상자 사번
            String disast_day;

            String jobid = box.get("jobid", "first");


            if (jobid.equals("first")) {   //제일처음 신청 화면에 들어온경우.
                //결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);

                //신청일자 -> 재해발생일자 기준 변경
                if(box.get("CONG_DATE").equals("")||box.get("CONG_DATE").trim() == ""){
                	disast_day = DataUtil.getCurrentDate();
                }else{
                	disast_day = WebUtil.replace(box.get("CONG_DATE"), ".", "");
                }

                Vector E19CongcondData_more = (new E19CongMoreRelaRFC()).getCongMoreRela(PERNR,  disast_day);
                E19CongcondData e19CongcondData = (E19CongcondData)E19CongcondData_more.get(0);
                e19CongcondData.PERNR = PERNR;

                /**** 계좌정보(계좌번호,은행명)를 새로가져온다. 수정:2002/01/22 ****/
                hris.common.rfc.AccountInfoRFC accountInfoRFC = new hris.common.rfc.AccountInfoRFC();
                Vector AccountData_pers_vt = accountInfoRFC.getPersAccountInfo(PERNR);

                AccountData AccountData_hidden = new AccountData();
                DataUtil.fixNull(AccountData_hidden);
                req.setAttribute("AccountData_hidden" , AccountData_hidden );

                req.setAttribute("AccountData_pers_vt", AccountData_pers_vt);
                /**** 계좌정보(계좌번호,은행명)를 새로가져온다.****/

                req.setAttribute("resultData", e19CongcondData);
                req.setAttribute("E19DisasterData_vt", new Vector());
                req.setAttribute("PERNR",PERNR);
                req.setAttribute("isUpdate", box.get("isUpdate"));
                dest = WebUtil.JspURL + "E/E19Disaster/E19CongraBuild.jsp";

            }  else if (jobid.equals("create")) {

                /* 실제 신청 부분 */
                dest = requestApproval(req, box, E19CongcondData.class, new RequestFunction<E19CongcondData>() {
                    public String porcess(E19CongcondData inputData,Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* 결재 신청 RFC 호출 */
                    	E19CongraRequestRFC e19CongraRequestRFC = new E19CongraRequestRFC();
                    	e19CongraRequestRFC.setRequestInput(user.empNo, UPMU_TYPE);
                    	Vector E19DisasterData_vt = new Vector();

                    	   // 재해피해신고서
                        int rowcount_report = box.getInt("RowCount_report");

                        Logger.debug.println("rowcount_report00----"+rowcount_report);
                        for( int i = 0; i < rowcount_report; i++ ) {
                        	E19DisasterData e19DisasterData = new E19DisasterData();
                            String          idx             = Integer.toString(i);

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
                        String AINF_SEQN = e19CongraRequestRFC.build(E19DisasterData_vt,inputData, box, req);

                        if(!e19CongraRequestRFC.getReturn().isSuccess()) {
                            throw new GeneralException(e19CongraRequestRFC.getReturn().MSGTX);
                        };

                        return AINF_SEQN;
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