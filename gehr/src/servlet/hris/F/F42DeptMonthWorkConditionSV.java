/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : 근태                                                        */
/*   Program Name : 월간 근태 집계표                                            */
/*   Program ID   : F42DeptMonthWorkConditionSV                                 */
/*   Description  : 부서별 월간 근태 집계표 조회를 위한 서블릿                  */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-02-17 유용원                                           */
/*   Update       :  @PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32"))  2018/02/09 rdcamel                                                           */
/*                                                                              */
/********************************************************************************/

package servlet.hris.F;

import com.common.RFCReturnEntity;
import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.F.rfc.F42DeptMonthWorkConditionRFC;
import hris.common.WebUserData;
import hris.common.rfc.BukrsCodeByOrgehRFCEurp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F42DeptMonthWorkConditionSV
 * 부서에 따른 전체 부서원의 월간 근태 집계표 정보를 가져오는
 * F42DeptMonthWorkConditionRFC 를 호출하는 서블릿 class
 *
 * @author  유용원
 * @version 1.0
 */
public class F42DeptMonthWorkConditionSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//부서코드...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//하위부서여부.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
            String year   = WebUtil.nvl(req.getParameter("year1"));
            String month  = WebUtil.nvl(req.getParameter("month1"));
            String subView       = WebUtil.nvl(req.getParameter("subView"));				//tab에서 호출되는지 여부
            String yymmdd   = "";
            String yyyymm   = ""; //Global에서 사용
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//세션.
            String dest_deail = user.area.toString();
	        String E_BUKRS = WebUtil.nvl(req.getParameter("E_BUKRS"));  //erup에서사용
	        Area area = null;
            //초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }
            if (!user.sapType.isLocal()){
            	if(year.equals("")||month.equals("")){
    				yyyymm = DataUtil.getCurrentDate().toString().substring(0,6);
    			} else {
    				yyyymm = year + month;
    			}

		    	BukrsCodeByOrgehRFCEurp rfc = new BukrsCodeByOrgehRFCEurp();
		    	Vector vt = rfc.getBukrsCode(deptId);
		        E_BUKRS = (String)vt.get(1);

	        	if ( E_BUKRS.equals("G290")) {
	        		dest_deail ="PL";
	        		area = Area.PL ;

	        	} else if ( E_BUKRS.equals("G260")) {
	        		dest_deail = "DE";
	        		area = Area.DE ;

	        	} else if (E_BUKRS.equals("G340") || E_BUKRS.equals("G400"))  {
	        		dest_deail = "US";
	        		area = Area.US ;
	        	
	        	} else if (E_BUKRS.equals("G560")) {//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32"))  2018/02/09 rdcamel
	        		dest_deail = "US";
	        		area = Area.MX ;

	        	} else {
	        		dest_deail = "CN";
	        		area = Area.CN ;
	 	        }



            }else{
            	area = Area.KR ;
            	if(year.equals("")||month.equals("")){
            		yymmdd = DataUtil.getCurrentDate();
            	} else {
            		yymmdd = year + month + "20";
            	}

                Box box = new Box("orgBox");
                box.put("I_ORGEH", deptId);
               	box.put("I_PERNR", user.empNo);
               	box.put("I_AUTHOR", "M");
               	box.put("I_GUBUN", "");

            }
	        String dest    		= "";
	        String E_RETURN  	= "";
	        //String E_MESSAGE 	= "부서 정보를 가져오는데 실패하였습니다.";
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007") ;
	        String E_YYYYMON 	= "";


	        /*************************************************************
	         * @$ 웹보안진단 marco257
	         * 세션에 있는 e_timeadmin = Y 인 사번이 부서 근태 권한이 있음.
	         * user.e_authorization.equals("E") 에서 !user.e_timeadmin.equals("Y")로 수정
	         *
	         * @ sMenuCode 코드 추가
	         * 부서근태 권한이 있는 사번과 MSS권한이 있는 사번을 체크하기 위해 추가
	         * 1406 : 부서근태 권한이 있는 메뉴코드(e_timeadmin 으로 체크)
	         * 1184 : 부서인사정보에 -> 조직통계 -> 근태 -> 월간근태 집계표에 권한이 있는사번
	         * 추가: 메뉴 코드가 없을경우 근태 권한이 우선한다.
	         *  (e_timeadmin 으로 체크못함 )
	         **************************************************************/

	        String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));
	        Logger.debug(sMenuCode + " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+user.e_timeadmin);
	        if(sMenuCode.equals("ESS_HRA_DAIL_STATE")){                            //개인인사정보 > 신청 > 부서근태
	        	if(!checkTimeAuthorization(req, res)) return;
	        }else{                                                               //부서인사정보
//	    	 @웹취약성 추가
	        	if ( user.e_authorization.equals("E")) {
	        		if(!checkTimeAuthorization(req, res)) return;
	        	}
	        }

            /*************************************************************
	         * @$ 웹보안진단 marco257
	         *
	         * 해당 사번이 조직을 조회할수 있는지 체크
	         * 체크로직 삭제 - SM 요청사항
	         *
	         **************************************************************/
//           	String sfunctionName = "ZHRA_RFC_CHECK_BELONG3";
//           	EHRComCRUDInterfaceRFC sRFC = new EHRComCRUDInterfaceRFC();
//	    	   String reCode = sRFC.setImportInsert(box, sfunctionName, "RETURN");

	    	//if(reCode.equals("S")){ //조회 가능


		        F42DeptMonthWorkConditionRFC func    = null;
		        Vector F42DeptMonthWorkCondition_vt  = null;
		        Vector F42DeptMonthWorkConditionTotal  = null;

				if ( !deptId.equals("") ) {
		        	func       				= new F42DeptMonthWorkConditionRFC();
		        	F42DeptMonthWorkCondition_vt  	= new Vector();
		            Vector ret 				= func.getDeptMonthWorkCondition(deptId, yymmdd,yyyymm, "1", checkYN,user.sapType,area);	// 월간 '1' set!

		            E_RETURN   				= (String)ret.get(0);
		            E_MESSAGE  				= (String)ret.get(1);

		            if (!user.sapType.isLocal()){
			            F42DeptMonthWorkCondition_vt 	= (Vector)ret.get(2);
			            F42DeptMonthWorkConditionTotal  = (Vector)ret.get(3);
			            E_YYYYMON = yyyymm;
		            }else{
		            	E_YYYYMON  				= (String)ret.get(2);
		            	F42DeptMonthWorkCondition_vt 	= (Vector)ret.get(3);
					}
				}
		        Logger.debug.println(this, " E_RETURN = " + E_RETURN);
		        RFCReturnEntity result = func.getReturn();
		        //RFC 호출 성공시.
		      //  if( result.isSuccess()){
		        	req.setAttribute("E_BUKRS", E_BUKRS);
			        req.setAttribute("checkYn", checkYN);
		        	req.setAttribute("E_YYYYMON", E_YYYYMON);
		        	req.setAttribute("subView", subView);
		        	Logger.debug.println(this, " subView = " + subView);
			        req.setAttribute("F42DeptMonthWorkCondition_vt", F42DeptMonthWorkCondition_vt);
			        req.setAttribute("F42DeptMonthWorkConditionTotal", F42DeptMonthWorkConditionTotal);
			        if( excelDown.equals("ED") ) //엑셀저장일 경우.
			            dest = WebUtil.JspURL+"F/F42DeptMonthWorkConditionExcel_"+ dest_deail +".jsp";
			        else if( excelDown.equals("print") ) //출력일 경우.
			        	dest = WebUtil.JspURL+"F/F42DeptMonthWorkConditionPrint_"+ dest_deail +".jsp";
			        else
			        	dest = WebUtil.JspURL+"F/F42DeptMonthWorkCondition_"+ dest_deail +".jsp";
			        Logger.debug.println(this, "E_RETURN : "+ E_RETURN);
			        Logger.debug.println(this, "E_MESSAGE : "+ E_MESSAGE);
			        Logger.debug.println(this, "F42DeptMonthWorkCondition_vt : "+ F42DeptMonthWorkCondition_vt.toString());
			        Logger.debug.println(this, "F42DeptMonthWorkConditionTotal : "+F42DeptMonthWorkConditionTotal);
			    //RFC 호출 실패시.
		        //}else{
			    //    String msg = E_MESSAGE;
	            //    String url = "history.back();";
			        //String url = "location.href = '"+WebUtil.JspURL+"F/F42DeptMonthWorkCondition.jsp?checkYn="+checkYN+"';";
			     //   req.setAttribute("msg", msg);
			     //   req.setAttribute("url", url);
			     //   dest = WebUtil.JspURL+"common/msg.jsp";
		        //}
	    	//}else{
	    		//String msg = "인사조직 조회권한이 없습니다";
               // String url = "history.back();";
               //req.setAttribute("msg", msg);
                //req.setAttribute("url", url);
                //dest = WebUtil.JspURL+"common/msg.jsp";
	    	//}
	        Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}