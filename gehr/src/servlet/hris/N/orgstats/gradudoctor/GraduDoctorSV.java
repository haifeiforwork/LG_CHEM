/********************************************************************************
*   Update       : [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 2017-07-07 eunha
********************************************************************************/
package servlet.hris.N.orgstats.gradudoctor;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.N.EHRComCRUDInterfaceRFC;
import hris.N.EHRCommonUtil;
import hris.N.orgstats.GlobalPrsnData;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Vector;

public class GraduDoctorSV extends  EHRBaseServlet {


	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);

			//[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
            if(!checkMenuAuth(req, res, "MSS_TALE_DOCT")) { //석박사
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
            box.put("I_DATUM", DataUtil.getCurrentDate());
            box.put("I_GUBUN", command);

            String I_AREA = EHRCommonUtil.nullToEmpty(box.get("searchRegion"));
            box.put("I_AREA", I_AREA);

            Vector cb = box.getVector("checkBox");
            int dataSize = cb.size();

            Vector newVt = new Vector();
            for(int n = 0 ; n < dataSize ; n++){
            	GlobalPrsnData globalData = new GlobalPrsnData();
            	box.copyToEntity(globalData, n);
            	globalData.ZCODE = WebUtil.nvl((String)box.getVector("checkBox").get(n));
            	newVt.addElement(globalData);
            }

            String I_INOUT = EHRCommonUtil.nullToEmpty(box.get("I_INOUT"));
            box.put("I_INOUT",I_INOUT);


            EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
           	String functionName = "ZGHR_RFC_GET_MBA_DR_CONDITION"; // "ZHRC_RFC_GET_MBA_DR_CONDITION";
           	String dest = WebUtil.JspURL+"N/orgstats/comcontent/ComContentList.jsp";
           	String targetpage = EHRCommonUtil.nullToEmpty(box.get("targetpage"));
           	if(targetpage.equals("main")){
           		dest = WebUtil.JspURL+"N/orgstats/gradudoctor/GraduDoctorFrame.jsp";
           	}else if(targetpage.equals("excel")){
           		dest = WebUtil.JspURL+"N/orgstats/gradudoctor/GraduDoctorFrameExcel.jsp";
           	}

           	/*Logger.debug(" I_GUBUN command >>>>>>>>>>>>>>>> "+ command);
           	Logger.debug(" I_GUBUN command >>>>>>>>>>>>>>>> "+ command);
           	Logger.debug(" I_ORGEH >>>>>>>>>>>>>>>> "+ orgCode);
           	Logger.debug(" I_LOWERYN >>>>>>>>>>>>>>>> "+ I_LOWERYN);
           	Logger.debug(" I_INOUT >>>>>>>>>>>>>>>> "+ I_INOUT);
           	Logger.debug(" box >>>>>>>>>>>>>>>> "+ box); */
           if(!targetpage.equals("main")){
        	     HashMap resultVT = comRFC.setExecutGetData(box, functionName, newVt, "I_IMPORT");
           		//HashMap resultVT = comRFC.getExecutAllTable(box, functionName,"RETURN");
           		req.setAttribute("resultVT", resultVT);
           }

            req.setAttribute("checkYn", I_LOWERYN);
            req.setAttribute("I_AREA", I_AREA);
            req.setAttribute("checkBox", cb);
            req.setAttribute("I_INOUT", I_INOUT);

            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}

