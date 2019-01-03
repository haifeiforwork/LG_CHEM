/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ��������                                                    */
/*   Program Name : �������� ��ȸ                                               */
/*   Program ID   : A04FamilyDetailSV                                           */
/*   Description  : �������� ������ jsp�� �Ѱ��ִ� class                        */
/*   Note         :                                                             */
/*   Creation     : 2001-12-17  �赵��                                          */
/*   Update       : 2005-03-03  ������                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.A;

import com.common.AjaxResultMap;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.A04FamilyDetailData;
import hris.A.rfc.A04FamilyDetailRFC;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class A04FamilyCheckDuplicateSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            AjaxResultMap ajaxResultMap = new AjaxResultMap();

            Box box = WebUtil.getBox(req);

            final String comapreValue = DataUtil.removeSeparate(box.get("REGNO"));

            box.put("I_PERNR", getPERNR(box, WebUtil.getSessionUser(req)));

            Vector<A04FamilyDetailData> familyList = new A04FamilyDetailRFC().getFamilyDetail(box);

            A04FamilyDetailData family = (A04FamilyDetailData) CollectionUtils.find(familyList, new Predicate() {
                public boolean evaluate(Object o) {
                    return StringUtils.equals(((A04FamilyDetailData) o).REGNO, comapreValue);
                }
            });

            if (family != null) {
                ajaxResultMap.setErrorMessage(g.getMessage("MSG.A.A12.0007"));    //������ �ֹε�Ϲ�ȣ�� ���� ������ �̹� �����մϴ�.
            }

            ajaxResultMap.writeJson(res);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}