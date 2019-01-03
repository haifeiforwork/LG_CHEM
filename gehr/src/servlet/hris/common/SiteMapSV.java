/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : ����                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : ����Ʈ�� �˻�                                               */
/*   Program ID   : OrganListSV.java                                            */
/*   Description  : ����Ʈ�� �˻��ϴ� ���� ����                               */
/*   Note         : ����                                                        */
/*   Creation     : 2005-03-01 �����                                           */
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

            //@v1.0 JDBD�� RFC�� ����
            //SysMenuPgmListRFC rfc_MenuList         = new SysMenuPgmListRFC();
            SysMenuListRFC rfc_MenuList         = new SysMenuListRFC();
            /**************************************
             * ����� ��õ �޴� ���� üũ��������  IP �߰� 
             ***************************************/
            String remIP = (String)req.getSession(false).getAttribute("remoteIP");
            //Vector vcMenuCodeData = rfc_MenuList.getMenuList(user.e_authorization, user.e_authorization2);//20141125 [CSR ID:2651528] �λ���� �߰� �� �޴���ȸ ��� ����
            MenuInputData inputData = new MenuInputData();
            inputData.setI_PERNR(user.empNo);
            inputData.setI_IP(remIP);

            Vector menuList = rfc_MenuList.getMenuList(inputData);

            Map<String, Vector<MenuCodeData>> menuMap = rfc_MenuList.getMenuMap(menuList);

            req.setAttribute("menuMap", menuMap);
            //Properties ptProgramCodeData = rfc_MenuList.getProgramList(user.e_authorization, user.e_authorization2);//20141125 [CSR ID:2651528] �λ���� �߰� �� �޴���ȸ ��� ����
            req.setAttribute("menuAllList" ,menuList);
            if (Utils.getSize(menuList) > 0) {
                dest = WebUtil.JspURL+"SiteMap.jsp";
            } else {
                String msg = "���� ������ �ִ� �޴��� �����ϴ�.";
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
