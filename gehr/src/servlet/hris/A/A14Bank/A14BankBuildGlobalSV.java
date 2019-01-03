/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR �젙蹂�                                                  */
/*   2Depth Name  : 湲됱뿬怨꾩쥖�젙蹂�                                                */
/*   Program Name : 湲됱뿬怨꾩쥖 �떊泥�                                               */
/*   Program ID   : A14BankBuildSV                                              */
/*   Description  : 湲됱뿬怨꾩쥖瑜� �떊泥��븷 �닔 �엳�룄濡� �븯�뒗 Class                      */
/*   Note         :                                                             */
/*   Creation     : 2002-01-08  源��룄�떊                                          */
/*   Update       : 2005-03-03  �쑄�젙�쁽                                          */
/*                                                                              */
/********************************************************************************/

package servlet.hris.A.A14Bank;

import java.sql.Connection;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.BusinessException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.A.A03AccountDetail1Data;
import hris.A.A14Bank.A14BankStockFeeData;
import hris.A.A14Bank.rfc.A14BankCodeRFC;
import hris.A.A14Bank.rfc.A14BankStockFeeRFC;
import hris.A.A14Bank.rfc.A14BankTypeRFC;
import hris.A.rfc.A03AccountDetailRFC;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalBaseServlet;
import hris.common.approval.ApprovalLineData;
import hris.common.rfc.PersonInfoRFC;

public class A14BankBuildGlobalSV extends ApprovalBaseServlet {

	private String UPMU_TYPE = "03"; // 寃곗옱 �뾽臾댄��엯(湲됱뿬怨꾩쥖)

	private String UPMU_NAME = "Bank Account Change";

	protected String getUPMU_TYPE() {
		return UPMU_TYPE;
	}

	protected String getUPMU_NAME() {
		return UPMU_NAME;
	}

