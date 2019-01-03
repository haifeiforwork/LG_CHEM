/*
 * ÀÛ¼ºµÈ ³¯Â¥: 2005. 1. 28.
 *
 */
package servlet.hris.G;


import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.PageUtil;
import com.sns.jdf.util.WebUtil;
import hris.G.G001Approval.ApprovalDocList;
import hris.G.G001Approval.ApprovalListKey;
import hris.G.G001Approval.rfc.G001ApprovalDocListRFC;
import hris.common.WebUserData;
import hris.common.rfc.UpmuCodeRFC;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Vector;

/**
 * @author ÀÌ½ÂÈñ
 *
 */
public class G002ApprovalIngDocListSV extends EHRBaseServlet
{

    /* (ºñJavadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void performTask(HttpServletRequest req, HttpServletResponse res)
            throws GeneralException {
        try{
            WebUserData user = WebUtil.getSessionUser(req);

            req.setAttribute("isLocal", WebUtil.isLocal(req));

            ApprovalListKey aplk    =   new ApprovalListKey();

            Box box = WebUtil.getBox(req);
            String jobid = box.get("jobid");
            String page  = box.get("page");

            if(StringUtils.isBlank(jobid)){
                aplk.I_BEGDA  =   DataUtil.getAfterDate( DataUtil.getCurrentDate() , -7);
                aplk.I_ENDDA  =   DataUtil.getCurrentDate();
            } else {
                box.copyToEntity(aplk);
            } // end if
            
            aplk.I_AGUBN =   "2";
            aplk.I_PERNR =   user.empNo;

            G001ApprovalDocListRFC aplRFC = new G001ApprovalDocListRFC();
            Vector<ApprovalDocList> resultList = aplRFC.getApprovalDocList(aplk);

            req.setAttribute("upmuList", ((new UpmuCodeRFC()).getUpmuCode(user.companyCode, user.empNo)));

            req.setAttribute("resultList", resultList);
            req.setAttribute("inputData", aplk);
            req.setAttribute("page", page);

            req.setAttribute("pu", new PageUtil(Utils.getSize(resultList), page , 10, 10));

            printJspPage(req, res, WebUtil.JspURL+"G/G002ApprovalIngDocList.jsp");

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}
