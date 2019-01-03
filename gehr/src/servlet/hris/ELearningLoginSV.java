/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : e-Learnig 로그인                                            */
/*   2Depth Name  : e-Learnig 로그인                                            */
/*   Program Name : e-Learnig 로그인                                            */
/*   Program ID   : ELearningLoginSV                                            */
/*   Description  : e-Learnig 에서 로그인하는 class                             */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-03-21  윤정현                                          */
/*                :  2015-08-20 이지은 [CSR ID:] ehr시스템웹취약성진단 수정                       */
/********************************************************************************/

package servlet.hris;

import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ELearningLoginSV extends EHRBaseServlet {

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            performTask(req, res);
        }catch(GeneralException e){
            throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            HttpSession session = req.getSession(false);
            if (session != null){ session.invalidate(); }

            String dest = "";
            Box    box  = WebUtil.getBox(req);
            String msg = ""; //[CSR ID:] ehr시스템웹취약성진단 수정

            WebUserData user = new WebUserData();
            box.copyToEntity(user);

            Logger.debug.println(this, "######### e-learning TEST : " + user);

            //처리 수 돌아 갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            String secretEmpNo = user.empNo;
            String originEmpNo = null;

            // 암호를 풀어서 원래사번으로 만들기 "" 값이 리턴되면 유효하지 않은 사번이다
            originEmpNo = calculateEmpNo(secretEmpNo);

            if( originEmpNo.equals("") ){
                //String msg = "유효한 사원번호가 아닙니다.";
                msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                String url = "history.back();";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                dest = WebUtil.JspURL +"common/msg.jsp";
            } else if( !user.e_learning.equals("Y") ) {
                //String msg = "올바른 로그인이 아닙니다.";
                msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                String url = "history.back();";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                dest = WebUtil.JspURL +"common/msg.jsp";
            } else {
                // 사번의 암호해제
                Logger.debug.println(this, "originEmpNo : " + originEmpNo);
                user.empNo = originEmpNo;

                PersonInfoRFC personInfoRFC      = new PersonInfoRFC();
                PersonData personData = null;

                try{
                    personData  = personInfoRFC.getPersonInfo(user.empNo, "X");

                }catch(Exception ex){
                    Logger.debug.println(this,"Data Not Found");
                    //String msg = "접속 중 오류가 발생하였습니다.";
                    msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL +"common/msg.jsp";
                }

                if( personData==null || personData.E_BUKRS==null || personData.E_BUKRS.equals("") ) {

                    //String msg = "사원번호를 확인하여 주십시요.";
                    msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL +"common/msg.jsp";

                } else {
                    user.login_stat       = "Y";
                    user.companyCode      = personData.E_BUKRS ;

                    Config conf           = new Configuration();
                    user.clientNo         = conf.get("com.sns.jdf.sap.SAP_CLIENT");

                    personInfoRFC.setSessionUserData(personData, user);
                    WebUtil.setLang(WebUtil.getLangFromCookie(req), req, user);
                    Logger.debug.println(this ,personData);

                    DataUtil.fixNull(user);
                    session = req.getSession(true);

                    int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
                    session.setMaxInactiveInterval(maxSessionTime);
                    session.setAttribute("user",user);

                    Logger.debug.println(this, "ok login.. user : "+user.toString() );
                    dest = WebUtil.JspURL+"C/C02Curri/C02CurriNoticeWait.jsp";
                }
            }
            printJspPage(req, res, dest);

        }catch(Exception e){
            throw new GeneralException(e);
        }
    }

    // 암호화된 사번을 파라미터로 받아서 원래사번을 리턴한다. ""을 리턴하면 유효하지 않은 사번이다
    private String calculateEmpNo(String secretEmpNo){
        try{
            String  originEmpNo     = "";
            String  firstDigit      = null;
            String  centerDigit     = null;
            String  lastDigit       = null;
            String  in_firstDigit   = null;
            String  in_centerDigit  = null;
            String  in_lastDigit    = null;
            long    d_centerDigit   = 0;
            //Logger.debug.println(this, "1 !!!secretEmpNo : " + secretEmpNo);
            // 숫자만 들어오는지 체크
            // 첨숫자와 중간, 마지막 숫자를 분리한다.
            firstDigit  = secretEmpNo.substring( 0, 1 );
            centerDigit = secretEmpNo.substring( 1, (secretEmpNo.length() - 1) );
            lastDigit   = secretEmpNo.substring( (secretEmpNo.length() - 1), secretEmpNo.length() );
            //Logger.debug.println(this, "2 !!! lastDigit : " + lastDigit);
            //Logger.debug.println(this, "2 !!! getLastCharAfterSum(centerDigit) : " + getLastCharAfterSum(centerDigit));

            // 가운데 숫자들의 합의 1자리수가 마지막 숫자랑 같은지 확인한다
            if( ! lastDigit.equals( getLastCharAfterSum(centerDigit) ) ){
                return "";
            }
            //Logger.debug.println(this, "3 !!!d_centerDigit 나뉘기 전 : " + centerDigit);
            // 가운데 수를 정해진 수로 나눈다. 이때 나누어 떨어지는지 확인...
            d_centerDigit = Long.parseLong(centerDigit);
            long modDigit = d_centerDigit % 33333;
            if( modDigit != 0) {
                return "";
            }
            d_centerDigit = d_centerDigit / 33333 ;
            centerDigit   = Long.toString(d_centerDigit);     // 33333으로 나눠진후의 가운데숫자
            //Logger.debug.println(this, "4 !!!33333으로 나눠진후의 가운데숫자centerDigit : " +centerDigit );

            // 몫을 다시 첨숫자와 마지막 숫자로 분리하고... 데이터 타입으로 파싱한다.
            in_firstDigit  = centerDigit.substring( 0, 1 );
            in_centerDigit = centerDigit.substring( 1, (centerDigit.length() - 1) );
            in_lastDigit   = centerDigit.substring( (centerDigit.length() - 1), centerDigit.length() );
            //Logger.debug.println(this, "5 !!!firstDigit : " + firstDigit);
            //Logger.debug.println(this, "5 !!!in_firstDigit : " + in_firstDigit);

            // 몫의 첨숫자가 암호화된 이전 숫자의 첨숫자와 같은지 확인한다
            if( ! firstDigit.equals( in_firstDigit ) ){
                return "";
            }
            //Logger.debug.println(this, "6 !!!in_lastDigit : " + in_lastDigit);
            //Logger.debug.println(this, "6 !!! getLastCharAfterSum(in_centerDigit) ) : " +  getLastCharAfterSum(in_centerDigit) );
            // 가운데 숫자들의 합의 1자리수가 마지막 수랑 같으면 가운데 수를 원래사번으로 확정한다
            if( ! in_lastDigit.equals( getLastCharAfterSum(in_centerDigit) ) ){
                return "";
            } else {
                originEmpNo = in_centerDigit;
            }
            //Logger.debug.println(this, "7 !!!originEmpNo : " + originEmpNo);

            return originEmpNo;

        }catch(Exception ex){
            return "";
        }
    }
    // 숫자로 구성된 String을 받아서 그 합의 1자리수를 String Object로 리턴한다
    private String getLastCharAfterSum(String centerDigit){

        String digit = centerDigit;
        int    sum   = 0 ;
        for(int i = 0 ; i < digit.length() ; i++ ){
            sum = sum + Integer.parseInt( digit.substring( i, i+1 ) );
        }
        String hap = Integer.toString(sum);
        return hap.substring( (hap.length()-1), hap.length() );
    }
}
