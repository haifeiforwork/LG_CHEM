/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : 공통                                                        */
/*   2Depth Name  :                                                             */
/*   Program Name : 조직도 검색                                                 */
/*   Program ID   : OrganListSV.java                                            */
/*   Description  : 조직도 검색하는 include 파일                                */
/*   Note         : 없음                                                        */
/*   Creation     : 2005-01-20 유용원                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
  
package servlet.hris.common;
 
import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * OrganListSV
 * 부서에 따른 전체 부서정보를 가져오는 
 * OrganListRFC 를 호출하는 서블릿 class
 *
 * @author  유용원
 * @version 1.0
 */
public class OrganListPopSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {

        printJspPage(req, res, WebUtil.JspURL + "common/OrganListPop.jsp");
    }
    
}