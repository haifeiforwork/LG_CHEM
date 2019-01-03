/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 의료비                                                      */
/*   Program Name : 의료비 조회                                                 */
/*   Program ID   : E17HospitalDetailSV                                         */
/*   Description  : 의료비를 조회/삭제 할수 있도록 하는 Class                   */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  김성일                                          */
/*   Update       : 2005-02-16  윤정현                                          */
/*                  2014-06-03  [CSR ID:2548667] 의료비관련 개선 요청의 건        */
/*                  2017-10-30  [CSR ID:3500559] 의료비지원 기준 변경에 대한 요청의 건                                              */
/********************************************************************************/

package servlet.hris.E.E17Hospital;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A01SelfDetailData;
import hris.A.rfc.A01SelfDetailRFC;
import hris.E.E17Hospital.E17BillData;
import hris.E.E17Hospital.E17HospitalData;
import hris.E.E17Hospital.E17HospitalResultData;
import hris.E.E17Hospital.E17SickData;
import hris.E.E17Hospital.rfc.*;
import hris.E.E18Hospital.E18HospitalListData;
import hris.E.E18Hospital.rfc.E18HospitalIngListRFC;
import hris.E.E18Hospital.rfc.E18HospitalListRFC;
import hris.G.ApprovalReturnState;
import hris.G.rfc.G001ApprovalPreCheckRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Vector;

