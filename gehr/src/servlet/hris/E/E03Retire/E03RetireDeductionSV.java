/******************************************************************************/
/*                                                                              */
/*   System Name  : ESS                                                         */
/*   1Depth Name  : 퇴직연금                                               */
/*   2Depth Name  : 퇴직연금 추가납입                                                 */
/*   Program Name : 퇴직연금 추가납입                               */
/*   Program ID   : E03RetireDeductionSV                                         */
/*   Description  : 퇴직연금 추가납입 서블릿                                  */
/*   Note         :                                               */
/*   Creation     : 2010-07-07 박민영                                           */
/*   Update       : 2010-07-12 siyakim                                                            */
/*                                                                              */
/*                                                                              */
/********************************************************************************/

package servlet.hris.E.E03Retire;

//퇴직연금 추가납입 저장

import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.rfc.*;

import hris.E.E03Retire.*;
import hris.E.E03Retire.rfc.*;
import hris.common.WebUserData;

public class E03RetireDeductionSV extends EHRBaseServlet 
{
    private String UPMU_TYPE ="54";	//업무유형코드
    private static String UPMU_SUBTYPE ="01";	//하부유형    
    
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		// TODO Auto-generated method stub
		Logger.debug.println("request = " + req.getRemoteAddr() + ":" + req.getRemoteHost());
		
		try {

            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getAttribute("user");

            String dest = "";
            String jobid = "";
            String PERNR;

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }
            PERNR = box.get("PERNR");
            if (PERNR == null || PERNR.equals("")) {
                PERNR = user.empNo;
            } // end if

            String retireType = new E03RetireGubunRFC().getRetireGubunInfo(user.empNo);
        	req.setAttribute("retireType", retireType);   
            
        	// 대리 신청 추가
            PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata = (PersonData)numfunc.getPersonInfo(PERNR);
            req.setAttribute("PERNR" , PERNR );
            req.setAttribute("PersonData" , phonenumdata );
            
            if(retireType.equalsIgnoreCase("DB") || retireType.equalsIgnoreCase("")){
                dest = WebUtil.JspURL+"E/E03Retire/E03RetireDeduction.jsp";  
            }else{
            	boolean retirePeriod = new E03RetirePeriodRFC().getRetirePeriodInfo(user.companyCode, UPMU_TYPE, UPMU_SUBTYPE);
	            req.setAttribute("retirePeriod", retirePeriod+"");//신청 기간 체크  
	            
	            if(jobid.equalsIgnoreCase("first")) { 
		            E03RetireDeductionInfoData data = new E03RetireDeductionInfoRFC().getCurrRetireInfo(user.empNo);
	                req.setAttribute("jobid", jobid);
	                
	                //원화이므로 100을 곱한다.
	                data.BETRG_0015=Double.toString(Double.parseDouble(data.BETRG_0015) * 100.0 );	//당월공제
	                data.BETRG_0014=Double.toString(Double.parseDouble(data.BETRG_0014) * 100.0 );	//반복공제
	                
	                req.setAttribute("E03RetireDeductionInfoData", data);  
	                dest = WebUtil.JspURL+"E/E03Retire/E03RetireDeduction.jsp";
	            } else if( jobid.equalsIgnoreCase("ins") || jobid.equalsIgnoreCase("del") ) {
	            	if(box.getString("fund_recursive").equalsIgnoreCase("BETRG_0015")){
	            		box.put("field_name", "CHECK_CODE_0015");
	            	}else if(box.getString("fund_recursive").equalsIgnoreCase("BETRG_0014")){
	            		box.put("field_name", "CHECK_CODE_0014");
	            	}
	            	
	            	E03RetireDeductionInfoData data = new E03RetireDeductionRFC().build(user.empNo, box);
	            	
	            	String msg = "";
	            	String url = "";
	            	
	            	if(data.RETCODE.equalsIgnoreCase("S") && data.RETTEXT.length() == 0){
	            		if(jobid.equalsIgnoreCase("ins"))
	            			msg = "퇴직연금 추가납입 신청이 완료되었습니다.";
	            		else if(jobid.equalsIgnoreCase("del"))
	            			msg = "퇴직연금 추가납입이 해지되었습니다.";
	            	}else{
	            		msg = data.RETTEXT;           		
	            	}
	            	
            		url = "location.href='"+WebUtil.ServletURL +"hris.E.E03Retire.E03RetireDeductionSV'";
	            	
//	                Logger.debug.println(this, " =================================================== ");
//	                Logger.debug.println(this, data.RETCODE +" :::: ======================= :::: " + data.RETTEXT);
//	                Logger.debug.println(this, " =================================================== ");
	                
	                
	                req.setAttribute("msg", msg);
	                req.setAttribute("url", url);
	    			      printJspPage(req, res, WebUtil.JspURL +"common/msg.jsp");
	            }else {
	                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
	            }
            }
            printJspPage(req, res, dest);
            Logger.debug.println(this, " destributed = " + dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        } 
    }
}
