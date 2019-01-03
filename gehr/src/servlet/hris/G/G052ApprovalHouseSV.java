/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : HR 결재함                                                   */
/*   2Depth Name  : 주택자금 신규신청 결재                                      */
/*   Program Name : 주택자금 신규신청 결재                                      */
/*   Program ID   : G052ApprovalHouseSV                                         */
/*   Description  : 주택자금 신규신청 결재할 수 있도록 하는 Class               */
/*   Note         :                                                             */
/*   Creation     : 2005-03-09  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.G;

import hris.E.E05House.*;
import hris.E.E05House.rfc.*;

import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalHeader;
import hris.common.approval.ApprovalLineData;
import hris.common.approval.ApprovalBaseServlet.ApprovalFunction;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class G052ApprovalHouseSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "12";     // 결재 업무타입(주택 자금 )
    private String UPMU_NAME = "주택자금";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException    {
        try{
        	HttpSession session = req.getSession(false);

            final WebUserData user = WebUtil.getSessionUser(req);
            final Box box = WebUtil.getBox(req);

            String dest	= "";

            String jobid	= box.get("jobid");
			String AINF_SEQN  = box.get("AINF_SEQN");

         	final E05HouseData e05HouseData;
            Vector       vc05HouseData;
            E05HouseRFC       e05Rfc   = new E05HouseRFC();

            e05Rfc.setDetailInput(user.empNo, "1", AINF_SEQN);
            vc05HouseData = e05Rfc.detail(AINF_SEQN);
            e05HouseData = (E05HouseData)vc05HouseData.get(0);

            //Logger.debug.println(this, " vc05HouseData=["+vc05HouseData);

            /* 승인 시 */
            if("A".equals(jobid)) {

            	dest = accept(req, box, "T_ZHRA014T", e05HouseData, e05Rfc, new ApprovalFunction<E05HouseData>() {
                    public boolean porcess(E05HouseData inputData, ApprovalHeader approvalHeader, Vector<ApprovalLineData> approvalLineDatas) throws GeneralException {

                    	//Logger.debug.println(this, "#####  approvalHeader.isEditManagerArea()   ===" + approvalHeader.isEditManagerArea() );

                        /* 개발자 영역 시작 */

                    	box.copyToEntity(inputData);  //사용자가 입력한 데이타로 업데이트


                    	inputData.TILBG = box.get("REFN_BEGDA");
                    	inputData.DLEND = box.get("REFN_ENDDA");
                        inputData.UNAME     =  user.empNo;
                        inputData.AEDTM     =  DataUtil.getCurrentDate();

                        //Logger.debug.println(this, "#####  2222222222222	inputData**===" + inputData );

                        return true;
                    }
                });

            	/* 반려시 */
            } else if("R".equals(jobid)) {

            	dest = reject(req, box, null, e05HouseData, e05Rfc, null);

            } else if("C".equals(jobid)) {

            	dest = cancel(req, box, null, e05HouseData, e05Rfc, null);
            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            } // end if

            //Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            //Logger.err.println(DataUtil.getStackTrace(e));
            throw new GeneralException(e);
        }

    }

    //[C20110808_41085] 기대출건 상환완료없이 추가신청이 가능해짐에 따라 담당자결재시 금액변경시 한도체크 로직 추가를 위하여
    private Vector getMaxMoney(E05PersInfoData pers, String companyCode, String persk ) throws GeneralException {
        try {
            E05LoanMoneyRFC function  = new E05LoanMoneyRFC();
            Vector          ret       = new Vector();
            E05MaxMoneyData data = null;

            Vector E05LoanMoneyData_vt = function.getLoanMoney(persk);//persk(시간선택제 인원을 위한 조건 추가)
            E05LoanMoneyData money = (E05LoanMoneyData)E05LoanMoneyData_vt.get(0);

            String loanCode   = money.LOAN_CODE;
            int    years      = Integer.parseInt(pers.E_YEARS);
            double loan_money = 0;

            for( int i = 0; i < E05LoanMoneyData_vt.size(); i++) {
                money = (E05LoanMoneyData)E05LoanMoneyData_vt.get(i);
                if( !companyCode.equals(money.BUKRS) ) {
                    E05LoanMoneyData_vt.remove(i);
                    i--;
                }
            }

            for( int i = 0; i < E05LoanMoneyData_vt.size(); i++) {
                money = (E05LoanMoneyData)E05LoanMoneyData_vt.get(i);
                if( loanCode.equals(money.LOAN_CODE) ) {
                    if( years >= Integer.parseInt(money.MIN_YEAR) ) {
                        loan_money = Double.parseDouble(money.LOAN_MONY);
                    }
                } else {
                    data = new E05MaxMoneyData();
                    data.LOAN_CODE = loanCode;
                    data.LOAN_MONY = Double.toString(loan_money);
                    ret.addElement(data);

                    loanCode = money.LOAN_CODE;
                    loan_money = 0;
                    i--;
                }
            }

            data = new E05MaxMoneyData();
            data.LOAN_CODE = loanCode;
            data.LOAN_MONY = Double.toString(loan_money);
            ret.addElement(data);

            Logger.debug.println(this, "max money : " +  ret.toString() );
            return ret;

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
