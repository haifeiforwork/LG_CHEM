/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : e-Learnig �α���                                            */
/*   2Depth Name  : e-Learnig �α���                                            */
/*   Program Name : e-Learnig �α���                                            */
/*   Program ID   : ELearningLoginSV                                            */
/*   Description  : e-Learnig ���� �α����ϴ� class                             */
/*   Note         :                                                             */
/*   Creation     :                                                             */
/*   Update       : 2005-03-21  ������                                          */
/*                :  2015-08-20 ������ [CSR ID:] ehr�ý�������༺���� ����                       */
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
            String msg = ""; //[CSR ID:] ehr�ý�������༺���� ����

            WebUserData user = new WebUserData();
            box.copyToEntity(user);

            Logger.debug.println(this, "######### e-learning TEST : " + user);

            //ó�� �� ���� �� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            String secretEmpNo = user.empNo;
            String originEmpNo = null;

            // ��ȣ�� Ǯ� ����������� ����� "" ���� ���ϵǸ� ��ȿ���� ���� ����̴�
            originEmpNo = calculateEmpNo(secretEmpNo);

            if( originEmpNo.equals("") ){
                //String msg = "��ȿ�� �����ȣ�� �ƴմϴ�.";
                msg = "���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
                String url = "history.back();";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                dest = WebUtil.JspURL +"common/msg.jsp";
            } else if( !user.e_learning.equals("Y") ) {
                //String msg = "�ùٸ� �α����� �ƴմϴ�.";
                msg = "���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
                String url = "history.back();";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                dest = WebUtil.JspURL +"common/msg.jsp";
            } else {
                // ����� ��ȣ����
                Logger.debug.println(this, "originEmpNo : " + originEmpNo);
                user.empNo = originEmpNo;

                PersonInfoRFC personInfoRFC      = new PersonInfoRFC();
                PersonData personData = null;

                try{
                    personData  = personInfoRFC.getPersonInfo(user.empNo, "X");

                }catch(Exception ex){
                    Logger.debug.println(this,"Data Not Found");
                    //String msg = "���� �� ������ �߻��Ͽ����ϴ�.";
                    msg = "���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    dest = WebUtil.JspURL +"common/msg.jsp";
                }

                if( personData==null || personData.E_BUKRS==null || personData.E_BUKRS.equals("") ) {

                    //String msg = "�����ȣ�� Ȯ���Ͽ� �ֽʽÿ�.";
                    msg = "���� �� ������ �߻��Ͽ����ϴ�."; //[CSR ID:] ehr�ý�������༺���� ����
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

    // ��ȣȭ�� ����� �Ķ���ͷ� �޾Ƽ� ��������� �����Ѵ�. ""�� �����ϸ� ��ȿ���� ���� ����̴�
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
            // ���ڸ� �������� üũ
            // ÷���ڿ� �߰�, ������ ���ڸ� �и��Ѵ�.
            firstDigit  = secretEmpNo.substring( 0, 1 );
            centerDigit = secretEmpNo.substring( 1, (secretEmpNo.length() - 1) );
            lastDigit   = secretEmpNo.substring( (secretEmpNo.length() - 1), secretEmpNo.length() );
            //Logger.debug.println(this, "2 !!! lastDigit : " + lastDigit);
            //Logger.debug.println(this, "2 !!! getLastCharAfterSum(centerDigit) : " + getLastCharAfterSum(centerDigit));

            // ��� ���ڵ��� ���� 1�ڸ����� ������ ���ڶ� ������ Ȯ���Ѵ�
            if( ! lastDigit.equals( getLastCharAfterSum(centerDigit) ) ){
                return "";
            }
            //Logger.debug.println(this, "3 !!!d_centerDigit ������ �� : " + centerDigit);
            // ��� ���� ������ ���� ������. �̶� ������ ���������� Ȯ��...
            d_centerDigit = Long.parseLong(centerDigit);
            long modDigit = d_centerDigit % 33333;
            if( modDigit != 0) {
                return "";
            }
            d_centerDigit = d_centerDigit / 33333 ;
            centerDigit   = Long.toString(d_centerDigit);     // 33333���� ���������� �������
            //Logger.debug.println(this, "4 !!!33333���� ���������� �������centerDigit : " +centerDigit );

            // ���� �ٽ� ÷���ڿ� ������ ���ڷ� �и��ϰ�... ������ Ÿ������ �Ľ��Ѵ�.
            in_firstDigit  = centerDigit.substring( 0, 1 );
            in_centerDigit = centerDigit.substring( 1, (centerDigit.length() - 1) );
            in_lastDigit   = centerDigit.substring( (centerDigit.length() - 1), centerDigit.length() );
            //Logger.debug.println(this, "5 !!!firstDigit : " + firstDigit);
            //Logger.debug.println(this, "5 !!!in_firstDigit : " + in_firstDigit);

            // ���� ÷���ڰ� ��ȣȭ�� ���� ������ ÷���ڿ� ������ Ȯ���Ѵ�
            if( ! firstDigit.equals( in_firstDigit ) ){
                return "";
            }
            //Logger.debug.println(this, "6 !!!in_lastDigit : " + in_lastDigit);
            //Logger.debug.println(this, "6 !!! getLastCharAfterSum(in_centerDigit) ) : " +  getLastCharAfterSum(in_centerDigit) );
            // ��� ���ڵ��� ���� 1�ڸ����� ������ ���� ������ ��� ���� ����������� Ȯ���Ѵ�
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
    // ���ڷ� ������ String�� �޾Ƽ� �� ���� 1�ڸ����� String Object�� �����Ѵ�
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
