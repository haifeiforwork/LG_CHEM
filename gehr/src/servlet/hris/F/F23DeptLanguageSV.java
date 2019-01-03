/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desc                                              */
/*   2Depth Name  : 인원현황                                                    */
/*   Program Name : 부서별 어학 인정점수 조회                                   */
/*   Program ID   : F23DeptLanguageSV                                           */
/*   Description  : 부서별 어학 인정점수 조회를 위한 서블릿                     */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-28 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
  
package servlet.hris.F;
 
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.F.F23DeptLanguageData;
import hris.F.rfc.F23DeptLanguageRFC;
import hris.common.WebUserData;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

/**
 * F23DeptLanguageSV
 * 부서에 따른 전체 부서원의 어학 인정점수 정보를 가져오는 
 * F23DeptLanguageRFC 를 호출하는 서블릿 class
 *
 * @author  유용원
 * @version 1.0
 */
public class F23DeptLanguageSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
    	try{ 
	        HttpSession session = req.getSession(false);
	        String deptId       = WebUtil.nvl(req.getParameter("hdn_deptId")); 			//부서코드...
	        String checkYN      = WebUtil.nvl(req.getParameter("chck_yeno"), "N"); 		//하위부서여부.
	        String excelDown    = WebUtil.nvl(req.getParameter("hdn_excel"));  			//excelDown...
	        WebUserData user    = (WebUserData)session.getAttribute("user");				//세션.

            Box         box     = WebUtil.getBox( req ) ;
            
            ///////////  SORT    /////////////
            String sortField = "";   //sortFieldName or sortFieldIndex
            String sortValue = "";  //sortValue ex) desc, asc
            sortField = box.get( "sortField" );
            sortValue = box.get( "sortValue" );
            if( sortField.equals("")  ) {
                sortField = "LGA_LAP_ORAL"; //LGA_LAP
            }
            if( sortValue.equals("")  ) {
                sortValue = "desc";  //정렬방법
            }
            
            //초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
            if( deptId.equals("") ){
            	deptId = user.e_objid;
            }
	
	        String dest    		= "";
	        boolean isSuccess = false;
	        String E_MESSAGE 	= "부서 정보를 가져오는데 실패하였습니다.";
	        
           	/**
           	 * @$ 웹보안진단 rdcamel
           	 * 해당 사번이 조직을 조회 할수 있는지 체크 
           	 */
	        int orgFlag = user.e_authorization.indexOf("M");    //조직도권한여부.

			if(!checkBelongGroup( req, res, deptId, "")){
				return;
			}
			// 웹취약성 추가
			if(!checkAuthorization(req, res)) return;

			F23DeptLanguageRFC func = null;
			Vector<F23DeptLanguageData> DeptLanguage_vt  = new Vector();

			if (StringUtils.isNotBlank(deptId)) {
				func       = new F23DeptLanguageRFC();
				DeptLanguage_vt = func.getDeptLanguage(deptId, checkYN);
				isSuccess = func.getReturn().isSuccess();
			}

			DeptLanguage_vt = SortUtil.sort( DeptLanguage_vt, sortField, sortValue ); //Vector Sort
			req.setAttribute( "sortField", sortField );
			req.setAttribute( "sortValue", sortValue );
			req.setAttribute( "hdn_deptId", deptId );

			//RFC 호출 성공시.
			if( isSuccess ){
				req.setAttribute("checkYn", checkYN);
				req.setAttribute("DeptLanguage_vt", DeptLanguage_vt);
				if( excelDown.equals("ED") ) //엑셀저장일 경우.
					dest = WebUtil.JspURL+"F/F23DeptLanguageExcel.jsp";
				else
					dest = WebUtil.JspURL+"F/F23DeptLanguage.jsp?checkYn="+checkYN+"&hdn_deptId="+deptId;

				Logger.debug.println(this, " dest = " + dest);
				Logger.debug.println(this, "DeptLanguage_vt : "+ DeptLanguage_vt.toString());
				//RFC 호출 실패시.
			}else{
				String msg = E_MESSAGE;
				String url = "location.href ='"+WebUtil.JspURL+"F/F23DeptLanguage.jsp?checkYn="+checkYN+"&hdn_deptId="+deptId+"';";

				req.setAttribute("msg", msg);
				req.setAttribute("url", url);
				dest = WebUtil.JspURL+"common/msg.jsp";
			}


			Logger.debug.println(this, " destributed = " + dest);
	        printJspPage(req, res, dest);
    	} catch(Exception e) {
            throw new GeneralException(e);
        }        
    }
}