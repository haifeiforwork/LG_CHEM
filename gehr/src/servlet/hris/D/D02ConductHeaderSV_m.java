/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ����                                                        */
/*   Program Name : ���½�������                                                */
/*   Program ID   : D02ConductHeaderSV_m                                        */
/*   Description  : ���� ������ ��ȸ�� �� �ֵ��� �ϴ� Class                     */
/*   Note         :                                                             */
/*   Creation     : 2002-02-16  �Ѽ���                                          */
/*   Update       : 2005-01-21  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D ;

import java.util.Vector ;
import javax.servlet.http.* ;

import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;
import hris.D.D02ConductDetailData;
import hris.D.rfc.* ;


public class D02ConductHeaderSV_m extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user_m  = ( WebUserData ) session.getAttribute( "user_m" ) ;
            Box         box     = WebUtil.getBox( req ) ;

            String dest    = "";
            String e_year  = box.get( "year" );
            String e_month = box.get( "month" );
            String e_day   = "";
            String b_year  = "";
            String b_month = "";
            String b_day   = "";
            String BEGDA   = "";
            String ENDDA   = "";

            double col1_c  = 0;
            double col2_c  = 0;
            double col3_c  = 0;
            double col4_c  = 0;
            double col5_c  = 0;
            double col6_c  = 0;
            double col7_c  = 0;
            double col8_c  = 0;
            double col9_c  = 0;
            double col10_c = 0;
            double col11_c = 0;
            double col12_c = 0;
            double c0140_c = 0;

            WebUserData user = WebUtil.getSessionUser(req);
//          @����༺ �߰�
            if ( user.e_authorization.equals("E")) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
            }

            // ����� ��ȸ �Ⱓ ����
            if( e_month.equals( "1" ) ) {
                b_year  = String.valueOf( Integer.parseInt( e_year ) - 1 ) ;
                b_month = "12" ;
            } else {
                b_year  = e_year ;
                b_month = String.valueOf( Integer.parseInt( e_month ) - 1 ) ;
            }

            if( b_month.length() == 1 ) {
                b_month = "0" + b_month ;
            }

            if( e_month.length() == 1 ) {
                e_month = "0" + e_month ;
            }

            //// LG ����ȭ���� ���( ���� 15�Ϻ��� �ݿ� 14�ϱ��� )
            //if( ( user_m.companyCode ).equals( "N100") ) {
            //    b_day = "16" ;
            //    e_day = "15" ;
            //    // LG ȭ���� ���( ���� 21�Ϻ��� �ݿ� 20�ϱ��� )( C100 )
            //} else {
                b_day = "21" ;
                e_day = "20" ;
            //}

            BEGDA = b_year + b_month + b_day ;
            ENDDA = e_year + e_month + e_day ;

            Logger.debug.println( this, "BEGDA : " + BEGDA );
            Logger.debug.println( this, "ENDDA : " + ENDDA );

            D02ConductDetailRFC func1 = new D02ConductDetailRFC() ;
            Vector D02ConductDetailData_vt = new Vector();

            if ( user_m != null ) {
                Logger.debug.println( this, "empNo : " + user_m.empNo );
                // ConductDetail - ZHRP_RFC_TIME_DISPLAY - ���� ����
                D02ConductDetailData_vt = func1.getConductDetail( user_m.empNo, BEGDA, ENDDA ) ;

            // �� ���ϱ�
            for( int i = 0 ; i < D02ConductDetailData_vt.size() ; i++ ) {
                D02ConductDetailData data = ( D02ConductDetailData ) D02ConductDetailData_vt.get( i ) ;

                if( data.DATUM.length() == 10 ) {
                    data.DATUM = data.DATUM.substring( 0,  4 ) + data.DATUM.substring( 5, 7 )
                    + data.DATUM.substring( 8, 10 ) ;
                }

                if( Integer.parseInt( data.DATUM ) >= Integer.parseInt( BEGDA )
                        && Integer.parseInt( data.DATUM ) <= Integer.parseInt( ENDDA ) ) {
                    // ���� ���� �ð�
                    if( data.LGART.equals( "1141" ) || data.LGART.equals( "7020" ) ) {
                        col1_c += Double.parseDouble( data.ANZHL ) ;
                        // ���� ���� �ð�
                    } else if( data.LGART.equals( "1151" ) || data.LGART.equals( "7023" ) ) {
                        col2_c += Double.parseDouble( data.ANZHL ) ;
                        // �߰� �ٹ� �ð�
                    } else if( data.LGART.equals( "1161" ) || data.LGART.equals( "1171" )
                            || data.LGART.equals( "7026" ) ) {
                        col3_c += Double.parseDouble( data.ANZHL ) ;
                        // ���� �ٹ� �ð�
                    } else if( data.LGART.equals( "1101" ) || data.LGART.equals( "1111" )
                            || data.LGART.equals( "1121" ) || data.LGART.equals( "1131" )
                            || data.LGART.equals( "7010" ) || data.LGART.equals( "7013" )
                            || data.LGART.equals( "7016" ) ) {
                        col4_c += Double.parseDouble( data.ANZHL ) ;
                        // ��� �ް� �ϼ�
                    } else if( data.LGART.equals( "0110" ) || data.LGART.equals( "0120" )
                            || data.LGART.equals( "0121" ) || data.LGART.equals( "0122" ) ) {
                        col5_c += Double.parseDouble( data.ABRTG ) ;
                        // ���� �ް� �ϼ�
                    } else if( data.LGART.equals( "0150" ) ) {
                        col6_c += Double.parseDouble( data.ABRTG ) ;
                        // ��� �ϼ�
                    } else if( data.LGART.equals( "0200" ) || data.LGART.equals( "0210" ) ) {
                        col7_c += Double.parseDouble( data.ABRTG ) ;
                        // ���� Ƚ��
                    } else if( data.LGART.equals( "0220" ) ) {
                        col8_c += Double.parseDouble( data.ABRTG ) ;
                        // ���� Ƚ��
                    } else if( data.LGART.equals( "0230" ) ) {
                        col9_c += Double.parseDouble( data.ABRTG ) ;
                        // �ⱺ����
                    } else if( data.LGART.equals( "1036" ) || data.LGART.equals( "1201" ) ) {
                        col10_c += Double.parseDouble( data.ANZHL ) ;
                        // ��������
                    } else if( data.LGART.equals( "1041" ) || data.LGART.equals( "1042" )
                            || data.LGART.equals( "7032" ) || data.LGART.equals( "7033" ) ) {
                        col11_c += Double.parseDouble( data.ANZHL ) ;
                        // ����
                    } else if( data.LGART.equals( "1043" ) || data.LGART.equals( "1044" )
                            || data.LGART.equals( "1045" ) || data.LGART.equals( "1046" )
                            || data.LGART.equals( "1047" ) || data.LGART.equals( "7038" )
                            || data.LGART.equals( "7039" ) ) {
                        col12_c += Double.parseDouble( data.ANZHL ) ;
                        // �ϰ��ް�
                    } else if( data.LGART.equals( "0140" ) ) {
                        c0140_c += Double.parseDouble( data.ABRTG ) ;
                    }
                }
            }

            } // if ( user_m != null ) end
            req.setAttribute( "COL1",  Double.toString( col1_c ) );  // ���� ���� �ð�
            req.setAttribute( "COL2",  Double.toString( col2_c ) );  // ���� ���� �ð�
            req.setAttribute( "COL3",  Double.toString( col3_c ) );  // �߰� �ٹ� �ð�
            req.setAttribute( "COL4",  Double.toString( col4_c ) );  // ���� �ٹ� �ð�
            req.setAttribute( "COL5",  Double.toString( col5_c ) );  // ��� �ް� �ϼ�
            req.setAttribute( "COL6",  Double.toString( col6_c ) );  // ���� �ް� �ϼ�
            req.setAttribute( "COL7",  Double.toString( col7_c ) );  // ��� �ϼ�
            req.setAttribute( "COL8",  Double.toString( col8_c ) );  // ���� Ƚ��
            req.setAttribute( "COL9",  Double.toString( col9_c ) );  // ���� Ƚ��
            req.setAttribute( "COL10", Double.toString( col10_c ) ); // �ⱺ����
            req.setAttribute( "COL11", Double.toString( col11_c ) ); // ��������
            req.setAttribute( "COL12", Double.toString( col12_c ) ); // ����
            req.setAttribute( "C0140", Double.toString( c0140_c ) ); // �ϰ��ް�

            req.setAttribute( "year",  e_year  );  // ��
            req.setAttribute( "month", e_month );  // ��

            dest = WebUtil.JspURL + "D/D02ConductHeader_m.jsp" ;

            Logger.debug.println( this, " destributed = " + dest ) ;

            printJspPage( req, res, dest ) ;

        } catch( Exception e ) {
            throw new GeneralException( e ) ;
        } finally {
        }
    }
}
