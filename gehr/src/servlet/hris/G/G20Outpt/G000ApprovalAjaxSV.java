/*
 * �ۼ��� ��¥: 2005. 2. 26.
 *
 */
package servlet.hris.G.G20Outpt;

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
 * ��û ���� �� �������� �̵�
 */
public class G000ApprovalAjaxSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            Box box = WebUtil.getBox(req);

            String AINF_SEQN       = box.get("AINF_SEQN");
            String UPMU_TYPE       = box.get("UPMU_TYPE");

            req.setAttribute("I_APGUB", "1");   //'1' : ������ ���� , '2' : ������ ���� , '3' : ����Ϸ� ����

            String forwardPage = WebUtil.makeGotoUrl(UPMU_TYPE, DocumentInfo.EDIT_ENABLE, AINF_SEQN);

            if(StringUtils.isBlank(forwardPage)) {
                //�ش� �������� �������� �ʽ��ϴ�. �̵�
            }

            printJspPage(req, res, forwardPage);
        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        } 
    }

}
