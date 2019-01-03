/********************************************************************************/
/*
/*   Program Name : ����� �����������Ʈ ��ȸ
/*   Program ID   : SearchEmpMbSV
/*   Description  : ����Ͽ��� �̸��� �޾Ƽ� �����������Ʈ DATA Return
/*   Note         :  ���� �ۼ� [CSR ID:2991671] g-mobile �� �λ����� ��ȸ ��� �߰� ���� ��û
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

        	//�α���ó��
        	MobileCommonSV mc = new MobileCommonSV() ;
        	mc.autoLogin(req,res);

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);

            String dest  = "";
            Box box = WebUtil.getBox(req);


            String empNo = box.get("empNo"); //���
            empNo = EncryptionTool.decrypt(empNo);
            empNo = DataUtil.fixEndZero( empNo ,8);

            // ����ó�� �����
            String returnXml = searchEmpInfo(req,res);

            // ����� ���� xmlStirng��  �����Ѵ�.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);

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
         * �����������Ʈ�� XML���·� �����´�.
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

            // 1.Envelop XML�� �����Ѵ�.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML�� �����Ѵ�.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE �� �����Ѵ�.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.������� �����Ѵ�.
            Element items = XmlUtil.createItems(itemsName);
            Element item = null;

            Logger.debug.println(this, " [user] : "+user.toString());

            Vector  DeptPersInfoData_vt = new Vector();
            String i_empNo = user.empNo; //����� ���

            Logger.debug("---- req.getParameter(\"searchName\") : " + req.getParameter("searchName"));

            Logger.debug("URLDecoder.decode : " + URLDecoder.decode(box.get("searchName"), "UTF-8"));
            Logger.debug("URLDecoder.decode : " + URLDecoder.decode(box.get("searchName"), "EUC-KR"));
            Logger.debug("URLDecoder.decode : " + URLDecoder.decode(box.get("searchName"), "ISO8859-1"));

            String i_searchName = URLDecoder.decode(req.getParameter("searchName"), "euc-kr") ; //�˻��� ������ �̸�

            DeptPersInfoData_vt = ( new DeptPersInfoRFC() ).getPersons(i_empNo, "", i_searchName, "2", "");
            DeptPersInfoData persInfo = new DeptPersInfoData();

            // 0:���� 1.�˻����� ����, 2.�����̸����� ������ ���� 3.��� ���� 99.�ý��� ����
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
				XmlUtil.addChildElement(items, "returnDesc", "��ȸ ����� �����ϴ�.");
			}

            Element rtnItems = XmlUtil.createItems("ReturnData");

            for( int i = 0 ; i < DeptPersInfoData_vt.size() ; i++ ) {
            	persInfo = (DeptPersInfoData)DeptPersInfoData_vt.get(i);

            	item = XmlUtil.createElement("Data");

            	XmlUtil.addChildElement(item, "ENAME", persInfo.ENAME);    			//�̸�
            	XmlUtil.addChildElement(item, "TITEL", persInfo.TITEL);    			//����
            	XmlUtil.addChildElement(item, "TELNUMBER", persInfo.TELNUMBER);    	//������� ��ȭ��ȣ
            	XmlUtil.addChildElement(item, "CELLPHONE", "");    					//������� ����ȣ
            	XmlUtil.addChildElement(item, "ORGTX", persInfo.ORGTX);    			//�μ�����
            	XmlUtil.addChildElement(item, "PERNR", persInfo.PERNR);    			//�����ȣ
            	XmlUtil.addChildElement(item, "TITL2", persInfo.TITL2);    			//��å

            	XmlUtil.addChildElement(rtnItems, item);
            }

            XmlUtil.addChildElement(items, rtnItems);

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
