/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR 정보                                                  */
/*   2Depth Name  : 교육과정 안내/신청                                          */
/*   Program Name : 교육과정 안내                                               */
/*   Program ID   : C02CurriInfoSV                                              */
/*   Description  : 교육과정안내 이벤트 유형 정보를 가져오는 Servlet            */
/*   Note         :                                                             */
/*   Creation     : 2002-01-15  박영락                                          */
/*   Update       : 2005-02-21  윤정현                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.C.C02Curri;

import java.util.Vector;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;
import hris.C.C02Curri.C02CurriCheckData;
import hris.C.C02Curri.C02CurriData;
import hris.C.C02Curri.C02CurriInfoData;
import hris.C.C02Curri.rfc.*;

public class C02CurriInfoSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            
            HttpSession session = req.getSession(false);
            
            WebUserData user = WebUtil.getSessionUser(req);
            
            Box box = WebUtil.getBox(req);
            String dest  = "";
            
            //처리 후 돌아 갈 페이지
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            C02CurriInfoData data = new C02CurriInfoData();
            
            String PERNR;
            
            PERNR = box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if
            
            // 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            
            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , phonenumdata );
            
            if( user.e_learning.equals("Y") ) {
                Vector data_vt = (new C02CurriInfoElearnRFC()).getEventInfo( user.OBJID );
                
                if( data_vt.size() > 0 ) {
                    data = (C02CurriInfoData) data_vt.get(0);
                } else {
                    box.copyToEntity(data);
                }
                
                user.e_learning = "N";
            } else {
                box.copyToEntity(data);
                
                user.e_learning = "";
            }
            
            //////////////////////////////////////////
            C02CurriInfoData key = new C02CurriInfoData();
            box.copyToEntity(key);
            req.setAttribute("C02CurriInfoKey", key);
            //////////////////////////////////////////
                        
            C02CurriInfoRFC   func1 = new C02CurriInfoRFC();
            Vector            ret   = func1.getCurriInfo( data.GWAID, data.CHAID );
            
            Vector C02CurriEventInfoData_vt = (Vector)ret.get(0);
            Vector C02CurriEventData_vt     = (Vector)ret.get(1);
            Vector C02CurriData_Course_vt   = (Vector)ret.get(2);//선이수과정
            Vector C02CurriData_Get_vt      = (Vector)ret.get(3);
            Vector C02CurriData_Grint_vt    = (Vector)ret.get(4);//선수자격요건
            Vector checkPre_vt              = new Vector();
            Vector checkPreChk_vt           = new Vector();
            
            for( int i = 0; i < C02CurriData_Course_vt.size(); i++ ){
                C02CurriCheckData chkData = new C02CurriCheckData();
                C02CurriData  infoData    = (C02CurriData)C02CurriData_Course_vt.get(i);
                chkData.OBJID             = infoData.PREID;
                checkPre_vt.addElement( chkData );
            }
            
            C02CurriPreRFC    func2         = new C02CurriPreRFC();//선이수과정CHECK
            Vector C02CurriCheck_Pre_vt     = func2.getCurriPreviouse( PERNR, checkPre_vt );
            
            for( int i = 0; i < C02CurriData_Grint_vt.size(); i++ ){
                C02CurriCheckData chkData = new C02CurriCheckData();
                C02CurriData  infoData    = (C02CurriData)C02CurriData_Grint_vt.get(i);
                chkData.OBJID             = infoData.PREID;
                chkData.CHARA             = infoData.CHARA;
                checkPreChk_vt.addElement( chkData );
            }
            C02CurriPreChkRFC func3         = new C02CurriPreChkRFC();//선수자격요건CHECK
            Vector C02CurriCheck_PreChk_vt  = func3.getCurriPreCheck( PERNR, checkPreChk_vt );
            
            req.setAttribute("C02CurriInfoData", data);
            req.setAttribute("C02CurriEventInfoData_vt", C02CurriEventInfoData_vt);
            req.setAttribute("C02CurriEventData_vt", C02CurriEventData_vt);
            req.setAttribute("C02CurriData_Course_vt", C02CurriData_Course_vt);
            req.setAttribute("C02CurriData_Grint_vt", C02CurriData_Grint_vt);
            req.setAttribute("C02CurriData_Get_vt", C02CurriData_Get_vt);
            
            req.setAttribute("C02CurriCheck_Pre_vt", C02CurriCheck_Pre_vt);
            req.setAttribute("C02CurriCheck_PreChk_vt", C02CurriCheck_PreChk_vt);   
            
            dest = WebUtil.JspURL+"C/C02Curri/C02CurriNotice.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
            
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
    }
}