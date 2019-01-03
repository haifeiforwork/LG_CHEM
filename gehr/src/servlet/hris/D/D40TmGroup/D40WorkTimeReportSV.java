/********************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : My HR	                                              		*/
/*   2Depth Name  : 부서근태		                                               	*/
/*   Program Name : 실근무 실적현황			                                  	*/
/*   Program ID   : D40WorkTimeReportSV		                                    */
/*   Description  : 실근무 관리 레포트를 조회하는 Class	                    		*/
/*   Note         :                                                             */
/*   Creation     : 2018-06-04  성환희	[WorkTime52] 실근무 관리 레포트 			*/
/*   Update       : 															*/
/*																				*/
/********************************************************************************/

package servlet.hris.D.D40TmGroup;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D25WorkTime.D25WorkTimeResultData;
import hris.D.D25WorkTime.rfc.D25WorkTimeLeaderReportRFC;
import hris.D.D40TmGroup.D40AbscTimeFrameData;
import hris.common.WebUserData;

/**
 * D40WorkTimeReportSV.java
 * 실근무 관리 레포트 정보를 jsp로 넘겨주는 class
 *
 */
public class D40WorkTimeReportSV extends EHRBaseServlet {
	
	protected void performTask(final HttpServletRequest req, final HttpServletResponse res) throws GeneralException {
		
		try {
			
			String dest = "";
			WebUserData user = WebUtil.getSessionUser(req);
			
			String LOGPER = user.empNo;

			Box box = WebUtil.getBox(req);

			String viewMode = box.get("viewMode");
			String orgOrTm = box.get("orgOrTm", "");
			String searchDeptNo = box.get("searchDeptNo", "");
			String searchDeptNm = box.get("searchDeptNm", "");
			String iSeqno = box.get("iSeqno", "");
			String ISEQNO = box.get("ISEQNO", "");
			String I_SELTAB = box.get("I_SELTAB", "");
			String SEARCH_DATE = box.get("SEARCH_DATE");				// 조회기준일
			
			D25WorkTimeLeaderReportRFC reportRFC = new D25WorkTimeLeaderReportRFC();
			
            Vector export = null;
            Vector<D25WorkTimeResultData> T_RESULT = new Vector<D25WorkTimeResultData>();
            
            Vector OBJID = new Vector();
			if("2".equals(orgOrTm)){		//근태그룹으로 선택하기
				String[] iSeqnos = ISEQNO.split(",");
				for(int i=0; i<iSeqnos.length; i++){
					D40AbscTimeFrameData data = new D40AbscTimeFrameData();
					if(!"".equals(iSeqnos[i])){
						data.OBJID = WebUtil.nvl(iSeqnos[i]);
						OBJID.addElement(data);
					}
				}
			}else{		//조직도로 선택하기
				String[] deptNos = searchDeptNo.split(",");
				for(int i=0; i<deptNos.length; i++){
					if(!"".equals(WebUtil.nvl(deptNos[i]))){
						D40AbscTimeFrameData data = new D40AbscTimeFrameData();
						data.OBJID = WebUtil.nvl(deptNos[i]);
						OBJID.addElement(data);
					}
				}
			}
            
        	if(SEARCH_DATE == null || SEARCH_DATE.equals("")) SEARCH_DATE = DataUtil.getCurrentDate();
        	export = reportRFC.getHReportByObjectTable(LOGPER, SEARCH_DATE, I_SELTAB, OBJID);
        	
        	T_RESULT = (Vector<D25WorkTimeResultData>) export.get(0);
            
            if(reportRFC.getReturn().isSuccess()) {
                req.setAttribute("T_RESULT", T_RESULT);

                req.setAttribute("orgOrTm", orgOrTm);
                req.setAttribute("searchDeptNo", searchDeptNo);
                req.setAttribute("searchDeptNm", searchDeptNm);
                req.setAttribute("iSeqno", iSeqno);
                req.setAttribute("ISEQNO", ISEQNO);
                req.setAttribute("I_SELTAB", I_SELTAB);
                req.setAttribute("SEARCH_DATE", SEARCH_DATE);
                
                if(viewMode.equals("excel")) {
                	dest = WebUtil.JspURL + "D/D40TmGroup/D40WorkTimeReportExcel.jsp";
                } else {
                	dest = WebUtil.JspURL + "D/D40TmGroup/D40WorkTimeReport.jsp";
                }
            } else {
            	String msg = reportRFC.getReturn().MSGTX;
                String url = "history.back();";
		        req.setAttribute("msg", msg);
		        req.setAttribute("url", url);
		        dest = WebUtil.JspURL+"common/caution.jsp";
            }

			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new GeneralException(e);
		}
		
	}

}
