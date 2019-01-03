package servlet.hris.N.common;

import com.common.AjaxResultMap;
import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.common.OrganInfoData;
import hris.common.OrganInsertData;
import hris.common.WebUserData;
import hris.common.rfc.OrganListRFC;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

public class CommonOrgTreeListSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{

            WebUserData user    = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            OrganInsertData importOrg = box.createEntity(OrganInsertData.class);
            Vector<OrganInsertData> importOrgList = null;
            if(StringUtils.isNotBlank(importOrg.OBJID)) importOrgList = Utils.asVector(importOrg);

            OrganListRFC func = new OrganListRFC();
            Vector<OrganInfoData> resultList = func.getOrganList(user.empNo, "M", importOrgList);    //권한 부분 넣기....

            /* 노드 조회시 ajax 요청 일 경우 */
            if("node".equals(box.get("jobid"))) {
                AjaxResultMap resultMap = new AjaxResultMap();
                if (func.getReturn().isSuccess()) {
                    resultMap.put("resultList", resultList);
                } else {
                    resultMap.setErrorMessage(func.getReturn().MSGTX);
                }

                resultMap.writeJson(res);
            } else {
                /* 일반 요청 일 경우 */
                req.setAttribute("resultList", resultList);
                printJspPage(req, res, WebUtil.JspURL + "N/vieworg/ViewOrgTreeList.jsp");

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
