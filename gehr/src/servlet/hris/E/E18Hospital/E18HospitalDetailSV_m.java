/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 의료비지원내역                                              */
/*   Program Name : 의료비 신청 조회                                            */
/*   Program ID   : E18HospitalDetailSV_m                                       */
/*   Description  : 사원의 의료비 상세 내역을 조회할 수 있도록 하는 Class       */
/*   Note         :                                                             */
/*   Creation     : 2002-01-03  한성덕                                          */
/*   Update       : 2005-01-24  윤정현                                          */
/*                  2005-11-09  lsa @v1.1:C2005110201000000339(의료비 조회시 이름포함 )*/
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E18Hospital ;

import java.util.Vector ;
import javax.servlet.http.* ;

import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;
import hris.E.E18Hospital.rfc.* ;

public class E18HospitalDetailSV_m extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user_m  = ( WebUserData ) session.getAttribute( "user_m" ) ;
            Box box = WebUtil.getBox( req ) ;

            String dest   = "" ;
            String CTRL_NUMB  = box.get( "CTRL_NUMB"  );
            String GUEN_CODE  = box.get( "GUEN_CODE"  );
            String PROOF      = box.get( "PROOF"      );
            String ENAME      = box.get( "ENAME"      ) ;            //@v1.1구분명
            String SICK_NAME  = box.get( "SICK_NAME"  );
            String SICK_DESC1 = box.get( "SICK_DESC1" );
            String SICK_DESC2 = box.get( "SICK_DESC2" );
            String SICK_DESC3 = box.get( "SICK_DESC3" );
            String EMPL_WONX  = box.get( "EMPL_WONX"  );  // 본인부담금 총액
            String COMP_WONX  = box.get( "COMP_WONX"  );  // 회사지원액
            String YTAX_WONX  = box.get( "YTAX_WONX"  );  // 연말정산반영액
            String RFUN_DATE  = box.get( "RFUN_DATE"  );
            String RFUN_RESN  = box.get( "RFUN_RESN"  );
            String RFUN_AMNT  = box.get( "RFUN_AMNT"  );  // 반납액
            String BIGO_TEXT1 = box.get( "BIGO_TEXT1" );
            String BIGO_TEXT2 = box.get( "BIGO_TEXT2" );
            String WAERS      = box.get( "WAERS"      );  // 통화키
            String COMP_sum   = box.get( "COMP_sum"   );  // 회사지원총액(배우자일경우)
            String TREA_CODE  = box.get( "TREA_CODE"  ) ;            // 06.02.24 진료과코드   
            String TREA_TEXT  = box.get( "TREA_TEXT"  ) ;            // 06.02.24 진료과코드명 
            String REGNO      = box.get( "REGNO"      ) ;            // 06.03.07 (자녀인 경우만)
            
            WebUserData user = WebUtil.getSessionUser(req);
//          @웹취약성 추가
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            E18HospitalDetailRFC func1 = new E18HospitalDetailRFC() ;
            Vector E18HospitalDetailData_vt = new Vector();

            //          기존 데이터의 처리
            if( GUEN_CODE.equals("") ) {
                GUEN_CODE = "0001";
            }

            if ( user_m != null ) {
                //              HospitalDetail - ZHRW_RFC_MEDIC_DETAIL - 의료비 상세 내역
                E18HospitalDetailData_vt = func1.getHospitalDetail( user_m.empNo, CTRL_NUMB, GUEN_CODE,REGNO ) ;
            } // if ( user_m != null ) end

            if( E18HospitalDetailData_vt.size() == 0 ) {
                Logger.debug.println( this, "Data Not Found" ) ;
                String msg = "msg004" ;
                String url = "history.back() ;" ;
                req.setAttribute( "msg", msg ) ;
                req.setAttribute( "url", url ) ;
                dest = WebUtil.JspURL + "common/msg.jsp" ;
            } else {
                req.setAttribute( "CTRL_NUMB",  CTRL_NUMB  );
                req.setAttribute( "GUEN_CODE",  GUEN_CODE  );
                req.setAttribute( "PROOF",      PROOF      );
                req.setAttribute( "ENAME",      ENAME      );  //@v1.1구분명
                req.setAttribute( "SICK_NAME",  SICK_NAME  );
                req.setAttribute( "SICK_DESC1", SICK_DESC1 );
                req.setAttribute( "SICK_DESC2", SICK_DESC2 );
                req.setAttribute( "SICK_DESC3", SICK_DESC3 );
                req.setAttribute( "EMPL_WONX",  EMPL_WONX  );  // 본인부담금 총액
                req.setAttribute( "COMP_WONX",  COMP_WONX  );  // 회사지원액
                req.setAttribute( "YTAX_WONX",  YTAX_WONX  );  // 연말정산반영액
                req.setAttribute( "RFUN_DATE",  RFUN_DATE  );
                req.setAttribute( "RFUN_RESN",  RFUN_RESN  );
                req.setAttribute( "RFUN_AMNT",  RFUN_AMNT  );  // 반납액
                req.setAttribute( "BIGO_TEXT1", BIGO_TEXT1 );
                req.setAttribute( "BIGO_TEXT2", BIGO_TEXT2 );
                req.setAttribute( "WAERS",      WAERS      );  // 통화키
                req.setAttribute( "COMP_sum",   COMP_sum   );  // 회사지원총액(배우자일경우)
                req.setAttribute( "TREA_CODE",  TREA_CODE  ); // 06.02.24 진료과코드  
                req.setAttribute( "TREA_TEXT",  TREA_TEXT  ); // 06.02.24 진료과코드명
                req.setAttribute( "REGNO"    ,  REGNO  ) ;                // 06.03.07 

                req.setAttribute( "E18HospitalDetailData_vt", E18HospitalDetailData_vt ) ;

                dest = WebUtil.JspURL + "E/E18Hospital/E18HospitalDetail_m.jsp" ;
            }

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }
    }
}
