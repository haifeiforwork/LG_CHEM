/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �������� ��û                                             */
/*   Program Name : �������� ��û                                             */
/*   Program ID   : A15CertiBuildSV                                             */
/*   Description  : ���������� ��û�� �� �ֵ��� �ϴ� Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  �ڿ���                                          */
/*   Update       : 2005-03-07  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.A.A15Certi;

import com.common.AjaxResultMap;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import hris.A.A15Certi.rfc.A15CertiUseCodeRFC;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class A15CertiUserCodeAjaxSV extends EHRBaseServlet {


    protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        AjaxResultMap resultVO = AjaxResultMap.getInstance();

        try {
            //����� ó�� �κ� key, value �� addResult ȣ��
            String I_CERT_CODE = req.getParameter("CERT_CODE");
            String I_PERNR = req.getParameter("PERNR");

            if(StringUtils.isNotBlank(I_CERT_CODE))
                resultVO.addResult("resultList", (new A15CertiUseCodeRFC()).getUseCodeList(I_PERNR, I_CERT_CODE));

            resultVO.writeJson(res);
        } catch (Exception e) {
            resultVO.setErrorMessage("not found.");
            Logger.error(e);
            throw new GeneralException(e);
        }

    }
}
