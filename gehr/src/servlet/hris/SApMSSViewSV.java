/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 관리자 로그인                                                */
/*   Program Name : 관리자 로그인                                     */
/*   Program ID   : AdminLoginSV.java                                    */
/*   Description  : 관리자 로그인                           */
/*   Note         :                                                             */
/*   Creation     :                                   */
/*   Update       :  [CSR ID:2574807] SAP 암호화 로직변경에 따른 E-hr WEB 수정                       */
/*                :  2015-08-20 이지은 [CSR ID:] ehr시스템웹취약성진단 수정                       */
/********************************************************************************/

package servlet.hris;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.PersonalCardInterfaceData;
import hris.A.rfc.A01PersonalCardInterfaceRFC;
import org.apache.commons.lang.StringUtils;
import servlet.hris.N.mssperson.A01SelfDetailNeoSV_m;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * SAP 에서 인사기록부 조회 사용
 * URL : servlet.hris.SApMSSViewSV?lang=국가키(ko,en,zh)&sysid=(0:국내 or 1:해외 )&I_ECRKEY=암호화키
 * -  0  : 국내 ERP (e-HR 관련)
 -  1  : 해외 ERP (e-HR  관련)
 -  2  : 지사 HR
 */
public class SApMSSViewSV extends ExternalViewSV {

    public final static String SAP_INTERFACE = "SAP_INTERFACE";

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            performTask(req, res);
        }catch(GeneralException e){
           throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        //Connection conn = null;
        try{

            Box box = WebUtil.getBox(req);


            String I_ECRKEY = req.getParameter("I_ECRKEY");

            String sysid = req.getParameter("sysid");

            SAPType sapType = SAPType.LOCAL;
            if ("0".equals(sysid)) sapType = SAPType.LOCAL;
            else if ("1".equals(sysid)) sapType = SAPType.GLOBAL;

            A01PersonalCardInterfaceRFC personalCardInterfaceRFC = new A01PersonalCardInterfaceRFC(sapType);
            PersonalCardInterfaceData interfaceData = personalCardInterfaceRFC.getPersonalCardInterfaceData(I_ECRKEY);

            String pernr = interfaceData.getMain().getLOGPER();

            if(!personalCardInterfaceRFC.getReturn().isSuccess() || StringUtils.isBlank(pernr)) {
                req.setAttribute("msg2", personalCardInterfaceRFC.getReturn().MSGTX);
                moveMsgPage(req, res, "msg004", "top.close();");
                return;
            }

            req.getSession().setAttribute("SYSTEM_ID", pernr);

            /* 로그인 처리 */
            process(req, res, true);

            req.getSession().setAttribute(SAP_INTERFACE, interfaceData);  /* 세션에 데이타를 담자 - RFC 에 데이타는 1회만 조회 되는 이유로 */

            Logger.debug("viewEmpno : " + box.get("viewEmpno"));

            /* 대상자의 첫번째 사번을 가져온다 */
            String viewEmpno = interfaceData.getFirstPersonData().getPERNR();

            /* 대상자의 MSS 세션 생성 */
            A01SelfDetailNeoSV_m a01SelfDetailNeoSV_m = new A01SelfDetailNeoSV_m();
            a01SelfDetailNeoSV_m.setUserSession(viewEmpno, req);

            String dest = WebUtil.JspURL + "common/printFrame_insa.jsp";

            redirect(res, dest);
            //printJspPage(req, res, dest);

        }catch(Exception e){
            throw new GeneralException(e);
        }// end try
    }

}