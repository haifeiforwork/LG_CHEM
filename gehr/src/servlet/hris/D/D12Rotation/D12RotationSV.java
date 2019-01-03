package  servlet.hris.D.D12Rotation;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D12Rotation.D12RotationData;
import hris.D.D12Rotation.D12RotationSearchData;
import hris.D.D12Rotation.rfc.D12OrgehRFC;
import hris.D.D12Rotation.rfc.D12RotationCnRFC;
import hris.D.D12Rotation.rfc.D12RotationRFC;
import hris.D.D12Rotation.rfc.D12RotationSimulationRFC;
import hris.D.D12Rotation.rfc.SearchDeptNameRotRFC;
import hris.D.D12Rotation.rfc.SearchDeptNameRotDeptTimeRFC;
import hris.common.WebUserData;

/**
 * D12RotationSV.java
 * ������ ������ ����� ���¸� �Է��� �� �ֵ��� �ϴ� Class
 *
 * @author �赵��
 * @version 1.0, 2004/02/24
 */

public class D12RotationSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        Connection con = null;
        String dest    = "";
        try{
        	WebUserData user = WebUtil.getSessionUser(req);
        	/* 2018-03-12  @PJ.������ ����(G570) Roll-Out Start */
        	//if( !user.companyCode.equals("G180") ){
        	// 2018-08-01 ������ @PJ.��ù���(G620) Roll-out
        	if( !user.companyCode.equals("G180") && !user.companyCode.equals("G570") && !user.companyCode.equals("G620") ){
        	/* 2018-03-12  @PJ.������ ����(G570) Roll-Out End  */
	            String jobid     = "";
	            String i_date   = "";         //������ ��ȸ�� ��������
	            String i_orgeh  = "";        //������ ��ȸ�� �μ��ڵ�

	            Box box = WebUtil.getBox(req);
	            jobid   = box.get("jobid");
	            i_date = box.get("I_DATE");
	            i_orgeh = box.get("hdn_deptId");
	            String deptNm = box.get("hdn_deptNm");
	            String isPop = req.getParameter("hdn_isPop");
	            String i_gbn = box.get("I_GBN");
	            String i_searchdata   = box.get("I_SEARCHDATA");
	            String i_OTEXT   = box.get("E_OTEXT");  //������ ������
	            String i_pernr = "";

	            Logger.debug.println(this, "\n   user.companyCode[0] : " + user.companyCode);
	            Logger.debug.println(this, "\n   i_gbn : " + i_gbn +"i_searchdata:"+i_searchdata +"jobid:"+jobid  +"i_orgeh:"+i_orgeh+"deptNm:"+deptNm);

	            if(i_gbn == null || i_gbn.equals("")){
	            	i_gbn = "ORGEH";
	            }
	             if(i_gbn.equals("PERNR")){
	            	i_pernr = i_searchdata;
	            }

	            if( jobid.equals("") ){
	                jobid = "first";
	            }
	            //�������ڰ� ������� �������ڸ� default���Ѵ�.
	            if( i_date == null || i_date.equals("") ) {
	                i_date = DataUtil.getCurrentDate();
	            }
	            if( i_orgeh == null || i_orgeh.equals("") ) {
	            	i_orgeh = user.e_orgeh;
	            }
	            if (i_pernr == null || i_pernr.equals("")) {
	            	i_pernr = user.empNo;
	            }

		        /*************************************************************
		         * @$ ���������� marco257
		         * ���ǿ� �ִ� e_timeadmin = Y �� ����� �μ� ���� ������ ����.
		         * user.e_authorization.equals("E") ���� !user.e_timeadmin.equals("Y")�� ����
		         *
		         * @ sMenuCode �ڵ� �߰�
		         * �μ����� ������ �ִ� ����� MSS������ �ִ� ����� üũ�ϱ� ���� �߰�
		         * 1406 : �μ����� ������ �ִ� �޴��ڵ�(e_timeadmin ���� üũ)
		         * 1184 : �μ��λ������� -> ������� -> ���� -> �������� ����ǥ�� ������ �ִ»��
		         * �߰�: �޴� �ڵ尡 ������� ���� ������ �켱�Ѵ�.
		         *  (e_timeadmin ���� üũ���� )
		         **************************************************************/

		        String sMenuCode = WebUtil.nvl(req.getParameter("sMenuCode"));
		        if(sMenuCode.equals("ESS_HRA_TIME_MAIN")){         //�����λ����� > ��û > �μ�����
		        	if(!checkTimeAuthorization(req, res)) return;
		        }else{                                                               //�μ��λ�����
//		    	 @����༺ �߰�
		        	if ( user.e_authorization.equals("E")) {
		        		if(!checkTimeAuthorization(req, res)) return;
		        	}
		        }

	            D12OrgehRFC     rfcOrgeh    = new D12OrgehRFC();

	            Vector          main_vt      = new Vector();
	            Vector          ret             = new Vector();
	            Vector          orgeh_vt     = new Vector();
	            int rowcount = box.getInt("rowCount");

	            Logger.debug.println(this, "\n------------- jobid : " + jobid +"i_orgeh:"+i_orgeh);
	            req.setAttribute("viewSource", "true"); //��Ŭ���� Ǯ��� ��
	            if( jobid.equals("first") ) {                 //����ó�� ���� ȭ�鿡 ���°��.
	            	//��ٰ����� ���� ����Ʈ�� �о� ��ü ��� ����Ʈ�� jsp�� �����Ѵ�.
	            	if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
	            		ret = rfcOrgeh.getDetailForOrgeh(i_date, i_orgeh);
	            	}else if(i_gbn.equals("PERNR")){
	            		ret = rfcOrgeh.getDetailForPernr(i_date, i_pernr);
	            	}



	                orgeh_vt = (Vector)ret.get(0);
	                String E_RETURN    = (String)ret.get(1);
	                String E_MESSAGE = (String)ret.get(2);
	                String E_STATUS = (String)ret.get(3);
	                String E_OTEXT = (String)ret.get(4);
	                i_orgeh = (String)ret.get(5);

	                Logger.debug.println(this, "\n------------- ret : " + ret.toString() );

	                if (! E_RETURN.equals("E") ) {


	                	//�ֱٰ˻�������� ������
	                	D12RotationSearchData d12SearchData = new D12RotationSearchData();
	                	SearchDeptNameRotDeptTimeRFC func = null;
	        	        Vector DeptName_vt  = null;
	                    Vector search_vt    = new Vector();

	    	        	func       		= new SearchDeptNameRotDeptTimeRFC();
	    	        	DeptName_vt  	= new Vector();

	    	            d12SearchData.SPERNR = user.empNo  ;    //��� ��ȣ
	    	            d12SearchData.OBJID = i_orgeh  ;    //������Ʈ ID
	    	            d12SearchData.STEXT =E_OTEXT  ;    //������Ʈ �̸�
	    	            d12SearchData.EPERNR = i_pernr  ;    //��� ��ȣ
	    	            d12SearchData.ENAME = ""  ;    //�����
	    	            d12SearchData.OBJTXT = deptNm  ;     //��� �Ǵ� �������� ���˵� �̸�
	    	            search_vt.addElement(d12SearchData);
	    	            Vector Searchret 		= func.setDept(user.empNo, "","",search_vt); //���� Set!!!
	    	            //�ֱٰ˻����

	                    Logger.debug.println("\n===SAVE=====search_vt "+search_vt.toString() );

		                for( int i = 0 ; i < orgeh_vt.size() ; i++ ) {
		                	D12RotationData dataOrgeh = (D12RotationData)orgeh_vt.get(i);
		                	dataOrgeh.ADDYN = "N";
		                    main_vt.addElement(dataOrgeh);
		                }
		                req.setAttribute("deptNm",            deptNm);
		                req.setAttribute("E_OTEXT",            E_OTEXT);
		                req.setAttribute("jobid",            jobid);
		                req.setAttribute("main_vt",       main_vt);
		                req.setAttribute("rowCount"  ,   Integer.toString(orgeh_vt.size())   );
		                if(isPop==null||isPop.equals("")){
		                	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail.jsp?hdn_deptId="+i_orgeh+"&hdn_deptNm="+deptNm+"&I_DATE="+i_date+"&E_STATUS="+E_STATUS+"&I_SEARCHDATA="+i_searchdata;
		                }else{
		                	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail.jsp?hdn_isPop="+isPop+"&hdn_deptId="+i_orgeh+"&hdn_deptNm="+deptNm+"&I_DATE="+i_date+"&E_STATUS="+E_STATUS;
		                }
	                } else {
	                    String msg = E_MESSAGE;
	                    req.setAttribute("msg", msg);
	                    dest = WebUtil.JspURL+"common/msg.jsp";
	                }

	                Logger.debug.println("\n====================dest "+dest);
	            } else if( jobid.equals("saveData") ) {       //����� �����Ѵ�.


	                for( int i = 0 ; i < rowcount ; i++ ) {
	                    D12RotationData data_main = new D12RotationData();
	                    String          idx       = Integer.toString(i);

	                    String l_changeFlag = box.get("changeFlag"+idx);
	                    String SUBTY = box.get("SUBTY"+idx);

	                    if( l_changeFlag.equals("Y") ) {
	                    	data_main.BEGDA      = i_date;
	                        data_main.PERNR      = box.get("PERNR" +idx);
	                        data_main.SUBTY     = box.get("SUBTY" +idx);
	                        data_main.BEGUZ      = box.get("BEGUZ"+idx);
	                        if( !data_main.BEGUZ.equals("") ) {
	                            data_main.BEGUZ += "00";
	                        } else {
	                            data_main.BEGUZ = "000000";
	                        }
	                        data_main.ENDUZ      = box.get("ENDUZ"+idx);
	                        if( !data_main.ENDUZ.equals("") ) {
	                            data_main.ENDUZ += "00";
	                        } else {
	                        	data_main.ENDUZ = "000000";
	                        }
	                        data_main.PBEG1      = box.get("PBEG1"+idx);
	                        if( !data_main.PBEG1.equals("") ) {
	                            data_main.PBEG1 += "00";
	                        }else {
	                        	data_main.PBEG1 = "000000";
	                        }
	                        data_main.PEND1      = box.get("PEND1"+idx);
	                        if( !data_main.PEND1.equals("") ) {
	                            data_main.PEND1 += "00";
	                        }else {
	                        	data_main.PEND1 = "000000";
	                        }
	                        data_main.ENAME     = box.get("ENAME" +idx);
	                        data_main.VTKEN = box.get("VTKEN"+idx).equals("Y")? "X":"";
	                        data_main.REASON        = box.get("REASON"+idx);
	                        data_main.CONG_CODE  = box.get("CONG_CODE" +idx);
	                        data_main.CONG_DATE  = box.get("CONG_DATE" +idx);
	                        data_main.HOLI_CONT   = box.get("HOLI_CONT" +idx);
	                        data_main.A002_SEQN   = box.get("P_A024_SEQN" +idx);
	                        data_main.ADDYN         = box.get("ADDYN" +idx);
	                        data_main.ATEXT         = box.get("ATEXT" +idx);
	                        data_main.OVTM_CODE = box.get("OVTM_CODE" +idx);  // CSR ID:1546748

	                        data_main.AEDTM = DataUtil.getCurrentDate();
	                        data_main.UNAME = user.webUserId;
	                        data_main.ZPERNR        = user.empNo;
	                        Logger.debug.println(this, "\n###################### data_main : " + data_main.toString() );
	                        main_vt.addElement(data_main);
	                    }
	                }

	                D12RotationSimulationRFC  rfcCheck         = new D12RotationSimulationRFC();
	                // �۾��� ����� ���� �Է� ���� �� ���������� üũ�Ѵ�.
	                Vector ret1 		= rfcCheck.CheckData(main_vt);

	                String E_RETURN 	= (String)ret1.get(0);
	                String E_MESSAGE 	= (String)ret1.get(1);
	                Logger.debug.println(this, "\n------------- E_RETURN : " + E_RETURN );
	                Logger.debug.println(this, "\n------------- E_MESSAGE : " + E_MESSAGE );

	                if(  E_RETURN.equals("E")){
	        	        String msg = E_MESSAGE;
	        	        //String url = "parent.close(); ";
	        	        //String url = "history.back(); ";
	                    String url = "location.href = '" + WebUtil.JspPath+"D/D12Rotation/D12RotationDetailWait.jsp?I_DATE="+i_date+"&hdn_deptId="+i_orgeh+"&hdn_isPop="+isPop+"&I_SEARCHDATA="+i_searchdata+"&I_GBN="+i_gbn+"';";

		                req.setAttribute("main_vt",     main_vt);
	        	        req.setAttribute("msg", msg);
	        	        req.setAttribute("url", url);
	        	        dest = WebUtil.JspURL+"common/msg.jsp";
	                }else{

		                D12RotationRFC  rfc         = new D12RotationRFC();
		                Logger.debug.println(this, "\n---SAVE---------- main_vt : " + main_vt.toString() );
		                Logger.debug.println(this, "\n------------- i_orgeh : " + i_orgeh );
		                Logger.debug.println(this, "\n------------- i_date : " + i_date );
		                // �۾��� ������ ����� ���� �Է� ������ �����Ѵ�.
		                Vector ret2 		= rfc.saveData(main_vt,i_orgeh,i_date);

		                E_RETURN 	= (String)ret2.get(0);
		                E_MESSAGE 	= (String)ret2.get(1);

		                Logger.debug.println(this, "\n------------- E_RETURN_SAVE : " + E_RETURN );
		                Logger.debug.println(this, "\n------------- E_MESSAGE_SAVE : " + E_MESSAGE );
		                if(! E_RETURN.equals("E") ){
		                	if(E_RETURN.equals("I")){//��� I �ϱ�????? EUNHA

				                req.setAttribute("hdn_deptId",  i_orgeh);
				                req.setAttribute("deptNm",            deptNm);
				                req.setAttribute("hdn_deptNm",            deptNm);
				                req.setAttribute("I_DATE",       i_date);

				                req.setAttribute("E_OTEXT",            i_OTEXT);
				                req.setAttribute("main_vt",     main_vt);
			                    String url = "location.href = '" + WebUtil.JspPath+"D/D12Rotation/D12RotationDetailWait.jsp?I_DATE="+i_date+"&hdn_deptId="+i_orgeh+"&hdn_isPop="+isPop+"&I_SEARCHDATA="+i_searchdata+"&I_GBN="+i_gbn+"&E_OTEXT="+i_OTEXT+"';";
			                    req.setAttribute("E_RETURN", E_RETURN);
			                    req.setAttribute("E_MESSAGE", E_MESSAGE);
			                    req.setAttribute("url", url);

			                    dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail.jsp?hdn_deptId="+i_orgeh+"&hdn_deptNm="+deptNm+"&I_DATE="+i_date+"&I_SEARCHDATA="+i_searchdata+"&I_GBN="+i_gbn+"&E_OTEXT="+i_OTEXT;
		                	}else{

			                	String msg = "msg008";
			                	req.setAttribute("jobid",  i_orgeh);
				                req.setAttribute("deptNm",            deptNm);
				                req.setAttribute("hdn_deptNm",            deptNm);
			                	req.setAttribute("hdn_deptId",  i_orgeh);
				                req.setAttribute("I_DATE",       i_date);
				                req.setAttribute("E_OTEXT",            i_OTEXT);

				                req.setAttribute("main_vt",     main_vt);
			                    String url = "location.href = '" + WebUtil.JspPath+"D/D12Rotation/D12RotationDetailWait.jsp?hdn_deptId="+i_orgeh+"&hdn_deptNm="+deptNm+"&I_DATE="+i_date+"&I_SEARCHDATA="+i_searchdata+"&hdn_isPop="+isPop+"&I_GBN="+i_gbn+"&E_OTEXT="+i_OTEXT+"';";
			                    req.setAttribute("msg", msg);
			                    req.setAttribute("url", url);

			                    dest = WebUtil.JspURL+"common/msg.jsp";
		                	}
		                }else{

		                    String msg = E_MESSAGE;
		        	        //String url = "parent.close(); ";
		        	        String url = "history.back(); ";

			                req.setAttribute("main_vt",     main_vt);
		        	        req.setAttribute("msg", msg);
		        	        req.setAttribute("url", url);
		        	        dest = WebUtil.JspURL+"common/msg.jsp";
		                }
	                }
	                Logger.debug.println(this, "\n------------- dest : " + dest );

	            } else if( jobid.equals("AddorDel") ) {       //�߰� ,����

	                for( int i = 0 ; i < rowcount ; i++ ) {
	                    D12RotationData data_main = new D12RotationData();
	                    String          idx       = Integer.toString(i);


	                    	data_main.BEGDA      = i_date;
	                        data_main.PERNR      = box.get("PERNR" +idx);
	                        data_main.ENAME     = box.get("ENAME" +idx);
	                        data_main.SUBTY     = box.get("SUBTY" +idx);

	                        data_main.BEGUZ      = box.get("BEGUZ"+idx);
	                        if( !data_main.BEGUZ.equals("") ) {
	                            data_main.BEGUZ += "00";
	                        } else {
	                            data_main.BEGUZ = "000000";
	                        }
	                        data_main.ENDUZ      = box.get("ENDUZ"+idx);
	                        if( !data_main.ENDUZ.equals("") ) {
	                            data_main.ENDUZ += "00";
	                        } else {
	                        	data_main.ENDUZ = "000000";
	                        }
	                        data_main.PBEG1      = box.get("PBEG1"+idx);
	                        if( !data_main.PBEG1.equals("") ) {
	                            data_main.PBEG1 += "00";
	                        }else {
	                        	data_main.PBEG1 = "000000";
	                        }
	                        data_main.PEND1      = box.get("PEND1"+idx);
	                        if( !data_main.PEND1.equals("") ) {
	                            data_main.PEND1 += "00";
	                        }else {
	                        	data_main.PEND1 = "000000";
	                        }
	                        data_main.VTKEN = box.get("VTKEN"+idx).equals("Y")? "X":"";
	                        data_main.REASON        = box.get("REASON"+idx);
	                        data_main.CONG_CODE  = box.get("CONG_CODE" +idx);
	                        data_main.CONG_DATE  = box.get("CONG_DATE" +idx);
	                        data_main.HOLI_CONT   = box.get("HOLI_CONT" +idx);
	                        data_main.A002_SEQN   = box.get("P_A024_SEQN" +idx);
	                        data_main.ADDYN         = box.get("ADDYN" +idx);
	                        data_main.ATEXT         = box.get("ATEXT" +idx);
	                        data_main.OVTM_CODE = box.get("OVTM_CODE" +idx);  // CSR ID:1546748

		                	if (!data_main.ADDYN.equals("D"))
	                             main_vt.addElement(data_main);
	                }

	                req.setAttribute( "main_vt"   , main_vt    );
	                req.setAttribute("deptNm",            deptNm);
	                req.setAttribute("hdn_deptNm",            deptNm);
	                req.setAttribute( "rowCount"  ,Integer.toString(rowcount)   );
	                req.setAttribute( "E_OTEXT"  ,i_OTEXT  );
	                //dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail.jsp?I_SEARCHDATA="+i_searchdata;
	            	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail.jsp?I_SEARCHDATA="+i_searchdata+"&hdn_isPop="+isPop+"&hdn_deptId="+i_orgeh+"&hdn_deptNm="+deptNm+"&I_DATE="+i_date;

	            } else if( jobid.equals("print") ) {
	            	if(i_gbn.equals("ORGEH")||i_gbn.equals("RECENT")){
	            		ret = rfcOrgeh.getDetailForOrgeh(i_date, i_orgeh);
	            	}else if(i_gbn.equals("PERNR")){
	            		ret = rfcOrgeh.getDetailForPernr(i_date, i_pernr);
	            	}

	                orgeh_vt = (Vector)ret.get(0);
	                String E_RETURN    = (String)ret.get(1);
	                String E_MESSAGE = (String)ret.get(2);
	                String E_STATUS = (String)ret.get(3);
	                String E_OTEXT = (String)ret.get(4);
	                i_orgeh = (String)ret.get(5);

	                if (! E_RETURN.equals("E") ) {
		                for( int i = 0 ; i < orgeh_vt.size() ; i++ ) {
		                	D12RotationData dataOrgeh = (D12RotationData)orgeh_vt.get(i);
		                	dataOrgeh.ADDYN = "N";
		                    main_vt.addElement(dataOrgeh);
		                }
		                req.setAttribute("deptNm",        deptNm);
		                req.setAttribute("hdn_deptNm",  deptNm);
		                req.setAttribute("jobid",            jobid);
		                req.setAttribute("main_vt",        main_vt);
		                req.setAttribute("rowCount"  ,    Integer.toString(orgeh_vt.size())   );

		                dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail_print.jsp?hdn_deptId="+i_orgeh+"&hdn_deptNm="+deptNm+"&I_DATE="+i_date+"&E_STATUS="+E_STATUS;

	                } else {
	                    String msg = E_MESSAGE;
	                    req.setAttribute("msg", msg);
	                    dest = WebUtil.JspURL+"common/msg.jsp";
	                }
	            }else {
	                throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
	            }
	        //
        	}else{
        		String deptId 		= WebUtil.nvl(req.getParameter("hdn_deptId"), user.e_objid); 	// �μ��ڵ�
        		String i_date 		= WebUtil.nvl(req.getParameter("I_DATE"));
        		String checkYN 	= WebUtil.nvl(req.getParameter("chck_yeno"), "N");				// �����μ�����
        		String excelDown = WebUtil.nvl(req.getParameter("hdn_excel"));  						// excelDown

        		boolean E_RETURN = false;
			    // ����༺ �߰�
	            if(!checkAuthorization(req, res)) return;

				if (i_date.equals("")) {
					i_date = DataUtil.getCurrentDate();
				}
				Vector <D12RotationData> D12RotationData_vt = null;
	            D12RotationCnRFC d12Rfc = null;
	            d12Rfc = new D12RotationCnRFC();
	            D12RotationData_vt = d12Rfc.getRotation(deptId, checkYN, i_date);

	            E_RETURN = d12Rfc.getReturn().isSuccess();

	            if( E_RETURN ){
					req.setAttribute("D12RotationData_vt", D12RotationData_vt);
					req.setAttribute("I_DATE", i_date);
					req.setAttribute("checkYn", checkYN);
	            }
		        if( excelDown.equals("ED") ) //���������� ���.
		        	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetailExcel_CN.jsp";
		        else
		        	dest = WebUtil.JspURL+"D/D12Rotation/D12RotationDetail_CN.jsp";
        	}
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
	}
}
