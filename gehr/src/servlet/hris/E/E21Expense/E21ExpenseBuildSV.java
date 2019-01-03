/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 장학자금                                                    */
/*   Program Name : 장학자금 신청                                               */
/*   Program ID   : E21ExpenseBuildSV                                           */
/*   Description  : 학자금/장학금 신청할 수 있도록 하는 Class                   */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김성일                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                  2006-02-03  @v1.1 lsa 학자금신청오류(중,고등학교입학금을 합쳐서처리하여 따로 따로 처리) */
/*                  2015-07-31  이지은D [CSR ID:2840321] 사내부부 자녀 학자금 신청시 문구요청*/
/*                  2017-05-22  eunha [CSR ID:3383001] 해외 주재원 장학자금 로직 수정*/
/*						2018-04-19 cykim [CSR ID:3660657] 학자금 수혜횟수 체크 로직 변경 요청의 건 */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E21Expense;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A04FamilyDetailData;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.E.E17Hospital.rfc.E17CompanyCoupleRFC;
import hris.E.E19Congra.E19CongcondData;
import hris.E.E19Congra.rfc.E19CongMoreRelaRFC;
import hris.E.E21Expense.E21ExpenseChkData;
import hris.E.E21Expense.E21ExpenseData;
import hris.E.E21Expense.rfc.E21ExpenceCheckRFC;
import hris.E.E21Expense.rfc.E21ExpenseBreakRFC;
import hris.E.E21Expense.rfc.E21ExpenseRFC;
import hris.E.E22Expense.E22ExpenseListData;
import hris.E.E22Expense.rfc.E22ExpenseListRFC;
import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.RequestFunction;
import hris.common.rfc.AccountInfoRFC;
import hris.common.rfc.CurrencyCodeRFC;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Vector;

public class E21ExpenseBuildSV extends ApprovalBaseServlet {

    private String UPMU_TYPE ="06";   // 결재 업무타입(학자금/장학금)
    private String UPMU_NAME = "장학자금";

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

            String dest = "";

            String msgFLAG = "";
            String msgTEXT = "";

            String jobid = box.get("jobid", "first");
            String PERNR = getPERNR(box, user); //신청대상자 사번

            box.put("PERNR", PERNR);
            box.put("I_PERNR", PERNR);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            //[CSR ID:3383001] 해외 주재원 장학자금 로직 수정 start
            //phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR, "X");
          //[CSR ID:3383001] 해외 주재원 장학자금 로직 수정 end

            //[CSR ID:2840321] 사내부부 자녀 학자금 신청시 문구요청 시작
            E17CompanyCoupleRFC  cc_rfc           = new E17CompanyCoupleRFC();
            String      CompanyCoupleYN = cc_rfc.getData(PERNR);
            //[CSR ID:2840321] 사내부부 자녀 학자금 신청시 문구요청 끝

