/********************************************************************************
*   Update       : [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 2017-07-07 eunha
********************************************************************************/
package servlet.hris.N.orgstats.languageprsn;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
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

public class LanguagePrsnSV extends  EHRBaseServlet {


	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);
            //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
            if(!checkMenuAuth(req, res, "MSS_TALE_LANG")) { //어학우수
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
            String targetpage = EHRCommonUtil.nullToEmpty(box.get("targetpage"));
            String I_ITEM = EHRCommonUtil.nullToEmpty(box.get("I_ITEM"));

            //sub메뉴 셋팅 초기값 셋팅
            String initUrl = "N";
            if(command.equals("")){
            	orgCode = user.e_orgeh;
            	I_LOWERYN = "Y";
            	command ="PIS0040";
            	initUrl = "Y";
            }

            box.put("I_ORGEH", orgCode);
            box.put("I_LOWERYN", I_LOWERYN);
            box.put("I_DATUM", DataUtil.getCurrentDate());
            box.put("I_GUBUN", command);
            box.put("I_ITEM", I_ITEM);
            Logger.debug(" I_GUBUN command >>>>>>>>>>>>>>>> "+ command);
           	Logger.debug(" I_ITEM  >>>>>>>>>>>>>>>> "+ I_ITEM);
           	Logger.debug(" I_ORGEH >>>>>>>>>>>>>>>> "+ orgCode);
           	Logger.debug(" I_LOWERYN >>>>>>>>>>>>>>>> "+ I_LOWERYN);
           	Logger.debug(" initUrl >>>>>>>>>>>>>>>> "+ initUrl);

            EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
           	//String functionName = "ZHRC_RFC_GET_LANG_CONDITION";
            String functionName = "ZGHR_RFC_GET_LANG_CONDITION";
           	HashMap resultVT = comRFC.getExecutAllTable(box, functionName,"RETURN");
       		req.setAttribute("resultVT", resultVT);

       		/*************************************
       		 * 초기에 sub메뉴값, 하위조직포함 체크 여부에
       		 * 따라 첫번째 sub메뉴값을 읽어온다.
       		 *************************************/
//       		if(initUrl.equals("Y") || targetpage.equals("main")){
//       			String firstITEM ="";
//       			String firstITEMTXT = "";
//       			HashMap<String, String> T_EXPORT = new HashMap<String, String>();
//       			Vector itemVT = (Vector)resultVT.get("T_ITEM");
//       			int itemSize = itemVT.size();
//       			if(itemSize > 0){
//       				T_EXPORT = (HashMap)itemVT.get(0);
//       				firstITEM = T_EXPORT.get("CODE");
//       				firstITEMTXT =  T_EXPORT.get("TEXT");
//       			}
//       		Logger.debug(" firstITEM >>>>>>>>>>>>> : "+firstITEM+" firstITEMTXT >>>>>>>>>>>>>>>> : "+firstITEMTXT);
//       			req.setAttribute("F_ITEM", firstITEM);
//       			req.setAttribute("F_ITEMTXT", firstITEMTXT);
//       		}

           	String dest = WebUtil.JspURL+"N/orgstats/comcontent/ComContentSubTabList.jsp";
           	if(initUrl.equals("N")){
	           	if(targetpage.equals("main")){
	           		dest = WebUtil.JspURL+"N/orgstats/languageprsn/LanguagePrsnFrame.jsp?T_ITEM="+I_ITEM;
	           	}else if(targetpage.equals("excel")){
	           		dest = WebUtil.JspURL+"N/orgstats/languageprsn/LanguagePrsnFrameExcel.jsp";
	           	}
           	}else{
           		//초기화면
           		dest = WebUtil.JspURL+"N/orgstats/languageprsn/LanguagePrsnFrame.jsp?checkYn=Y";
           	}

            req.setAttribute("checkYn", I_LOWERYN);
            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}

