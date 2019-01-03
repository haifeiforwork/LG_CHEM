/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : �������                                                    */
/*   2Depth Name  : ���� Pool                                                   */
/*   Program Name : �����̷�                                                    */
/*   Program ID   : C04HrdLearnDetailSV_m                                       */
/*   Description  : ����� ���� �̷� ������ ��ȸ�� �� �ֵ��� �ϴ� Class         */
/*   Note         : ����                                                        */
/*   Creation     : 2008-08-12  lsa                                             */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/


package servlet.hris.C ;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.C.rfc.C04HrdLearnDetailRFC;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

public class C04HrdLearnDetailSV_m extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try { 
            HttpSession session = req.getSession( false ) ;
            WebUserData user_m  = ( WebUserData ) session.getAttribute( "user_m" ) ;

            String jobid  = "" ;
            String dest   = "" ;
            
            WebUserData user = WebUtil.getSessionUser(req);
//          @����༺ �߰�
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            Box box = WebUtil.getBox( req ) ;
            jobid = box.get("jobid2");
            String pernr = box.get("pernr");
            String IM_SORTKEY = box.get("IM_SORTKEY");
            String IM_SORTDIR = box.get("IM_SORTDIR");
            
            if( jobid.equals("") ){
                jobid = "wait";
            }

            if( IM_SORTKEY.equals("") ){
            	IM_SORTKEY = "BEGDA";
            }
            if( IM_SORTDIR.equals("") ){
            	IM_SORTDIR = "DES";
            }
            C04HrdLearnDetailRFC func1                 = null ;
            Vector            C04HrdLearnDetailData_vt = new Vector() ;
            Logger.debug.println(this, "pernrL:"+pernr+"[jobid] = "+jobid  );

            if ( pernr != null ) {

 
                if( jobid.equals("wait") ) {            //��ȸ���̶�� �޽����� �����ش�.
                    req.setAttribute( "pernr", pernr ) ;
                    req.setAttribute( "IM_SORTKEY", IM_SORTKEY ) ;
                    req.setAttribute( "IM_SORTDIR", IM_SORTDIR ) ; 
                    dest = WebUtil.JspURL + "C/C04HrdLearnDetailWait_m.jsp" ;

                } else if( jobid.equals("detail") ) {   //wait page���� ȣ���Ѵ�.

 
                    func1                 = new C04HrdLearnDetailRFC() ;
//                    C04HrdLearnDetailData_vt = func1.getLearnDetail( pernr ,IM_SORTKEY,  IM_SORTDIR ) ;

                    Logger.debug.println( this, "C04HrdLearnDetailData_vt : " + C04HrdLearnDetailData_vt.toString() ) ;
                    req.setAttribute( "C04HrdLearnDetailData_vt", C04HrdLearnDetailData_vt ) ;
                    req.setAttribute( "pernr", pernr ) ;
                    req.setAttribute( "IM_SORTKEY", IM_SORTKEY ) ;
                    req.setAttribute( "IM_SORTDIR", IM_SORTDIR ) ; 
                    dest = WebUtil.JspURL + "C/C04HrdLearnDetail_m.jsp" ;
                } else if ( jobid.equals("wait_detail") ) {   //detail page���� ȣ���Ѵ�.
                    req.setAttribute( "pernr", pernr ) ;
                    req.setAttribute( "IM_SORTKEY", IM_SORTKEY ) ;
                    req.setAttribute( "IM_SORTDIR", IM_SORTDIR ) ; 
                    dest = WebUtil.JspURL + "C/C04HrdLearnDetailWait_m.jsp" ;
                } else if ( jobid.equals("excel") ) {   //excel �ٿ�ε�
                    func1                 = new C04HrdLearnDetailRFC() ;
//                    C04HrdLearnDetailData_vt = func1.getLearnDetail( pernr ,IM_SORTKEY,  IM_SORTDIR ) ;
                	
                    req.setAttribute( "C04HrdLearnDetailData_vt", C04HrdLearnDetailData_vt ) ;
                    req.setAttribute( "pernr", pernr ) ;
                    req.setAttribute( "IM_SORTKEY", IM_SORTKEY ) ;
                    req.setAttribute( "IM_SORTDIR", IM_SORTDIR ) ; 
                    dest = WebUtil.JspURL + "C/C04HrdLearnDetailexcel_m.jsp" ;

                } else {
                    throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
                }

            } else {
                req.setAttribute( "C04HrdLearnDetailData_vt", C04HrdLearnDetailData_vt ) ;
                req.setAttribute( "pernr", pernr ) ;
                req.setAttribute( "IM_SORTKEY", IM_SORTKEY ) ;
                req.setAttribute( "IM_SORTDIR", IM_SORTDIR ) ; 
                dest = WebUtil.JspURL + "C/C04HrdLearnDetail_m.jsp" ;
            }
            Logger.debug.println( this, " destributed = " + dest ) ;
            printJspPage( req, res, dest ) ;
        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }
    }
}
