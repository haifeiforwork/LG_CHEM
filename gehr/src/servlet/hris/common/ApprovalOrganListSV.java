/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 조직도 검색                                                 */
/*   Program ID   : OrganListSV.java                                            */
/*   Description  : 조직도 검색하는 include 파일                                */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-20 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
  
package servlet.hris.common;

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

/**
 * OrganListSV
 * 부서에 따른 전체 부서정보를 가져오는 
 * OrganListRFC 를 호출하는 서블릿 class
 *
 * @author  유용원
 * @version 1.0
 */
public class ApprovalOrganListSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{

            WebUserData user    = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            OrganInsertData importOrg = box.createEntity(OrganInsertData.class);
            Vector<OrganInsertData> importOrgList = null;
            if(StringUtils.isNotBlank(importOrg.OBJID)) importOrgList = Utils.asVector(importOrg);

            OrganListRFC func = new OrganListRFC();
            Vector<OrganInfoData> resultList = func.getOrganList(user.empNo, "M", importOrgList);    //권한 부분 넣기....

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
                printJspPage(req, res, WebUtil.JspURL + "common/ApprovalOrganListLeftIF.jsp");
            }
        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

}