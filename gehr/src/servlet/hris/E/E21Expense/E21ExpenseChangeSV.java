/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 장학자금                                                    */
/*   Program Name : 장학자금 수정                                               */
/*   Program ID   : E21ExpenseChangeSV                                          */
/*   Description  : 학자금/장학금 수정할 수 있도록 하는 Class                   */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  김성일                                          */
/*   Update       : 2005-03-07  윤정현                                          */
/*                  2006-02-03  @v1.1 lsa 학자금신청오류(중,고등학교입학금을 합쳐서처리하여 따로 따로 처리) */
/*                  2015-07-31  이지은D [CSR ID:2840321] 사내부부 자녀 학자금 신청시 문구요청*/
/*                  2017-05-22  eunha [CSR ID:3383001] 해외 주재원 장학자금 로직 수정*/
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
import hris.E.E21Expense.rfc.E21ExpenseRFC;
import hris.E.E22Expense.E22ExpenseListData;
import hris.E.E22Expense.rfc.E22ExpenseListRFC;
import hris.common.*;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ChangeFunction;
import hris.common.rfc.CurrencyCodeRFC;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

public class E21ExpenseChangeSV extends ApprovalBaseServlet {

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
        	HttpSession session = req.getSession(false);
        	final WebUserData user = WebUtil.getSessionUser(req);
			final Box box = WebUtil.getBox(req);

			String dest = "";
			String jobid = box.get("jobid", "first");
			String PERNR = box.get("PERNR", user.empNo);//getPERNR(box, user); //신청대상자 사번

			String I_APGUB = (String) req.getAttribute("I_APGUB");  //어느 페이지에서 왔나? '1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서
			String AINF_SEQN = box.get("AINF_SEQN");

			String msgFLAG = "";
            String msgTEXT = "";

			E21ExpenseRFC e21Rfc = new E21ExpenseRFC();
			e21Rfc.setDetailInput(user.empNo, I_APGUB, AINF_SEQN); // set DetailInput

            E21ExpenseData firstData = new E21ExpenseData();
            Vector E21ExpenseData_vt = new Vector();

            E21ExpenseData_vt = e21Rfc.detail(AINF_SEQN, "");
            Logger.debug.println(this, "장학자금 조회  : " + E21ExpenseData_vt);

            firstData = (E21ExpenseData)E21ExpenseData_vt.get(0);

            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            //[CSR ID:3383001] 해외 주재원 장학자금 로직 수정 start
           // phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR);
            phonenumdata = (PersonData)numfunc.getPersonInfo(firstData.PERNR, "X");
          //[CSR ID:3383001] 해외 주재원 장학자금 로직 수정 end
            req.setAttribute("PersonData" , phonenumdata );


