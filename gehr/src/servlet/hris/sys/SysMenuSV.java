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
public class SysMenuSV extends EHRBaseServlet {

    /* (비Javadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            MenuInputData menuInputData = box.createEntity(MenuInputData.class);
            menuInputData.I_PERNR = user.empNo;
            menuInputData.I_IP  = user.remoteIP;

           /* if(WebUtil.isLocal(req)) {
                menuInputData.setI_ADMIN("X");

            }*/

            menuInputData.setI_BUKRS(user.companyCode);

            SysMenuListRFC menuRFC = new SysMenuListRFC();
            Vector<MenuCodeData> menuList = menuRFC.getMenuList(menuInputData);

            Map<String, Vector<MenuCodeData>> menuMap = menuRFC.getMenuMap(menuList);

            if(Utils.getSize(menuList) == 0) {
                moveMsgPage(req, res, "접근 권한이 있는 메뉴가 없습니다.", "history.back();");
                return;
            } // end if

            req.setAttribute("menuMap", menuMap);
            req.setAttribute("menuInputData", menuInputData);

//            /* 한국일 경우만 */
//            if(user.area == Area.KR) {
//            /* 기본 인사 정보 확인 */
//                A01SelfDetailConfirmRFC confirmRfc = new A01SelfDetailConfirmRFC();
//                String ret = confirmRfc.getInsaConfirmTargetCheck(user.empNo);
//                Logger.debug.println(this, " getInsaConfirmTargetCheck = " + ret);
//                //[CSR ID:2953938] 개인 인사정보 확인기능 구축 및 반영의 件
//                req.setAttribute("InsaInfoYN", ret);
//
//                /* 초기 팝업 여부 */
//                SysPopListRFC popListRFC = new SysPopListRFC();
//                HashMap initPop_hm = popListRFC.getPopupList(user.empNo);
//                req.setAttribute("initPop_hm", initPop_hm);
//            }
        } catch (Exception e) {
            Logger.debug(e.toString());
//            throw new GeneralException(e); //추가
        } finally {
            //추가
            printJspPage(req, res, WebUtil.JspURL + "sys/sysMenu.jsp");
        }
    } // end performTask
    

}
