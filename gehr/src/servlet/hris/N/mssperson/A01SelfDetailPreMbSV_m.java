/********************************************************************************/
/*
/*   Program Name : 모바일 인사정보 조회
/*   Program ID   : A01SelfDetailPreMbSV_m
/*   Description  : 모발일에서 로그인 사번을 받아서 인사정보조회 권한이 있는지 권한 DATA Return
/*   Note         : 최초 작성  [CSR ID:2991671] g-mobile 내 인사정보 조회 기능 추가 개발 요청
/*   Creation     : 2015-12-07
/*
/********************************************************************************/

package servlet.hris.N.mssperson;

import hris.common.WebUserData;
import hris.common.rfc.GetMobileMSSAuthCheckRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jdom.Document;
import org.jdom.Element;

import servlet.hris.MobileAutoLoginSV;
import servlet.hris.MobileCommonSV;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.WebUtil;

public class A01SelfDetailPreMbSV_m extends MobileAutoLoginSV {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

    	try{

        	Logger.debug.println("A01SelfDetailPreMbSV_m start++++++++++++++++++++++++++++++++++++++" );

        	//로그인처리
        	MobileCommonSV mc = new MobileCommonSV() ;
        	mc.autoLogin(req,res);

            String dest  = "";

            // 결재처리 결과값
            String returnXml = HRInfo(req,res);

            // 결과에 대한 xmlStirng을  저장한다.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);
            Logger.debug.println("A01SelfDetailPreMbSV_m returnXml++++++++++++++++++++++++++++++++++++++"+returnXml );
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
     * 인사정보를 XML형태로 가져온다.
     * @param input
     * @return
     */
    public String HRInfo( HttpServletRequest req, HttpServletResponse res){

    	Element envelope = null;

        String xmlString = "";
        String itemsName = "MenuOpen";

        String errorCode = "";
        String errorMsg = "";

        try{
        	Logger.debug.println("A01SelfDetailPreMbSV_m HRInfo Strart++++++++++++++++++++++++++++++++++++++" );

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            //WebUserData user_m  = null;

            Box box = WebUtil.getBox(req);

            // 1.Envelop XML을 생성한다.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML을 생성한다.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE 를 생성한다.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.결과값을 생성한다.
            Element items = XmlUtil.createItems(itemsName);



            String mbAuth = (new GetMobileMSSAuthCheckRFC()).getMbMssAuthChk(user.empNo);
            //권한 체크
            if(mbAuth.equals("Y")){
            	XmlUtil.addChildElement(items, "returnCode", "0");
				XmlUtil.addChildElement(items, "returnDesc", "success");
	    	}else{
	    		//1.검색권한 없음
	    		XmlUtil.addChildElement(items, "returnCode", "1");
				XmlUtil.addChildElement(items, "returnDesc", "권한이 없습니다.");
	    	}


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
