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
import hris.common.util.DocumentInfo;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 신청 결재 상세 페이지로 이동
 */
public class G003ApprovalFinishDetailSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            Box box = WebUtil.getBox(req);

            String AINF_SEQN       = box.get("AINF_SEQN");
            String UPMU_TYPE       = box.get("UPMU_TYPE");

            req.setAttribute("I_APGUB", "3");   //'1' : 결재할 문서 , '2' : 결재중 문서 , '3' : 결재완료 문서

            String forwardPage =
                    StringUtils.substringBefore(WebUtil.makeGotoUrl(UPMU_TYPE, DocumentInfo.EDIT_ENABLE, AINF_SEQN, g.getSapType()), "?") ;

            if(StringUtils.isBlank(forwardPage)) {
                //해당 페이지가 존재하지 않습니다. 이동
                moveMsgPage(req, res, g.getMessage("MSG.COMMON.PAGE.NOT.FOUND"), "history.back();");
            }

            //결재 페이지 - 승인 취소시 사용
            req.setAttribute("approvalPage", StringUtils.substringBefore(WebUtil.makeGotoUrl(UPMU_TYPE, DocumentInfo.MUST_APPROVAL, AINF_SEQN, g.getSapType()), "?"));

            req.setAttribute("detailPage", StringUtils.substringBefore(forwardPage, "?"));
             /* 기본 g.getRequestPageName(req) 없을 시 결재할 문서  */
            req.setAttribute("RequestPageName", g.getRequestPageName(req, g.getServlet() + "hris.G.G003ApprovalFinishDocListSV"));

            printJspPage(req, res, forwardPage);
        } catch(Exception e) {
            Logger.debug.println(this ,e);
            throw new GeneralException(g.getMessage("MSG.COMMON.PAGE.NOT.FOUND"));
        }
    }

}
