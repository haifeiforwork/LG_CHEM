/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ????                                                  */
/*   2Depth Name  : ???????? ??????                                           */
/*   Program Name : ???????? ??????                                           */
/*   Program ID   : A12FamilyBuildSV                                            */
/*   Description  : ???????? ????? ?? ?? ????? ??? Class                     */
/*   Note         :                                                             */
/*   Creation     : 2002-01-28  ????                                          */
/*   Update       : 2005-02-21  ??????                                          */
/*                      2018/01/05 rdcamel [CSR ID:3569665] 2017�� �������� ��ȭ�� ���� ��û�� ��                                                        */
/********************************************************************************/

package servlet.hris.A.A12Family;

import com.common.RFCReturnEntity;
import com.common.constant.Area;
import com.google.common.base.Predicate;
import com.google.common.collect.Collections2;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.CodeEntity;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.A.A04FamilyDetailData;
import hris.A.A12Family.A12FamilyListData;
import hris.A.A12Family.rfc.*;
import hris.A.A13Address.rfc.A13AddressNationRFC;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.Map;
import java.util.Vector;

public class A12FamilyBuildSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try {
            WebUserData user = WebUtil.getSessionUser(req);
            String dest = "";
            String jobid = "";
            String subty = "";
            String objps = "";
            String PERNR;

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid", "first");
            subty = box.get("SUBTY");
            objps = box.get("OBJPS");

            String screen = box.get("SCREEN", "A12");
            req.setAttribute("SCREEN", screen);

            Vector a12FamilyListData_vt = new Vector();

            Logger.debug.println(this, "[jobid] = " + jobid + " [user] : " + user.toString());


            /******************************
             *
             * @$ ���������� marco257
             * �븮��û ����üũ �߰�
             * user.e_representative;
             *
             ******************************/
            //�븮��û ������ �ִ� ��� �߰�
            PERNR = getPERNR(box, user);
            box.put("I_PERNR", PERNR);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData) numfunc.getPersonInfo(PERNR);

            if (jobid.equals("first")) {    // ����ó�� ��û ȭ�鿡 ���°��.

                // -------------------------------------------------------------------------------
                // 2002.08.07. ���������� �Է½� ������ ��ϵǾ� �ִ� ��������� check �ϵ��� �Ѵ�.

                if (user.area == Area.KR) {
                    A04FamilyDetailRFC func1 = new A04FamilyDetailRFC();
                    Vector a04FamilyDetailData_vt = func1.getFamilyDetail(box) ;

                    req.setAttribute("a04FamilyDetailData_vt", a04FamilyDetailData_vt);
                    req.setAttribute("familyRelationList", (new A12FamilyRelationRFC()).getFamilyRelation(""));
                    req.setAttribute("scholarShipList", (new A12FamilyScholarshipRFC()).getFamilyScholarship());

                    Vector<CodeEntity> subTypeList = (new A12FamilySubTypeRFC()).getFamilySubType();
                    subTypeList = new Vector<CodeEntity>(Collections2.filter(subTypeList, new Predicate<CodeEntity>() {
                        public boolean apply(CodeEntity codeEntity) {
                            return !StringUtils.equals("15", codeEntity.code);
                        }
                    }));
                    req.setAttribute("subTypeList", subTypeList);

                } else {
                    req.setAttribute("subTypeList", (new A12FamilyListRFC()).getFamilySubType(user.e_area));

                    Map familyEntry = ((new A12FamilyUtil()).getElements(user.empNo));
                    req.setAttribute("familyEntry", familyEntry.get("T_ITAB"));
                    req.setAttribute("familyEntry1", familyEntry.get("T_ITAB1"));
                    req.setAttribute("familyEntry4", familyEntry.get("T_ITAB4"));
                }


                req.setAttribute("PERNR", PERNR);
                req.setAttribute("PersonData", phonenumdata);
                req.setAttribute("PhoneNumData2", phonenumdata);
                // -------------------------------------------------------------------------------

                req.setAttribute("nationList", (new A13AddressNationRFC()).getAddressNation());


                if (Arrays.asList(Area.KR.getMolga(), Area.CN.getMolga(), Area.HK.getMolga(), Area.TW.getMolga()).contains(phonenumdata.getE_MOLGA())) {
                    dest = WebUtil.JspURL + "A/A12Family/A12FamilyBuild_" + user.area + ".jsp";
//                    dest = WebUtil.JspURL + "A/A12Family/A12FamilyBuild_HK.jsp";
                    printJspPage(req, res, dest);
                } else {
                    moveMsgPage(req, res, g.getMessage("MSG.COMMON.0060"), "history.back();"); //�������� ������ �����ϴ�.
                }

            } else if (jobid.equals("create")) {  // �Է¹�ư Ŭ��..

                A12FamilyListRFC rfc = new A12FamilyListRFC();
                //A12FamilyListData a12FamilyListData = new A12FamilyListData();
                A04FamilyDetailData a12FamilyListData = new A04FamilyDetailData();//[CSR ID:3569665]

                // �ּ� �Է�
                box.copyToEntity(a12FamilyListData);
                a12FamilyListData.PERNR = PERNR;                                      // ���
                a12FamilyListData.REGNO = DataUtil.removeSeparate(box.get("REGNO"));  // �ֹε�Ϲ�ȣ
                a12FamilyListData.BEGDA = DataUtil.getCurrentDate();

                a12FamilyListData_vt.addElement(a12FamilyListData);

                Logger.debug.println(this, "�������� ��û ������ : " + a12FamilyListData_vt.toString());

                // ??? RFC Call
                String objps_out = rfc.build(PERNR, subty, objps, a12FamilyListData_vt);
                RFCReturnEntity result = rfc.getReturn();

                if (!result.isSuccess()) {
                    moveMsgPage(req, res, result.MSGTX, "history.back(); ");
                } else {
//                    String url = "location.href = '" + WebUtil.ServletURL+"hris.A.A12Family.A04FamilyDetailSV?SUBTY="+subty+"&OBJPS="+objps_out+"&PERNR="+PERNR+"';";

                    if("E19".equals(screen))
                        moveMsgPage(req, res, "msg008", "top.close();");
                    else
                        moveMsgPage(req, res, "msg008", "location.href='" + WebUtil.ServletURL + "hris.A.A04FamilyDetailSV" + "';");
                }

            } else {
                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            Logger.debug.println(this, " destributed = " + dest);
            //printJspPage(req, res, dest);
        } catch (Exception e) {
            throw new GeneralException(e);
        } finally {

        }
    }
}
