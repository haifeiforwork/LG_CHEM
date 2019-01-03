/********************************************************************************
*   Update       : [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ 2017-07-07 eunha
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
            //[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ start
            if(!checkMenuAuth(req, res, "MSS_TALE_LANG")) { //���п��
				return;
			}
          //[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ end
            //���� ���� ���� üũ
            String I_LOWERYN = EHRCommonUtil.nullToEmpty(box.get("chck_yeno"));
            if(I_LOWERYN.equals("N")){
            	I_LOWERYN ="";
            }

            String orgCode = box.get("hdn_deptId");
            String command = box.get("command");
            String targetpage = EHRCommonUtil.nullToEmpty(box.get("targetpage"));
            String I_ITEM = EHRCommonUtil.nullToEmpty(box.get("I_ITEM"));

            //sub�޴� ���� �ʱⰪ ����
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
       		 * �ʱ⿡ sub�޴���, ������������ üũ ���ο�
       		 * ���� ù��° sub�޴����� �о�´�.
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
           		//�ʱ�ȭ��
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

