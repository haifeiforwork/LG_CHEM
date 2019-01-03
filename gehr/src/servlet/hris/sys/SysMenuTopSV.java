/*
 * 작성된 날짜: 2005. 1. 12.
 *
 */
package servlet.hris.sys;

import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
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

/**
 * @author 이승희
 * 
 * 
 */
public class SysMenuTopSV extends EHRBaseServlet {

    /* (비Javadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            MenuInputData menuInputData = box.createEntity(MenuInputData.class);
            /*
            menuInputData.I_PERNR = user.empNo;
            menuInputData.I_IP  = (String) req.getSession().getAttribute("remoteIP");
            */
            menuInputData.setI_ADMIN("X");
            menuInputData.setI_BUKRS(user.companyCode);

            SysMenuListRFC menuRFC = new SysMenuListRFC();
            Vector<MenuCodeData> menuList = menuRFC.getMenuList(menuInputData);
            Logger.debug("======= menuList : " + menuList);
            Map<String, Vector<MenuCodeData>> menuMap = menuRFC.getMenuMap(menuList);
            Logger.debug("====== menuMap : " + menuMap);
            if(Utils.getSize(menuList) == 0) {
                moveMsgPage(req, res, "접근 권한이 있는 메뉴가 없습니다.", "history.back();");
                return;
            } // end if

            req.setAttribute("menuMap", menuMap);
            req.setAttribute("menuInputData", menuInputData);

        } catch (Exception e) {
            Logger.debug(e.toString());
//            throw new GeneralException(e); //추가
        } finally {
            //추가
            printJspPage(req, res, WebUtil.JspURL + "sys/sysMenuTop.jsp");
        }
    } // end performTask
    

}
