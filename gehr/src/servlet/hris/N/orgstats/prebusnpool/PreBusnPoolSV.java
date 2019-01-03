/********************************************************************************
*   Update       : [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 2017-07-07 eunha
********************************************************************************/

package servlet.hris.N.orgstats.prebusnpool;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.N.EHRComCRUDInterfaceRFC;
import hris.N.EHRCommonUtil;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;

public class PreBusnPoolSV extends  EHRBaseServlet {

	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException  {

        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

			//[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
            if(!checkMenuAuth(req, res, "MSS_TALE_HPI")) {//예비사업가
				return;
			}
          //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end
            //하위 조직 여부 체크
            String I_LOWERYN = EHRCommonUtil.nullToEmpty(box.get("chck_yeno"));
            if(I_LOWERYN.equals("N")){
            	I_LOWERYN ="";
            }

            String orgCode = box.get("hdn_deptId");
            String command = box.get("command");
            box.put("I_ORGEH", orgCode);
            box.put("I_LOWERYN", I_LOWERYN);
            if("".equals(box.get("searchYear"))){
            	box.put("I_YEAR", DataUtil.getCurrentYear());
            }else{
            	box.put("I_YEAR", box.get("searchYear"));
            }
            box.put("I_GUBUN", command);
            EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
           	String functionName = "ZGHR_RFC_GET_BIZ_CAN_CONDITION"; //ZHRC_RFC_GET_BIZ_CAN_CONDITION";
           	String dest = WebUtil.JspURL+"N/orgstats/comcontent/ComContentPoolList.jsp";
           	String targetpage = EHRCommonUtil.nullToEmpty(box.get("targetpage"));
           	if(targetpage.equals("main")){
           		dest = WebUtil.JspURL+"N/orgstats/prebusnpool/PreBusnPoolFrame.jsp";
           	}else if(targetpage.equals("excel")){
           		dest = WebUtil.JspURL+"N/orgstats/prebusnpool/PreBusnPoolFrameExcel.jsp";
           	}
           if(!targetpage.equals("main")){
           		HashMap resultVT = comRFC.getExecutAllTable(box, functionName,"RETURN");
           		req.setAttribute("resultVT", resultVT);
           }

            req.setAttribute("checkYn", I_LOWERYN);
            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        }

	}
}

