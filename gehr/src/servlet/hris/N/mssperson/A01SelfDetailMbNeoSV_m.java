/********************************************************************************/
/*
/*   Program Name : ����� �λ����� ��ȸ
/*   Program ID   : A01MbSelfDetailNeoSV_m
/*   Description  : ����Ͽ��� ��ȸ ����� �޾Ƽ� �λ����� DATA Return
/*   Note         : �����ۼ� [CSR ID:2991671] g-mobile �� �λ����� ��ȸ ��� �߰� ���� ��û
/*   Creation     : 2015-12-07
/*   Update       : 2016/02/23 [CSR ID:2992953] g-mobile Ү �λ�������ȸ ���� �������� �ݿ�
/*   Update       : 2017/02/16 [CSR ID:3302951] G Mobile Ү HR info ȭ�� ���� ���� ���� ��û�� ��
/*   Update       : 2017/07/18 eunha [CSR ID:3436191] G Mobile �λ����� �޴� ��������
/********************************************************************************/

package servlet.hris.N.mssperson;

import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.mobile.EncryptionTool;
import com.sns.jdf.mobile.XmlUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.SortUtil;
import com.sns.jdf.util.WebUtil;
import hris.A.*;
import hris.A.rfc.*;
import hris.B.B01ValuateDetailData;
import hris.B.rfc.B01ValuateDetailCheckRFC;
import hris.B.rfc.B01ValuateDetailRFC;
import hris.C.C05FtestResult1Data;
import hris.C.rfc.C05FtestResultRFC2;
import hris.common.MappingPernrData;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.rfc.GetMobileMSSAuthCheckRFC;
import hris.common.rfc.GetPhotoURLRFC;
import hris.common.rfc.MappingPernrRFC;
import hris.common.rfc.PersonInfoRFC;
import org.jdom.Document;
import org.jdom.Element;
import servlet.hris.MobileAutoLoginSV;
import servlet.hris.MobileCommonSV;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;

public class A01SelfDetailMbNeoSV_m extends MobileAutoLoginSV {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {

