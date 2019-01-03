package servlet.hris.N.bsnrmd;

import com.common.AjaxResultMap;
import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.N.WebAccessLog;
import hris.N.bsnrmd.BusinRecommendRFC;
import hris.common.OrganInsertData;
import hris.common.WebUserData;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class BusinRecommendSV  extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{

            WebUserData user    = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            OrganInsertData importOrg = box.createEntity(OrganInsertData.class);
            Vector<OrganInsertData> importOrgList = null;
            if(StringUtils.isNotBlank(importOrg.OBJID)) importOrgList = Utils.asVector(importOrg);
            else {
                /**
                 * 사업가 후보 웹로그 추가 2015-08-21
                 * EADMIN 와 EMANAG로 시작하는 사용자는 제외 한다.
                 * 개발자,운영자,관리자는 웹로그 추가 제외임
                 */
                if(!user.user_group.equals("01") && !user.user_group.equals("02") && !user.user_group.equals("03")){
                    (new WebAccessLog()).setBusnAccessLog(user.empNo);
                }

            }

            BusinRecommendRFC func = new BusinRecommendRFC();
            Vector resultList 		= func.getOrganList(user.empNo, "M", importOrgList);	//권한 부분 넣기....


            if("node".equals(box.get("jobid"))) {
                AjaxResultMap resultMap = new AjaxResultMap();
                if (func.getReturn().isSuccess()) {
                    resultMap.put("resultList", resultList);
                } else {
                    resultMap.setErrorMessage(func.getReturn().MSGTX);
                }

                resultMap.writeJson(res);
            } else {
                req.setAttribute("resultList", resultList);

                printJspPage(req, res, WebUtil.JspURL+"N/bsnrmd/BusinRecommendOrgList.jsp");

                /*if( popCode.equals("V") ) // 초기화면의 조직도와 상세모두 보기.
                    dest = WebUtil.JspURL+"common/ViewOrganListLeftIF.jsp";
                else if( popCode.equals("A") ) // 조직도와 상세모두 보기.
                    dest = WebUtil.JspURL+"common/OrganListLeftIF.jsp";
                else // 조직도만 보기.
                    dest = WebUtil.JspURL+"common/OrganListPopIF.jsp";*/
            }
        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }

    }
    
}
