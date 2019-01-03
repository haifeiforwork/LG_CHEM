/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �λ�������ȸ                                                */
/*   Program Name : �λ��Ϻ� ��ȸ �� ���                                     */
/*   Program ID   : A01PersonalCardSV_m.java                                    */
/*   Description  : �λ��Ϻ� ��ȸ �� ����ϴ� class                           */
/*   Note         :                                                             */
/*   Creation     : 2005-01-12  ������                                          */
/*   Update       :  �����߰� C20140210_84209                            */
/*   Update       :  2014/05/30 ������   [CSR ID:2553584]  �λ��Ϻ� ��¹�� ����(PDF)                            */
/*                       //@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel                                                        */
/********************************************************************************/

package	servlet.hris.A;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.*;
import hris.A.rfc.*;
import hris.B.rfc.B01ValuateDetailCheckRFC;
import hris.C.C03LearnDetailData;
import hris.C.db.C03LearnDetailDB;
import hris.C.db.C03MapPernrData;
import hris.C.rfc.C04HrdLearnDetailRFC;
import hris.common.WebUserData;
import org.apache.commons.lang.StringUtils;
import servlet.hris.B.B01ValuateDetailSV;
import servlet.hris.C.C03LearnDetailSV;
import servlet.hris.C.C05FtestResultSV;
import servlet.hris.N.essperson.A01SelfDetailNeoPersonalSV;
import servlet.hris.N.essperson.A01SelfDetailNeoSV;
import servlet.hris.SApMSSViewSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A01PersonalCardSV_m extends A01SelfDetailNeoSV {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            WebUserData user_m = WebUtil.getSessionMSSUser(req);
            WebUserData user = WebUtil.getSessionUser(req);

            if(StringUtils.indexOf(user.e_authorization, 'H') < 0) {
                moveMsgPage(req, res, g.getMessage("MSG.COMMON.0060"), "top.close();");
            }

            req.setAttribute("I_CFORM", "X");

            /* SAP ���� �ѿ��� interface ���� ���� ��� �⺻ ���������� �Ѵ� */
            PersonalCardInterfaceData interfaceData = (PersonalCardInterfaceData) req.getSession().getAttribute(SApMSSViewSV.SAP_INTERFACE);
            PersonalCardInterfacePersonData personData = null;
            boolean isWeb = true;

            if(interfaceData != null) {
                personData = interfaceData.getPersonData(user_m.getEmpNo());
                isWeb = false;
            } else personData = new PersonalCardInterfacePersonData();

            /*�⺻ �λ� ���� Header*/
            if(isWeb || "X".equals(personData.getWB01()))
                process(req, res, user_m, "M");


            /* �߰� ����Ÿ ��ȸ - �λ��� ���� ���� ���ο��� ó�� */
            if((new A01SelfDetailNeoPersonalSV()).process(req, res, user_m, "M")) {
            	//[CSR ID:3516631] �±� ���� Roll in �� ���� Globlal HR Portal ���� ��û�� TH�߰�
            	if(user_m.area == Area.KR || user_m.area == Area.CN || user_m.area == Area.HK || user_m.area == Area.TW || user_m.area == Area.TH) {
                // ��������
                    if(isWeb || "X".equals(personData.getWS09())) {
                        A04FamilyDetailRFC familfunc = new A04FamilyDetailRFC();
                        Box box = WebUtil.getBox(req);
                        box.put("I_PERNR", user_m.empNo);
                        if(!isWeb) box.put("I_CFEDU", personData.WS09EDU);
                        Vector<A04FamilyDetailData> familyList = familfunc.getFamilyDetail(box);
                        req.setAttribute("familyList", familyList);
                    }
                } else {

            /* �߰� ���� ��ȸ */
                    A01SelfDetailExtraRFC extraRFC = new A01SelfDetailExtraRFC();
                    A01SelfDetailExtraData extraData = Utils.indexOf(extraRFC.getPersonExtra(user_m.empNo, user_m.area.getMolga(), "X"), 0, A01SelfDetailExtraData.class);
                    req.setAttribute("extraData", extraData);
                }

                if(isWeb || "X".equals(personData.getWB02())) {
                    // �з»���
                    A02SchoolDetailRFC scholfunc = new A02SchoolDetailRFC();
                    req.setAttribute("schoolList", scholfunc.getSchoolDetail(user_m.empNo, user_m.area.getMolga(), "X", personData.WB02GRAD));
                }

                if(isWeb || "X".equals(personData.getWB04())) {
                    A01SelfDetailLicenseRFC licenfunc = new A01SelfDetailLicenseRFC();
                    Vector<A01SelfDetailLicenseData> licenseList = licenfunc.getLicenseList(user_m.empNo, user_m.area.getMolga(), "X");
                    req.setAttribute("licenseList", licenseList);
                }
            }

            String check_A01 = (String) req.getAttribute("check_A01");

            if(isWeb || "X".equals(personData.getWS02())) {
            /* �߷� */
                (new A05AppointDetailSV()).process(req, res, WebUtil.getSessionMSSUser(req), "M", personData.WS02ORG);
            }

            B01ValuateDetailCheckRFC checkRFC =  new B01ValuateDetailCheckRFC();
            req.setAttribute("check_A02", checkRFC.getValuateDetailCheck(user.empNo, user_m.empNo, "A02", "M", user_m.area));

            /* ����/¡�� - �λ��� ���� ���δ� process �ȿ��� ó�� */
            (new A06PrizeNPunishSV()).process(req, res, WebUtil.getSessionMSSUser(req), "M");

            if(isWeb || "X".equals(personData.getWB05())) {
            /* ��� */
                (new A09CareerDetailSV()).process(req, res, WebUtil.getSessionMSSUser(req), "M");
            }

            if(isWeb || "X".equals(personData.getWS01())) {
             /* �򰡰�� */
                if ("Y".equals(check_A01)) {
                    (new B01ValuateDetailSV()).process(req, res, WebUtil.getSessionMSSUser(req), "M");
                }
            }

            if(isWeb || "X".equals(personData.getWB03())) {
            /* ���� */
                (new C05FtestResultSV()).process(req, res, WebUtil.getSessionMSSUser(req), "M");
            }

            /* ��޿���ó */
          //@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel 
            if(user_m.area == Area.US || user_m.area == Area.MX)
                (new A20EmergencyContactsListSV()).process(req, res, WebUtil.getSessionMSSUser(req), "M");

            if(isWeb || "X".equals(personData.getWS03())) {
                /* �ؿ� ���� */
                req.setAttribute("tripList", (new A01SelfTripFormRFC()).getSelfTripList(user_m.empNo, user_m.e_area, "X"));
            }

            if(isWeb || "X".equals(personData.getWS04())) {
                /* �ٽ����� */
                req.setAttribute("talentList", (new A01SelfTalentRFC()).getTalentList(user_m.empNo, user_m.e_area, "X"));
            }

            if(isWeb || "X".equals(personData.getWS05())) {
                /* �����̷� */
                C03MapPernrData c03MapPernrData = new C03MapPernrData();
                c03MapPernrData = C03LearnDetailSV.getMapPernr(g,  user_m.empNo,  "");
                req.setAttribute("training", (new C03LearnDetailDB()).getPersonalCardTrainingList(c03MapPernrData.PERNR, c03MapPernrData.BEGDA, isWeb ? "X" : personData.WS05MAN));

                //req.setAttribute("training", (new C04HrdLearnDetailRFC()).getTrainingList(user_m.empNo, "X", isWeb ? "X" : personData.WS05MAN));
            }


            req.setAttribute("printDate", DataUtil.getCurrentDate(req));

            req.setAttribute("pageConfig", interfaceData == null ? new PersonalCardInterfaceMainData() : interfaceData.getMain());

            printJspPage(req, res, WebUtil.JspURL+"A/A01PersonalCard_m.jsp?subView=true");
        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }
}
