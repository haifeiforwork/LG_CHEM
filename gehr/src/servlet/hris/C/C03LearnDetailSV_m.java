/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �����̷�                                                    */
/*   Program Name : �����̷�                                                    */
/*   Program ID   : C03LearnDetailSV_m                                          */
/*   Description  : ����� ���� �̷� ������ ��ȸ�� �� �ֵ��� �ϴ� Class         */
/*   Note         : ����                                                        */
/*   Creation     : 2001-12-20  �Ѽ���                                          */
/*   Update       : 2005-01-07  ������                                          */
/*                     2017-10-16  ������  [CSR ID:3504688] Global Academy �����̷� I/F ���� ��û                       */
/********************************************************************************/


package servlet.hris.C ;

import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.util.WebUtil;

public class C03LearnDetailSV_m extends C03LearnDetailSV {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            WebUserData user = WebUtil.getSessionMSSUser(req);

            //@����༺ �߰�
            if(!checkAuthorization(req, res)) return;
            if(process(req, res, user))
            	printJspPage(req, res, WebUtil.JspURL + "C/C03LearnDetail_m.jsp");

        } catch (Exception e) {
            throw new GeneralException(e);
        }

    }
}
