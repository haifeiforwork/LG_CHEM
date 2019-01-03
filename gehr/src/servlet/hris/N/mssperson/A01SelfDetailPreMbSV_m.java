/********************************************************************************/
/*
/*   Program Name : ����� �λ����� ��ȸ
/*   Program ID   : A01SelfDetailPreMbSV_m
/*   Description  : ����Ͽ��� �α��� ����� �޾Ƽ� �λ�������ȸ ������ �ִ��� ���� DATA Return
/*   Note         : ���� �ۼ�  [CSR ID:2991671] g-mobile �� �λ����� ��ȸ ��� �߰� ���� ��û
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

        	//�α���ó��
        	MobileCommonSV mc = new MobileCommonSV() ;
        	mc.autoLogin(req,res);

            String dest  = "";

            // ����ó�� �����
            String returnXml = HRInfo(req,res);

            // ����� ���� xmlStirng��  �����Ѵ�.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);
            Logger.debug.println("A01SelfDetailPreMbSV_m returnXml++++++++++++++++++++++++++++++++++++++"+returnXml );
            // 3.return URL�� ȣ���Ѵ�.
            dest = WebUtil.JspURL+"common/mobileResult.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res,dest );

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {

        }
    }

    /**
     * �λ������� XML���·� �����´�.
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

            // 1.Envelop XML�� �����Ѵ�.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML�� �����Ѵ�.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE �� �����Ѵ�.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.������� �����Ѵ�.
            Element items = XmlUtil.createItems(itemsName);



            String mbAuth = (new GetMobileMSSAuthCheckRFC()).getMbMssAuthChk(user.empNo);
            //���� üũ
            if(mbAuth.equals("Y")){
            	XmlUtil.addChildElement(items, "returnCode", "0");
				XmlUtil.addChildElement(items, "returnDesc", "success");
	    	}else{
	    		//1.�˻����� ����
	    		XmlUtil.addChildElement(items, "returnCode", "1");
				XmlUtil.addChildElement(items, "returnDesc", "������ �����ϴ�.");
	    	}


	        // XML�� �����Ѵ�.
	        XmlUtil.addChildElement(waitResponse, items);
	        XmlUtil.addChildElement(body, waitResponse);
	        XmlUtil.addChildElement(envelope, body);

	        // ���������� XML Document�� XML String�� ��ȯ�Ѵ�.
	        xmlString = XmlUtil.convertString(new Document(envelope));


	    } catch(Exception e) {

	    	//99.�ý��� ����
	    	errorCode = "99";
            errorMsg  = "�ý��� ����ڿ��� �����Ͻñ� �ٶ��ϴ�.: ";
            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
            Logger.error(e);
            return xmlString;

	    } finally {

	    }
	    return xmlString;
    }
}
