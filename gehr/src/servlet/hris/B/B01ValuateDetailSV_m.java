/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �����                                                    */
/*   Program Name : �򰡻��� ��ȸ                                               */
/*   Program ID   : B01ValuateDetailSV_m                                        */
/*   Description  : ����� �� ������ ��ȸ�� �� �ֵ��� �ϴ� Class              */
/*   Note         : ����                                                        */
/*   Creation     : 2002-01-14  �Ѽ���                                          */
/*   Update       : 2005-01-11  ������                                          */
/*                     2014/11/25 [CSR ID:2651528] �λ���� �߰� �� �޴���ȸ ��� ����                                                        */
                        /*2015/02/10 ������D [CSR ID:2703351] ¡�� ���� �߰� ����*/
/********************************************************************************/

package servlet.hris.B ;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.util.WebUtil;
import hris.B.rfc.B01ValuateDetailCheckRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class B01ValuateDetailSV_m extends B01ValuateDetailSV {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        if(!checkAuthorization(req, res)) return;

        WebUserData user_m = WebUtil.getSessionMSSUser(req);
        WebUserData user = WebUtil.getSessionUser(req);

        if(user_m.area == Area.KR) {
            B01ValuateDetailCheckRFC checkRFC = new B01ValuateDetailCheckRFC();
            String checkYn = checkRFC.getValuateDetailCheck(user.empNo, user_m.empNo, "A01", "M");//CSR ID:2703351 ���� ��� A�� �����ڷ� ��.

/*      process �ȿ� */
            if (!"Y".equals(checkYn)) {
                //"�ش� ������ �����ϴ�."
                moveCautionPage(req, res, g.getMessage("MSG.COMMON.0060"), "");  //return page ? -> ���� �� jsp�� ���� ���ٴ� �޼��� ������
                return;
            }
        }

        if(process(req, res, user_m, "M")) {
            printJspPage(req, res, WebUtil.JspURL + "B/B01ValuateDetail_" + req.getAttribute("evalSuffix") + ".jsp");
        }
    }
}
