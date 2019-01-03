/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 재직증명서 신청                                             */
/*   Program Name : 재직증명서 신청                                             */
/*   Program ID   : A15CertiBuildSV                                             */
/*   Description  : 재직증명서를 신청할 수 있도록 하는 Class                    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  박영락                                          */
/*   Update       : 2005-03-07  윤정현                                          */
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
            //결과값 처리 부분 key, value 로 addResult 호출
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
