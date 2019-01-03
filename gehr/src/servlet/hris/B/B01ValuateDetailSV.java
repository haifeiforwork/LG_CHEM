package servlet.hris.B ;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.B.B01ValuateDBData;
import hris.B.B01ValuateDetailData;
import hris.B.db.B01ValuateDetailDB;
import hris.B.rfc.B01ValuateDetailCheckRFC;
import hris.B.rfc.B01ValuateDetailRFC;
import hris.common.MappingPernrData;
import hris.common.WebUserData;
import hris.common.rfc.MappingPernrRFC;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * B01ValuateDetailSV.java
 *  ����� �� ������ ��ȸ�� �� �ֵ��� �ϴ� Class
 *
 * @author �Ѽ���
 * @version 1.0, 2002/01/14
 *   Update       :  [CSR ID:3306654] �� ��� ��ȸ ���� ����
 *  					@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel
 *  					@PJ.��Ʈ�� ������ ���� Rollout ������Ʈ �߰� ����(Area = OT("99")) 2018/04/19 Kang DM.
 *                     2015-05-25 rdcamel //[CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��
 */
public class B01ValuateDetailSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        WebUserData user = WebUtil.getSessionUser(req);

        if(process(req, res, user, "E")) {
            printJspPage(req, res, WebUtil.JspURL + "B/B01ValuateDetail_" + req.getAttribute("evalSuffix") + ".jsp");
        }

    }


    public boolean process(HttpServletRequest req, HttpServletResponse res, WebUserData user_m, String pageType) throws GeneralException {

        try {
            WebUserData user = WebUtil.getSessionUser(req);

            String I_CFORM = (String) req.getAttribute("I_CFORM");

            B01ValuateDetailDB valuateDetailDB = null;
            if (user_m.area == Area.KR) {
                //tab ���� ��ȸ
                B01ValuateDetailCheckRFC checkRFC = new B01ValuateDetailCheckRFC();
                String check = checkRFC.getValuateDetailCheck(user.empNo, user_m.empNo, "A01", pageType);
                if (!"Y".equals(check))
                    moveMsgPage(req, res, g.getMessage("MSG.COMMON.0060"), "history.back();");

                valuateDetailDB = new B01ValuateDetailDB();
                String DB_YEAR = valuateDetailDB.getYEAR();
                String StartDate = valuateDetailDB.getStartDate();
                req.setAttribute("DB_YEAR", DB_YEAR);
                req.setAttribute("isBefore", Long.parseLong(StartDate) <= Long.parseLong(DataUtil.getCurrentDate()));
            }

            /* 1. ���Ի��� ���� Ȯ�� - C100 �ϰ�츸 �ش� */
            MappingPernrRFC mapfunc = new MappingPernrRFC();
            Vector<MappingPernrData> mapData_vt = null;

            if ("C100".equals(user_m.companyCode)) {
                mapData_vt = mapfunc.getPernr(user_m.empNo);
            }

            /* 1.1. ��ȸ�� ��� ����Ʈ - ���� ��� �⺻ ��� */
            if (Utils.getSize(mapData_vt) == 0) {
                mapData_vt = new Vector<MappingPernrData>();
                MappingPernrData pernrData = new MappingPernrData();
                pernrData.PERNR = user_m.empNo;

                mapData_vt.add(pernrData);
            }

            /* 2. ����� �ش��ϴ�  �� ���� ��ȸ - �� �ý���*/
            B01ValuateDetailRFC func1 = new B01ValuateDetailRFC();
            Vector<B01ValuateDetailData> resultList = new Vector();

            for (MappingPernrData mapData : mapData_vt) {

                    /* RFC���� �򰡵���Ÿ ��ȸ */
                Vector<B01ValuateDetailData> detailData_vt = null;
                /*[CSR ID:3306654] �� ��� ��ȸ ���� ���� start* /
                 *[CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� �� ���� ���� �������� ����/
                if ("M".equals(pageType) && user.empNo.equals(mapData.PERNR)&& user.e_persk.equals("31") && user.e_titl2.equals("��������") && (user.e_btrtl.equals("BAAE") ||user.e_btrtl.equals("BAAD")||user.e_btrtl.equals("BAAC")||
                		user.e_btrtl.equals("CABA")||user.e_btrtl.equals("BAGA")||user.e_btrtl.equals("BAAA")||user.e_btrtl.equals("BAAB")||user.e_btrtl.equals("BABA")||user.e_btrtl.equals("CABB")
                ))
                	detailData_vt = func1.getValuateDetail(mapData.PERNR,  "", "", I_CFORM, null);
                /*[CSR ID:3306654] �� ��� ��ȸ ���� ���� end* /
                else if("M".equals(pageType)) detailData_vt = func1.getValuateDetail(mapData.PERNR, "Y" , user.empNo, I_CFORM, null);
                else detailData_vt = func1.getValuateDetail(mapData.PERNR,  "", "", I_CFORM, null);  */
                
                
                //[CSR ID:3687969] �λ��Ϻλ� �ؿܹ��θ� �ѱۺ��� ��û�� ��
                if ("M".equals(pageType) && user.empNo.equals(mapData.PERNR)&& user.e_persk.equals("31") && user.e_titl2.equals("��������") && (user.e_btrtl.equals("BAAE") ||user.e_btrtl.equals("BAAD")||user.e_btrtl.equals("BAAC")||
                		user.e_btrtl.equals("CABA")||user.e_btrtl.equals("BAGA")||user.e_btrtl.equals("BAAA")||user.e_btrtl.equals("BAAB")||user.e_btrtl.equals("BABA")||user.e_btrtl.equals("CABB")
                ))
                	detailData_vt = func1.getValuateDetailLong(mapData.PERNR,  "", "", I_CFORM, null);
                else if("M".equals(pageType)) detailData_vt = func1.getValuateDetailLong(mapData.PERNR, "Y" , user.empNo, I_CFORM, null);
                else detailData_vt = func1.getValuateDetailLong(mapData.PERNR,  "", "", I_CFORM, null);

                    /* �򰡽ý��ۿ� ����Ÿ ���� Ȯ�� �� Link FLag ó�� */
                if (user_m.area == Area.KR) {
                    Vector<B01ValuateDBData> valuData_vt = valuateDetailDB.getDetail(mapData.PERNR);

                    for (B01ValuateDetailData row : detailData_vt) {

                        for (B01ValuateDBData dbData : valuData_vt) {
                            /* 3. RFC ��ȸ RFC�� �⵵�� 3���� ��ȸ�� ������ ������ ��� FLAG = 3���� EVAL_YORN */
                            if (StringUtils.equals(row.YEAR1, dbData.EVAL_YEAR)) {
                                row.L_FLAG = dbData.EVAL_YORN;
                                break;
                            }
                        }
                    }
                }

                resultList.addAll(detailData_vt);
            }


            req.setAttribute("evalList", resultList);

            req.setAttribute("pageType", pageType);
            req.setAttribute("user", user_m);

          //@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel
          //@PJ.��Ʈ�� ������ ���� Rollout ������Ʈ �߰� ����(Area = OT("99") && companyCode(G580) ) 2018/04/19 Kang DM
            String suffix;
            if (user_m.area == Area.KR) suffix = "KR";
            else if (user_m.area == Area.US || user_m.area == Area.DE || user_m.area == Area.PL || user_m.area == Area.MX || (user_m.area == Area.OT && user_m.companyCode.equals("G580")) ) suffix = "EU";
            else suffix = "GLOBAL";

            req.setAttribute("evalSuffix", suffix);

            return true;
        } catch (Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }

    }
}
