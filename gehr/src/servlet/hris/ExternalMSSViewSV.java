/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ������ �α���                                                */
/*   Program Name : ������ �α���                                     */
/*   Program ID   : AdminLoginSV.java                                    */
/*   Description  : ������ �α���                           */
/*   Note         :                                                             */
/*   Creation     :                                   */
/*   Update       :  [CSR ID:2574807] SAP ��ȣȭ �������濡 ���� E-hr WEB ����                       */
/*                :  2015-08-20 ������ [CSR ID:] ehr�ý�������༺���� ����                       */
/********************************************************************************/

package servlet.hris;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.N.AES.AESgenerUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * �����λ����� ��ȸ���� MSS ȭ�� ȣ�� �� ���
 * URL : servlet.hris.ExternalMSSViewSV?lang=����Ű(ko,en,zh)empNo=�α��λ��&empNoKey=�α��λ����ȣȭŰ
 *      �����λ����� ��ȸ�� &viewEmpno=����ڻ��&viewEmpnoKey=����ڻ����ȣȭŰ
 *      ��Ÿ ��ȸ�� &redirectURLType
 *
 */
public class ExternalMSSViewSV extends ExternalViewSV {

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

            process(req, res, false);

            Logger.debug("viewEmpno : " + box.get("viewEmpno"));
            String viewEmpno = decryptEmpno(box.get("viewEmpno"));

//            if(StringUtils.isNotBlank(box.get("viewEmpnoKey"))) {
//                req.getSession().setAttribute("AESKEY", "sshr" + box.get("viewEmpnoKey"));
//            }

            String dest = WebUtil.ServletURL + "hris.N.mssperson.A01SelfDetailNeoSV_m?ViewOrg=Y&viewEmpno=" + AESgenerUtil.encryptAES(viewEmpno, req);

            redirect(res, dest);
            //printJspPage(req, res, dest);

        }catch(Exception e){
            throw new GeneralException(e);
        }// end try
    }

}