            if( jobid.equals("first") ) {       //제일처음 신청 화면에 들어온경우.

            	//결재라인, 결재 헤더 정보 조회
                getApprovalInfo(req, PERNR);

                req.setAttribute("PERNR" , PERNR );
                req.setAttribute("PersonData" , phonenumdata );

                // 장학자금 예외자 CHECK - FLAG 가 'X'는 예외자로 장학자금신청되도록 함. -2004.09.06
                E21ExpenceCheckRFC    except_rfc  = new E21ExpenceCheckRFC();
                String eflag = except_rfc.getExceptFLAG( PERNR, "" );

                // 2003.03.19 입사일이 근속 6개월 미만일 경우 신청이 되지 않도록 한다.
                if( user.companyCode.equals("C100") ) {
                    Vector E19Congra_vt = (new E19CongMoreRelaRFC()).getCongMoreRela(PERNR, DataUtil.getCurrentDate(),"");

                    E21ExpenseBreakRFC    chk_rfc  = new E21ExpenseBreakRFC();

                    String flag = chk_rfc.check(PERNR);

                    int work_year = 0;
                    int work_mnth = 0;

                    if( E19Congra_vt.size() > 0 ) {
                        E19CongcondData e19Data = (E19CongcondData)E19Congra_vt.get(0);
                        if( !e19Data.WORK_YEAR.equals("") && !e19Data.WORK_YEAR.equals("00") ) {
                            work_year = Integer.parseInt(e19Data.WORK_YEAR);
                        }
                        if( !e19Data.WORK_MNTH.equals("") && !e19Data.WORK_MNTH.equals("00") ) {
                            work_mnth = Integer.parseInt(e19Data.WORK_MNTH);
                        }

                        if( (work_year < 1) && (work_mnth < 6) && !eflag.equals("X")) {  // 6개월미만
                            //String msg = "근속 6개월 미만인 경우 신청 대상이 아닙니다.";
                            msgFLAG = "C";
                            msgTEXT = g.getMessage("MSG.E.E22.0019");// "근속 6개월 미만인 경우 신청 대상이 아닙니다.";
                        }
                    }

                    if( flag.equals("N") ){
                        //String msg = "휴직기간에는 장학자금을 신청할 수 없습니다. 담당자에게 문의 바랍니다.";
                        msgFLAG = "C";
                        msgTEXT = g.getMessage("MSG.E.E22.0020");//"휴직기간에는 장학자금을 신청할 수 없습니다. 담당자에게 문의 바랍니다.";
                    }
                }
                // 2003.03.19 입사일이 근속 6개월 미만일 경우 신청이 되지 않도록 한다.

                A04FamilyDetailRFC rfc = new A04FamilyDetailRFC();

                Vector A04FamilyDetailData_vt = null;
                Vector temp                   = new Vector();
                Vector E21ExpenseChkData_vt   = null;
                Vector data_vt                  = (new E22ExpenseListRFC()).getExpenseList( PERNR );

                Vector data1_vt                = (new E22ExpenseListRFC()).getExpenseList1( PERNR );
                Vector E22ExpenseListdata_vt = new Vector();

                E22ExpenseListData e22ExpenseListdata = new E22ExpenseListData();
                for( int j = 0 ; j < data_vt.size() ; j++ ) {
                	e22ExpenseListdata = (E22ExpenseListData)data_vt.get(j);
                	E22ExpenseListdata_vt.addElement(e22ExpenseListdata);
                }

                for( int j = 0 ; j < data1_vt.size() ; j++ ) {
                	e22ExpenseListdata = (E22ExpenseListData)data1_vt.get(j);
                	E22ExpenseListdata_vt.addElement(e22ExpenseListdata);
                }

                //Logger.debug.println(this,"====E22ExpenseListdata_vt 2222==="+ E22ExpenseListdata_vt.toString());

                A04FamilyDetailData_vt = rfc.getFamilyDetail(box);

                for( int i = 0 ; i < A04FamilyDetailData_vt.size() ; i++ ){
                    A04FamilyDetailData data = (A04FamilyDetailData)A04FamilyDetailData_vt.get(i);
                    if( data.SUBTY.equals("2") ){
                        temp.addElement(data);
                    }
                }

                A04FamilyDetailData_vt = temp;

                //수혜횟수 등 가져오기
                E21ExpenseChkData_vt = getCountTable(PERNR, A04FamilyDetailData_vt, data_vt, phonenumdata.E_OVERSEA);

                //Logger.debug.println(this,"====E21ExpenseChkData_vt==="+ E21ExpenseChkData_vt);

                if(A04FamilyDetailData_vt.size()==0){
                    //String msg = "학자금/장학금 신청 대상 자녀가 없습니다.";
                    msgFLAG = "C";
                    msgTEXT = g.getMessage("MSG.E.E22.0021");// "학자금/장학금 신청 대상 자녀가 없습니다.";
                }

                Vector currencyCodeList = new CurrencyCodeRFC().getCurrencyCode();

                req.setAttribute("eflag", eflag);
                req.setAttribute("msgFLAG", msgFLAG);
                req.setAttribute("msgTEXT", msgTEXT);
                req.setAttribute("currencyCodeList", currencyCodeList);
                req.setAttribute("A04FamilyDetailData_vt", A04FamilyDetailData_vt);
                req.setAttribute("E21ExpenseChkData_vt",   E21ExpenseChkData_vt);
                //req.setAttribute("E22ExpenseListData_vt",  data_vt);
                req.setAttribute("E22ExpenseListDataFull_vt",   E22ExpenseListdata_vt);
                req.setAttribute("CompanyCoupleYN"    , CompanyCoupleYN);	//[CSR ID:2840321] 사내부부 자녀 학자금 신청시 문구요청

                dest = WebUtil.JspURL+"E/E21Expense/E21ExpenseBuild.jsp";
            } else if( jobid.equals("create") ) {


            	/* 실제 신청 부분 */
                dest = requestApproval(req, box, E21ExpenseData.class, new RequestFunction<E21ExpenseData>() {
                    public String porcess(E21ExpenseData inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                    	 /**** 신청된금액이 입금될 계좌정보가 있는지 체크 ******************/
                        AccountInfoRFC accountInfoRFC = new AccountInfoRFC();

                        if(! accountInfoRFC.hasPersAccount(box.get("PERNR")) ) {
                        	throw new GeneralException(g.getMessage("MSG.COMMON.0006")); //throw new GeneralException("계좌번호가 등록되지 있지 않습니다.");
                       }
                        /**** 신청된금액이 입금될 계좌정보가 있는지 체크 ******************/

                        /* 결재 신청 RFC 호출 */
                    	E21ExpenseRFC e21Rfc = new E21ExpenseRFC();
                    	e21Rfc.setRequestInput(user.empNo, UPMU_TYPE);

                    	//inputData.PERNR  = box.get("PERNR");
                    	inputData.ZPERNR = user.empNo;     // 신청자 사번(대리신청, 본인 신청)
                    	inputData.UNAME  = user.empNo;     // 신청자 사번(대리신청, 본인 신청)
                    	inputData.AEDTM  = DataUtil.getCurrentDate();  // 변경일(현재날짜)

                    	if( inputData.WAERS.equals("KRW") ) {
                    		inputData.PROP_AMNT = Double.toString(Double.parseDouble(inputData.PROP_AMNT) / 100 ) ;  // 신청액
                        }

        				box.put("I_GTYPE", "2");  // insert

                        //String AINF_SEQN = e21Rfc.build(box.get("PERNR"), "", E21ExpenseData_vt);
                        String AINF_SEQN = e21Rfc.build(Utils.asVector(inputData), box, req);

                        if(!e21Rfc.getReturn().isSuccess()) {
                        	 throw new GeneralException(e21Rfc.getReturn().MSGTX);
                        }
                        return AINF_SEQN;

                        /* 개발자 작성 부분 끝 */
                    }
                });

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }
            //Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }

    }

    private Vector getCountTable(String empNo, Vector A04FamilyDetailData_vt, Vector data_vt, String e_oversea) throws GeneralException {
        Vector return_vt = new Vector();

        for( int i = 0 ; i < A04FamilyDetailData_vt.size(); i++ ) {
            A04FamilyDetailData ja_data = (A04FamilyDetailData)A04FamilyDetailData_vt.get(i);
            String subty = ja_data.SUBTY;
            String objps = ja_data.OBJPS;

            String gubn = "";
            String hak = "";

            if( ja_data.FASAR.equals("D1") ){  //중고생
                gubn = "2";
                hak = "중";
            } else if( ja_data.FASAR.equals("E1") ) {
                gubn = "2";
                hak = "고";
            } else if( ja_data.FASAR.equals("F1") || ja_data.FASAR.equals("G1")
                    || ja_data.FASAR.equals("G2") || ja_data.FASAR.equals("H1")) {  //대학생
                gubn = "3";
                hak = "대";
            }

            // 2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게
            if( e_oversea.equals("X") ) {
                if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ){  //유치원, 초등학생
                    gubn = "2";
                    hak = "중";   // 임시적처리
                }
            }
            // 2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게

            String count = "";
            String enter = "";

            for( int j = 0; j < data_vt.size(); j++ ) {
                E22ExpenseListData data = (E22ExpenseListData)data_vt.get(j);

                if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ) {   //유치원, 초등학생
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("B1") || data.ACAD_CARE.equals("C1")) ) {
                        if( !data.ENTR_FIAG.equals("X")&& !data.RFUN_FLAG.equals("X") ) {  //입학금이 아닌 경우 @v1.2추가 및 수혜횟수차감여부가 아닌 경우
                            count = data.P_COUNT;
                            break;
                        }
                    }
                } else if( ja_data.FASAR.equals("D1") ) {    //중학생
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            data.ACAD_CARE.equals("D1"  ) ) {
                        if( !data.ENTR_FIAG.equals("X")&& !data.RFUN_FLAG.equals("X") ) {  //입학금이 아닌 경우
                            count = data.P_COUNT;
                            break;
                        }
                    }
                } else if(  ja_data.FASAR.equals("E1") ) {    //고등학생
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            data.ACAD_CARE.equals("E1") ) {
                        if( !data.ENTR_FIAG.equals("X")&& !data.RFUN_FLAG.equals("X") ) {  //입학금이 아닌 경우
                            count = data.P_COUNT;
                            break;
                        }
                    }
                } else if( ja_data.FASAR.equals("F1") || ja_data.FASAR.equals("G1") ||
                        ja_data.FASAR.equals("G2") || ja_data.FASAR.equals("H1") ) {    //대학생
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("F1") || data.ACAD_CARE.equals("G1") || data.ACAD_CARE.equals("G2") || data.ACAD_CARE.equals("H1")) ) {
                        if( !data.ENTR_FIAG.equals("X")&& !data.RFUN_FLAG.equals("X") ) {  //입학금이 아닌 경우
                            count = data.P_COUNT;
                         //   Logger.debug.println(this, "------count = "+count + " [data] : "+data.toString());
                            break;
                        }
                    }
                }

                //Logger.debug.println(this, "[[[[[[[[count] = "+count + " [data] : "+data.toString());
            }

            for( int j = 0; j < data_vt.size(); j++ ) {
                E22ExpenseListData data = (E22ExpenseListData)data_vt.get(j);

                if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ) {    //유치원, 초등학생
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("B1") || data.ACAD_CARE.equals("C1")) ) {
                        if( data.ENTR_FIAG.equals("X") ) {  //입학금인 경우
                            enter = data.P_COUNT;
                            break;
                        }
                    }
                } else if( ja_data.FASAR.equals("D1") || ja_data.FASAR.equals("E1") ) {    //중학생, 고등학생
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                          (data.ACAD_CARE.equals(ja_data.FASAR)) ) {
                      //@v1.1 (data.ACAD_CARE.equals("D1") || data.ACAD_CARE.equals("E1")) ) {
                        if( data.ENTR_FIAG.equals("X") ) {  //입학금인 경우
                            enter = data.P_COUNT;
                         //   Logger.debug.println(this, "[count======] = "+count  );
                            break;
                        }
                    }
                } else if( ja_data.FASAR.equals("F1") || ja_data.FASAR.equals("G1") ||
                        ja_data.FASAR.equals("G2") || ja_data.FASAR.equals("H1") ) {    //대학생
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("F1") || data.ACAD_CARE.equals("G1") || data.ACAD_CARE.equals("G2") || data.ACAD_CARE.equals("H1")) ) {
                        if( data.ENTR_FIAG.equals("X") ) {  //입학금인 경우
                            enter = data.P_COUNT;
                            //[CSR ID:3660657] 학자금 수혜횟수 체크 로직 변경 요청의 건 start
                            // 수혜횟수는 입학금 (1회) 횟수 포함 장학금 수혜횟수를 넘겨줌. data_vt 리스트가 입학금 한건일 경우 수혜횟수 count 필드에 값을 안담아 주고 있기 때문에 수혜횟수 변수인 count에 값을 담아줌.
                            count = data.P_COUNT;
                            //[CSR ID:3660657] 학자금 수혜횟수 체크 로직 변경 요청의 건 end
                            break;
                        }
                    }
                }
            }

            E21ExpenseChkData ret_data = new E21ExpenseChkData();
            ret_data.subty     = subty;
            ret_data.objps     = objps;
            ret_data.grade     = hak;
            ret_data.subf_type = gubn;
            ret_data.count     = count;
            ret_data.enter     = enter;

            return_vt.addElement(ret_data);
        }

        return return_vt;
    }
}
