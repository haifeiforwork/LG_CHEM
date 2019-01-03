/********************************************************************************
*   Update       : [CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 2017-07-07 eunha
********************************************************************************/

package servlet.hris.N.orgstats;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.N.EHRComCRUDInterfaceRFC;
import hris.N.orgstats.GlobalPrsnData;
import hris.common.WebUserData;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Vector;

public class CommonOrgDetailSV    extends  EHRBaseServlet {


	private static final long serialVersionUID = 1L;

	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            Box box = WebUtil.getBox(req);
            String dest ="";
			//[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 start
            if(!checkMenuAuth(req, res, "MSS_TALE_POOL")) {//인재pool
				return;
			}
          //[CSR ID:3390354] 인사시스템 보안점검 미준수 사항 조치 end

           	box.put("I_ORGEH", box.get("orgcode"));
           	if(box.get("ichck_yeno").equals("Y")){
           	box.put("I_LOWERYN", box.get("ichck_yeno"));
           	}
        	box.put("I_JIKWI", box.get("gubun"));  //직위 구분
        	box.put("I_GUBUN", box.get("command"));
   		 	String deptNm =  box.get("deptnm");
           	String command = box.get("command");
           	box.put("I_AREA", box.get("searchRegion"));
           	String  I_INOUT = box.get("I_INOUT");
           	box.put("I_INOUT", I_INOUT);
           	//Logger.debug("box.get(>>>>>>>>>>>>>>>>>>"+box.get("checkBox"));
            Vector cb = box.getVector("checkBox");
            int dataSize = cb.size();

            Vector newVt = new Vector();
            for(int n = 0 ; n < dataSize ; n++){
            	GlobalPrsnData globalData = new GlobalPrsnData();
            	box.copyToEntity(globalData, n);
            	globalData.ZCODE = WebUtil.nvl((String)cb.get(n));
            	newVt.addElement(globalData);
            }

           	Logger.debug("newVt Common: >>>>>>>>>>>>>>>>>>>"+newVt);
           	//사업가후보 - 검색년도 설정
           	if("".equals(box.get("searchYear"))){
            	box.put("I_YEAR", DataUtil.getCurrentYear());
           	}else{
           		box.put("I_YEAR", box.get("searchYear"));
           	}

           //글로벌 인재 - 서브그룹 파라미터
           	if(!"".equals(box.get("subty"))){
            	box.put("I_GROUP", box.get("subty"));
           	}



   		Logger.debug("box : >>>>>>>>>>>>>>>>>>>"+box);
            EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
           	//String functionName = "ZHRC_RFC_GET_CINFO";
            String functionName = "ZGHR_RFC_GET_CINFO";

           	if("Y".equals(box.get("excel"))){
           	    dest = WebUtil.JspURL+"N/orgstats/orgcommon/OrgStatsDetailExcel.jsp";
           	}else{
           	    dest = WebUtil.JspURL+"N/orgstats/orgcommon/OrgStatsDetail.jsp";
           	}




           	if(command.equals("G1")  || command.equals("E")  || command.equals("0002")   || command.equals("01") || command.equals("02")  || command.equals("03") || command.equals("Z") ){
           		HashMap resultVT = comRFC.setExecutGetData(box, functionName, newVt, "I_IMPORT");
           		req.setAttribute("resultVT", resultVT);
           		Logger.debug("import input getdata : >>>>>>>>>>>>>>>>>>>"+resultVT);
           	}else{
           		HashMap resultVT = comRFC.getExecutAllTable(box, functionName,"RETURN");
           		req.setAttribute("resultVT", resultVT);
           		Logger.debug("resultVT : >>>>>>>>>>>>>>>>>>>"+resultVT);
           	}
            req.setAttribute("deptNm", deptNm);
            req.setAttribute("orgcode",  box.get("orgcode"));
            req.setAttribute("I_YEAR",  box.get("I_YEAR"));
            req.setAttribute("ichck_yeno",  box.get("ichck_yeno"));
            req.setAttribute("gubun",  box.get("gubun"));
            req.setAttribute("command",  box.get("command"));
         //   req.setAttribute("hidden_nation",  box.get("hidden_nation"));
        //    Logger.debug("year : >>>>>>>>>>>>>>>>>>>"+req.getAttribute("I_YEAR"));



            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}

