/*
 * 작성된 날짜: 2005. 2. 26.
 *
 */
package servlet.hris.G;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;
import hris.common.WebUserData;
import hris.common.util.DocumentInfo;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @author 이승희
 *
 */
public class G000ApprovalDocMapSV extends EHRBaseServlet
{

    /* (비Javadoc)
     * @see com.sns.jdf.servlet.EHRBaseServlet#performTask(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    protected void performTask(HttpServletRequest req, HttpServletResponse res)
            throws GeneralException
    {
        String dest  = "";
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            
            String jobid = "";
            Box box = WebUtil.getBox(req);
            
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);
            
            jobid = box.get("jobid");
            String AINF_SEQN       = box.get("AINF_SEQN");
            boolean isEditAble = box.getBoolean("isEditAble");

            
            Logger.debug.println(this ,"RequestPageName:"+RequestPageName+"AINF_SEQN:"+AINF_SEQN);            
            String detailPage = makeDetailPageURL(AINF_SEQN ,user.empNo ,RequestPageName ,isEditAble);
            
            Logger.debug.println(this ,"detailPage  = " + detailPage);
            
            if (detailPage == null ||  detailPage.equals("")) {
                String msg = " 해당 문서에 접근 할 수 없습니다.";
                String url = "history.back();";
                req.setAttribute("msg", msg);
                req.setAttribute("url", url);
                dest =  WebUtil.JspURL+"common/msg.jsp";
                printJspPage(req ,res ,dest);
            } else {
                Logger.debug.println(this," location.href = '" + detailPage +  "';");
                dest = detailPage;
                res.sendRedirect(dest);
            } // end if
        } catch(Exception e) {
            Logger.debug.println(this ,e);
            throw new GeneralException(e);
        } 
    }

    private String makeDetailPageURL(String AINF_SEQN ,String empNo ,String requestName ,boolean isEditAble) throws GeneralException {
        
        StringBuffer detailPage = new StringBuffer(256);
        // 현재 결재자 구분
        DocumentInfo docInfo = new DocumentInfo(AINF_SEQN ,empNo ,isEditAble);
        if (!docInfo.isHaveAuth()) {
            Logger.info.println(this ,empNo + "는 " + AINF_SEQN + " 문서에 접근할 수 없습니다");
            return null;
        } // end if
        Logger.debug.println(this ," UPMU_TYPE = " + docInfo.getUPMU_TYPE() + " \t type = " + docInfo.getType());
//        return WebUtil.makeGotoUrl(docInfo.getUPMU_TYPE() ,docInfo.getType() ,AINF_SEQN ,requestName);

        return WebUtil.approvalMappingURL(docInfo, AINF_SEQN, requestName);
    }

}