    	try{

        	Logger.debug.println("A01MbSelfDetailNeoSV_m start++++++++++++++++++++++++++++++++++++++" );

        	//�α���ó��
        	MobileCommonSV mc = new MobileCommonSV() ;
        	mc.autoLogin(req,res);

            String dest  = "";

            // ����ó�� �����
            String returnXml = HRInfo(req,res);

            // ����� ���� xmlStirng��  �����Ѵ�.
            req.setAttribute("returnXml", returnXml);
            //LHtmlUtil.blockHttpCache(res);
            Logger.debug.println("A01MbSelfDetailNeoSV_m returnXml++++++++++++++++++++++++++++++++++++++"+returnXml );
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
     * @return
     */
    public String HRInfo( HttpServletRequest req, HttpServletResponse res){

    	Element envelope = null;

        String xmlString = "";
        String itemsName = "HRInfo";

        String errorCode = "";
        String errorMsg = "";

        try{
        	Logger.debug.println("A01MbSelfDetailNeoSV_m HRInfo Strart++++++++++++++++++++++++++++++++++++++" );

            HttpSession session = req.getSession(false);
            WebUserData user = WebUtil.getSessionUser(req);
            WebUserData user_m  = null;

            Box box = WebUtil.getBox(req);

            // 1.Envelop XML�� �����Ѵ�.
            envelope =  XmlUtil.createEnvelope();

            // 2.Body XML�� �����Ѵ�.
            Element body =  XmlUtil.createBody();

            // 3.WAT_RESPONSE �� �����Ѵ�.
            Element waitResponse =  XmlUtil.createWaitResponse();

            // 4.������� �����Ѵ�.
            Element items = XmlUtil.createItems(itemsName);


            String empNo_m = box.get("empNo_m"); //���

            if(empNo_m.equals("")){
            	empNo_m = user.empNo; // �˻� ����� ���� ��� ���� ������� ��ü�Ѵ�.
            }else{
            	empNo_m = EncryptionTool.decrypt(empNo_m);
            	empNo_m = DataUtil.fixEndZero( empNo_m ,8);
            }

    		//2. ���������� marco257
    		box.put("I_DEPT", user.empNo); //�α��� ���
        	box.put("I_PERNR", empNo_m);   // ��ȸ���
        	box.put("I_RETIR", ""); //�����ڸ� ��ȸ�� - ���� ����

           	/*String functionName = "ZHRA_RFC_CHECK_BELONG2";

        	EHRComCRUDInterfaceRFC comRFC = new EHRComCRUDInterfaceRFC();
	    	String reCode = comRFC.setImportInsert(box, functionName, "RETURN");*/
            String mbAuth = (new GetMobileMSSAuthCheckRFC()).getMbMssAuthChk(user.empNo);

            boolean isBelong = checkBelongPerson(req, res, empNo_m, box.get("I_RETIR"));

            //���� üũ
            if(mbAuth.equals("Y")){
    	    	if(isBelong){ //��ȸ ����
    	    		SetUserSession(empNo_m, req);
    	    		user_m  = (WebUserData)session.getAttribute("user_m");
    	    		errorCode = "0";
    	            errorMsg  = "success";
    	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
    	    	}else{
    	    		//1.�˻����� ����
    		    	errorCode = "1";
    	            errorMsg  = "�˻����� ����";
    	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
    	            return xmlString;
    	    	}
    	    	//@����༺ �߰�
                if ( user.e_authorization.equals("E")) {
                	//1.�˻����� ����
    		    	errorCode = "1";
    	            errorMsg  = "�˻����� ����";
    	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
    	            return xmlString;
                }

            }else{
            	errorCode = "1";
	            errorMsg  = "�˻����� ����";
	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	            return xmlString;
            }//���� üũ ����

	    	/*
	    	 * �Ʒ��κ� ������ �� test ��!!!!
	    	 *
	    	 */
	    	//user.empNo = "00206319";
	    	//empNo_m = "00028213";
	    	//isBelong=true;

	    	if(isBelong){ //��ȸ ����
	    		SetUserSession(empNo_m, req);
	    		user_m  = (WebUserData)session.getAttribute("user_m");
	    	}else{
	    		//1.�˻����� ����
		    	errorCode = "1";
	            errorMsg  = "�˻����� ����";
	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	            return xmlString;
	    	}


	    	//@����༺ �߰�
            if ( user.e_authorization.equals("E")) {
            	//1.�˻����� ����
		    	errorCode = "1";
	            errorMsg  = "�˻����� ����";
	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	            return xmlString;
            }


            String imgUrl ="";
            GetPhotoURLRFC      photofunc = null;  // ����
            A01SelfDetailRFC    funcA01  = null;  // ���λ���
//            A08LicenseDetailRFC funcA08 = null;  // �ڰݻ���
            A02SchoolDetailRFC  funcA02 = null;  // �з»���
            A04FamilyDetailRFC  funcA04 = null;  // ��������
            Vector a01SelfDetailData_vt   = new Vector();
            Vector a08LicenseDetail_vt    = new Vector();
            Vector a02SchoolData_vt       = new Vector();
            Vector a04FamilyDetailData_vt = new Vector();
            A01SelfDetailData dataA01   	  = null;

	        // ������ũ
            photofunc = new GetPhotoURLRFC();
            imgUrl = photofunc.getPhotoURL( user_m.empNo );

            // A01SelfDetailRFC ������������ ��ȸ
            funcA01 = new A01SelfDetailRFC();
            // [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 start
            //a01SelfDetailData_vt = funcA01.getPersInfo(user_m.empNo, user.area.getMolga(), "");
            a01SelfDetailData_vt = funcA01.getPersInfoM(user_m.empNo, user.area.getMolga(), "");
            // [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 end
            if (a01SelfDetailData_vt != null && a01SelfDetailData_vt.size() > 0 ) {
            	dataA01 = (A01SelfDetailData)a01SelfDetailData_vt.get(0);
            }

            // 0:���� 1.�˻����� ����, 2.�����̸����� ������ ���� 3.��� ���� 99.�ý��� ����
            if (true) {

            	XmlUtil.addChildElement(items, "returnCode", "0");
				XmlUtil.addChildElement(items, "returnDesc", "success");
			}else{
				//3.��� ����
		    	errorCode = "3";
	            errorMsg  = "��ȸ ����� �����ϴ�.";
	            xmlString = XmlUtil.createErroXml(itemsName, errorCode, errorMsg);
	            return xmlString;
			}

	        Element item = XmlUtil.createElement("A01SelfDetailData");

	        XmlUtil.addChildElement(item, "IMAGEURL", imgUrl);  			// ������ũ
	        XmlUtil.addChildElement(item, "ORGTX", dataA01.ORGTX);  		// ����
	        XmlUtil.addChildElement(item, "KNAME", dataA01.ENAME);  		// �ѱ��̸�
	     // [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 start
	        //XmlUtil.addChildElement(item, "TITEL", dataA01.JIKWT);  		// ����
	        XmlUtil.addChildElement(item, "TITEL", dataA01.JIK_M);  		// ����
	     // [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 end
	        XmlUtil.addChildElement(item, "GBDAT", dataA01.GBDAT);  		// �������
	        XmlUtil.addChildElement(item, "DAT02", dataA01.DAT01);  		// �׷��Ի���    DAT01
	        XmlUtil.addChildElement(item, "DAT03", dataA01.DAT02);  		// �ڻ��Ի���    DAT02
	        XmlUtil.addChildElement(item, "TITL2", dataA01.JIKKT);  		// ��å
	        XmlUtil.addChildElement(item, "VGLST", dataA01.VGLST);  		// ����/����

            /*DAT01	ZEHRDAT01	DATS	8	0	�׷��Ի���
            DAT02	ZEHRDAT02	DATS	8	0	ȸ���Ի���
            DAT03	ZEHRDAT03	DATS	8	0	������������*/
            XmlUtil.addChildElement(items, item);

            // �з»���
            funcA02 = new A02SchoolDetailRFC();
            a02SchoolData_vt = funcA02.getSchoolDetail(user_m.empNo, user_m.area.getMolga(), "");

            for ( int i = 0 ; i < a02SchoolData_vt.size() ; i++ ) {
            	A02SchoolData dataA02 = (A02SchoolData)a02SchoolData_vt.get(i);

            	item = XmlUtil.createElement("A02SchoolData");

            	XmlUtil.addChildElement(item, "LART_TEXT", dataA02.SCHTX);    	//�б���
            	XmlUtil.addChildElement(item, "FTEXT", dataA02.SLTP1X);    			//����
            	XmlUtil.addChildElement(item, "PERIOD", dataA02.PERIOD);    		//�Ⱓ
            	XmlUtil.addChildElement(item, "SLART_TEXT", dataA02.SLATX);    		//����



            	XmlUtil.addChildElement(items, item);
            }


            // ��������
            funcA04 = new A04FamilyDetailRFC();
            a04FamilyDetailData_vt = funcA04.getFamilyDetail(box) ;
            Logger.debug.println(this, "a04FamilyDetailData_vt : "+ a04FamilyDetailData_vt.toString());

            for ( int i = 0 ; i < a04FamilyDetailData_vt.size() ; i++ ) {
                A04FamilyDetailData dataA04 = (A04FamilyDetailData)a04FamilyDetailData_vt.get(i);

            	item = XmlUtil.createElement("A04FamilyDetailData");
            	XmlUtil.addChildElement(item, "STEXT", dataA04.STEXT);   // ����
            	XmlUtil.addChildElement(item, "LNMHG", dataA04.LNMHG);   // �̸�(��)
            	XmlUtil.addChildElement(item, "FNMHG", dataA04.FNMHG);   // �̸�(��)
            	XmlUtil.addChildElement(item, "FGBDT", dataA04.FGBDT);   // �������
            	XmlUtil.addChildElement(item, "FAJOB", dataA04.FAJOB);   // ����

            	XmlUtil.addChildElement(items, item);

            }

            // �߷�
            Vector A05AppointDetail1Data_vt = new Vector() ;
            A05AppointDetail1RFC funcA051 = null ;

            MappingPernrRFC  mapfunc = null ;
            MappingPernrData mapData = new MappingPernrData();
            Vector mapData_vt = new Vector() ;
            Vector appData1_vt = new Vector() ;

            mapfunc = new MappingPernrRFC() ;
            mapData_vt = mapfunc.getPernr( user_m.empNo ) ;

            A05AppointDetail1Data dataA051 = new A05AppointDetail1Data();



            if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    // AppointDetail1 - ZHRA_RFC_GET_IT0000_ETC - �߷�
                    funcA051 = new A05AppointDetail1RFC() ;
                    appData1_vt = funcA051.getAppointDetail1M( mapData.PERNR, "" ) ;
                    appData1_vt = SortUtil.sort( appData1_vt, "BEGDA", "desc" );

                    for( int j = 0 ; j < appData1_vt.size() ; j++ ) {
                        dataA051 = (A05AppointDetail1Data)appData1_vt.get(j);

                    	item = XmlUtil.createElement("A05AppointDetail1Data");
                    	XmlUtil.addChildElement(item, "MNTXT", dataA051.MNTXT);      // �߷�����
                    	XmlUtil.addChildElement(item, "BEGDA", dataA051.BEGDA);      // �߷�����
                    	XmlUtil.addChildElement(item, "ORGTX", dataA051.ORGTX);      // �Ҽ�
                    	// [CSR ID:3302951] G Mobile Ү HR info ȭ�� ���� ���� ���� ��û�� �� begin
                    	//XmlUtil.addChildElement(item, "TITEL", dataA051.JIKWE);      // �����ڵ�
                    	// [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 start
                    	//XmlUtil.addChildElement(item, "TITEL", dataA051.JIKWT);      // ����
                    	XmlUtil.addChildElement(item, "TITEL", dataA051.JIK_M);      // ����
                    	// [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 end
                    	// [CSR ID:3302951] G Mobile Ү HR info ȭ�� ���� ���� ���� ��û�� �� end

                    	XmlUtil.addChildElement(items, item);

                    }

                }

            } else {
                // AppointDetail1 - ZHRA_RFC_GET_IT0000_ETC - �߷�
                funcA051 = new A05AppointDetail1RFC() ;
                A05AppointDetail1Data_vt = funcA051.getAppointDetail1( user_m.empNo, "" ) ;

                for( int j = 0 ; j < A05AppointDetail1Data_vt.size() ; j++ ) {
                    dataA051 = (A05AppointDetail1Data)A05AppointDetail1Data_vt.get(j);

                    item = XmlUtil.createElement("A05AppointDetail1Data");
                	XmlUtil.addChildElement(item, "MNTXT", dataA051.MNTXT);      // �߷�����
                	XmlUtil.addChildElement(item, "BEGDA", dataA051.BEGDA);      // �߷�����
                	XmlUtil.addChildElement(item, "ORGTX", dataA051.ORGTX);      // �Ҽ�
                	// [CSR ID:3302951] G Mobile Ү HR info ȭ�� ���� ���� ���� ��û�� �� begin
                	//XmlUtil.addChildElement(item, "TITEL", dataA051.JIKWE);      // �����ڵ�
                	// [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 start
                	//XmlUtil.addChildElement(item, "TITEL", dataA051.JIKWT);      // ����
                	XmlUtil.addChildElement(item, "TITEL", dataA051.JIK_M);      // ����
                	// [CSR ID:3436191] G Mobile �λ����� �޴� ��������  eunha 2017-07-18 end
                	// [CSR ID:3302951] G Mobile Ү HR info ȭ�� ���� ���� ���� ��û�� �� end

                	XmlUtil.addChildElement(items, item);
                }

            }


            //��
            B01ValuateDetailRFC funcB01 = null ;
            B01ValuateDetailCheckRFC funcB01Check =  new B01ValuateDetailCheckRFC() ;
            Vector B01ValuateDetailData_vt = new Vector();
            Vector detailData_vt = new Vector() ;
            String checkYn = "";

            //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH

            checkYn = funcB01Check.getValuateDetailCheck(user.empNo, user_m.empNo, "A01", "M");//CSR ID:2703351 ���� ��� A�� �����ڷ� ��.

            if( checkYn.equals("Y")){//20141125 ���ѿ��� check [CSR ID:2651528] �λ���� �߰� �� �޴���ȸ ��� ����
                if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // ���Ի��� ó��
                    B01ValuateDetailData dataB01 = new B01ValuateDetailData();

                    for ( int i=0; i < mapData_vt.size(); i++) {
                        mapData = (MappingPernrData)mapData_vt.get(i);

                        funcB01 = new B01ValuateDetailRFC() ;
                        detailData_vt = funcB01.getValuateDetail( mapData.PERNR ,"Y",user_m.empNo, "", null) ;

                        for( int j = 0 ; j < detailData_vt.size() ; j++ ) {
                        	dataB01 = (B01ValuateDetailData)detailData_vt.get(j);
                            item = XmlUtil.createElement("B01ValuateDetailData");

                            XmlUtil.addChildElement(item, "YEAR1", dataB01.YEAR1);         // �⵵
                            XmlUtil.addChildElement(item, "ORGTX", dataB01.ORGTX);         // �ٹ��μ�
                            XmlUtil.addChildElement(item, "RTEXT1", dataB01.RTEXT1);       // ��
                            XmlUtil.addChildElement(item, "BOSS_NAME", dataB01.BOSS_NAME); // ����

                            XmlUtil.addChildElement(items, item);
                        }
                    }

                } else {
                    // ValuateDetail - ZHRD_RFC_APPRAISAL_LIST - �� ����
                	funcB01 = new B01ValuateDetailRFC() ;
                    B01ValuateDetailData_vt = funcB01.getValuateDetail( user_m.empNo,"Y",user_m.empNo, "", null ) ;
                    B01ValuateDetailData dataB01 = new B01ValuateDetailData();

                    for( int j = 0 ; j < B01ValuateDetailData_vt.size() ; j++ ) {
                    	dataB01 = (B01ValuateDetailData)B01ValuateDetailData_vt.get(j);

                    	item = XmlUtil.createElement("B01ValuateDetailData");

                        XmlUtil.addChildElement(item, "YEAR1", dataB01.YEAR1);         // �⵵
                        XmlUtil.addChildElement(item, "ORGTX", dataB01.ORGTX);         // �ٹ��μ�
                        XmlUtil.addChildElement(item, "RTEXT1", dataB01.RTEXT1);       // ��
                        XmlUtil.addChildElement(item, "BOSS_NAME", dataB01.BOSS_NAME); // ����

                        XmlUtil.addChildElement(items, item);
                    }

                }
            }else{
//            	retnMsg = "�ش� ������ �����ϴ�.";
            }


