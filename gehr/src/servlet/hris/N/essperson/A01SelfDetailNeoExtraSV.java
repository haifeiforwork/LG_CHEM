package servlet.hris.N.essperson;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.A01SelfDetailArmyData;
import hris.A.A01SelfDetailPersonalData;
import hris.A.rfc.A01SelfDetailArmyRFC;
import hris.A.rfc.A01SelfDetailPersonalRFC;
import hris.A.rfc.A02SchoolDetailRFC;
import hris.common.WebUserData;
import hris.common.rfc.EmpListRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class A01SelfDetailNeoExtraSV extends EHRBaseServlet {

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        if(process(req, res, WebUtil.getSessionUser(req), "E"))
            printJspPage(req, res, WebUtil.JspURL+"N/essperson/A01SelfDetailNeoExtra.jsp");
    }

    protected boolean process(HttpServletRequest req, HttpServletResponse res, WebUserData user_m, String pageType) throws GeneralException {
        try{
           /* *//* �߰� ���� ��ȸ *//*
            A01SelfDetailExtraRFC extraRFC = new A01SelfDetailExtraRFC();
            A01SelfDetailExtraData extraData = Utils.indexOf(extraRFC.getPersonExtra(user_m.empNo, user_m.area.getMolga(), ""), 0, A01SelfDetailExtraData.class);
            req.setAttribute("extraData",  extraData);*/

        	//sapType�� �ٲٰ��� �Ҷ� start
        	/*EmpListRFC empListRFC = new EmpListRFC();
            String R_EMP_NO = empListRFC.getElofficePERNR(user_m.empNo);//����ڻ��
            SAPType sapType = g.getSapType();
            String molga =  user_m.area.getMolga();
            WebUserData userMolga = new WebUserData();

            if (!R_EMP_NO.equals(user_m.empNo)) {

            	sapType = SAPType.LOCAL;
            	molga ="41";
            	userMolga.setArea(Area.KR);
            }
            // �з»���


            A02SchoolDetailRFC scholfunc = new A02SchoolDetailRFC(sapType);
            req.setAttribute("schoolList", scholfunc.getSchoolDetail(R_EMP_NO, molga, ""));
            */
        	//sapType�� �ٲٰ��� �Ҷ� end

            A02SchoolDetailRFC scholfunc = new A02SchoolDetailRFC();
            req.setAttribute("schoolList", scholfunc.getSchoolDetail(user_m.empNo, user_m.area.getMolga(), ""));
            String I_CFORM = (String) req.getAttribute("I_CFORM");

            if(user_m.area == Area.KR) {

            /* ���νŻ�/�ּ� ��ȸ */
                A01SelfDetailPersonalRFC personalRFC = new A01SelfDetailPersonalRFC();
                A01SelfDetailPersonalData personalData = Utils.indexOf(personalRFC.getPersonal(user_m.empNo, user_m.area.getMolga(), I_CFORM), 0, A01SelfDetailPersonalData.class);
                req.setAttribute("personalData", personalData);

            /* �������� */
                A01SelfDetailArmyRFC armyFunc = new A01SelfDetailArmyRFC();
                A01SelfDetailArmyData armyData = Utils.indexOf(armyFunc.getArmyList(user_m.empNo, user_m.area.getMolga(), I_CFORM), 0, A01SelfDetailArmyData.class);
                req.setAttribute("armyData", armyData);

                req.setAttribute("pageType", pageType);
            }

            req.setAttribute("pageType", pageType);
            req.setAttribute("user", user_m);

            return true;
        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}