public class E17HospitalDetailSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="03";  // 결재 업무타입(의료비)
    private String UPMU_NAME = "의료비";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {
            final WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            String jobid = box.get("jobid", "first");

            String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            final E17HospitalRFC hospitalRFC = new E17HospitalRFC();
            hospitalRFC.setDetailInput(user.empNo, I_APGUB, box.get("AINF_SEQN"));
            E17HospitalResultData resultData = hospitalRFC.detail(); //결과 데이타

            Vector<E17SickData> E17SickData_vt = resultData.T_ZHRA006T;
            Vector<E17HospitalData> E17HospitalData_vt = resultData.T_ZHRW005A;
            Vector<E17BillData> E17BillData_vt = resultData.T_ZHRW006A;

            String AINF_SEQN = box.get("AINF_SEQN");

            E17SickData e17SickData = Utils.indexOf(E17SickData_vt, 0);

            if (jobid.equals("first")) {           //제일처음 신청 화면에 들어온경우.

                if (!detailApporval(req, res, hospitalRFC))
                    return;

                E18HospitalListRFC func_E18 = new E18HospitalListRFC();

                Vector E18HospitalData_vt = new Vector();
                String l_CTRL_NUMB        = "";

                if(Utils.getSize(E17SickData_vt) == 0) {
                    moveMsgPage(req, res, g.getMessage("MSG.SEARCH.ERROR"),  "history.back();");
                    return;
                }

                double COMP_sum = 0;
                double totEMPL_WONX = 0;
                // -----------------배우자일 경우 회사지원총액을 보여주기 위해서 총액을 계산한다.
                if( e17SickData.GUEN_CODE.equals("0002") ) {
                    E18HospitalData_vt = func_E18.getHospitalList( e17SickData.PERNR ) ;

                    for ( int i = 0 ; i < E18HospitalData_vt.size() ; i++ ) {
                        E18HospitalListData data_18 = ( E18HospitalListData ) E18HospitalData_vt.get( i ) ;
                        l_CTRL_NUMB = data_18.CTRL_NUMB.substring(0, 4);
                        if( data_18.GUEN_CODE.equals("0002") && l_CTRL_NUMB.equals(e17SickData.BEGDA.substring(0, 4)) ) {
                            COMP_sum = COMP_sum + Double.parseDouble( data_18.COMP_WONX );
                        }
                        totEMPL_WONX += Double.parseDouble(data_18.EMPL_WONX);
                    }
                }

                //  ------------------------------------------------------------------------------
                req.setAttribute("e17SickData"       , e17SickData);
                req.setAttribute("E17HospitalData_vt", E17HospitalData_vt);
                req.setAttribute("E17BillData_vt"    , E17BillData_vt);
                req.setAttribute("COMP_sum"          , Double.toString( COMP_sum ));

                req.setAttribute("MedicTrea_vt", (new E17MedicTreaRFC()).getMedicTrea());

                Map<String, Vector> guenMap = (new E17GuenCodeRFC()).getGuenCode(e17SickData.PERNR);
                req.setAttribute("guenCodeList", guenMap.get("T_RESULT"));


                Vector<CodeEntity> currency_vt = (new hris.common.rfc.CurrencyDecimalRFC()).getCurrencyDecimal();
                for(CodeEntity codeEnt : currency_vt) {
                    if( e17SickData.WAERS.equals(codeEnt.code) ){
                        req.setAttribute("currencyValue"          , NumberUtils.toInt(codeEnt.value));
                        break;
                    }
                }

                ApprovalHeader approvalHeader = (ApprovalHeader) req.getAttribute("approvalHeader");

                if("X".equals(approvalHeader.ACCPFL)) {
                    String             P_Flag              = "";
                    double            WCOMP_SUM            = 0.0; //배우자
                    double            ICOMP_SUM            = 0.0; //자녀
                    double            SCOMP_SUM            = 0.0; //본인
                    double            WCOMPING_SUM            = 0.0; //배우자
                    double            ICOMPING_SUM            = 0.0; //자녀
                    double            SCOMPING_SUM            = 0.0; //본인

                    totEMPL_WONX = 0;   //합계 초기화

                    String E_YEARS = resultData.E_YEARS; //자녀 나이 년수
                    String E_MNTH = resultData.E_MNTH; //자녀 나이 월

                    E17MedicCheckYNRFC checkYN = new E17MedicCheckYNRFC();
                    P_Flag  = checkYN.getE_FLAG( DataUtil.getCurrentYear(), e17SickData.PERNR );

                    //  회사지원 총액을 보여주기 위해서 총액을 계산한다.
                    //@CSR1 결재진행중 금액도 합산하여 한도체크
                    E18HospitalIngListRFC ingListRFC            = new E18HospitalIngListRFC();
                    Vector<E18HospitalListData> ingList = ingListRFC.getHospitalList(e17SickData.PERNR, e17SickData.BEGDA);

                    for(E18HospitalListData ingData : ingList) {

                        String ingCTRL_NUMB = StringUtils.substring(ingData.CTRL_NUMB, 0, 4);

                        if(StringUtils.equals(ingData.AINF_SEQN, AINF_SEQN) || !ingCTRL_NUMB.equals(e17SickData.BEGDA.substring(0, 4))) continue;

                        if("0001".equals(ingData.GUEN_CODE)) {
                            SCOMP_SUM = SCOMP_SUM + NumberUtils.toDouble( ingData.COMP_WONX );
                            if(WebUtil.isEmptyDate(ingData.POST_DATE)) SCOMPING_SUM = SCOMPING_SUM + NumberUtils.toDouble( ingData.COMP_WONX );
                        } else if("0002".equals(ingData.GUEN_CODE)) {
                            WCOMP_SUM = WCOMP_SUM + NumberUtils.toDouble( ingData.COMP_WONX );
                            if(WebUtil.isEmptyDate(ingData.POST_DATE)) WCOMPING_SUM = WCOMPING_SUM + NumberUtils.toDouble( ingData.COMP_WONX );
                        } else if("0003".equals(ingData.GUEN_CODE)) {
                            ICOMP_SUM = ICOMP_SUM + NumberUtils.toDouble( ingData.COMP_WONX );
                            if(WebUtil.isEmptyDate(ingData.POST_DATE)) ICOMPING_SUM = ICOMPING_SUM + NumberUtils.toDouble( ingData.COMP_WONX );
                        } // end if
                    }
                        //Logger.debug.println(this, "#######e17SickData = " + e17SickData);

                    for(E17HospitalData row : E17HospitalData_vt) {
                        totEMPL_WONX = totEMPL_WONX + NumberUtils.toDouble(row.EMPL_WONX);
                    }

                    Logger.debug.println(this, "#######dSCOMP_SUM = " + SCOMP_SUM +"dWCOMP_SUM:"+WCOMP_SUM+"dICOMP_SUM:"+ICOMP_SUM);

                    //결재전사내커플 유무  사전체크 2012.07.02
                    //시간제의 경우 사전 popup 추가 2014.05.21 (사무직(4H) : 50% 지급, 사무직(6H) : 75% 지급)
                    G001ApprovalPreCheckRFC PreCheck = new G001ApprovalPreCheckRFC();
                    Vector<ApprovalReturnState> vcCheck = PreCheck.setApprovalStatutsList(AINF_SEQN);

                    if(Utils.getSize(vcCheck) > 0) {
                        ApprovalReturnState checkData = Utils.indexOf(vcCheck, 0);
                        req.setAttribute("E_COUPLEYN"  ,checkData.E_RETURN);  //Y: 사내커플인 경우 담당자 결재시 자녀 확인 메세지 처리 & 시간제 메시지 추가
                        req.setAttribute("E_MESSAGE"  ,checkData.E_MESSAGE);  //Y: 사내커플인 경우 담당자 결재시 자녀 확인 메세지       & 시간제 메시지 추가
                    }

                    //out.println("e17SickData.CTRL_NUMB.substring(7,9):"+e17SickData.CTRL_NUMB.substring(7,9));
                    /*
                            if (totEMPL_WONX< 100000)  //@v1.4
                                e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX );
                            else
                                e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX - 100000);
                     */
                    boolean isFirst = "01".equals(StringUtils.substring(e17SickData.CTRL_NUMB, 7, 9)) ;

                    if(approvalHeader.isCharger()) {
//                        if(approvalHeader.isDepartManager()) {
                        double  dSCOMP_SUM = SCOMP_SUM;
                        double  dWCOMP_SUM = WCOMP_SUM;
                        double  dICOMP_SUM = ICOMP_SUM;
                        //out.println("e17SickData.CTRL_NUMB.substring(7,9):"+e17SickData.CTRL_NUMB.substring(7,9));
                        if (e17SickData.GUEN_CODE.equals("0001")) {
                            // 본인
                            //@v1.5 if (dSCOMP_SUM == 0) {
                            if (e17SickData.CTRL_NUMB.substring(7,9).equals("01")) {
                                // 최초 신청
                                if (totEMPL_WONX< 100000)  //@v1.4
                                    e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX );
                                else
                                    e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX - 100000);
                            } else {

                                e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX );
                            } // end if
                            e17SickData.YTAX_WONX = String.valueOf(totEMPL_WONX);
                        } else {
                            if (P_Flag.equals("Y") && e17SickData.GUEN_CODE.equals("0002")) {
                                // 배우자 지원 한도 미 적용
                                if (e17SickData.GUEN_CODE.equals("0002")) { // 배우자 신청
                                    if (e17SickData.CTRL_NUMB.substring(7,9).equals("01")) {

                                        // 최초 신청
                                        //e17SickData.COMP_WONX = String.valueOf((totEMPL_WONX - 100000)/2);
                                        //@1.6 배우자본인과 똑같이 100%지원으로 변경
                                        if (totEMPL_WONX< 100000)
                                            e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX );
                                        else
                                            e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX - 100000);

                                    } else {
                                        e17SickData.COMP_WONX = String.valueOf(totEMPL_WONX );
                                    } // end if
                                }

                            } else {
                                // [CSR ID:2598080] 의료비 지원한도 적용 수정 배우자, 자녀 합산 1000만원
                                //double dFlag = 5000000; //@v1.5
                                double dFlag = 10000000;//배우자+자녀
                                double dTemp = 0;
                                double totEMPL_WONXH = totEMPL_WONX; //@v1.5
                                double dWICOMP_SUM;
                                //if (e17SickData.GUEN_CODE.equals("0002") )
                                //    dWICOMP_SUM = dWCOMP_SUM;
                                // else
                                //    dWICOMP_SUM = dICOMP_SUM;
                                dWICOMP_SUM = dWCOMP_SUM + dICOMP_SUM;

                                //@1.6 배우자본인과 똑같이 100%지원으로 변경
                               //[CSR ID:3500559] 의료비지원 기준 변경에 대한 요청의 건 start
                              //의료비결재 화면에 자녀의료비인 경우 지원금액이 신청금액의 50%가 자동 계산되어 보여지는데 이를 100%로 적용되어 보여져야 함
                                 // if (e17SickData.GUEN_CODE.equals("0002")) {
                                if (e17SickData.GUEN_CODE.equals("0002")||e17SickData.GUEN_CODE.equals("0003")) {
                                    if (e17SickData.CTRL_NUMB.substring(7,9).equals("01")) {
                                        // 최초 신청
                                        if ( (totEMPL_WONX - 100000) > dFlag)
                                            dTemp = dFlag;
                                        else {
                                            if (totEMPL_WONX < 100000) //@v1.4
                                                dTemp = totEMPL_WONX;
                                            else
                                                dTemp = (totEMPL_WONX - 100000);
                                        }
                                        //out.println("dTemp배우자최초 신청:"+dTemp);

                                        if ( (dTemp+dWICOMP_SUM) > dFlag) {
                                            dTemp = dFlag - dWICOMP_SUM;
                                        }

                                    } else {
                                        dTemp = (dWICOMP_SUM + totEMPL_WONXH); //이미사용한금액+신청금액합
                                        if (dTemp > dFlag) {
                                            dTemp = dFlag - dWICOMP_SUM;
                                        } else {
                                            dTemp = totEMPL_WONXH;//@v1.5
                                        } // end if
                                    } // end if
                                }
                                //배우자 와 자녀 로직 분리: 2005.10.28일추가(제도 미반영에러로 인하여)
                                /*else if (e17SickData.GUEN_CODE.equals("0003")) { //자녀
                                    //@v1.5 if (dWICOMP_SUM == 0) {
                                    if (e17SickData.CTRL_NUMB.substring(7,9).equals("01")) {
                                        // 최초 신청
                                        if ( (totEMPL_WONX - 100000)/2 > dFlag)
                                            dTemp = dFlag;
                                        else {
                                            if (totEMPL_WONX < 100000) //@v1.4
                                                dTemp = totEMPL_WONX/2;
                                            else
                                                dTemp = (totEMPL_WONX - 100000)/2;
                                        }
                                        //out.println("dTemp배우자최초 신청:"+dTemp);

                                        if ( (dTemp+dWICOMP_SUM) > dFlag) {
                                            dTemp = dFlag - dWICOMP_SUM;
                                        }

                                    } else {
                                        dTemp = (dWICOMP_SUM + totEMPL_WONXH/2); //이미사용한금액+신청금액합
                                        if (dTemp > dFlag) {
                                            dTemp = dFlag - dWICOMP_SUM;
                                        } else {
                                            dTemp = totEMPL_WONXH/2;//@v1.5
                                        } // end if
                                    } // end if
                                }*/
                              //[CSR ID:3500559] 의료비지원 기준 변경에 대한 요청의 건 end
                                if (dTemp < 0) //@v1.4
                                    e17SickData.COMP_WONX = String.valueOf(totEMPL_WONXH);
                                else
                                    e17SickData.COMP_WONX = String.valueOf(dTemp); //회사지원최종금액
                                if (e17SickData.PROOF.equals("X")) {
                                    e17SickData.YTAX_WONX = String.valueOf(totEMPL_WONX);
                                } else {
                                    e17SickData.YTAX_WONX = "0";
                                } // end if

                                e17SickData.COMP_WONX = String.valueOf(Double.parseDouble(e17SickData.COMP_WONX) / 1);

                            } // end if
                        } // end if

                    }
                    double TempCompanySum_1 = SCOMP_SUM-SCOMPING_SUM;
                    double TempCompanySum_2 = WCOMP_SUM-WCOMPING_SUM;
                    double TempCompanySum_3 = ICOMP_SUM-ICOMPING_SUM;

                    req.setAttribute("TempCompanySum_1", TempCompanySum_1);
                    req.setAttribute("TempCompanySum_2", TempCompanySum_2);
                    req.setAttribute("TempCompanySum_3", TempCompanySum_3);

                    req.setAttribute("MediCode_vt", (new E17MediCodeRFC()).getMediCode());  //"code", "desc"
                    req.setAttribute("RcptCode_vt", (new E17RcptCodeRFC()).getRcptCode());

                    req.setAttribute("isFirst", isFirst);
                    req.setAttribute("e17SickData"       , e17SickData);
                    req.setAttribute("P_Flag"           , P_Flag);
                    req.setAttribute("WCOMP_SUM"        , WCOMP_SUM);
                    req.setAttribute("ICOMP_SUM"        , ICOMP_SUM);
                    req.setAttribute("SCOMP_SUM"        , SCOMP_SUM);
                    req.setAttribute("WCOMPING_SUM"        , WCOMPING_SUM);
                    req.setAttribute("ICOMPING_SUM"        , ICOMPING_SUM);
                    req.setAttribute("SCOMPING_SUM"        , SCOMPING_SUM);
                    req.setAttribute("E_YEARS"       ,E_YEARS);
                    req.setAttribute("E_MNTH"        ,E_MNTH);
                    printJspPage(req, res, WebUtil.JspURL+"G/G006ApprovalHospital.jsp");
                } else
                    printJspPage(req, res, WebUtil.JspURL+"E/E17Hospital/E17HospitalDetail.jsp");

            } else if (jobid.equals("delete")) {           //제일처음 신청 화면에 들어온경우.

                String dest = deleteApproval(req, box, hospitalRFC, new DeleteFunction() {
                    public boolean porcess() throws GeneralException {

                        E17HospitalRFC deleteRFC = new E17HospitalRFC();
                        deleteRFC.setDeleteInput(user.empNo, UPMU_TYPE, hospitalRFC.getApprovalHeader().AINF_SEQN);

                        RFCReturnEntity returnEntity = deleteRFC.delete();

                        if (!returnEntity.isSuccess()) {
                            throw new GeneralException(returnEntity.MSGTX);
                        }

                        return true;
                    }
                });

                printJspPage(req, res, dest);
            } else if( jobid.equals("print_hospital") ) {  //새창띠움

                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.E.E17Hospital.E17HospitalDetailSV?jobid=print&AINF_SEQN=" + AINF_SEQN);
//                Logger.debug.println(this, WebUtil.ServletURL+"hris.E.E17Hospital.E17HospitalDetailSV?jobid=print&AINF_SEQN=" + AINF_SEQN);

                printJspPage(req, res, WebUtil.JspURL+"common/printFrame.jsp");
            } else if( jobid.equals("print") ) {

                if(Utils.getSize(E17SickData_vt) == 0) {
                    moveMsgPage(req, res, g.getMessage("MSG.SEARCH.ERROR"),  "history.back();");
                    return;
                }

                //CSR ID : 2548667 자사입사일(DAT03)을 확인하기 위한 A01SelfDetailRFC 개인인적사항 조회
                A01SelfDetailRFC rfc2 = new A01SelfDetailRFC();
                Vector<A01SelfDetailData> A01SelfDetailData_vt = rfc2.getPersInfo(e17SickData.PERNR, user.area.getMolga(), "");


                if (Utils.getSize(A01SelfDetailData_vt) == 0 ) {
                    moveCautionPage(req, res, "msg004", "");
                    return;

                }

                String E_LASTDAY     = resultData.E_LASTDAY;

                req.setAttribute("E_LASTDAY"       , E_LASTDAY);
                req.setAttribute("e17SickData"       , e17SickData);
                req.setAttribute("E17HospitalData_vt", E17HospitalData_vt);
                req.setAttribute("A01SelfDetailData_vt", A01SelfDetailData_vt);//CSR ID : 2548667

                printJspPage(req, res, WebUtil.JspURL+"E/E17Hospital/E17HospitalPrintpage.jsp");

            }  else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }


        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }

    }
}
