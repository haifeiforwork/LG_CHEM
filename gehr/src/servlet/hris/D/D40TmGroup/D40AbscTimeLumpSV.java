/******************************************************************************/
/*																							*/
/*   System Name	:  MSS														*/
/*   1Depth Name		:  �μ�����													*/
/*   2Depth Name		:  ��ٹ�/�ٹ�												*/
/*   Program Name	:  ��ٹ�/�ٹ�(�ϰ�)										*/
/*   Program ID		:  D40AbscTimeLumpSV.java							*/
/*   Description		:  ��ٹ�/�ٹ�(�ϰ�)										*/
/*   Note				:  																*/
/*   Creation			:  2017-12-08  ������                                          	*/
/*   Update				:  2017-12-08  ������                                          	*/
/*                                                                              			*/
/********************************************************************************/
package servlet.hris.D.D40TmGroup;

import hris.D.D40TmGroup.D40AbscTimeFrameData;
import hris.D.D40TmGroup.rfc.D40AbscTimeLumpFrameRFC;
import hris.common.WebUserData;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.sns.jdf.GeneralException;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.WebUtil;

public class D40AbscTimeLumpSV extends EHRBaseServlet {

	protected void performTask( HttpServletRequest req, HttpServletResponse res ) throws GeneralException {

		try{

			WebUserData user    = WebUtil.getSessionUser(req);
			String gubun = WebUtil.nvl(req.getParameter("gubun"));
			String orgOrTm = WebUtil.nvl(req.getParameter("orgOrTm"));
			String searchDeptNo = WebUtil.nvl(req.getParameter("searchDeptNo"));
			String searchDeptNm = WebUtil.nvl(req.getParameter("searchDeptNm"));
			String iSeqno = WebUtil.nvl(req.getParameter("iSeqno"));
			String ISEQNO = WebUtil.nvl(req.getParameter("ISEQNO"));
			String I_SELTAB = WebUtil.nvl(req.getParameter("I_SELTAB"));
			String I_ACTTY = WebUtil.nvl(req.getParameter("I_ACTTY"));

			String I_BEGDA = WebUtil.nvl(req.getParameter("I_BEGDA"));
			String I_ENDDA = WebUtil.nvl(req.getParameter("I_ENDDA"));

			if("EXCEL".equals(gubun)){
				Vector OBJID = new Vector();
				if("2".equals(orgOrTm)){		//���±׷����� �����ϱ�
					String[] iSeqnos = ISEQNO.split(",");
					for(int i=0; i<iSeqnos.length; i++){
						D40AbscTimeFrameData data = new D40AbscTimeFrameData();
						if(!"".equals(iSeqnos[i])){
							data.OBJID = WebUtil.nvl(iSeqnos[i]);
							OBJID.addElement(data);
						}
					}
				}else{		//�������� �����ϱ�
					String[] deptNos = searchDeptNo.split(",");
					for(int i=0; i<deptNos.length; i++){
						if(!"".equals(WebUtil.nvl(deptNos[i]))){
							D40AbscTimeFrameData data = new D40AbscTimeFrameData();
							data.OBJID = WebUtil.nvl(deptNos[i]);
							OBJID.addElement(data);
						}
					}
				}
				Vector vec = (new D40AbscTimeLumpFrameRFC()).getAbscTimeLumpExcelDown(user.empNo, I_ACTTY, I_SELTAB, OBJID );
				req.setAttribute("viewSource", "true");
				req.setAttribute("excelSheet1", vec.get(0));
				req.setAttribute("excelSheet2", vec.get(1));	//����
				req.setAttribute("excelSheet3", vec.get(2));	//���»���
				req.setAttribute("excelSheet4", vec.get(3));	//���»���
				printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40AbscTimeExcelDown.jsp");

		    }else if("SAVE".equals(gubun)){

		    	String PERNR[] = req.getParameterValues("PERNR");	//��� ��ȣ
		    	String ENAME[] = req.getParameterValues("ENAME");	//����
		    	String WTMCODE[] = req.getParameterValues("WTMCODE");	//��������
		    	String BEGDA[] = req.getParameterValues("BEGDA");	//	������
		    	String ENDDA[] = req.getParameterValues("ENDDA");	//������
		    	String AWART[] = req.getParameterValues("AWART");	//�ٹ�/�޹� ����
		    	String INFTY[] = req.getParameterValues("INFTY");	//	����Ÿ��
		    	String TPROG[] = req.getParameterValues("TPROG");	//	���ϱٹ�����
		    	String BEGUZ[] = req.getParameterValues("BEGUZ");	//���۽ð�
		    	String ENDUZ[] = req.getParameterValues("ENDUZ");	//	����ð�
		    	String REASON[] = req.getParameterValues("REASON");	//�����ڵ�
		    	String DETAIL[] = req.getParameterValues("DETAIL");	//�󼼻���
		    	String REASON_YN[] = req.getParameterValues("REASON_YN");	//�����ڵ� �ʼ�����
		    	String DETAIL_YN[] = req.getParameterValues("DETAIL_YN");	//�󼼻��� �ʼ�����
		    	String TIME_YN[] = req.getParameterValues("TIME_YN");	//	�ð��Է� �ʼ�����

		    	Vector OBJID = new Vector();
				for( int i = 0; i <  PERNR.length; i++ ){
					D40AbscTimeFrameData excelDt = new D40AbscTimeFrameData();
					excelDt.PERNR = PERNR[i];
					excelDt.ENAME = ENAME[i];
					excelDt.WTMCODE = WTMCODE[i];
					excelDt.BEGDA = BEGDA[i].replace(".","");
					excelDt.ENDDA = ENDDA[i].replace(".","");
					excelDt.AWART = AWART[i];
					excelDt.INFTY = INFTY[i];
					excelDt.TPROG = TPROG[i];

					if(!"".equals(WebUtil.nvl(BEGUZ[i]))){
						String sBEGUZ = BEGUZ[i].substring(0,2);
						if("24".equals(sBEGUZ)){
							sBEGUZ = "00";
						}
						String eBEGUZ = BEGUZ[i].substring(3,5);
						excelDt.BEGUZ	= sBEGUZ+eBEGUZ;
					}else{
						excelDt.BEGUZ	= BEGUZ[i];
					}
					if(!"".equals(WebUtil.nvl(ENDUZ[i]))){
						if("00:00".equals(WebUtil.nvl(ENDUZ[i]))){
							excelDt.ENDUZ = "2400";
						}else{
							excelDt.ENDUZ	= ENDUZ[i].replace(":","");
						}
					}else{
						excelDt.ENDUZ	= ENDUZ[i];
					}

					excelDt.REASON = REASON[i];
					excelDt.DETAIL = DETAIL[i];
					excelDt.REASON_YN = REASON_YN[i];
					excelDt.DETAIL_YN = DETAIL_YN[i];
					excelDt.TIME_YN = TIME_YN[i];

					OBJID.addElement(excelDt);
				}

				D40AbscTimeLumpFrameRFC rfc = new D40AbscTimeLumpFrameRFC();
				I_ACTTY = "A";	//������ : U �ϰ����ε�, A ���ε��ļ����ݿ�
				Vector resultList = rfc.saveTable(user.empNo, I_ACTTY, OBJID);

				String E_RETURN = (String)resultList.get(0);	//�����ڵ�
				String E_MESSAGE = (String)resultList.get(1);	//���ϸ޼���
				String E_SAVE_CNT = (String)resultList.get(2);	//ó������
				Vector OBJPS_OUT1 = (Vector)resultList.get(3);	//��ȸ������
				Vector OBJPS_OUT3 = (Vector)resultList.get(4);	//����	�ڵ�-�ؽ�Ʈ
				Vector OBJPS_OUT4 = (Vector)resultList.get(5);	//���»���	�ڵ�-�ؽ�Ʈ
				Vector OBJPS_OUT5 = (Vector)resultList.get(6);	//���»���	�ڵ�-�ؽ�Ʈ


				req.setAttribute("E_RETURN", E_RETURN);
				req.setAttribute("E_MESSAGE", E_MESSAGE);
				req.setAttribute("E_SAVE_CNT", E_SAVE_CNT);
				req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);	//��ȸ������
				req.setAttribute("OBJPS_OUT3", OBJPS_OUT3);	//����	�ڵ�-�ؽ�Ʈ
				req.setAttribute("OBJPS_OUT4", OBJPS_OUT4);	//���»���	�ڵ�-�ؽ�Ʈ
				req.setAttribute("OBJPS_OUT5", OBJPS_OUT5);	//��Ÿ
				req.setAttribute("viewSource", "true");
		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40AbscTimeLumpExcel.jsp");

		    }else if("SEARCHONE".equals(gubun)){

		    	I_ACTTY = "P";	//P:���߰� �� �Է��ʵ� ���涧���� ����

		    	String searchPERNR = WebUtil.nvl(req.getParameter("searchPERNR"));
				String searchBEGDA = WebUtil.nvl(req.getParameter("searchBEGDA"));
				String searchWTMCODE = WebUtil.nvl(req.getParameter("searchWTMCODE"));
				String no = WebUtil.nvl(req.getParameter("no"));

		    	Vector T_IMLIST = new Vector();
	    		D40AbscTimeFrameData data = new D40AbscTimeFrameData();

				if(!"".equals(searchPERNR)){
					data.PERNR = searchPERNR;
				}
				if(!"".equals(searchBEGDA)){
					data.BEGDA = searchBEGDA.replace(".","");
				}
				if(!"".equals(searchWTMCODE)){
					data.WTMCODE = searchWTMCODE;
				}
				T_IMLIST.addElement(data);

		    	Vector vec = (new D40AbscTimeLumpFrameRFC()).getOverTimeOne(user.empNo, I_ACTTY, T_IMLIST);

		    	Vector OBJPS_OUT1 = (Vector)vec.get(2);	//��ȸ�� ����
		    	String E_RETURN = (String)vec.get(3);	//RETURN

		    	req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);
		    	req.setAttribute("E_RETURN", E_RETURN);
		    	req.setAttribute("no", no);
		    	req.setAttribute("viewSource", "true");
		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40AbscTimeHidden.jsp");

		    }else{


		    	String I_DATUM = "";
				String I_SCHKZ = "";
				Vector T_IMPERS = new Vector();
				Vector OBJID = new Vector();
				I_ACTTY = "T";
				Vector vec = (new D40AbscTimeLumpFrameRFC()).getAbscTimeLump(user.empNo, I_ACTTY, I_SCHKZ, T_IMPERS, I_SELTAB, OBJID);

		    	String E_RETURN 		= (String)vec.get(0);	//�����ڵ�
		    	String E_MESSAGE 	= (String)vec.get(1);	//���ϸ޼���
	            String E_BEGDA 		= (String)vec.get(2);	//��ȸ������
	            String E_ENDDA 		= (String)vec.get(3);	//��ȸ������
	            String E_SAVE_CNT 	= (String)vec.get(4);	//����� �Ǽ� ī��Ʈ �ȳ�����
	            String E_INFO 			= (String)vec.get(5);	//�ȳ�����
	            Vector OBJPS_OUT1 = (Vector)vec.get(6);	//��ȸ������
	            Vector OBJPS_OUT2 = (Vector)vec.get(7);	//��ȹ�ٹ�	�ڵ�-�ؽ�Ʈ
	            Vector OBJPS_OUT3 = (Vector)vec.get(8);	//���»���	�ڵ�-�ؽ�Ʈ
	            Vector OBJPS_OUT4 = (Vector)vec.get(9);	//���»���	�ڵ�-�ؽ�Ʈ
	            Vector OBJPS_OUT5 = (Vector)vec.get(10);	//��Ÿ

	            req.setAttribute("E_INFO", E_INFO);
	            req.setAttribute("OBJPS_OUT1", OBJPS_OUT1);
	            req.setAttribute("OBJPS_OUT3", OBJPS_OUT3);
	            req.setAttribute("OBJPS_OUT4", OBJPS_OUT4);
	            req.setAttribute("OBJPS_OUT5", OBJPS_OUT5);

	            req.setAttribute("textChange", "Y");		//�ȳ����� ��ü�Ѵ�.
	            req.setAttribute("viewSource", "true");
		    	printJspPage(req, res, WebUtil.JspURL + "D/D40TmGroup/D40AbscTimeLumpExcel.jsp");

		    }

		} catch (Exception e) {
//			e.printStackTrace();
			throw new GeneralException(e);
		}
	}

}
