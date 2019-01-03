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
 *  사원의 평가 사항을 조회할 수 있도록 하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2002/01/14
 *   Update       :  [CSR ID:3306654] 평가 결과 조회 권한 조정
 *  					@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
 *  					@PJ.베트남 하이퐁 법인 Rollout 프로젝트 추가 관련(Area = OT("99")) 2018/04/19 Kang DM.
 *                     2015-05-25 rdcamel //[CSR ID:3687969] 인사기록부상 해외법인명 한글병기 요청의 건
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
                //tab 권한 조회
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

            /* 1. 재입사자 여부 확인 - C100 일경우만 해당 */
            MappingPernrRFC mapfunc = new MappingPernrRFC();
            Vector<MappingPernrData> mapData_vt = null;

            if ("C100".equals(user_m.companyCode)) {
                mapData_vt = mapfunc.getPernr(user_m.empNo);
            }

            /* 1.1. 조회된 사번 리스트 - 없을 경우 기본 사번 */
            if (Utils.getSize(mapData_vt) == 0) {
                mapData_vt = new Vector<MappingPernrData>();
                MappingPernrData pernrData = new MappingPernrData();
                pernrData.PERNR = user_m.empNo;

                mapData_vt.add(pernrData);
            }

            /* 2. 사번에 해당하는  평가 정보 조회 - 평가 시스템*/
            B01ValuateDetailRFC func1 = new B01ValuateDetailRFC();
            Vector<B01ValuateDetailData> resultList = new Vector();

            for (MappingPernrData mapData : mapData_vt) {

                    /* RFC에서 평가데이타 조회 */
                Vector<B01ValuateDetailData> detailData_vt = null;
                /*[CSR ID:3306654] 평가 결과 조회 권한 조정 start* /
                 *[CSR ID:3687969] 인사기록부상 해외법인명 한글병기 요청의 건 으로 하위 로직으로 변경/
                if ("M".equals(pageType) && user.empNo.equals(mapData.PERNR)&& user.e_persk.equals("31") && user.e_titl2.equals("전문과장") && (user.e_btrtl.equals("BAAE") ||user.e_btrtl.equals("BAAD")||user.e_btrtl.equals("BAAC")||
                		user.e_btrtl.equals("CABA")||user.e_btrtl.equals("BAGA")||user.e_btrtl.equals("BAAA")||user.e_btrtl.equals("BAAB")||user.e_btrtl.equals("BABA")||user.e_btrtl.equals("CABB")
                ))
                	detailData_vt = func1.getValuateDetail(mapData.PERNR,  "", "", I_CFORM, null);
                /*[CSR ID:3306654] 평가 결과 조회 권한 조정 end* /
                else if("M".equals(pageType)) detailData_vt = func1.getValuateDetail(mapData.PERNR, "Y" , user.empNo, I_CFORM, null);
                else detailData_vt = func1.getValuateDetail(mapData.PERNR,  "", "", I_CFORM, null);  */
                
                
                //[CSR ID:3687969] 인사기록부상 해외법인명 한글병기 요청의 건
                if ("M".equals(pageType) && user.empNo.equals(mapData.PERNR)&& user.e_persk.equals("31") && user.e_titl2.equals("전문과장") && (user.e_btrtl.equals("BAAE") ||user.e_btrtl.equals("BAAD")||user.e_btrtl.equals("BAAC")||
                		user.e_btrtl.equals("CABA")||user.e_btrtl.equals("BAGA")||user.e_btrtl.equals("BAAA")||user.e_btrtl.equals("BAAB")||user.e_btrtl.equals("BABA")||user.e_btrtl.equals("CABB")
                ))
                	detailData_vt = func1.getValuateDetailLong(mapData.PERNR,  "", "", I_CFORM, null);
                else if("M".equals(pageType)) detailData_vt = func1.getValuateDetailLong(mapData.PERNR, "Y" , user.empNo, I_CFORM, null);
                else detailData_vt = func1.getValuateDetailLong(mapData.PERNR,  "", "", I_CFORM, null);

                    /* 평가시스템에 데이타 여부 확인 및 Link FLag 처리 */
                if (user_m.area == Area.KR) {
                    Vector<B01ValuateDBData> valuData_vt = valuateDetailDB.getDetail(mapData.PERNR);

                    for (B01ValuateDetailData row : detailData_vt) {

                        for (B01ValuateDBData dbData : valuData_vt) {
                            /* 3. RFC 조회 RFC에 년도가 3에서 조회된 연도가 존재할 경우 FLAG = 3번의 EVAL_YORN */
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

          //@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel
          //@PJ.베트남 하이퐁 법인 Rollout 프로젝트 추가 관련(Area = OT("99") && companyCode(G580) ) 2018/04/19 Kang DM
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