            //����  ZHRE_RFC_LANGUAGE_ABILITY2
            C05FtestResultRFC2 funcC05= null;
            Vector c05FtestResult1Data_vt = new Vector();
            Vector ftestData_vt = new Vector() ;

            if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // ���Ի��� ó��
                C05FtestResult1Data dataC05 = new C05FtestResult1Data();

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    funcC05 = new C05FtestResultRFC2() ;
                    ftestData_vt = funcC05.getFtestResult( mapData.PERNR, "1");  // ���дɷ�

                    for( int j = 0 ; j < ftestData_vt.size() ; j++ ) {
                    	dataC05 = (C05FtestResult1Data)ftestData_vt.get(j);

                    	item = XmlUtil.createElement("c05FtestResult1Data");

                    	XmlUtil.addChildElement(item, "LANG_TYPE", dataC05.LANG_TYPE);   // ���豸��
                    	XmlUtil.addChildElement(item, "BEGDA", dataC05.BEGDA);       	 // ������
                    	XmlUtil.addChildElement(item, "STEXT", dataC05.STEXT);   // �����
                    	XmlUtil.addChildElement(item, "TOTL_SCOR", dataC05.TOTL_SCOR);   // TOTAL����

	                	XmlUtil.addChildElement(items, item);

                    }
                }

            } else {
            	funcC05 = new C05FtestResultRFC2();
                c05FtestResult1Data_vt = funcC05.getFtestResult(user_m.empNo, "1");  // ���дɷ�
                C05FtestResult1Data dataC05 = new C05FtestResult1Data();

                for( int j = 0 ; j < c05FtestResult1Data_vt.size() ; j++ ) {
                	dataC05 = (C05FtestResult1Data)c05FtestResult1Data_vt.get(j);

                	item = XmlUtil.createElement("c05FtestResult1Data");

                	XmlUtil.addChildElement(item, "LANG_TYPE", dataC05.LANG_TYPE);   // ���豸��
                	XmlUtil.addChildElement(item, "BEGDA", dataC05.BEGDA);       	 // ������
                	XmlUtil.addChildElement(item, "STEXT", dataC05.STEXT);   // �����
                	XmlUtil.addChildElement(item, "TOTL_SCOR", dataC05.TOTL_SCOR);   // TOTAL����

                	XmlUtil.addChildElement(items, item);

                }
            }

            //����
            //TODO
            A10RaiseResultRFC funcA10 = null ;
            Vector A10RaiseResultData_vt = new Vector() ;
            Vector RsResultData_vt = new Vector() ;

            if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // ���Ի��� ó��
            	A10RaiseResultData dataA10 = new A10RaiseResultData();

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    funcA10 = new A10RaiseResultRFC() ;
                    RsResultData_vt = funcA10.getRaise(mapData.PERNR);

                    for( int j = 0 ; j < RsResultData_vt.size() ; j++ ) {
                    	dataA10 = (A10RaiseResultData)RsResultData_vt.get(j);

                    	item = XmlUtil.createElement("a10RaiseResultData");

                    	XmlUtil.addChildElement(item, "STEXT", dataA10.STEXT);   // ����
                    	XmlUtil.addChildElement(item, "ENDDA", dataA10.ENDDA);       	 // ������
                    	XmlUtil.addChildElement(item, "BEGDA", dataA10.BEGDA);   // �������� FLAG
                    	XmlUtil.addChildElement(item, "RES_DEVE", dataA10.RES_DEVE);   // TOTAL����
                    	XmlUtil.addChildElement(item, "LANDX", dataA10.LANDX);   // ���

	                	XmlUtil.addChildElement(items, item);

                    }
                }

            } else {
            	funcA10 = new A10RaiseResultRFC() ;
            	A10RaiseResultData_vt = funcA10.getRaise(mapData.PERNR);
            	A10RaiseResultData dataA10 = new A10RaiseResultData();

                for( int j = 0 ; j < A10RaiseResultData_vt.size() ; j++ ) {
                	dataA10 = (A10RaiseResultData)A10RaiseResultData_vt.get(j);

                	item = XmlUtil.createElement("a10RaiseResultData");

                	XmlUtil.addChildElement(item, "STEXT", dataA10.STEXT);   // ����
                	XmlUtil.addChildElement(item, "ENDDA", dataA10.ENDDA);       	 // ������
                	XmlUtil.addChildElement(item, "BEGDA", dataA10.BEGDA);   // �������� FLAG
                	XmlUtil.addChildElement(item, "RES_DEVE", dataA10.RES_DEVE);   // TOTAL����
                	XmlUtil.addChildElement(item, "LANDX", dataA10.LANDX);   // ���

                	XmlUtil.addChildElement(items, item);

                }
            }

          //¡��
            A07PunishResultRFC funcA07 = null;
            Vector PunishData_vt = new Vector();
            Vector puData_vt = new Vector() ;

            checkYn = funcB01Check.getValuateDetailCheck(user.empNo, user_m.empNo,"A02", "M");//CSR ID:2703351 ����/¡���� ��� B�� �����ڷ� ��.

	        if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // ���Ի��� ó��

                A07PunishResultData dataA07 = new A07PunishResultData();

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    funcA07 = new A07PunishResultRFC() ;
//                    puData_vt = funcA07.getPunish( mapData.PERNR, checkYn); -> tab check�� ����
                    puData_vt = funcA07.getPunish( mapData.PERNR, "");

                    for( int j = 0 ; j < puData_vt.size() ; j++ ) {
                    	dataA07 = (A07PunishResultData)puData_vt.get(j);

                    	item = XmlUtil.createElement("A07PunishResultData");

                    	XmlUtil.addChildElement(item, "PUNTX", dataA07.PUNTX);       // ¡������(text)[CSR ID:2992953]
                    	XmlUtil.addChildElement(item, "BEGDA", dataA07.BEGDA);       // ������
                    	XmlUtil.addChildElement(item, "ENDDA", dataA07.ENDDA);       // ������
                    	XmlUtil.addChildElement(item, "PUNRS", dataA07.PUNRS);       // ¡�賻��

	                	XmlUtil.addChildElement(items, item);
                    }
                }

            } else {

                funcA07 = new A07PunishResultRFC() ;
                PunishData_vt = funcA07.getPunish(user_m.empNo, "");

                A07PunishResultData dataA07 = new A07PunishResultData();

                for( int j = 0 ; j < PunishData_vt.size() ; j++ ) {
                	dataA07 = (A07PunishResultData)PunishData_vt.get(j);

                	item = XmlUtil.createElement("A07PunishResultData");

                	XmlUtil.addChildElement(item, "PUNTY", dataA07.PUNTY);       // ¡������
                	XmlUtil.addChildElement(item, "BEGDA", dataA07.BEGDA);       // ������
                	XmlUtil.addChildElement(item, "ENDDA", dataA07.ENDDA);       // ������
                	XmlUtil.addChildElement(item, "PUNRS", dataA07.PUNRS);       // ¡�賻��

                	XmlUtil.addChildElement(items, item);
                }
            }

	        //�����
	        //��»���
	        A09CareerDetailRFC funcA09 = null;
            Vector CareerData_vt = new Vector();
            Vector carData_vt = new Vector() ;

	        if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {  // ���Ի��� ó��

	        	A09CareerDetailData dataA09 = new A09CareerDetailData();

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    funcA09 = new A09CareerDetailRFC() ;
                    carData_vt = funcA09.getCareerDetail( mapData.PERNR,"" );

                    for( int j = 0 ; j < carData_vt.size() ; j++ ) {
                    	dataA09 = (A09CareerDetailData)carData_vt.get(j);

                    	item = XmlUtil.createElement("A09CareerDetailData");
                    	XmlUtil.addChildElement(item, "BEGDA", dataA09.BEGDA);       // ������
                    	XmlUtil.addChildElement(item, "ENDDA", dataA09.ENDDA);       // ������
                    	XmlUtil.addChildElement(item, "TOTAL", dataA09.PERIOD);       // �ٹ��Ⱓ
                    	XmlUtil.addChildElement(item, "ARBGB", dataA09.ARBGB);		// �ٹ�ó
                    	XmlUtil.addChildElement(item, "TITL_TEXT", dataA09.JIKWT);		// ����
                    	XmlUtil.addChildElement(item, "JOBB_TEXT", dataA09.STLTX);		// ����

	                	XmlUtil.addChildElement(items, item);
                    }
                }

            } else {

                funcA09 = new A09CareerDetailRFC() ;
                CareerData_vt = funcA09.getCareerDetail( user_m.empNo, "" );

                A09CareerDetailData dataA09 = new A09CareerDetailData();

                for( int j = 0 ; j < CareerData_vt.size() ; j++ ) {
                	dataA09 = (A09CareerDetailData)CareerData_vt.get(j);

                	item = XmlUtil.createElement("A09CareerDetailData");

                	XmlUtil.addChildElement(item, "BEGDA", dataA09.BEGDA);       // ������
                	XmlUtil.addChildElement(item, "ENDDA", dataA09.ENDDA);       // ������
                    XmlUtil.addChildElement(item, "TOTAL", dataA09.PERIOD);       // �ٹ��Ⱓ
                    XmlUtil.addChildElement(item, "ARBGB", dataA09.ARBGB);		// �ٹ�ó
                    XmlUtil.addChildElement(item, "TITL_TEXT", dataA09.JIKWT);		// ����
                    XmlUtil.addChildElement(item, "JOBB_TEXT", dataA09.STLTX);		// ����

                	XmlUtil.addChildElement(items, item);
                }
            }
	        //��»��� ��


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

	public void SetUserSession(String empno, HttpServletRequest req) throws Exception{

		WebUserData user_m     = new WebUserData();

	    PersonInfoRFC personInfoRFC        = new PersonInfoRFC();
	    PersonData personData   = new PersonData();

	    personData = (PersonData)personInfoRFC.getPersonInfo(empno);

	    user_m.login_stat   = "Y";
	    user_m.companyCode  = personData.E_BUKRS ;

	    Config conf         = new Configuration();
	    user_m.clientNo     = conf.get("com.sns.jdf.sap.SAP_CLIENT");

	    user_m.empNo        = empno ;

		personInfoRFC.setSessionUserData(personData, user_m);
        user_m.e_mss = "X";

		DataUtil.fixNull(user_m);

	    HttpSession session = req.getSession(true);

	    int maxSessionTime = Integer.parseInt(conf.get("com.sns.jdf.SESSION_MAX_INACTIVE_INTERVAL"));
	    session.setMaxInactiveInterval(maxSessionTime);

	    session.setAttribute("user_m",user_m);
	}
}
