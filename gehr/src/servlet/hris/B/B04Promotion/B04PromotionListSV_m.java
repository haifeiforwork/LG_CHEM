package servlet.hris.B.B04Promotion;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;

import hris.B.B04Promotion.B04PromotionAData;
import hris.B.B04Promotion.B04PromotionCData;
import hris.B.B04Promotion.rfc.B04PromotionRFC;
import hris.C.db.C03LearnDetailDB;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * B04PromotionListSV_m.java
 * 진급자격요건에 대한 데이터를 jsp로 넘겨주는 class
 *  B04PromotionRFC를 호출하여 jsp로 정보를 넘겨준다.
 *
 * @author 이형석
 * @version 1.0, 2002/02/15
 * update [CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件  20171115 eunha
 */
public class B04PromotionListSV_m extends EHRBaseServlet {

    protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

        try {
            HttpSession session = req.getSession( false ) ;
            WebUserData user_m  = ( WebUserData ) session.getAttribute( "user_m" ) ;

            String jobid = "";
            String dest = "";

            WebUserData user = WebUtil.getSessionUser(req);

//          @웹취약성 추가
			if(!checkAuthorization(req, res)) {
				return;
			}

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");

            if( jobid.equals("") ){
                jobid = "first";
            }
			if(user_m != null) {
	            Logger.debug.println(this, "[jobid] = "+jobid + " [user_m] : "+user_m.toString());
			} else {
	            Logger.debug.println(this, "[jobid] = "+jobid + " [user_m] : null");
			}

            B04PromotionRFC func1  = new B04PromotionRFC();

            if(jobid.equals("first")) {

                /*req.setAttribute("topPage", WebUtil.ServletURL+"hris.B.B04Promotion.B04PromotionListSV_m?jobid=top");
                req.setAttribute("endPage", WebUtil.ServletURL+"hris.B.B04Promotion.B04PromotionListSV_m?jobid=end");*/

				B04PromotionCData data  = func1.getPromotionList(user_m.empNo);
				req.setAttribute("B04PromotionCData", data);
				req.setAttribute("result", func1.getReturn());

				Vector Pyunga1_vt       = data.PYUNGA_TAB;

				data.PYUNGA_TAB = SortUtil.sort( Pyunga1_vt , "PROM_YEAR", "asc");

				//[CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件 start
				C03LearnDetailDB c03LearnDetailDB=   new C03LearnDetailDB();
                Vector<B04PromotionAData> Edu_vt = c03LearnDetailDB.getPromotionCheck(user_m.empNo,data.E_PROM_CODE);
                Logger.debug.println("Edu_vt------"+Edu_vt);
              //[CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件 end
				req.setAttribute("Pyunga_vt", data.PYUNGA_TAB);
				req.setAttribute("Edu_vt", Edu_vt);//[CSR ID:3525660] 진급 시뮬레이션 Logic 수정 및 화면구현 요청 件 start
				req.setAttribute("PyunggaScore_vt", data.PYUNGGA_SCORE_TAB);
				req.setAttribute("Lang_vt", data.LANG_TAB);
				req.setAttribute("LangGijun_vt", data.LANG_GIJUN_TAB);

				req.setAttribute("result", func1.getReturn());

                dest = WebUtil.JspURL+"B/B04Promotion/B04PromotionDetail_m.jsp";

            } else if(jobid.equals("top")) {
       			if(user_m != null) {
					B04PromotionCData data  = func1.getPromotionList(user_m.empNo);
					req.setAttribute("B04PromotionCData", data);
					req.setAttribute("result", func1.getReturn());
				}
                dest = WebUtil.JspURL+"B/B04Promotion/B04Promotion01_m.jsp";

            } else if(jobid.equals("end")) {
       			if(user_m != null) {
					B04PromotionCData data  = func1.getPromotionList(user_m.empNo);

					Vector Pyunga1_vt       = data.PYUNGA_TAB;

					data.PYUNGA_TAB = SortUtil.sort( Pyunga1_vt , "PROM_YEAR", "asc");

					req.setAttribute("B04PromotionCData", data);
					req.setAttribute("Pyunga_vt", data.PYUNGA_TAB);
					req.setAttribute("Edu_vt", data.EDU_TAB);
					req.setAttribute("PyunggaScore_vt", data.PYUNGGA_SCORE_TAB);
					req.setAttribute("Lang_vt", data.LANG_TAB);
					req.setAttribute("LangGijun_vt", data.LANG_GIJUN_TAB);

					req.setAttribute("result", func1.getReturn());
				}
                dest = WebUtil.JspURL+"B/B04Promotion/B04Promotion02_m.jsp";


            } else if(jobid.equals("pop")) {
       			if(user_m != null) {
					B04PromotionCData data  = func1.getPromotionList(user_m.empNo);

					Vector Pyungatab_vt       = data.PYUNGA_TAB;
					Vector PyunggaScoretab_vt = data.PYUNGGA_SCORE_TAB;

					Vector Pyunga_vt = SortUtil.sort( Pyungatab_vt , "PROM_YEAR", "asc");

					req.setAttribute("Pyunga_vt", Pyunga_vt);
					req.setAttribute("PyunggaScore_vt", PyunggaScoretab_vt);
					req.setAttribute("B04PromotionCData", data);
				}
                 dest = WebUtil.JspURL+"B/B04Promotion/B04PromotionPop_m.jsp";

            } else {
               throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
            }

            printJspPage(req, res, dest);
            Logger.debug.println(this, " destributed = " + dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
		}
    }
}
