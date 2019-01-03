package servlet.hris.N.mssperson;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;
import hris.A.A01SelfDetailExtraData;
import hris.A.A01SelfDetailLicenseData;
import hris.A.A04FamilyDetailData;
import hris.A.rfc.A01SelfDetailExtraRFC;
import hris.A.rfc.A01SelfDetailLicenseRFC;
import hris.A.rfc.A02SchoolDetailRFC;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.common.WebUserData;
import servlet.hris.N.essperson.A01SelfDetailNeoPersonalSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * 개인 신상 및 병역
 */
public class A01SelfDetailNeoPersonalSV_m extends A01SelfDetailNeoPersonalSV {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        if(!checkAuthorization(req, res)) return;

        WebUserData user_m = WebUtil.getSessionMSSUser(req);

        if(process(req, res, user_m, "M")) {

            if(user_m.area == Area.KR) {
// 가족사항
                A04FamilyDetailRFC familfunc = new A04FamilyDetailRFC();
                Box box = WebUtil.getBox(req);
                box.put("I_PERNR", user_m.empNo);
                Vector<A04FamilyDetailData> familyList = familfunc.getFamilyDetail(box);;
                req.setAttribute("familyList", familyList);
            } else {
            /* 추가 사항 조회 */
                A01SelfDetailExtraRFC extraRFC = new A01SelfDetailExtraRFC();
                A01SelfDetailExtraData extraData = Utils.indexOf(extraRFC.getPersonExtra(user_m.empNo, user_m.area.getMolga(), ""), 0, A01SelfDetailExtraData.class);
                req.setAttribute("extraData", extraData);
            }



            // 학력사항
            A02SchoolDetailRFC scholfunc = new A02SchoolDetailRFC();
            req.setAttribute("schoolList", scholfunc.getSchoolDetail(user_m.empNo, user_m.area.getMolga(), ""));


            A01SelfDetailLicenseRFC licenfunc  = new A01SelfDetailLicenseRFC();
            Vector<A01SelfDetailLicenseData> licenseList = licenfunc.getLicenseList(user_m.empNo, user_m.area.getMolga(), "");
            req.setAttribute("licenseList", licenseList);

            printJspPage(req, res, WebUtil.JspURL+"N/mssperson/A01SelfDetailNeoPersonal_m.jsp");
        }
	}
}