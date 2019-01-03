/********************************************************************************/
/*
/*   System Name  : e-HR ��ȭ
/*   1Depth Name  :
/*   2Depth Name  :
/*   Program Name : G��Ż ���� �޴�
/*   Program ID   : EHRPortalMainSV
/*   Description  : ���� ������
/*   Note         :
/*   Creation     : 2015-05-19  marco257
/*   Update       :2016-01-04 [CSR ID:2953938] ���� �λ����� Ȯ�α�� ���� �� �ݿ��� ��
/*
/********************************************************************************/
package servlet.hris.N.ehrptmain;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.N.EHRComCRUDInterfaceRFC;
import hris.N.ehrptmain.EHRPortalMainRFC;
import hris.N.essperson.A01SelfDetailConfirmRFC;
import hris.common.WebUserData;
import hris.common.rfc.GetPhotoURLRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Vector;

public class EHRPortalMainSV extends  EHRBaseServlet {


	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

            // ���� URL
            String dest  = "";
            GetPhotoURLRFC func = new GetPhotoURLRFC();
            String imgUrl = func.getPhotoURL( user.empNo );//������ũ �߰�
            req.setAttribute("imgUrl", imgUrl);
            //Logger.debug("imgUrl :" + imgUrl);
            EHRPortalMainRFC mtRFC = new EHRPortalMainRFC();
            // ���� �ް�, �μ��ް�


            Vector vcInit = mtRFC.getInitViewData(user.empNo ,user.e_objid ,user.e_authorization);
            req.setAttribute("viewData", vcInit);

            // ����� �ʰ� �ٹ��ð�
            // 2015-09-15 ���� : �μ��� or ������ ��� - ���� ���� ������ ��� �ʰ��ٹ��ð�
            String cDate = DataUtil.getCurrentDate();
            Vector mtVT = mtRFC.getOverTime(user.empNo, user.e_objid , user.e_authorization, cDate);
            req.setAttribute("otData", mtVT);
            Logger.debug(">>>>>>>>>>>>>>> : "+mtVT);


            // ���޴� �߰�
            //Logger.debug(user);
            HashMap qmVT =  mtRFC.getQuickMenu(user.empNo,  user.e_persk, user.e_titl2);
            req.setAttribute("qmVTData", qmVT);

            // �ʱ� �˾� ����
            EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
            box.put("I_PERNR", user.empNo);
            box.put("I_DATUM", DataUtil.getCurrentDate());
            box.put("I_CODE", "0001");
            HashMap initPop_hm = comRFC.getReturnST(box, "ZHRC_RFC_GET_POPUP_LIST", "T");
            req.setAttribute("initPop_hm", initPop_hm);

            A01SelfDetailConfirmRFC confirmRfc = new A01SelfDetailConfirmRFC();
        	String ret = confirmRfc.getInsaConfirmTargetCheck(user.empNo);
        	Logger.debug.println(this, " getInsaConfirmTargetCheck = " + ret);
            //[CSR ID:2953938] ���� �λ����� Ȯ�α�� ���� �� �ݿ��� ��
            req.setAttribute("InsaInfoYN", ret);

            dest = WebUtil.JspURL+"N/ehrptmain/EHRPortalMain.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}