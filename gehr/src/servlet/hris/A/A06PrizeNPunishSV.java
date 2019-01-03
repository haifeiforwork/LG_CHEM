/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : 포상/징계                                                   */
/*   Program Name : 포상 및 징계내역 조회                                       */
/*   Program ID   : A06PrizeNPunishSV                                           */
/*   Description  : 포상 및 징계내역을 보여주는 class                           */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-26  윤정현                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package servlet.hris.A;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A06PrizDetailData;
import hris.A.A07PunishResultData;
import hris.A.PersonalCardInterfaceData;
import hris.A.PersonalCardInterfacePersonData;
import hris.A.rfc.A06PrizDetailRFC;
import hris.A.rfc.A07PunishResultRFC;
import hris.common.WebUserData;
import servlet.hris.SApMSSViewSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A06PrizeNPunishSV extends EHRBaseServlet {


    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        WebUserData user = WebUtil.getSessionUser(req);

        if (process(req, res, user, "E"))
            printJspPage(req, res, WebUtil.JspURL + "A/A06PrizeNPunish_" + (user.area == Area.KR ? "KR" : "GLOBAL") + ".jsp");
    }

    public boolean process(HttpServletRequest req, HttpServletResponse res, WebUserData user_m, String pageType) throws GeneralException {
        try {
            Box box = WebUtil.getBox(req);

            PersonalCardInterfaceData interfaceData = (PersonalCardInterfaceData) req.getSession().getAttribute(SApMSSViewSV.SAP_INTERFACE);
            PersonalCardInterfacePersonData personData = null;
            if(interfaceData != null) personData = interfaceData.getPersonData(user_m.getEmpNo());
            else personData = new PersonalCardInterfacePersonData();

            String page = box.get("page");
            Logger.debug.println(this, "servlet Page : " + page);
            if (page == null || page.equals("")) {
                page = "1";
            }

            //2016-03-08 [CSR ID:2995203] 보상명세서 적용(Total Compensation)
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            A06PrizDetailRFC func1 = new A06PrizDetailRFC();
            A07PunishResultRFC func2 = new A07PunishResultRFC();

            String I_CFORM = (String) req.getAttribute("I_CFORM");

            Vector<A06PrizDetailData> prizeList = null;
            Vector<A07PunishResultData> punishList = null;

            if( "X".equals(personData.getWS06())) {

                prizeList = func1.getPrizDetail(user_m.empNo, I_CFORM, personData.WS06MAN, personData.WS06REC);
            } else prizeList = new Vector<A06PrizDetailData>();

            if( "X".equals(personData.getWS07())) {
                punishList = func2.getPunish(user_m.empNo, I_CFORM, (String) req.getAttribute("check_A02"));
            } else punishList = new Vector<A07PunishResultData>();

            ///////////  SORT    /////////////
            String sortField = box.get("sortField");
            String sortValue = box.get("sortValue");
            if (sortField == null || sortField.equals("")) {
                sortField = "BEGDA"; //신청일
            }
            if (sortValue == null || sortValue.equals("") || sortValue.equals("undefined")) {
                sortValue = "desc"; //정렬방법
            }

            prizeList = SortUtil.sort(prizeList, sortField, sortValue); //Vector Sort

            req.setAttribute("sortField", sortField);
            req.setAttribute("sortValue", sortValue);
            ///////////  SORT    /////////////

            req.setAttribute("page", page);

            req.setAttribute("prizeList", prizeList);
            req.setAttribute("punishList", punishList);

            req.setAttribute("pageType", pageType);
            req.setAttribute("user", user_m);

            return true;

        } catch (Exception e) {
            throw new GeneralException(e);
        }
    }
}
