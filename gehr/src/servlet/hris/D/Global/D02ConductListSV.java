/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ����                                                        */
/*   Program Name : ���½�������                                                */
/*   Program ID   : D02ConductListSV                                       */
/*   Description  : Time & Attendance servlet                     */
/*   Note         :                                                             */
/*   Creation     : 2002-02-16  �Ѽ���                                          */
/*   Update       : 2005-01-21  ������                                          */
/*                  2007-09-12  zhouguangwen   global e-hr update          */
/********************************************************************************/

package servlet.hris.D.Global ;

import java.io.* ;
import java.sql.* ;
import java.util.Vector ;
import javax.servlet.* ;
import javax.servlet.http.* ;

import com.common.constant.Area;
import com.sns.jdf.* ;
import com.sns.jdf.db.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;
import hris.D.* ;
import hris.D.Global.D02ConductDisplayMonthData;
import hris.D.rfc.Global.* ;

/**
 * D02ConductListSV.java
 *  ���� ������ ��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author �Ѽ���
 * @version 2.0, 2002/02/16
 * update by zhouguangwen 2007/09/12
 *                2017-11-06  eunha  [CSR ID:3516631] �±� ���� Roll in �� ���� Globlal HR Portal ���� ��û��
 *                //@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel 
 */
public class D02ConductListSV extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {

            HttpSession session = req.getSession( false ) ;
            WebUserData user    = ( WebUserData ) session.getAttribute( "user" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String jobid   = "" ;
            String dest    = "" ;
            String e_year  = box.get( "year" ) ;
            String dest_deail = user.area.toString();

            if( e_year == null || e_year.equals("")) {
            	e_year = DataUtil.getCurrentYear() ;
            }

            String e_month = box.get( "month" ) ;

            if( e_month == null ||e_month.equals("")) {
            	e_month = DataUtil.getCurrentMonth();
            }

            Logger.debug.println( this, "e_year==========>" + e_year ) ;
            Logger.debug.println( this, "e_month=========>" + e_month ) ;

            Vector temp_vt = new Vector();   //temp Vector 1

            Vector dayDetial_vt = new Vector();
		    Vector monthTotal_vt = new Vector();
		    String E_RETURN = "";
		    String E_MESSAGE = "";

		    D02ConductDisplayMonthRFC monthfunc= new D02ConductDisplayMonthRFC();
		    D02ConductDisplayMonthRFCEurp monthfuncEurp= new D02ConductDisplayMonthRFCEurp();

		    //[CSR ID:3516631] �±� ���� Roll in �� ���� Globlal HR Portal ���� ��û�� start
		    // if (user.area== Area.HK||user.area== Area.CN||user.area== Area.TW) {
		    if (user.area== Area.HK||user.area== Area.CN||user.area== Area.TW||user.area== Area.TH) {
		    //[CSR ID:3516631] �±� ���� Roll in �� ���� Globlal HR Portal ���� ��û�� end
		    	 temp_vt = monthfunc.getMonAndDay(user.empNo, e_year, e_month);
		    	 dest_deail="CN";
		    } else{
		    	 temp_vt = monthfuncEurp.getMonAndDay(user.empNo, e_year, e_month);
            }

            E_RETURN  = temp_vt.get(0).toString();
            D02ConductDisplayMonthData monthlyData = new D02ConductDisplayMonthData();


            if(E_RETURN.trim().equals("S")){

              E_MESSAGE = temp_vt.get(1).toString();
              dayDetial_vt = (Vector)temp_vt.get(2);
              monthTotal_vt = (Vector)temp_vt.get(3);
              monthlyData = (D02ConductDisplayMonthData)monthTotal_vt.get(0);

            }else{

            	 dayDetial_vt = new Vector();
    		     monthTotal_vt = new Vector();
    		     monthlyData = new D02ConductDisplayMonthData();
            }

            DataUtil.fixNullAndTrim( monthlyData );

            req.setAttribute( "E_RETURN",  E_RETURN  ) ;
            req.setAttribute( "E_MESSAGE",  E_MESSAGE  ) ;
            req.setAttribute( "year",  e_year  ) ;  // year
            req.setAttribute( "month", e_month ) ;  // month
            req.setAttribute( "monthlyData",  monthlyData  ) ;  // month Total
            req.setAttribute( "dayDetial_vt",  dayDetial_vt  ) ;  // day detail

//[CSR ID:3516631] �±� ���� Roll in �� ���� Globlal HR Portal ���� ��û��
            if (user.area== Area.HK||user.area== Area.CN||user.area== Area.TW ||user.area== Area.TH ) dest_deail="CN";
            
          //@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel 
            if (user.area== Area.MX) dest_deail="US";

            dest = WebUtil.JspURL + "D/D02ConductList_"+dest_deail+".jsp" ;

            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }

    }

}
