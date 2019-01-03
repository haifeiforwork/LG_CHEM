/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : ����                                                        */
/*   Program Name : ���½�������                                                */
/*   Program ID   : D02ConductListSV_m                                          */
/*   Description  : ���� ������ ��ȸ�� �� �ֵ��� �ϴ� Class                     */
/*   Note         :                                                             */
/*   Creation     : 2002-02-16  �Ѽ���                                          */
/*   Update       : 2005-01-21  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.D ;

import java.util.Vector ;
import javax.servlet.http.* ;

import com.common.constant.Area;
import com.sns.jdf.* ;
import com.sns.jdf.util.* ;
import com.sns.jdf.servlet.* ;

import hris.common.* ;
import hris.D.D02ConductDetailData;
import hris.D.D02ConductDisplayData;
import hris.D.rfc.* ;

public class D02ConductListDirectSV_m extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

    	 try{
         	WebUserData user = WebUtil.getSessionUser(req);
         	if(g.getSapType().isLocal()) {
         		printJspPage(req, res, WebUtil.ServletURL + "hris.D.D02ConductListSV_m");
         	}else{
         		printJspPage(req, res, WebUtil.ServletURL + "hris.D.Global.D02ConductListSV_m");
         	}
         } catch(Exception e) {
             throw new GeneralException(e);
         }

    }

}
