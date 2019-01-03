
/*	  System Name  	: g-HR
/*   1Depth Name		: Application
/*   2Depth Name  	: Benefit Management
/*   Program Name 	: Medical Fee
/*   Program ID   		: E17HospitalBuildSV
/*   Description  		: �Ƿ�� ��û�� �ϴ� Class
/*   Note         		:
/*   Creation    		: 2002-01-08 �輺��
/*   Update       		: 2005-02-16 ������
/*                  		: 2005-12-26 @v1.1 [C2005121301000001097] �ſ�ī��/���ݱ����߰�
/*   Update				: 2009-05-18 jungin @v1.2 [C20090514_56175] ���谡�� ���� 'ZINSU' �ʵ� �߰�.
/*							  2017-05-25 eunha [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ
/********************************************************************************/

package servlet.hris.E.Global.E17Hospital;

import hris.E.Global.E17Hospital.E17HospitalDetailData;
import hris.E.Global.E17Hospital.E17HospitalDetailData1;
import hris.E.Global.E17Hospital.E17HospitalDetailData2;
import hris.E.Global.E17Hospital.rfc.E17HospitalCodeRFC;
import hris.E.Global.E17Hospital.rfc.E17HospitalDetailRFC;
import hris.E.Global.E17Hospital.rfc.E17HospitalDetailRFC01;
import hris.E.Global.E17Hospital.rfc.E17HospitalFmemberRFC;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;

import hris.common.rfc.PersonInfoRFC;
import hris.common.PersonData;
import hris.common.rfc.RepeatCheckRFC;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.common.Utils;
import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.io.IOUtils;
import java.security.SecureRandom;

