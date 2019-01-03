/********************************************************************************/
/*																																				*/
/*   System Name  : MSS														                                                        */
/*   1Depth Name  : MY HR ����                                                  																*/
/*   2Depth Name  : ��������                                                    																	*/
/*   Program Name : �������� ��ȸ                                               																*/
/*   Program ID     : A04FamilyDetailSV                                           													*/
/*   Description     : �������� ������ jsp�� �Ѱ��ִ� class                        												*/
/*   Note             :                                                             															*/
/*   Creation        : 2001-12-17  �赵��                                          															*/
/*   Update          : 2005-03-03  ������                                          															*/
/*                     @PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel               */
/*                     @PJ.��Ʈ�� ������ Rollout ������Ʈ �߰� ����(Area = OT("99") && companyCode='G580') 2018/04/04 Kang DMl               */
/********************************************************************************/

package	servlet.hris.A;

import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.A.A12Family.rfc.A12FamilyUtil;
import hris.A.A13Address.rfc.A13AddressNationRFC;
import hris.A.rfc.A04FamilyDetailRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.PersonInfoRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class A04FamilyDetailSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user   = (WebUserData)session.getAttribute("user");

            Box box = WebUtil.getBox(req, user);

            String dest = "";

            //@������ ���� �߰� 2015-08-19
            //�븮��û ������ �ִ� ��� �߰�
            String PERNR = getPERNR(box, user);
            box.put("I_PERNR", PERNR);

            // �븮 ��û �߰�
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData personData = numfunc.getPersonInfo(PERNR);

            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , personData );

            A04FamilyDetailRFC func1                  = new A04FamilyDetailRFC();

            req.setAttribute("a04FamilyDetailData_vt", func1.getFamilyDetail(box));

            if(user.area != Area.KR) {
                req.setAttribute("nationList", (new A13AddressNationRFC()).getAddressNation()); //CNATIO
//                req.setAttribute("nationList2", (new A13AddressNation2RFC()).getAddressNation());   //LAND

                req.setAttribute("familyEntry", (new A12FamilyUtil()).getElements(user.empNo));
            }

            //@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel
            //if(user.area == Area.US || user.area == Area.DE || user.area == Area.PL || user.area == Area.MX) {

            //@PJ.��Ʈ�� ������ Rollout ������Ʈ �߰� ����(Area = OT("99") && companyCode='G580') 2018/04/04 Kang DM
            if(user.area == Area.US || user.area == Area.DE || user.area == Area.PL || user.area == Area.MX || (user.area == Area.OT && user.companyCode.equals("G580"))) {
            	req.setAttribute("isEU", true);
                req.setAttribute("isUpdate", false);
                dest = WebUtil.JspURL+"A/A04FamilyDetail_EU.jsp";
            } else {
                req.setAttribute("isUpdate", true);
                dest = WebUtil.JspURL+"A/A04FamilyDetail_" + user.area + ".jsp";
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}