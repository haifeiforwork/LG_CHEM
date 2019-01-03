/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �������� �ȳ�/��û                                          */
/*   Program Name : �������� �ȳ�/��û                                          */
/*   Program ID   : C02CurriInfoListSV                                          */
/*   Description  : �������� ������ �������� Class                              */
/*   Note         :                                                             */
/*   Creation     : 2002-01-14  �ڿ���                                          */
/*   Update       : 2005-02-21  ������                                          */
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
import hris.C.C02Curri.C02CurriInfoData;
import hris.C.C02Curri.rfc.*;

public class C02CurriInfoListSV extends EHRBaseServlet {
    
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            
            HttpSession session = req.getSession(false);
            
            WebUserData user = WebUtil.getSessionUser(req);
            
            Box box = WebUtil.getBox(req);
            
            String dest  = "";
            String jobid = "";    
            String page  = "";  //paging ó��
            String gubun = "";
            String PERNR;
            
            //ó�� �� ���� �� ������
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            gubun = box.get("gubun");
            
            page  = box.get("page");
            jobid = box.get("jobid");
            Logger.debug.println(this, "servlet Page : " + page);
            if( jobid.equals("") ){
                jobid = "first";
            }
            if( page.equals("") || page == null ){
                page = "1";
            }
            
            PERNR = box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            
            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , phonenumdata );
            
            C02CurriInfoData key = new C02CurriInfoData();
            Vector C02CurriInfoData_vt = new Vector();
            
            box.copyToEntity(key);
            
            if ( jobid.equals("first" ) ){
                dest = WebUtil.JspURL+"C/C02Curri/C02CurriSearch.jsp";
                req.setAttribute("C02CurriInfoData", key);
                req.setAttribute("gubun", "");
            } else if ( jobid.equals("goBack" ) ){
                dest = WebUtil.JspURL+"C/C02Curri/C02CurriSearch.jsp";
                req.setAttribute("C02CurriInfoData", key);
                req.setAttribute("gubun", "1");
            } else if( jobid.equals("search") ){
                C02CurriInfoListRFC func = new C02CurriInfoListRFC();
                C02CurriInfoData_vt = func.getCurriInfoList(key);
                C02CurriInfoData_vt = SortUtil.sort( C02CurriInfoData_vt , "GWAID,BEGDA", "desc,asc");
                dest = WebUtil.JspURL+"C/C02Curri/C02CurriSearchDown.jsp";
                req.setAttribute("C02CurriInfoData", key);
                req.setAttribute("C02CurriInfoData_vt", C02CurriInfoData_vt);
            } else if( jobid.equals("submit") ){
                dest = WebUtil.JspURL+"C/C02Curri/C02CurriWait.jsp";
                req.setAttribute("C02CurriInfoData", key);
            } else if( jobid.equals("frameset") ){
                dest = WebUtil.JspURL+"C/C02Curri/C02CurriSearchTop.jsp";
                req.setAttribute("C02CurriInfoData", key);
                req.setAttribute("gubun", gubun);
            }
            Logger.debug.println(this, "##2##KEY = " + key);
            Logger.debug.println(this, "##2##C02CurriInfoData_vt = " + C02CurriInfoData_vt);
            req.setAttribute("jobid", jobid);
            req.setAttribute("page", page);
            
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
    }
}