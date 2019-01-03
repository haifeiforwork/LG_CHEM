/********************************************************************************/
/*
/*   Program Name : 모바일 사원정보리스트 조회
/*   Program ID   : SearchEmpMbSV
/*   Description  : 모발일에서 이름을 받아서 사원정보리스트 DATA Return
/*   Note         :  최초 작성 [CSR ID:2991671] g-mobile 내 인사정보 조회 기능 추가 개발 요청
/*   Creation     : 2015-12-09
/*
/********************************************************************************/

package servlet.hris.common;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.common.DeptPersInfoData;
import hris.common.WebUserData;
import hris.common.rfc.DeptPersInfoRFC;
import org.jdom.Document;
import org.jdom.Element;
import servlet.hris.MobileAutoLoginSV;
import servlet.hris.MobileCommonSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.URLDecoder;
import java.util.Vector;

public class SearchEmpMbSV extends MobileAutoLoginSV {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

    	try{

        	Logger.debug.println("SearchEmpMbSV start++++++++++++++++++++++++++++++++++++++" );

        	//로그인처리
        	MobileCommonSV mc = new MobileCommonSV() ;
        	mc.autoLogin(req,res);

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            Box box = WebUtil.getBox(req);


            String empNo = box.get("empNo"); //사번
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);

            // 결재처리 결과값
            String returnXml = searchEmpInfo(req,res);

            // 결과에 대한 xmlStirng을  저장한다.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);

            // 3.return URL을 호출한다.
            dest = WebUtil.JspURL+"common/mobileResult.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res,dest );

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
    }
        /**
         * 사원정보리스트를 XML형태로 가져온다.
         * @return
         */
    public String searchEmpInfo( HttpServletRequest req, HttpServletResponse res){

    	Element envelope = null;

        String xmlString = "";
        String itemsName = "SearchEmpInfo";
        String docStatus = "";

        String errorCode = "";
        String errorMsg = "";

        try{
        	Logger.debug.println("SearchEmpMbSV apprItem Strart++++++++++++++++++++++++++++++++++++++" );

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            Box box = WebUtil.getBox(req);

            // 1.Envelop XML을 생성한다.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML을 생성한다.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE 를 생성한다.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.결과값을 생성한다.
            Element items = XmlUtil.createItems(itemsName);
            Element item = null;

            Logger.debug.println(this, " [user] : "+user.toString());

            Vector  DeptPersInfoData_vt = new Vector();
            String i_empNo = user.empNo; //사용자 사번

            Logger.debug("---- req.getParameter(\"searchName\") : " + req.getParameter("searchName"));

            Logger.debug("URLDecoder.decode : " + URLDecoder.decode(box.get("searchName"), "UTF-8"));
            Logger.debug("URLDecoder.decode : " + URLDecoder.decode(box.get("searchName"), "EUC-KR"));
            Logger.debug("URLDecoder.decode : " + URLDecoder.decode(box.get("searchName"), "ISO8859-1"));

            String i_searchName = URLDecoder.decode(req.getParameter("searchName"), "euc-kr") ; //검색한 임직원 이름

            DeptPersInfoData_vt = ( new DeptPersInfoRFC() ).getPersons(i_empNo, "", i_searchName, "2", "");
            DeptPersInfoData persInfo = new DeptPersInfoData();

            // 0:성공 1.검색권한 없음, 2.동일이름으로 여러명 있음 3.결과 없음 99.시스템 에러
            if (DeptPersInfoData_vt.size() > 0) {

            	if (DeptPersInfoData_vt.size() == 1) {
                	XmlUtil.addChildElement(items, "returnCode", "0");
    				XmlUtil.addChildElement(items, "returnDesc", "success");
                }else{
	            	XmlUtil.addChildElement(items, "returnCode", "2");
					XmlUtil.addChildElement(items, "returnDesc", "success");
                }

			}else{
				XmlUtil.addChildElement(items, "returnCode", "3");
				XmlUtil.addChildElement(items, "returnDesc", "조회 결과가 없습니다.");
			}

            Element rtnItems = XmlUtil.createItems("ReturnData");

            for( int i = 0 ; i < DeptPersInfoData_vt.size() ; i++ ) {
            	persInfo = (DeptPersInfoData)DeptPersInfoData_vt.get(i);

            	item = XmlUtil.createElement("Data");

            	XmlUtil.addChildElement(item, "ENAME", persInfo.ENAME);    			//이름
            	XmlUtil.addChildElement(item, "TITEL", persInfo.TITEL);    			//직위
            	XmlUtil.addChildElement(item, "TELNUMBER", persInfo.TELNUMBER);    	//담당자의 전화번호
            	XmlUtil.addChildElement(item, "CELLPHONE", "");    					//담당자의 폰번호
            	XmlUtil.addChildElement(item, "ORGTX", persInfo.ORGTX);    			//부서정보
            	XmlUtil.addChildElement(item, "PERNR", persInfo.PERNR);    			//사원번호
            	XmlUtil.addChildElement(item, "TITL2", persInfo.TITL2);    			//직책

            	XmlUtil.addChildElement(rtnItems, item);
            }

            XmlUtil.addChildElement(items, rtnItems);

	        // XML을 조합한다.
	        XmlUtil.addChildElement(waitResponse, items);
	        XmlUtil.addChildElement(body, waitResponse);
	        XmlUtil.addChildElement(envelope, body);

	        // 최종적으로 XML Document를 XML String을 변환한다.
	        xmlString = XmlUtil.convertString(new Document(envelope));

	    } catch(Exception e) {

	    	//99.시스템 에러
	    	errorCode = "99";
            errorMsg  = "시스템 담당자에게 문의하시기 바랍니다.: ";
            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
            Logger.error(e);
            return xmlString;

	    } finally {

	    }
	    return xmlString;
    }
}
