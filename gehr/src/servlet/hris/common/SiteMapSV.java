/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 사이트맵 검색                                               */
/*   Program ID   : OrganListSV.java                                            */
/*   Description  : 사이트맵 검색하는 서블릿 파일                               */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-03-01 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
package servlet.hris.common;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.common.WebUserData;
import hris.sys.MenuCodeData;
import hris.sys.MenuInputData;
import hris.sys.rfc.SysMenuListRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Vector;

public class SiteMapSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException 
    {   
        String dest = "";
        boolean isCommit = false;
        //Connection conn = null;        
        
        try {
            
            WebUserData user = WebUtil.getSessionUser(req);
            //conn = DBUtil.getTransaction("HRIS");
            //MenuCodeDB  mcdb = new MenuCodeDB(conn);
            
            //Vector vcMenuCodeData = mcdb.getMenuList();
            //Properties ptProgramCodeData = mcdb.getProgramList(user.user_group);

            //@v1.0 JDBD를 RFC로 변경
            //SysMenuPgmListRFC rfc_MenuList         = new SysMenuPgmListRFC();
            SysMenuListRFC rfc_MenuList         = new SysMenuListRFC();
            /**************************************
             * 사업가 추천 메뉴 권한 체크로직으로  IP 추가 
             ***************************************/
            String remIP = (String)req.getSession(false).getAttribute("remoteIP");
            //Vector vcMenuCodeData = rfc_MenuList.getMenuList(user.e_authorization, user.e_authorization2);//20141125 [CSR ID:2651528] 인사권한 추가 및 메뉴조회 기능 변경
            MenuInputData inputData = new MenuInputData();
            inputData.setI_PERNR(user.empNo);
            inputData.setI_IP(remIP);

            Vector menuList = rfc_MenuList.getMenuList(inputData);

            Map<String, Vector<MenuCodeData>> menuMap = rfc_MenuList.getMenuMap(menuList);

            req.setAttribute("menuMap", menuMap);
            //Properties ptProgramCodeData = rfc_MenuList.getProgramList(user.e_authorization, user.e_authorization2);//20141125 [CSR ID:2651528] 인사권한 추가 및 메뉴조회 기능 변경
            req.setAttribute("menuAllList" ,menuList);
            if (Utils.getSize(menuList) > 0) {
                dest = WebUtil.JspURL+"SiteMap.jsp";
            } else {
                String msg = "접근 권한이 있는 메뉴가 없습니다.";
                String url = "history.back();";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                dest = WebUtil.JspURL+"common/msg.jsp";
            } // end if
            
            isCommit = true;
        //} catch (GeneralException e) {
        //    Logger.err.println(e);
        //    throw e;
        //} catch (SQLException e) {
        //   throw new GeneralException(e);
        //} finally {
        //    DBUtil.close(conn ,isCommit);  
        //} // end try
        printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
        }        
        
    } // end performTask
    
}
