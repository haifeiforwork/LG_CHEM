/********************************************************************************
*   System Name  : MSS
*   1Depth Name  : Manager's Desc
*   2Depth Name  : 인원현황
*   Program Name : 부서별 연명부
*   Program ID   : F21DeptEntireEmpInfoSV.java
*   Description  : 부서별 연명부를 검색
*   Note         : 없음
*   Creation     :
*   Update       :
********************************************************************************/

package servlet.hris.F;

import hris.F.rfc.F21DeptEntireEmpInfoRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

/**
 * F21DeptEntireEmpInfoSV
 * 부서에 따른 전체 부서원의 연명부정보를 가져오는
 * F21DeptEntireEmpInfoRFC 를 호출하는 서블릿 class
 * @author
 * @version 1.0
 * update 2017-07-07 [CSR ID:3428660] 인사 list 화면 오류 수정
 */
public class F21DeptEntireEmpInfoSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{

            Box box = WebUtil.getBox( req ) ;
            //String checkYN   = box.get("checkYN");  //부서코드
            String checkYN   = box.get("chck_yeno");  //부서코드[CSR ID:3428660] 인사 list 화면 오류 수정
            checkYN          = WebUtil.nvl(checkYN, "N");      //하위부서여부.
            String deptId    = box.get("hdn_deptId");  //부서코드
            String deptNm    = box.get("hdn_deptNm");  //부서명
            String hdn_count = box.get("hdn_count");  //부서명
	        WebUserData user = WebUtil.getSessionUser(req);	                               //세션
	        boolean userArea = user.area.toString().equals("KR");
            //초기화면 오픈시 로그인 사용자의 데이터를 보여준다.
            if( deptId.equals("") ){
                deptId = user.e_objid;
            }

            String page   = box.get( "page" ) ;
            if( page.equals("")  ){
                page = "1";
            }

            String dest         = "";
	        boolean RfcSuccess  = false;
	        String E_MESSAGE 	= g.getMessage("MSG.F.F41.0007");

           	/**
           	 * @$ 웹보안진단 rdcamel
           	 * 해당 사번이 조직을 조회 할수 있는지 체크*/
           	if(!checkBelongGroup( req, res, deptId, "")){
           		return;
           	}

		    // 웹취약성 추가
            if(!checkAuthorization(req, res)) return;

	            Vector DeptEntireEmpInfo_vt  = new Vector();
	            F21DeptEntireEmpInfoRFC f21Rfc = null;

	            if ( !deptId.equals("") ) {
	            	f21Rfc       = new F21DeptEntireEmpInfoRFC();
	                Vector ret = f21Rfc.getDeptEntireEmpList(deptId, checkYN, userArea);

	            	RfcSuccess = f21Rfc.getReturn().isSuccess();
	            	E_MESSAGE = f21Rfc.getReturn().MSGTX;
	            	DeptEntireEmpInfo_vt = (Vector) ret.get(0);
	            }

	            //RFC 호출 성공시.
	            if( RfcSuccess ){
	                req.setAttribute( "page", page );
	                req.setAttribute( "hdn_deptId", deptId );
	                req.setAttribute( "hdn_deptNm", deptNm );
	                req.setAttribute( "hdn_count",  hdn_count );

	                req.setAttribute("checkYn", checkYN);
	                req.setAttribute("DeptEntireEmpInfo_vt", DeptEntireEmpInfo_vt);
	                req.setAttribute("pageType", "M");

	                dest = WebUtil.JspURL+"F/F21DeptEntireEmpInfo.jsp";
	            //RFC 호출 실패시.
	            }else{
		        	throw new GeneralException(E_MESSAGE);
	            }
            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}