            if( jobid.equals("first") ) {     //제일처음 신청 화면에 들어온경우.

            	//[CSR ID:2840321] 사내부부 자녀 학자금 신청시 문구요청 시작
                E17CompanyCoupleRFC  cc_rfc           = new E17CompanyCoupleRFC();
                String      CompanyCoupleYN = cc_rfc.getData(firstData.PERNR);
                //[CSR ID:2840321] 사내부부 자녀 학자금 신청시 문구요청 끝

            	E21ExpenseData e21ExpenseData = new E21ExpenseData();

                // 2003.03.19 입사일이 근속 6개월 미만일 경우 신청이 되지 않도록 한다.
                if( user.companyCode.equals("C100") ) {
                    Vector E19Congra_vt = (new E19CongMoreRelaRFC()).getCongMoreRela(firstData.PERNR, DataUtil.getCurrentDate(),"");
                    int    work_year    = 0;
                    int    work_mnth    = 0;

                    if( E19Congra_vt.size() > 0 ) {
                        E19CongcondData e19Data = (E19CongcondData)E19Congra_vt.get(0);
                        if( !e19Data.WORK_YEAR.equals("") && !e19Data.WORK_YEAR.equals("00") ) {
                            work_year = Integer.parseInt(e19Data.WORK_YEAR);
                        }
                        if( !e19Data.WORK_MNTH.equals("") && !e19Data.WORK_MNTH.equals("00") ) {
                            work_mnth = Integer.parseInt(e19Data.WORK_MNTH);
                        }

                        if( (work_year < 1) && (work_mnth < 6) ) {   // 6개월미만
                            //String msg = "근속 6개월 미만인 경우 신청 대상이 아닙니다.";
                            msgFLAG = "C";
                            msgTEXT = "근속 6개월 미만인 경우 신청 대상이 아닙니다.";
                        }
                    }
                }
                // 2003.03.19 입사일이 근속 6개월 미만일 경우 신청이 되지 않도록 한다.

                A04FamilyDetailRFC A_rfc          = new A04FamilyDetailRFC();

                Vector E21ExpenseChkData_vt   = null;
                Vector data_vt                = (new E22ExpenseListRFC()).getExpenseList( firstData.PERNR );
                Vector data1_vt                = (new E22ExpenseListRFC()).getExpenseList1( firstData.PERNR );
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

                Vector A04FamilyDetailData_vt = null;
                Vector temp                   = new Vector();
                box.put("I_PERNR", firstData.PERNR);
                A04FamilyDetailData_vt = A_rfc.getFamilyDetail(box);
                for( int i = 0 ; i < A04FamilyDetailData_vt.size() ; i++ ){
                    A04FamilyDetailData data = (A04FamilyDetailData)A04FamilyDetailData_vt.get(i);
                    if( data.SUBTY.equals("2") ){
                        temp.addElement(data);
                    }
                }
                A04FamilyDetailData_vt = temp;
                Logger.debug.println(this,A04FamilyDetailData_vt.toString());

                //수혜횟수 등 가져오기
                E21ExpenseChkData_vt = getCountTable(firstData.PERNR, A04FamilyDetailData_vt, data_vt, phonenumdata.E_OVERSEA);
                Logger.debug.println(this,E21ExpenseChkData_vt.toString());

                if( E21ExpenseData_vt.size() < 1 ){
                    //String msg = "System Error! \n\n 신청된 항목이 없습니다.";
                    msgFLAG = "C";
                    msgTEXT = "System Error! 신청된 항목이 없습니다.";
                }else if(A04FamilyDetailData_vt.size() < 0){
                    //String msg = "학자금/장학금 신청 대상 자녀가 없습니다.";
                    msgFLAG = "C";
                    msgTEXT = "학자금/장학금 신청 대상 자녀가 없습니다.";
                }

                e21ExpenseData = (E21ExpenseData)E21ExpenseData_vt.get(0);
                Vector currencyCodeList = new CurrencyCodeRFC().getCurrencyCode();

                req.setAttribute("isUpdate", true); //등록 수정 여부
                req.setAttribute("msgFLAG", msgFLAG);
                req.setAttribute("msgTEXT", msgTEXT);
                req.setAttribute("e21ExpenseData" ,         e21ExpenseData);
                req.setAttribute("currencyCodeList", currencyCodeList);
                req.setAttribute("resultData" ,         e21ExpenseData);
                req.setAttribute("A04FamilyDetailData_vt",  A04FamilyDetailData_vt);
                req.setAttribute("E21ExpenseChkData_vt",    E21ExpenseChkData_vt);
                req.setAttribute("E22ExpenseListData_vt",   data_vt);
                req.setAttribute("E22ExpenseListDataFull_vt",   E22ExpenseListdata_vt);
                req.setAttribute("CompanyCoupleYN"    , CompanyCoupleYN);	//[CSR ID:2840321] 사내부부 자녀 학자금 신청시 문구요청

                req.setAttribute("subty",      box.get("subty"));//수정에서 첵크
                req.setAttribute("objps",      box.get("objps"));//수정에서 첵크
                req.setAttribute("subf_type",  box.get("subf_type"));//수정에서 첵크

                detailApporval(req, res, e21Rfc);

                printJspPage(req, res, WebUtil.JspURL + "E/E21Expense/E21ExpenseChange.jsp");

            } else if( jobid.equals("change") ) {

            	/* 실제 신청 부분 */
				dest = changeApproval(req, box, E21ExpenseData.class, e21Rfc, new ChangeFunction<E21ExpenseData>(){

					public String porcess(E21ExpenseData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLine) throws GeneralException {

        				inputData.PERNR  = inputData.PERNR;
        				inputData.ZPERNR = inputData.ZPERNR;    // 신청자 사번(대리신청, 본인 신청)
        				inputData.UNAME  = user.empNo;          // 수정자 사번(대리신청, 본인 신청)
    	                inputData.AEDTM  = DataUtil.getCurrentDate();  // 변경일(현재날짜)

    	                if( inputData.WAERS.equals("KRW") ) {
                    		inputData.PROP_AMNT = Double.toString(Double.parseDouble(inputData.PROP_AMNT) / 100 ) ;  // 신청액
                        }

                    	box.put("I_GTYPE", "3");

                    	/* 결재 신청 RFC 호출 */
                    	E21ExpenseRFC changeRFC = new E21ExpenseRFC();
                		changeRFC.setChangeInput(user.empNo, UPMU_TYPE, approvalHeader.AINF_SEQN);

                        changeRFC.build(Utils.asVector(inputData), box, req);
                        //e21Rfc.change( AINF_SEQN, firstData.PERNR, e21ExpenseData );

                    	 //Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn().isSuccess() );
                         //Logger.debug.println(this, "====changeRFC.getReturn().isSuccess()======== : " +  changeRFC.getReturn() );

                        if(!changeRFC.getReturn().isSuccess()) {
                        	 throw new GeneralException(changeRFC.getReturn().MSGTX);
                        }
                        return inputData.AINF_SEQN;

                        /* 개발자 작성 부분 끝 */
                    }
                });

				 printJspPage(req, res, dest);

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            //printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }

    //수혜횟수 등 가져오기
    private Vector getCountTable(String empNo, Vector A04FamilyDetailData_vt, Vector data_vt, String e_oversea) throws GeneralException {
        Vector return_vt = new Vector();

        for( int i = 0 ; i < A04FamilyDetailData_vt.size(); i++ ) {
            A04FamilyDetailData ja_data = (A04FamilyDetailData)A04FamilyDetailData_vt.get(i);
            String subty = ja_data.SUBTY;
            String objps = ja_data.OBJPS;

            String gubn = "";
            String hak = "";

            if( ja_data.FASAR.equals("D1") ){ //중고생
                gubn = "2";
                hak = "중";
            } else if( ja_data.FASAR.equals("E1") ) {
                gubn = "2";
                hak = "고";
            } else if( ja_data.FASAR.equals("F1") || ja_data.FASAR.equals("G1")
                    || ja_data.FASAR.equals("G2") || ja_data.FASAR.equals("H1")) { //대학생
                gubn = "3";
                hak = "대";
            }

            //          2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게
            if( e_oversea.equals("X") ) {
                if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ){ //유치원, 초등학생
                    gubn = "2";
                    hak = "중";       // 임시적처리
                }
            }
            //          2002.07.27. 해외근무자일 경우 유치원, 초등학생도 학자금 신청 가능하게

            String count = "";
            String enter = "";

            for( int j = 0; j < data_vt.size(); j++ ) {
                E22ExpenseListData data = (E22ExpenseListData)data_vt.get(j);

                if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ) {            //유치원, 초등학생
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("B1") || data.ACAD_CARE.equals("C1")) ) {
                        if( !data.ENTR_FIAG.equals("X")&& !data.RFUN_FLAG.equals("X") ) {  //입학금이 아닌 경우 @v1.2추가 및 수혜횟수차감여부가 아닌 경우
                            count = data.P_COUNT;
                            break;
                        }
                    }
                    /*
                } else if( ja_data.FASAR.equals("D1") || ja_data.FASAR.equals("E1") ) {    //중학생, 고등학생
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("D1") || data.ACAD_CARE.equals("E1")) ) {
                        if( !data.ENTR_FIAG.equals("X")&& !data.RFUN_FLAG.equals("X") ) {  //입학금이 아닌 경우
                            count = data.P_COUNT;
                            break;
                        }
                    }*/
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
                            break;
                        }
                    }
                }
            }

            for( int j = 0; j < data_vt.size(); j++ ) {
                E22ExpenseListData data = (E22ExpenseListData)data_vt.get(j);

                if( ja_data.FASAR.equals("B1") || ja_data.FASAR.equals("C1") ) {            //유치원, 초등학생
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
                      //@v1.1      (data.ACAD_CARE.equals("D1") || data.ACAD_CARE.equals("E1")) ) {
                        if( data.ENTR_FIAG.equals("X") ) {  //입학금인 경우
                            enter = data.P_COUNT;
                            break;
                        }
                    }
                } else if( ja_data.FASAR.equals("F1") || ja_data.FASAR.equals("G1") ||
                        ja_data.FASAR.equals("G2") || ja_data.FASAR.equals("H1") ) {    //대학생
                    if( subty.equals(data.FAMSA) && objps.equals(data.OBJC_CODE) && gubn.equals(data.SUBF_TYPE) &&
                            (data.ACAD_CARE.equals("F1") || data.ACAD_CARE.equals("G1") || data.ACAD_CARE.equals("G2") || data.ACAD_CARE.equals("H1")) ) {
                        if( data.ENTR_FIAG.equals("X") ) {  //입학금인 경우
                            enter = data.P_COUNT;
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