	protected void performTask(final HttpServletRequest req, HttpServletResponse res) throws GeneralException {
		Connection con = null;

		try {
			req.setCharacterEncoding("utf-8");
			HttpSession session = req.getSession(false);

			final WebUserData user = (WebUserData) session.getAttribute("user");

			String dest = "";
			String jobid = "";
			final String bankflag = "01";

			final Box box = WebUtil.getBox(req);
			jobid = box.get("jobid");
			String acctype = Integer.toString((Integer.parseInt(box.get("TYPE")) - 1));
			if (jobid.equals("")) {
				jobid = "first";
			}
			Logger.debug.println(this, "[jobid] = " + jobid + " [user] : " + user.toString() );
			Logger.debug.println(this, "[ZBANKL] = " +  box.get("ZBANKL") + "  [STATE1] = " +   box.get("STATE1"));

			final String PERNR =  getPERNR(box, user); // box.get("PERNR", user.empNo);

			// ��由� �떊泥� 異붽�
			// PhoneNumRFC numfunc = new PhoneNumRFC();
			// final PhoneNumData phonenumdata = (PhoneNumData)
			// numfunc.getPhoneNum(PERNR);
			// req.setAttribute("PhoneNumData", phonenumdata);

			PersonInfoRFC numfunc = new PersonInfoRFC();
			final PersonData phonenumdata = (PersonData) numfunc.getPersonInfo(PERNR);
			req.setAttribute("PersonData", phonenumdata);

			req.setAttribute("PERNR", PERNR);

			// 20151116 start
			A14BankTypeRFC rfc_type = new A14BankTypeRFC();
			Vector a14BankTypeData_vt = rfc_type.getTypeCode(PERNR);
			// 20151116 end
			Logger.debug.println(this, "a14BankTypeData_vt" + a14BankTypeData_vt.toString());
			// if("".equals(box.get("BNKTX"))){
			// jobid="create";
			// }

			if (jobid.equals("first")) { // �젣�씪泥섏쓬 �떊泥� �솕硫댁뿉 �뱾�뼱�삩寃쎌슦.

				// ********** 寃곗옱�씪�씤, 寃곗옱 �뿤�뜑 �젙蹂� 議고쉶 ****************
				getApprovalInfo(req, PERNR); // <-- 諛섎뱶�떆 異붽�

				// 湲됱뿬怨꾩쥖 由ъ뒪�듃瑜� 援ъ꽦�븳�떎.
				A14BankCodeRFC rfc_bank = new A14BankCodeRFC();
				Vector a14BankCodeData_vt = rfc_bank.getBankCode(PERNR);
				Vector a14BankValueData_vt = rfc_bank.getBankValue(PERNR);
				if (a14BankCodeData_vt.size() == 0) {
					String msg = "No information on individual salary account.";
					String url = "history.back();";
					req.setAttribute("msg", msg);
					req.setAttribute("url", url);
					dest = WebUtil.JspURL + "common/msg.jsp";
				} else {
					Logger.debug.println(this, "湲됱뿬怨꾩쥖 由ъ뒪�듃 : " + a14BankCodeData_vt.toString());

					// �쁽�옱 �벑濡앸맂 湲됱뿬怨꾩쥖瑜� 珥덇린�뿉 �뀑�똿�빐二쇨린 �쐞�빐�꽌..
					A03AccountDetailRFC func1 = new A03AccountDetailRFC();
					Vector adata_vt = func1.getAccountDetail(PERNR); // 湲됱뿬怨꾩쥖

					A03AccountDetail1Data adata = new A03AccountDetail1Data();
					// 20151203 BANKCARD START
					if (adata_vt.size() > 0 && box.get("BNKTX").equals("Main bank")) {
						for (int i = 0; adata_vt.size() > i; i++) {
							A03AccountDetail1Data adata1 = new A03AccountDetail1Data();
							adata1 = (A03AccountDetail1Data) adata_vt.get(i);
							if (adata1.BNKTX.equals("Main bank")) {
								int j = i;
								adata = (A03AccountDetail1Data) adata_vt.get(j);
								break;
							}
						}

						Logger.debug.println(this, "�씠�쟾�뜲�씠�꽣" + adata.toString());
						req.setAttribute("A03AccountDetail1Data", adata);
					} else if (adata_vt.size() > 1 && !box.get("BNKTX").equals("Main bank")) {
						for (int i = 1; adata_vt.size() > i; i++) {
							A03AccountDetail1Data adata1 = new A03AccountDetail1Data();
							adata1 = (A03AccountDetail1Data) adata_vt.get(i);
							if (!adata1.BNKTX.equals("Main bank")) {
								int j = i;
								adata = (A03AccountDetail1Data) adata_vt.get(j);
								break;
							}
						}
						// 20151203 BANKCARD END

						Logger.debug.println(this, "�씠�쟾�뜲�씠�꽣" + adata.toString());
						req.setAttribute("A03AccountDetail1Data", adata);
					}

					req.setAttribute("a14BankCodeData_vt", a14BankCodeData_vt);
					req.setAttribute("a14BankValueData_vt", a14BankValueData_vt);
					req.setAttribute("acctype", acctype);

					// 20151116 start
					req.setAttribute("a14BankTypeData_vt", a14BankTypeData_vt);
					// 20151116 end

					dest = WebUtil.JspURL + "A/A14Bank/A14BankBuild_Global.jsp";
				}

			} else if (jobid.equals("create")) { //

				dest = requestApproval(req, box, A14BankStockFeeData.class, new RequestFunction<A14BankStockFeeData>() {
					public String porcess(A14BankStockFeeData inputData, Vector<ApprovalLineData> approvalLine)
							throws GeneralException {

						/*
						 * 泥댄겕 濡쒖쭅 �븘�슂�븳 寃쎌슦 if(checkDup(user, inputData)) throw new
						 * GeneralException("�씠誘� 以묐났�맂 �떊泥�嫄댁씠 �엳�뒿�땲�떎.");
						 */

						/* 寃곗옱 �떊泥� RFC �샇異� */
						A14BankStockFeeRFC rfc = new A14BankStockFeeRFC();
						// 湲됱뿬怨꾩쥖 ���옣..
						box.copyToEntity(inputData);
						inputData.ZPERNR = user.empNo; // �떊泥��옄 �궗踰� �꽕�젙(��由ъ떊泥� ,蹂몄씤 �떊泥�)

						// 湲됱뿬怨꾩쥖 ���옣..
						inputData.PERNR = PERNR; // �궗�썝踰덊샇
						inputData.BEGDA = box.get("BEGDA"); // �떊泥��씪
						// inputData.BANK_FLAG = box.get("BANK_FLAG"); //
						// 援щ텇(���뻾/利앷텒)

						// 20151117
						if (user.companyCode.equals("G100") && phonenumdata.E_PERSG.equals("A")) {
							if (box.get("STEXT").equals(g.getMessage("MSG.A.A03.0009"))) {
								inputData.BNKSA = "0";
								inputData.VORNA = box.get("VORNA1");// first
																	// name
								inputData.NACHN = box.get("NACHN1");// last name
							} else {
								inputData.BNKSA = "7";
								inputData.EMFTX = box.get("NACHN1");// full name
							}
						} else {
							inputData.BNKSA = box.get("BNKSA");
						}
						// inputData.BNKSA = box.get("BNKSA"); // ���뻾/利앷텒
						// 20151117 end
						inputData.ZBANKL = box.get("ZBANKL"); // �쉶�궗
						inputData.ZBANKN = box.get("ZBANKN"); // ���뻾/利앷텒
						inputData.ZBKREF = box.get("ZBKREF");
						inputData.STATE1 = box.get("STATE1");
						inputData.BRANCH = box.get("BRANCH"); // �쉶�궗紐�
						inputData.ZBANKA = (box.get("ZBANKA")); // ���뻾/利앷텒 怨꾩쥖
						inputData.ZPERNR = user.empNo; // �떊泥��옄 �궗踰� �꽕�젙(��由ъ떊泥�,蹂몄씤 �떊泥�)
						inputData.AEDTM = DataUtil.getCurrentDate();
						Logger.debug.println(this, "湲됱뿬怨꾩쥖 �떊泥� : " + inputData.toString());

						// String msg2 = rfc.build(PERNR, ainf_seqn,
						// box.get("BNKSA"), inputData);

						rfc.setRequestInput(user.empNo, UPMU_TYPE);
						String ainf_seqn = rfc.buildGlobal(PERNR, inputData.BNKSA, inputData, box, req);
						Logger.debug.println(this, "寃곗옱踰덊샇  ainf_seqn=" + ainf_seqn.toString());
						if (!rfc.getReturn().isSuccess() || ainf_seqn == null) {
							throw new GeneralException(rfc.getReturn().MSGTX);
						}
						;

						/* �떊泥� �썑 msg 泥섎━ �썑 �씠�룞 �럹�씠吏� 吏��젙 */
						req.setAttribute("url", "location.href = '" + WebUtil.ServletURL
								+ "hris.A.A14Bank.A14BankDetailGlobalSV?AINF_SEQN=" + ainf_seqn + "';");

						return ainf_seqn;
						/* 媛쒕컻�옄 �옉�꽦 遺�遺� �걹 */
					}
				});

			} else {
				throw new BusinessException("�궡遺�紐낅졊(jobid)�씠 �삱諛붾Ⅴ吏� �븡�뒿�땲�떎.");
			}
			Logger.debug.println(this, " BNKTX = " + box.get("BNKTX"));
			Logger.debug.println(this, " destributed = " + dest);
			printJspPage(req, res, dest);

		} catch (Exception e) {
			throw new GeneralException(e);
		} finally {
			DBUtil.close(con);
		}
	}
}
