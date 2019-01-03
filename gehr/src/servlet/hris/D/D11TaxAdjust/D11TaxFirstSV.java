/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �����ְ�����Ȳ                                              */
/*   Program Name : �����ְ�����Ȳ                                              */
/*   Program ID   : D11TaxFirstSV                                               */
/*   Description  : �������� ù ȭ�� ���� class                                 */
/*   Note         :                                                             */
/*   Creation     : 2005-01-26  ������                                          */
/*   Update       :  2013/12/10 CSR ID:C20140106_63914 PDF ���μ���    */
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
            
            //�븮 ��û �߰�
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

            
            // �������� ��û/����/������ȸ/�ùķ��̼� ������ �Ⱓ�������θ� ���ǿ� ����
            periodData = (hris.D.D00TaxAdjustPeriodData)periodRFC.getPeriod(user.companyCode,PERNR);
            Logger.debug.println(this,periodData.toString());


            if(periodData.BUKRS!=null && periodData.BUKRS!=""){

                // �������� ��������
                String currentData = DataUtil.getCurrentDate();
                int appl_from = DataUtil.getBetween(currentData, DataUtil.removeStructur(periodData.APPL_FROM,"-"));
                int appl_toxx = DataUtil.getBetween(currentData, DataUtil.removeStructur(periodData.APPL_TOXX,"-"));
                int simu_from = DataUtil.getBetween(currentData, DataUtil.removeStructur(periodData.SIMU_FROM,"-"));
                int simu_toxx = DataUtil.getBetween(currentData, DataUtil.removeStructur(periodData.SIMU_TOXX,"-"));
                int disp_from = DataUtil.getBetween(currentData, DataUtil.removeStructur(periodData.DISP_FROM,"-"));
                int disp_toxx = DataUtil.getBetween(currentData, DataUtil.removeStructur(periodData.DISP_TOXX,"-"));

                // ȸ��⵵
               // taxAdjustFlagData.targetYear = taxAdjustPeriodData.APPL_FROM.substring(0,4);
                taxAdjustFlagData.targetYear = periodData.YEA_YEAR;
               

                // �������ڿ� ��
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

                Logger.debug.println(this, "ok login.. �������� �Ⱓ : "+taxAdjustFlagData.toString() );  
            } else {
                session = req.getSession(true);
                session.setAttribute("taxAdjust",new TaxAdjustFlagData());

                Logger.debug.println(this, "ok login.. �������� �Ⱓ : "+taxAdjustFlagData.toString() );  
            }
            // �������� ��û/����/������ȸ/�ùķ��̼� ������ �Ⱓ�������θ� ���ǿ� ����

            
            targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;

            dest = WebUtil.JspURL+"D/D11TaxAdjust/D11TaxAdjustGuide.jsp";
            //dest = WebUtil.ServletURL+ "hris.D.D11TaxAdjust.D11TaxAdjustPersonSV";
            req.setAttribute( "targetYear", targetYear );
            req.setAttribute( "PERNR", PERNR );
            req.setAttribute("PersonData",phonenumdata);
            Logger.debug.println(this, " destributed = " + dest);

            //pdfYn ���ǿ� ����   C20140106_63914
            String pdfYn = "N";

            Vector              retYN            = new Vector();
            
            retYN = ( new D11TaxAdjustScreenControlRFC() ).getFLAG( user.empNo ,targetYear,DataUtil.getCurrentDate() );   
            
            pdfYn = (String)retYN.get(0); //ȸ�纰�� PDF ��뿩�ΰ� �� 
            //String eCONFIRM = (String)retYN.get(1);  
            session = req.getSession(true);
            session.setAttribute("pdfYn", pdfYn);
            Logger.debug.println(this, "pdfYn : "+ session.getAttribute("pdfYn"));

            //ApLog ����
            ApLoggerWriter.writeApLog("��������", "��û�ȳ�", "D11TaxFirstSV", "��û��Ȳ��ȸ", "12", "0", null, user, req.getRemoteAddr());

            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}