package servlet.hris.E.E18Hospital ;

import java.io.* ;
import java.sql.* ;
import java.util.Vector ;
import javax.servlet.* ;
import javax.servlet.http.* ;

import com.sns.jdf.* ;
import com.sns.jdf.db.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;
import hris.common.db.* ;
import hris.common.rfc.* ;
import hris.E.E18Hospital.* ;
import hris.E.E18Hospital.rfc.* ;

/**
 * E18BillDetailSV_m.java
 *  사원의 진료비 계산서 내역을 조회할 수 있도록 하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/01/03
 */
public class E18BillDetailSV_m extends EHRBaseServlet_m {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user_m  = ( WebUserData ) session.getAttribute( "user_m" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String jobid  = "" ;
            String dest   = "" ;
            String CTRL_NUMB = box.get( "CTRL_NUMB" ) ;
            String RCPT_NUMB = box.get( "RCPT_NUMB" ) ;
            String GUEN_CODE = box.get( "GUEN_CODE" ) ;
            String CNT1_WONX = "" ;
            String CNT2_WONX = "" ;
            
            WebUserData user = WebUtil.getSessionUser(req);
//          @웹취약성 추가
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

Logger.debug.println( this, "empNo     : " + user_m.empNo ) ;
Logger.debug.println( this, "CTRL_NUMB : " + CTRL_NUMB  ) ;
Logger.debug.println( this, "RCPT_NUMB : " + RCPT_NUMB  ) ;
Logger.debug.println( this, "GUEN_CODE : " + GUEN_CODE  ) ;

            E18BillDetailRFC func1                = null ;
            Vector           E18BillDetailData_vt = null ;

            // BillDetail - ZHRW_RFC_MEDIC_BILL - 진료비 계산서 내역
            func1                = new E18BillDetailRFC() ;
            
//          기존 데이터의 처리
            if( GUEN_CODE.equals("") ) {
                GUEN_CODE = "0001";
            }
            
            E18BillDetailData_vt = func1.getBillDetail( user_m.empNo, CTRL_NUMB, RCPT_NUMB, GUEN_CODE ) ;

            if( E18BillDetailData_vt.size() == 0 ) {
Logger.debug.println( this, "Data Not Found" ) ;
                
                String msg = "msg004" ;
                String url = "history.back() ;" ;
                req.setAttribute( "msg", msg ) ;
                req.setAttribute( "url", url ) ;
                dest = WebUtil.JspURL + "common/msg.jsp" ;
            } else {
Logger.debug.println( this, "E18BillDetailData_vt : " + E18BillDetailData_vt.toString() ) ;

                for( int i = 0 ; i < E18BillDetailData_vt.size() ; i++ ) {
                    E18BillDetailData data = ( E18BillDetailData ) E18BillDetailData_vt.get( i ) ;

                    CNT1_WONX = Double.toString( Double.parseDouble( data.MEAL_WONX )      // 식대
                                               + Double.parseDouble( data.APNT_WONX )      // 지정 진료비
                                               + Double.parseDouble( data.ROOM_WONX )      // 상급 병실료 차액
                                               + Double.parseDouble( data.CTXX_WONX )      // C T
                                               + Double.parseDouble( data.MRIX_WONX )      // M R I
                                               + Double.parseDouble( data.SWAV_WONX )      // 초음파
                                               + Double.parseDouble( data.ETC1_WONX )      // 기타1 의 금액
                                               + Double.parseDouble( data.ETC2_WONX )      // 기타2 의 금액
                                               + Double.parseDouble( data.ETC3_WONX )      // 기타3 의 금액
                                               + Double.parseDouble( data.ETC4_WONX )      // 기타4 의 금액
                                               + Double.parseDouble( data.ETC5_WONX ) ) ;  // 기타5 의 금액
                    CNT2_WONX = Double.toString( Double.parseDouble( data.EMPL_WONX ) 
                                               + Double.parseDouble( CNT1_WONX ) 
                                               - Double.parseDouble( data.DISC_WONX ) ) ;  // 할인금액
                }

                req.setAttribute( "CNT1_WONX", CNT1_WONX ) ;
                req.setAttribute( "CNT2_WONX", CNT2_WONX ) ;
                req.setAttribute( "E18BillDetailData_vt", E18BillDetailData_vt ) ;

                dest = WebUtil.JspURL + "E/E18Hospital/E18BillDetail_m.jsp" ;
            }
Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }

    }

}
