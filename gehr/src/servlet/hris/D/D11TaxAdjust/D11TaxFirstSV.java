/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 인포멀가입현황                                              */
/*   Program Name : 인포멀가입현황                                              */
/*   Program ID   : D11TaxFirstSV                                               */
/*   Description  : 연말정산 첫 화면 가는 class                                 */
/*   Note         :                                                             */
/*   Creation     : 2005-01-26  윤정현                                          */
/*   Update       :  2013/12/10 CSR ID:C20140106_63914 PDF 여부수정    */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D11TaxAdjust;

import java.util.Vector;

import javax.servlet.http.*;
import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.D.D11TaxAdjust.rfc.D11TaxAdjustScreenControlRFC; 
import hris.common.*;

import hris.common.rfc.*;

public class D11TaxFirstSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");
            Box         box     = WebUtil.getBox(req);

            String dest       = "";
            String targetYear = "";
            
            //대리 신청 추가
            String PERNR = box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            
            Logger.debug.println(this,phonenumdata.toString());
            
            hris.D.rfc.D00TaxAdjustPeriodRFC periodRFC           = new hris.D.rfc.D00TaxAdjustPeriodRFC();
            hris.D.D00TaxAdjustPeriodData    periodData = new hris.D.D00TaxAdjustPeriodData();
            TaxAdjustFlagData                taxAdjustFlagData   = new TaxAdjustFlagData();

            
            // 연말정산 신청/수정/내역조회/시뮬레이션 가능한 기간인지여부를 세션에 저장
            periodData = (hris.D.D00TaxAdjustPeriodData)periodRFC.getPeriod(user.companyCode,PERNR);
            Logger.debug.println(this,periodData.toString());


            if(periodData.BUKRS!=null && periodData.BUKRS!=""){

                // 현재일자 가져오기
                String currentData = DataUtil.getCurrentDate();
                int appl_from = DataUtil.getBetween(currentData, DataUtil.removeStructur(periodData.APPL_FROM,"-"));
                int appl_toxx = DataUtil.getBetween(currentData, DataUtil.removeStructur(periodData.APPL_TOXX,"-"));
                int simu_from = DataUtil.getBetween(currentData, DataUtil.removeStructur(periodData.SIMU_FROM,"-"));
                int simu_toxx = DataUtil.getBetween(currentData, DataUtil.removeStructur(periodData.SIMU_TOXX,"-"));
                int disp_from = DataUtil.getBetween(currentData, DataUtil.removeStructur(periodData.DISP_FROM,"-"));
                int disp_toxx = DataUtil.getBetween(currentData, DataUtil.removeStructur(periodData.DISP_TOXX,"-"));

                // 회계년도
               // taxAdjustFlagData.targetYear = taxAdjustPeriodData.APPL_FROM.substring(0,4);
                taxAdjustFlagData.targetYear = periodData.YEA_YEAR;
               

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

            
            targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;

            dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGuide.jsp";
            //dest = WebUtil.ServletURL+ "hris.D.D11TaxAdjust.D11TaxAdjustPersonSV";
            req.setAttribute( "targetYear", targetYear );
            req.setAttribute( "PERNR", PERNR );
            req.setAttribute("PersonData",phonenumdata);
            Logger.debug.println(this, " destributed = " + dest);

            //pdfYn 세션에 저장   C20140106_63914
            String pdfYn = "N";

            Vector              retYN            = new Vector();
            
            retYN = ( new D11TaxAdjustScreenControlRFC() ).getFLAG( user.empNo ,targetYear,DataUtil.getCurrentDate() );   
            
            pdfYn = (String)retYN.get(0); //회사별로 PDF 사용여부가 옴 
            //String eCONFIRM = (String)retYN.get(1);  
            session = req.getSession(true);
            session.setAttribute("pdfYn", pdfYn);
            Logger.debug.println(this, "pdfYn : "+ session.getAttribute("pdfYn"));

            //ApLog 생성
            ApLoggerWriter.writeApLog("연말정산", "신청안내", "D11TaxFirstSV", "신청현황조회", "12", "0", null, user, req.getRemoteAddr());

            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}