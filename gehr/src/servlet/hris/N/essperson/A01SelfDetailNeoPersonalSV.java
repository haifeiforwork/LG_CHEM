package servlet.hris.N.essperson;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.A01SelfDetailArmyData;
import hris.A.A01SelfDetailPersonalData;
import hris.A.PersonalCardInterfaceData;
import hris.A.PersonalCardInterfacePersonData;
import hris.A.rfc.A01SelfDetailArmyRFC;
import hris.A.rfc.A01SelfDetailPersonalRFC;
import hris.common.WebUserData;
import servlet.hris.SApMSSViewSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 개인 신상 및 병역
 */
public class A01SelfDetailNeoPersonalSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        //Connection con = null;

        if(process(req, res, WebUtil.getSessionUser(req), "E"))
            printJspPage(req, res, WebUtil.JspURL+"N/essperson/A01SelfDetailNeoPersonal.jsp");
	}

    public boolean process(HttpServletRequest req, HttpServletResponse res, WebUserData user_m, String pageType) throws GeneralException {
        try{

            String I_CFORM = (String) req.getAttribute("I_CFORM");

            PersonalCardInterfaceData interfaceData = (PersonalCardInterfaceData) req.getSession().getAttribute(SApMSSViewSV.SAP_INTERFACE);
            PersonalCardInterfacePersonData personData = null;

            if(interfaceData != null) personData = interfaceData.getPersonData(user_m.getEmpNo());
            else personData = new PersonalCardInterfacePersonData();

            if(user_m.area == Area.KR) {

                if("X".equals(personData.getWS08())) {
            /* 개인신상/주소 조회 */
                    A01SelfDetailPersonalRFC personalRFC = new A01SelfDetailPersonalRFC();
                    A01SelfDetailPersonalData personalData = Utils.indexOf(personalRFC.getPersonal(user_m.empNo, user_m.area.getMolga(), I_CFORM), 0, A01SelfDetailPersonalData.class);
                    req.setAttribute("personalData", personalData);
                }
                if("X".equals(personData.getWS10())) {
            /* 병역사항 */
                    A01SelfDetailArmyRFC armyFunc = new A01SelfDetailArmyRFC();
                    A01SelfDetailArmyData armyData = Utils.indexOf(armyFunc.getArmyList(user_m.empNo, user_m.area.getMolga(), I_CFORM), 0, A01SelfDetailArmyData.class);
                    req.setAttribute("armyData", armyData);
                }
                req.setAttribute("pageType", pageType);
            }

            req.setAttribute("user", user_m);

            return true;

        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

}