public class E17HospitalBuildSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "11"; // ���� ����Ÿ��(�Ƿ��)
	private String UPMU_NAME = "Medical Fee";

    protected String getUPMU_TYPE() {
        return UPMU_TYPE;
    }
    protected String getUPMU_NAME() {
        return UPMU_NAME;
    }

	protected void performTask(final HttpServletRequest req, HttpServletResponse res)	throws GeneralException {

		try {
			HttpSession session = req.getSession(false);

			final WebUserData user = WebUtil.getSessionUser(req);
			final Box box = WebUtil.getBox(req);

			final Vector E17HospitailFile_vt = new  Vector();

			/*ServletFileUpload sfu = new ServletFileUpload(factory);
            ///sfu.setFileSizeMax(5 * 1024 * 1024);
            //sfu.setSizeMax(25 * 1024 * 1024);
            //sfu.setHeaderEncoding("UTF-8");*/

	        try {

				String path =  WebUtil.UploadFilePath+ File.separator +"E17"+ File.separator;  // path check

				File dir = new File(path);
				if(!dir.exists()) dir.mkdirs();

                for(int n = 1; n <= 5; n++) {
					FileItem fileItem = (FileItem) box.getObject("File0" + n);

					if(fileItem != null) {
						//[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ start
						//String fileName =new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+new Double(Math.random()*1000).intValue(); // newSourceName+"_"+new Double(Math.random()*10000).intValue();
						String fileName =new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+new Double(new SecureRandom().nextDouble()*1000).intValue(); // newSourceName+"_"+new Double(Math.random()*10000).intValue();
						//[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ end
						String lname=fileItem.getFieldName();
						String sourceName = fileItem.getName();

						String newSourceName= sourceName.substring(sourceName.lastIndexOf("\\")+1);

						//Logger.debug.println("****************"+sourceName);
						String suffix = sourceName.substring(sourceName.lastIndexOf("."));

						// ÷�� ���� ����

						if( !(suffix.equalsIgnoreCase(".jpg") || suffix.equalsIgnoreCase(".jpeg") || suffix.equalsIgnoreCase(".gif") || suffix.equalsIgnoreCase(".tif")
								|| suffix.equalsIgnoreCase(".bmp") || suffix.equalsIgnoreCase(".png") || suffix.equalsIgnoreCase(".xls") || suffix.equalsIgnoreCase(".xlsx")
								|| suffix.equalsIgnoreCase(".ppt") || suffix.equalsIgnoreCase(".pptx") || suffix.equalsIgnoreCase(".doc")|| suffix.equalsIgnoreCase(".docx")
							|| suffix.equalsIgnoreCase(".pdf")|| suffix.equalsIgnoreCase(".hwp")) ) {

							moveMsgPage(req, res, g.getMessage("MSG.COMMON.UPLOAD.EXTFAIL"), "history.back();");
						}

						E17HospitalDetailData2 e17Hfile=new E17HospitalDetailData2();
						//e17Hfile.AINF_SEQN=AINF_SEQN;
						e17Hfile.FILE_NM= fileName;
						e17Hfile.FILE_PATH=path;
						e17Hfile.FILE_TYPE=suffix;
						e17Hfile.CREATE_BY=user.empNo;
						e17Hfile.PERNR=user.empNo;
						e17Hfile.REQ_TYPE="M";
						E17HospitailFile_vt.addElement(e17Hfile);

						String fpath= path + fileName + suffix;

						//Logger.debug.println("******** fpath =========********"+fpath);

						IOUtils.copy(fileItem.getInputStream(),  new FileOutputStream(fpath));
					}

	            }
	        }catch (Exception e) {
	        	Logger.error(e);
	        	throw new GeneralException(e);
	        }
			//--------2016.11.18 end---
			String dest	= "";
			String jobid = box.get("jobid","first");

			String PERNR = getPERNR(box, user); //��û����� ���
			box.put("PERNR",PERNR);

			String ZINSU = box.get("ZINSU");
			if (ZINSU.equals("")) {
				if(user.companyCode != null && (user.companyCode == "G220" || user.companyCode.equals("G220")) ){
					ZINSU = "In";
				}else{
					ZINSU = "O";
				}
				Logger.debug.println(this, "[#####]	ZINSU	:	[" + ZINSU + "]");
			} // end if

			req.setAttribute("ZINSU", ZINSU);

			String cdate = box.get("cdate",DataUtil.getCurrentDate());
			String waers = box.get("waers","RMB");

			// �븮 ��û �߰�
			PersonInfoRFC numfunc = new PersonInfoRFC();
            PersonData phonenumdata;
            phonenumdata    =   (PersonData)numfunc.getPersonInfo(PERNR);
			req.setAttribute("PersonData", phonenumdata);

			if (jobid.equals("first")) {

				//�������, ���� ��� ���� ��ȸ
                getApprovalInfo(req, PERNR);

				E17HospitalDetailRFC hd_rfc = new E17HospitalDetailRFC();
				E17HospitalCodeRFC e17Code = new E17HospitalCodeRFC();
				E17HospitalFmemberRFC e17member = new E17HospitalFmemberRFC();

				Vector vcResult = hd_rfc.getMediData(PERNR, ZINSU, "", "5", cdate, waers);

				E17HospitalDetailData hdata = (E17HospitalDetailData)vcResult.get(0);
				String wtem = (String)Utils.indexOf(vcResult, 1); //(String)vcResult.get(1);

				Vector mediCodeList = e17Code.getMediCode();
				Vector memberList = e17member.getCodeVector(PERNR);

				req.setAttribute("mediCodeList", mediCodeList);
				req.setAttribute("memberList", memberList);

				//Logger.debug.println(this, "E17HospitalDetailData : " + hdata.toString());
				req.setAttribute("PERNR", PERNR);
				req.setAttribute("mode", "Build");
				req.setAttribute("upload", "true");
				req.setAttribute("E17HospitalDetailData", hdata);   // Ȯ�� �� ����

				String sWaers = "";
				 if( hdata.getWAERS().equals("") ) {
					 sWaers = "KRW";
				}else {
					sWaers = hdata.getWAERS();
				}

				E17HospitalDetailData1 resultData = new E17HospitalDetailData1();

				resultData.setPLIMIT(hdata.getPLIMIT());
				resultData.setPAMT_BALANCE(hdata.getPAMT_BALANCE());
				resultData.setPAAMT_BALANCE(hdata.getPAAMT_BALANCE());
				resultData.setPRATE(hdata.getPRATE());
				resultData.setWAERS(sWaers);
				resultData.setZINSU(ZINSU);
				//resultData.setEXPENSE("0"); // �ʱ�ȭ

				DataUtil.fixNull(resultData);
				req.setAttribute("resultData", resultData);

				req.setAttribute("wtem", wtem);

				dest = WebUtil.JspURL + "E/E17Hospital/E17HospitalBuild_Global.jsp";

			} else if (jobid.equals("create")) { // ��û��

				/* ���� ��û �κ� */
                dest = requestApproval(req, box, E17HospitalDetailData1.class, new RequestFunction<E17HospitalDetailData1>() {
                    public String porcess(E17HospitalDetailData1 inputData, Vector<ApprovalLineData> approvalLine) throws GeneralException {

                        /* ���� ��û RFC ȣ�� */
                    	E17HospitalDetailRFC e17Rfc = new E17HospitalDetailRFC();
                    	e17Rfc.setRequestInput(user.empNo, UPMU_TYPE);

                    	inputData.PLIMIT			= box.get("PLIMIT");
                    	inputData.CERT_BETG	= box.get("EXPENSE");
                    	inputData.PERNR_D		= user.empNo;
                    	inputData.ZPERNR 		= user.empNo;

                    	String liness = box.get("LLINESS");
        				if(liness.length()<=70){
        					inputData.LLINESS1= liness.substring(0,liness.length()) ;
        				}
        				if(liness.length()>70 && liness.length()<= 140){
        					inputData.LLINESS1 = liness.substring(0,70) ;
        					inputData.LLINESS2 = liness.substring(70,liness.length()) ;
        				}
        				if(liness.length()>140){
        					inputData.LLINESS1 = liness.substring(0,70) ;
        					inputData.LLINESS2 = liness.substring(70,140) ;
        					inputData.LLINESS3 = liness.substring(140,liness.length()) ;
        				}

        				//inputData.AINF_SEQN 	= AINF_SEQN;
                    	box.put("ZINSU", inputData.ZINSU);
                    	box.put("I_GTYPE", "2");
                    	box.put("BEGDA", inputData.BEGDA);
                    	box.put("WAERS", inputData.WAERS);
                    	box.put("I_RTYPE", "M"); //2016.11.18

                    	String appytype = ((ApprovalLineData)approvalLine.get(0)).APPR_TYPE;

                    	//Logger.debug.println(this, "====appytype========= : " + appytype);

                    	RepeatCheckRFC crfc=new RepeatCheckRFC();
        				Vector rmess = crfc.checkApp(user.companyCode, box.get("PERNR"), UPMU_TYPE, appytype, "");

        				if(((String)rmess.get(0)).equalsIgnoreCase("N")){

	                        String AINF_SEQN = e17Rfc.build(Utils.asVector(inputData), box, req, E17HospitailFile_vt); //  e17Rfc.build(Utils.asVector(inputData), box, req);

	                        /*rfc.build(PERNR, ZINSU, AINF_SEQN, "2", e17Hdata.BEGDA, e17Hdata.WAERS, E17HospitalData_vt);
	                        //Logger.debug.println(this, "====e23Rfc.getReturn().isSuccess()======== : " +  e17Rfc.getReturn().isSuccess() );
	                        //Logger.debug.println(this, "====e23Rfc.getReturn().isSuccess()======== : " +  e17Rfc.getReturn() ); */

	                        if(!e17Rfc.getReturn().isSuccess()) {
	                        	 throw new GeneralException(e17Rfc.getReturn().MSGTX);
	                        }
	                        return AINF_SEQN;
                    	}else {
                    		throw new GeneralException( (String)rmess.get(2) );
                    	}
                        /* ������ �ۼ� �κ� �� */
                    }
                });

			} else {
				throw new BusinessException(g.getMessage("MSG.COMMON.0016"));
			}
			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		}
	}

	private String getNewCTRL_NUMB(String CTRL_NUMB, String stat)
			throws GeneralException { // ���ο� ������ȣ�������� "new" �Ǵ� "old"

		try {
			Logger.debug.println(this, "�� ������ȣ : " + CTRL_NUMB);

			int cur_year = Integer.parseInt(DataUtil.getCurrentDate()
					.substring(0, 4));
			if (CTRL_NUMB.equals("")) {
				Logger.debug.println(this, "NEW ������ȣ : " + cur_year + "-A-01");
				return (cur_year + "-A-01");
			}

			if (CTRL_NUMB.length() != 9
					|| !CTRL_NUMB.substring(4, 5).equals("-")
					|| !CTRL_NUMB.substring(6, 7).equals("-")) { // ex)
				// 2001-A-01
				throw new BusinessException("������ȣ ������ �ùٸ��� �ʽ��ϴ�. ex)2001-A-01");
			}

			String year = CTRL_NUMB.substring(0, 4);
			String alpabet = CTRL_NUMB.substring(5, 6);
			String numb = CTRL_NUMB.substring(7, 9);
			int int_year = Integer.parseInt(year);
			int int_numb = Integer.parseInt(numb);
			if (cur_year != int_year) {
				if (stat.equals("new")) {
					Logger.debug.println(this,
							"�ش�⵵�� ���ᰡ ���� ���� ���ᰡ ������ ���������û -> NEW ������ȣ : "
									+ (cur_year + "-A-01"));
					return (cur_year + "-A-01");
				} else {
					// 2002.12.03. ���������û�� ���ų⵵�� ���᳻���� �����Ұ��
					// ex) 2002�⿡ �������Ḧ ��û�ϴµ� �������᳻���� 2000-P-05��� ���� ���᳻����
					// 2002-A-06��.
					if ((int_numb + 1) < 10) {
						numb = "0" + (int_numb + 1);
					} else {
						numb = "" + (int_numb + 1);
					}

					Logger.debug.println(this,
							"�ش�⵵�� ���ᰡ ���� ���� ���ᰡ ������ ���������û -> NEW ������ȣ : "
									+ (cur_year + "-A-" + numb));
					return (cur_year + "-A-" + numb);
					// 2002.12.03. ���������û�� ���ų⵵�� ���᳻���� �����Ұ��
				}
			} else {
				if (stat.equals("new")) {
					String[] alpa = { "A", "B", "C", "D", "E", "F", "G", "H",
							"I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
							"S", "T", "U", "V", "W", "X", "Y", "Z" };
					String new_alpa = "a";
					for (int i = 0; i < alpa.length; i++) {
						if (alpabet.equals(alpa[i])) {
							new_alpa = alpa[i + 1];
							break;
						}
					}
					alpabet = new_alpa;
					numb = "01";
				} else {
					if ((int_numb + 1) < 10) {
						numb = "0" + (int_numb + 1);
					} else {
						numb = "" + (int_numb + 1);
					}
				}
				Logger.debug.println(this, "NEW ������ȣ : "
						+ (year + "-" + alpabet + "-" + numb));
				return (year + "-" + alpabet + "-" + numb);
			}
		} catch (Exception e) {
			throw new GeneralException(e, "������ȣ ������ �ùٸ��� �ʽ��ϴ�. ex)2001-A-01");
		}
	}
}
