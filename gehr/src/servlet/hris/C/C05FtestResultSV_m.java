/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ���дɷ�                                                    */
/*   Program Name : ���дɷ� ��ȸ                                               */
/*   Program ID   : C05FtestResultSV_m                                          */
/*   Description  : ������ ���дɷ� ������ jsp�� �Ѱ��ִ� class                 */
/*   Note         : ����                                                        */
/*   Creation     : 2002-01-14  �赵��                                          */
/*   Update       : 2005-01-07  ������                                          */
/*                  2006-01-06  lsa @v1.1  teps�߰�                             */
/*                  2013/12/18 C20131202_46202  0010:TOEIC Speaking,0011:OPIc,0012:JLPT  */
/*                  2016/02/11 [CSR ID:2981372] SAP/ERP �� G Portal(e-HR) ���м��� �߰� ��û�� �� */
/*                                                                              */
/********************************************************************************/


package servlet.hris.C;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.util.WebUtil;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class C05FtestResultSV_m extends C05FtestResultSV {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        WebUserData user_m = WebUtil.getSessionMSSUser(req);

        if(process(req, res, user_m, "M"))
            printJspPage(req, res, WebUtil.JspURL+"C/C05FtestResult_" + (user_m.area == Area.KR ? "KR" : "GLOBAL") + ".jsp");


    }
}
