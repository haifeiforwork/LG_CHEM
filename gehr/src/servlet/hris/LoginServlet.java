/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  :                                                */
/*   2Depth Name  :                                                 */
/*   Program Name :                                      */
/*   Program ID   : HrdMailAutoLoginSV.java                                    */
/*   Description  :                          */
/*   Note         :                                                             */
/*   Creation     :                                   */
/*   Update       :  2015-08-20 이지은 [CSR ID:] ehr시스템웹취약성진단 수정                       */
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
import hris.common.TaxAdjustFlagData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginServlet extends EHRBaseServlet {

    protected void performPreTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            performTask(req, res);
        }catch(GeneralException e){
           throw new GeneralException (e);
        }
    }

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
         try{
         	Box box = WebUtil.getBox(req);
            WebUserData user = new WebUserData();
            box.copyToEntity(user);
            
            PersonInfoRFC personInfoRFC        = new PersonInfoRFC();
            PersonData personData   = new PersonData();
            String msg = ""; //[CSR ID:] ehr시스템웹취약성진단 수정
            
            hris.D.rfc.D00TaxAdjustPeriodRFC periodRFC           = new hris.D.rfc.D00TaxAdjustPeriodRFC();
            hris.D.D00TaxAdjustPeriodData    taxAdjustPeriodData = new hris.D.D00TaxAdjustPeriodData();
            TaxAdjustFlagData                taxAdjustFlagData   = new TaxAdjustFlagData();
                    
            if(box.getString("webUserId").equals("admin")) {
                if (box.getString("webUserPwd").equals("admin")) {

                    HttpSession session = req.getSession(false);
                    if (session != null){ session.invalidate(); }
                    try{
                        personData = (PersonData)personInfoRFC.getPersonInfo(user.empNo, "X");

                    }catch(Exception ex){
                        Logger.debug.println(this,"Data Not Found");
                        //String msg = "접속 중 오류가 발생하였습니다.";
                        msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                        String url = "history.back();";
                        req.setAttribute("msg", msg);
                        req.setAttribute("url", url);
                        printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
                    }
                    if( personData.E_BUKRS==null|| personData.E_BUKRS.equals("") ) {

                        //String msg = "사원번호를 확인하여 주십시요.";
                        msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                        String url = "history.back();";
                        req.setAttribute("msg", msg);
                        req.setAttribute("url", url);
                        printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");

                    } else {
                        user.login_stat       = "Y";
                        user.companyCode      = personData.E_BUKRS ;

                        Config conf           = new Configuration();
                        user.clientNo         = conf.get("com.sns.jdf.sap.SAP_CLIENT");

                        personInfoRFC.setSessionUserData(personData, user);

                        WebUtil.setLang(WebUtil.getLangFromCookie(req), req, user);

                        DataUtil.fixNull(user);

                        session = req.getSession(true);

                        int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
                        session.setMaxInactiveInterval(maxSessionTime);

                        session.setAttribute("user",user);

                        // 연말정산 신청/수정/내역조회/시뮬레이션 가능한 기간인지여부를 세션에 저장
                        taxAdjustPeriodData = (hris.D.D00TaxAdjustPeriodData)periodRFC.getPeriod(user.companyCode,user.empNo);
                        Logger.debug.println(this,taxAdjustPeriodData.toString());

                        if(taxAdjustPeriodData.BUKRS!=null && taxAdjustPeriodData.BUKRS!=""){

                            // 현재일자 가져오기
                            String currentData = DataUtil.getCurrentDate();
                            int appl_from = DataUtil.getBetween(currentData, DataUtil.removeStructur(taxAdjustPeriodData.APPL_FROM,"-"));
                            int appl_toxx = DataUtil.getBetween(currentData, DataUtil.removeStructur(taxAdjustPeriodData.APPL_TOXX,"-"));
                            int simu_from = DataUtil.getBetween(currentData, DataUtil.removeStructur(taxAdjustPeriodData.SIMU_FROM,"-"));
                            int simu_toxx = DataUtil.getBetween(currentData, DataUtil.removeStructur(taxAdjustPeriodData.SIMU_TOXX,"-"));
                            int disp_from = DataUtil.getBetween(currentData, DataUtil.removeStructur(taxAdjustPeriodData.DISP_FROM,"-"));
                            int disp_toxx = DataUtil.getBetween(currentData, DataUtil.removeStructur(taxAdjustPeriodData.DISP_TOXX,"-"));

                            // 회계년도
                            taxAdjustFlagData.targetYear = taxAdjustPeriodData.APPL_FROM.substring(0,4);

                            // 현재일자와 비교
                            if(appl_from <= 0 && appl_toxx >= 0){
                                taxAdjustFlagData.canPeriod = true;
                                taxAdjustFlagData.canBuild = true;
                            }
                            if(simu_from <= 0 && simu_toxx >= 0){
                                taxAdjustFlagData.canPeriod = true;
                                taxAdjustFlagData.canSimul = true;
                            }
                            if(disp_from <= 0 && disp_toxx >= 0){
                                taxAdjustFlagData.canPeriod = true;
                                taxAdjustFlagData.canDetail = true;
                            }
                          
                            session = req.getSession(true);
                            session.setAttribute("taxAdjust",taxAdjustFlagData);

                            Logger.debug.println(this, "ok login.. 연말정산 기간 : "+taxAdjustFlagData.toString() );	
                        } else {
                            session = req.getSession(true);
                            session.setAttribute("taxAdjust",new TaxAdjustFlagData());

                            Logger.debug.println(this, "ok login.. 연말정산 기간 : "+taxAdjustFlagData.toString() );	
                        }
                        // 연말정산 신청/수정/내역조회/시뮬레이션 가능한 기간인지여부를 세션에 저장

                        Logger.debug.println(this, "ok login.. user : "+user.toString() );	
                        String dest = WebUtil.JspURL+"reload.jsp";
                        //printHtmlPage(req, res, dest);
                        printJspPage(req, res, dest);
                    }
                } else {
                    //String msg = "비밀번호가 일치하지 않습니다. ";
                    msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                    String url = "history.back();";
                    req.setAttribute("msg", msg);
                    req.setAttribute("url", url);
                    printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
                }
           }else{
                //String msg = "비밀번호가 일치하지 않습니다. ";
               msg = "접속 중 오류가 발생하였습니다."; //[CSR ID:] ehr시스템웹취약성진단 수정
                String url = "history.back();";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
           }
        }catch(Exception e){
            throw new GeneralException(e);
        }		
    }
}