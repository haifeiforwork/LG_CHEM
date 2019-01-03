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
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.N.AES.AESgenerUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 통합인사정보 조회에서 MSS 화면 호출 시 사용
 * URL : servlet.hris.ExternalMSSViewSV?lang=국가키(ko,en,zh)empNo=로그인사번&empNoKey=로그인사번암호화키
 *      통합인사정보 조회시 &viewEmpno=대상자사번&viewEmpnoKey=대상자사번암호화키
 *      기타 조회시 &redirectURLType
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