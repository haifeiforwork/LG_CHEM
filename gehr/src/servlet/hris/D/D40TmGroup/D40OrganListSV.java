/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  �μ�����													*/
/*   2Depth Name		:  ����														*/
/*   Program Name	:  																*/
/*   Program ID		:  D40OrganListPopSV.java								*/
/*   Description		:  ������ Ʈ�� ���� �μ� ã��								*/
/*   Note				:  																*/
/*   Creation			:  2017-12-08  ������                                          	*/
/*   Update				:  2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40OrganInfoData;
import hris.D.D40TmGroup.D40OrganInsertData;
import hris.D.D40TmGroup.rfc.D40OrganListRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import com.common.AjaxResultMap;
import com.common.Utils;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class D40OrganListSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        try{

            WebUserData user    = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);
            String orgOrTm  = WebUtil.nvl(req.getParameter("orgOrTm"));          //�Ⱓ
            String iSeqno  = WebUtil.nvl(req.getParameter("iSeqno"));          //�Ⱓ
            String I_DATUM  = WebUtil.nvl(req.getParameter("I_DATUM"));          //�Ⱓ
        	if( I_DATUM == null|| I_DATUM.equals("")) {
        		I_DATUM = DataUtil.getCurrentDate();           //1��° ��ȸ��
            }
            D40OrganInsertData importOrg = box.createEntity(D40OrganInsertData.class);
            Vector<D40OrganInsertData> importOrgList = null;
            if(StringUtils.isNotBlank(importOrg.OBJID)) {
            	importOrgList = Utils.asVector(importOrg);
            }
            I_DATUM = I_DATUM.replace(".","");
            String I_SELTAB = req.getParameter("I_SELTAB");
            D40OrganListRFC func = new D40OrganListRFC();
            Vector<D40OrganInfoData> resultList = func.getOrganList(user.empNo, "M", I_DATUM, I_SELTAB, importOrgList);    //���� �κ� �ֱ�....

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
                req.setAttribute("orgOrTm", orgOrTm);
                req.setAttribute("iSeqno", iSeqno);
                req.setAttribute("I_SELTAB", I_SELTAB);

                if("B".equals(req.getParameter("popCode"))) {
                    printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40OrganListPopIF.jsp");
                } else {
                    printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40OrganListLeftIF.jsp");
                }

            }
        } catch(Exception e) {
            Logger.error(e);
            throw new GeneralException(e);
        }
    }

}
