/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                    */
/*   1Depth Name  : Manaer's Desk                                      */
/*   2Depth Name  : ���޿�                                                             */
/*   Program Name : ���޿�                                                             */
/*   Program ID   : D05MpayDetailSV_m                                */
/*   Description  : ������ ���޿����� ������ jsp�� �Ѱ��ִ� class    */
/*   Note         :                                                             */
/*   Creation     : 2002-01-28  chldudgh                              */
/*   Update       : 2005-01-19  ������                                          */
/*   Update       : 2013-06-24 [CSR ID:2353407] sap�� �߰��ϰ��� �߰� ��  */
/*                      //@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel         */
/* 				 	2018-01-18  cykim [CSR ID:3447340] �޿� ���� ����(PA03) �޿���ǥ ��� ���� ���� ��û  */
/*                     2018-03-29 [��û��ȣ]C20180329_48084 | [���񽺹�ȣ]3648084  �±�����(ȸ���ڵ� G530) MSS ȭ�� ���� */
/*                      //@PJ.��Ʈ�� ������ ���� Rollout ������Ʈ �߰� ����(Area = OT("99") && companyCode(G580)) 2018/04/19 Kang */
/********************************************************************************/

package servlet.hris.D.D05Mpay;

import com.common.Utils;
import com.common.constant.Area;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.D.D05Mpay.*;
import hris.D.D05Mpay.rfc.D05LatestPaidRFC;
import hris.D.D05Mpay.rfc.D05MpayDetailRFC;
import hris.D.D05Mpay.rfc.D05ZocrsnTextRFC;
import hris.common.MappingPernrData;
import hris.common.WebUserData;
import hris.common.rfc.MappingPernrRFC;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Vector;


public class D05MpayDetailSV_m extends EHRBaseServlet {
    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);


            String dest = WebUtil.JspURL+"D/D05Mpay/D05MpayDetail_KR_m.jsp";

            WebUserData user = WebUtil.getSessionUser(req);

//          @����༺ �߰�
            if ( user.e_authorization.equals("E") || isBlocklist(user) ) {
                Logger.debug.println(this, "E Authorization!!");
                String msg = "msg015";
                req.setAttribute("msg", msg);
                dest = WebUtil.JspURL+"common/caution.jsp";
                printJspPage(req, res, dest);
                return;
            }

            if(!"X".equals(user_m.e_mss)) {
                req.setAttribute("title", "COMMON.MENU.ESS_PY_MONT_PAY");
                req.setAttribute("servlet", "hris.D.D05Mpay.D05MpayDetailSV_m");

            	 printJspPage(req, res, WebUtil.JspURL+"common/MSS_SearchPernNameOrg.jsp");
            	 return;
            }


            String jobid_m = "";
            String flag   = " ";
            String yymmdd = "";
            String ymd    = "";

            /**
             * ������ �б�ó��
             * //@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32")) 2018/02/09 rdcamel
             * //@PJ.�±� ����    Rollout ������Ʈ �߰� ����(Area = TH("26")) 2018/03/27 Kang  [��û��ȣ]C20180329_48084 | [���񽺹�ȣ]3648084
             * //@PJ.��Ʈ�� ������ ����    Rollout ������Ʈ �߰� ����(Area = OT("99")/G580) 2018/04/19 Kang
             */
            String fdUrl = ".";

           if (user_m.area.equals(Area.CN) || user_m.area.equals(Area.TW) || user_m.area.equals(Area.HK) || user_m.area.equals(Area.US) || user_m.area.equals(Area.MX)|| user_m.area.equals(Area.TH)||(user_m.area.equals(Area.OT) && user_m.companyCode.equals("G580")) ) {	// Ÿ�̿�,ȫ���� �߱�ȭ������
               fdUrl = "hris.D.D05Mpay.D05MpayDetailGlobalSV_m";
			} else if (user_m.area.equals(Area.PL) || user_m.area.equals(Area.DE)) { // PL ������, DE ���� �� ����ȭ������
        	   fdUrl = "hris.D.D05Mpay.D05MpayDetailEurpSV_m";
			} else if(user_m.area.getMolga().equals("")){
				dest = WebUtil.JspURL + "common/msg.jsp";
	            req.setAttribute("url", "history.back();");
	            req.setAttribute("msg2", g.getMessage("MSG.COMMON.0029")); //�����ڵ尡 �ٸ��� ���մϴ�
				printJspPage(req, res, dest);
				return;
			}
           Logger.debug.println(this, "-------------[user.area] = "+user.area + " fdUrl: " + fdUrl );

            if( !".".equals(fdUrl )){
            	printJspPage(req, res, WebUtil.ServletURL+fdUrl);
		       	return;
           }

            D05MpayDetailRFC   rfc                = new D05MpayDetailRFC();
            D05MpayDetailData4 d05MpayDetailData4 = null;
            D05MpayDetailData5 d05MpayDetailData5 = null;
            D05MpayDetailData3 data               = new D05MpayDetailData3();
            D05MpayDetailData2 data4              = new D05MpayDetailData2();//�߰� 2002/02/21
            D05MpayDetailData1 data6              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21
            D05MpayDetailData1 data7              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21
            D05LatestPaidRFC   rfc_paid   = null;
            D05ZocrsnTextRFC   rfc_zocrsn = null;
            Vector d05ZocrsnTextData_vt  = new Vector();
            Vector d05MpayDetailData1_vt = new Vector();
            Vector d05MpayDetailData2_vt = new Vector();
            Vector d05MpayDetailData3_vt = new Vector();
            Vector d05MpayDetailData4_vt = new Vector();
            Vector d05MpayDetailData5_vt = new Vector(); //�߰� 2002/02/21
            Vector d05MpayDetailData6_vt = new Vector(); //�߰�(�ؿܱ޿�) 2002/02/21

            //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH ----------------------------------------
            MappingPernrRFC  mapfunc    = null ;
            MappingPernrData mapData    = new MappingPernrData();
            Vector mapData_vt = new Vector() ;
            String mapPernr = "";
            String mapDate  = "";

            String paydt  = "";
            String ocrsn  = "";
            String seqnr  = "";

            String year   = "";
            String month  = "";
            String yymm   = "";

            String year1  = "";
            String month1 = "";
            String ocrsn1 = "";
            String zyymm  = "";

            Box box = WebUtil.getBox(req);
            jobid_m = box.get("jobid_m");

            if( jobid_m.equals("") ){
                jobid_m = "first";
            }

            if( jobid_m.equals("first") ) {

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    rfc_paid = new D05LatestPaidRFC();

//                    paydt = rfc_paid.getLatestPaid1(user_m.empNo,user_m.webUserId); //[CSR ID:2353407]
//                    ocrsn = rfc_paid.getLatestPaid2(user_m.empNo,user_m.webUserId);//[CSR ID:2353407]
//                    seqnr = rfc_paid.getLatestPaid3(user_m.empNo,user_m.webUserId);  // 5�� 21�� �߰�
	                Vector v = rfc_paid.getLatestPaid(user_m.empNo, user_m.webUserId);  // 5�� 21�� �߰�
					 paydt = (String)Utils.indexOf(v, 0);
					 ocrsn = (String)Utils.indexOf(v, 1);;
					 seqnr = (String)Utils.indexOf(v, 2);;  // 5�� 21�� �߰�

                    year  = paydt.substring(0,4);
                    month = paydt.substring(5,7);
                    yymm  = year + month ;
                    if(user_m.companyCode.equals("C100")) {
                        ymd = year + month + "20";
                    }else{
                        ymd = year + month + "15";
                    }
                    Logger.debug.println(this, "�����޿������� = "+paydt+ "�޿������ڵ� = "+ocrsn+"���� = "+seqnr);
                    Logger.debug.println(this, "�����޿����޳⵵ = "+year+ "�����޿����޿� = "+month);

                    rfc_zocrsn           = new D05ZocrsnTextRFC();
                    d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(user_m.empNo, yymm);  // �޿����� �ڵ�� TEXT

                    if (ocrsn.equals("") && (d05ZocrsnTextData_vt.size()>0)){
                    	ocrsn = ((D05ZocrsnTextData)d05ZocrsnTextData_vt.get(0)).ZOCRSN;
                    }
                    Logger.debug.println(this, "�޿����� �ڵ�� TEXT : "+ d05ZocrsnTextData_vt.toString());
                    Logger.debug.println(this, "�޿����� �ڵ�� TEXT : "+ d05ZocrsnTextData_vt.size());


//                    d05MpayDetailData1_vt = rfc.getMpayDetail(user_m.empNo, ymd, ocrsn, flag, "1", seqnr,user_m.webUserId);  // �ؿܱ޿� �ݿ�����(�׸�) ����  5�� 21�� ���� �߰� ,[CSR ID:2353407]
//                    d05MpayDetailData2_vt = rfc.getMpayDetail(user_m.empNo, ymd, ocrsn, flag, "2", seqnr,user_m.webUserId);  // ���޳���/�������� 5�� 21�� ���� �߰� ,[CSR ID:2353407]
//                    d05MpayDetailData3_vt = rfc.getMpayDetail(user_m.empNo, ymd, ocrsn, flag, "3", seqnr,user_m.webUserId);  // �����߰�����  5�� 21�� ���� �߰� ,[CSR ID:2353407]
                    Vector sum = rfc.getMpayDetail(user_m.empNo, ymd, ocrsn, flag, seqnr,user_m.webUserId);  // �����߰�����  5�� 21�� ���� �߰� ,[CSR ID:2353407]

                    d05MpayDetailData1_vt = (Vector) Utils.indexOf(sum, 0);  // �ؿܱ޿� �ݿ�����(�׸�) ����  5�� 21�� ���� �߰�

                    Logger.debug.println(this, "�޿�����  d05MpayDetailData1_vt1 : " );
                    d05MpayDetailData2_vt = (Vector) Utils.indexOf(sum, 1);  // ���޳���/�������� 5�� 21�� ���� �߰�

                    Logger.debug.println(this, "�޿�����  d05MpayDetailData1_vt2 : " );
                    d05MpayDetailData3_vt = (Vector) Utils.indexOf(sum, 2);  // �����߰�����  5�� 21�� ���� �߰�

                    Logger.debug.println(this, "�޿�����  d05MpayDetailData1_vt3 : " );

                    Logger.debug.println(this, "�����߰�����1 : "+ d05MpayDetailData3_vt.toString());
                    for( int i = 0 ; i < d05MpayDetailData3_vt.size() ; i++ ) {
                        data  = (D05MpayDetailData3)d05MpayDetailData3_vt.get(i);
                        D05MpayDetailData3 data1 = new D05MpayDetailData3();
                        D05MpayDetailData3 data2 = new D05MpayDetailData3();
                        D05MpayDetailData3 data3 = new D05MpayDetailData3();

                        data1.LGTX1 = data.LGTX1;
                        data1.BET01 = data.BET01;
                        data2.LGTX1 = data.LGTX2;
                        data2.BET01 = data.BET02;
                        data3.LGTX1 = data.LGTX3;
                        data3.BET01 = data.BET03;

                        d05MpayDetailData4_vt.addElement(data1);
                        d05MpayDetailData4_vt.addElement(data2);
                        d05MpayDetailData4_vt.addElement(data3);
                    }
                    Logger.debug.println(this, " ���� �����߰����� : "+ d05MpayDetailData4_vt.toString());

                    d05MpayDetailData4 = (D05MpayDetailData4)rfc.getPerson(user_m.empNo, ymd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData5 = (D05MpayDetailData5)rfc.getPaysum(user_m.empNo, ymd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�
                    //              ���޳��� text 2002/02/21
                    for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
                        data4  = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
                        D05MpayDetailData2 data5 = new D05MpayDetailData2();

                        if(!data4.LGTXT.equals("")) {
                            data5.LGTXT = data4.LGTXT;
                            data5.ANZHL = data4.ANZHL;
                            data5.BET01 = data4.BET01;

                            d05MpayDetailData5_vt.addElement(data5);
                        }
                    }
                    Logger.debug.println(this, " ���޳���size : "+ d05MpayDetailData5_vt.size());
                    Logger.debug.println(this, " ���޳���text : "+ d05MpayDetailData5_vt.toString());

                    for( int i = 0 ; i < d05MpayDetailData1_vt.size() ; i++ ) {
                        data6  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(i);
                        D05MpayDetailData1 data8               = new D05MpayDetailData1();
                        String LGT = (String)  data6.LGTXT+"(����ȭ)";

                        for ( int j = 0 ; j < d05MpayDetailData1_vt.size() ; j++ ) {
                            data7  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(j);

                            if(LGT.equals((String) data7.LGTX1)) {
                                data8.LGTXT = data6.LGTXT;
                                data8.LGTX1 = data7.LGTX1;
                                data8.BET01 = data6.BET01;
                                data8.BET02 = data6.BET02;
                                data8.BET03 = data7.BET03;
                                break;
                            }else{
                                data8.LGTXT = data6.LGTXT;
                                data8.LGTX1 = "";
                                data8.BET01 = data6.BET01;
                                data8.BET02 = data6.BET02;
                                data8.BET03 = "0";
                            }
                        }
                        Logger.debug.println(this,"���" );
                        d05MpayDetailData6_vt.addElement(data8);
                    }
                    Logger.debug.println(this, " �ؿܳ������� : "+ d05MpayDetailData6_vt.toString());
                    ////////////////////////////////////////////////////////////////////////////
                    Logger.debug.println(this, "�ؿܱ޿� �ݿ�����(�׸�) ���� : "+ d05MpayDetailData1_vt.toString());
                    Logger.debug.println(this, "���޳���/��������  : "+ d05MpayDetailData2_vt.toString());
                    Logger.debug.println(this, "�����߰�����2 : "+ d05MpayDetailData3_vt.toString());

                    Logger.debug.println(this, "�޿���ǥ - ��������/ȯ�� ����  : "+ d05MpayDetailData4.toString());
                    Logger.debug.println(this, "���޳���/�������� ��  : "+ d05MpayDetailData5.toString());
                } // if ( user_m != null ) end

                req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt); //�ؿܱ޿� �ݿ�����(�׸�) ����
                req.setAttribute("d05MpayDetailData2_vt", d05MpayDetailData2_vt); //���޳���/��������
                req.setAttribute("d05MpayDetailData3_vt", d05MpayDetailData3_vt); //�����߰�����2
                req.setAttribute("d05MpayDetailData4_vt", d05MpayDetailData4_vt); //���� �����߰�����
                req.setAttribute("d05MpayDetailData5_vt", d05MpayDetailData5_vt); //�߰� 2002/02/21
                req.setAttribute("d05MpayDetailData6_vt", d05MpayDetailData6_vt); //�ؿ����޳������� �߰� 2002/02/21

                req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt); //�޿����� �ڵ�� TEXT

                req.setAttribute("d05MpayDetailData4", d05MpayDetailData4); //�޿���ǥ - ��������/ȯ�� ����
                req.setAttribute("d05MpayDetailData5", d05MpayDetailData5); //���޳���/�������� ��

                req.setAttribute("paydt", paydt); // �����޿�������
//                req.setAttribute("ocrsn", ocrsn); //�޿������ڵ�

                req.setAttribute("year", year);
                req.setAttribute("month", month);
                req.setAttribute("ocrsn", ocrsn+seqnr);// �޿������ڵ�
                req.setAttribute("seqnr", seqnr);  // 5�� 21�� �߰�

                /*[CSR ID:3447340] �޿� ���� ����(PA03) �޿���ǥ ��� ���� ���� ��û*/
                req.setAttribute("E_CODE", rfc.getReturn().MSGTY ); //      �޿��۾���  M   �����Ͱ� ������ F

            } else if(jobid_m.equals("getcode")){

                year  = box.get("year1");
                month = box.get("month1");
                yymm  = year + month;

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    mapPernr = "";
                    mapfunc    = new MappingPernrRFC() ;
                    mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                    mapDate = "";
                    int cnt= 0;

                    if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                        cnt = mapData_vt.size();
                        for ( int i=0; i < mapData_vt.size(); i++) {
                            mapData = (MappingPernrData)mapData_vt.get(i);
                            mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                            mapDate = mapDate.substring(0,6);

                            if ( Integer.parseInt(yymm) >= Integer.parseInt(mapDate) ) {
                                cnt--;
                            }
                        }

                        if ( cnt == mapData_vt.size() ) {
                            mapPernr = user_m.empNo;
                        } else {
                            mapData = (MappingPernrData)mapData_vt.get(cnt);
                            mapPernr = mapData.PERNR;
                        }
                    } else {
                        mapPernr = user_m.empNo;
                    }
                    ///-----------------------------------------------------------------------------------

                    rfc_zocrsn           = new D05ZocrsnTextRFC();
                    d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm);  // �޿����� �ڵ�� TEXT
                } // if ( user_m != null ) end

                req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
                dest = WebUtil.JspURL+"D/D05Mpay/D05Hidden_m.jsp";

            } else if(jobid_m.equals("search")  || jobid_m.equals("search_back")){
                year  = box.get("year1");
                month = box.get("month1");
                ocrsn = box.get("ocrsn");
                seqnr = ocrsn.substring(2,7);  // 5�� 21�� ���� �߰�
                yymm  = year + month;

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    //              lgȭ�а� ����ȭ���� ����(�ް��ϼ�)
                    if(user_m.companyCode.equals("C100")) {
                        yymmdd = year + month + "20";
                    } else  {
                        yymmdd = year + month + "15";
                    }

                    mapPernr = "";
                    mapfunc    = new MappingPernrRFC() ;
                    mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                    mapDate = "";
                    int    cnt     = 0;

                    if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                        cnt = mapData_vt.size();
                        for ( int i=0; i < mapData_vt.size(); i++) {
                            mapData = (MappingPernrData)mapData_vt.get(i);
                            mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                            mapDate = mapDate.substring(0,6);

                            if ( Integer.parseInt(yymm) >= Integer.parseInt(mapDate) ) {
                                cnt--;
                            }
                    Logger.debug.println(this, "SEARCH ���Ի��� LOGIC=> CNT : " + cnt +   "i :"+i+"mapDate:"+mapDate+"mapData.PERNR:"+mapData.PERNR);

                        }

                        if ( cnt == mapData_vt.size() ) {
                            mapPernr = user_m.empNo;
                        } else {
                            mapData = (MappingPernrData)mapData_vt.get(cnt);
                            mapPernr = mapData.PERNR;
                    Logger.debug.println(this, "SEARCH ���Ի��� ���λ�� : "+ mapData.PERNR + yymm + "cnt :"+cnt);

                        }
                    } else {
                        mapPernr = user_m.empNo;
                    }
                    ///-----------------------------------------------------------------------------------

                    rfc_zocrsn           = new D05ZocrsnTextRFC();
                    d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm);  // �޿����� �ڵ�� TEXT

                    Logger.debug.println(this, "������ �⵵ : "+ year+"������ ��:"+month+"������ �ӱ�����:"+ocrsn+"yymm;"+yymm+"seqnr :"+seqnr);
                    Logger.debug.println(this, "�޿����� �ڵ�� TEXT : "+ d05ZocrsnTextData_vt.toString());

                    rfc                = new D05MpayDetailRFC();
                    d05MpayDetailData4 = null;
                    d05MpayDetailData5 = null;
                    data               = new D05MpayDetailData3();
                    data4              = new D05MpayDetailData2();//�߰� 2002/02/21
                    data6              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21
                    data7              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21

                    Vector sum = rfc.getMpayDetail(mapPernr, yymmdd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData1_vt = (Vector) Utils.indexOf(sum, 0);  // �ؿܱ޿� �ݿ�����(�׸�) ����  5�� 21�� ���� �߰�
                    d05MpayDetailData2_vt = (Vector) Utils.indexOf(sum, 1);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData3_vt = (Vector) Utils.indexOf(sum, 2);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData4_vt = new Vector();
                    d05MpayDetailData5_vt = new Vector();//�߰� 2002/02/21
                    d05MpayDetailData6_vt = new Vector();//�߰�(�ؿܱ޿�) 2002/02/21

                    Logger.debug.println(this, "�����߰�����1 : "+ d05MpayDetailData3_vt.toString());
                    for( int i = 0 ; i < d05MpayDetailData3_vt.size() ; i++ ) {
                        data  = (D05MpayDetailData3)d05MpayDetailData3_vt.get(i);
                        D05MpayDetailData3 data1 = new D05MpayDetailData3();
                        D05MpayDetailData3 data2 = new D05MpayDetailData3();
                        D05MpayDetailData3 data3 = new D05MpayDetailData3();

                        data1.LGTX1 = data.LGTX1;
                        data1.BET01 = data.BET01;
                        data2.LGTX1 = data.LGTX2;
                        data2.BET01 = data.BET02;
                        data3.LGTX1 = data.LGTX3;
                        data3.BET01 = data.BET03;

                        d05MpayDetailData4_vt.addElement(data1);
                        d05MpayDetailData4_vt.addElement(data2);
                        d05MpayDetailData4_vt.addElement(data3);
                    }
                    Logger.debug.println(this, " ���� �����߰����� : "+ d05MpayDetailData4_vt.toString());

                    d05MpayDetailData4 = (D05MpayDetailData4)rfc.getPerson(mapPernr, yymmdd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData5 = (D05MpayDetailData5)rfc.getPaysum(mapPernr, yymmdd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�

                    //              ���޳��� text 2002/02/21
                    for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
                        data4  = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
                        D05MpayDetailData2 data5  = new D05MpayDetailData2();

                        if(!data4.LGTXT.equals("")) {
                            data5.LGTXT = data4.LGTXT ;
                            data5.ANZHL = data4.ANZHL ;
                            data5.BET01 = data4.BET01 ;

                            d05MpayDetailData5_vt.addElement(data5);
                        }
                    }
                    Logger.debug.println(this, " ���޳���size : "+ d05MpayDetailData5_vt.size());
                    Logger.debug.println(this, " ���޳���text : "+ d05MpayDetailData5_vt.toString());

                    for( int i = 0 ; i < d05MpayDetailData1_vt.size() ; i++ ) {
                        data6  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(i);
                        D05MpayDetailData1 data8 = new D05MpayDetailData1();
                        String LGT = (String)  data6.LGTXT+"(����ȭ)";

                        for ( int j = 0 ; j < d05MpayDetailData1_vt.size() ; j++ ) {
                            data7  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(j);

                            if(LGT.equals((String) data7.LGTX1)) {
                                data8.LGTXT = data6.LGTXT;
                                data8.LGTX1 = data7.LGTX1;
                                data8.BET01 = data6.BET01;
                                data8.BET02 = data6.BET02;
                                data8.BET03 = data7.BET03;
                                break;
                            }else{
                                data8.LGTXT = data6.LGTXT;
                                data8.LGTX1 = "";
                                data8.BET01 = data6.BET01;
                                data8.BET02 = data6.BET02;
                                data8.BET03 = "0";
                            }
                        }
                        Logger.debug.println(this,"���" );
                        d05MpayDetailData6_vt.addElement(data8);
                    }
                    Logger.debug.println(this, " �ؿܳ������� : "+ d05MpayDetailData6_vt.toString());

                    ////////////////////////////////////////////////////////////////////////////
                    Logger.debug.println(this, "�ؿܱ޿� �ݿ�����(�׸�) ���� : "+ d05MpayDetailData1_vt.toString());
                    Logger.debug.println(this, "���޳���/��������  : "+ d05MpayDetailData1_vt.toString());
                    Logger.debug.println(this, "�����߰����� : "+ d05MpayDetailData1_vt.toString());

                    Logger.debug.println(this, "�޿���ǥ - ��������/ȯ�� ����  : "+ d05MpayDetailData4.toString());
                    Logger.debug.println(this, "���޳���/�������� ��  : "+ d05MpayDetailData5.toString());
                }  // if ( user_m != null ) end

                req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
                req.setAttribute("d05MpayDetailData2_vt", d05MpayDetailData2_vt);
                req.setAttribute("d05MpayDetailData3_vt", d05MpayDetailData3_vt);
                req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
                req.setAttribute("d05MpayDetailData4_vt", d05MpayDetailData4_vt);
                req.setAttribute("d05MpayDetailData5_vt", d05MpayDetailData5_vt); //�߰� 2002/02/21
                req.setAttribute("d05MpayDetailData6_vt", d05MpayDetailData6_vt); //�ؿ����޳������� �߰� 2002/02/21

                req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
                req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

                req.setAttribute("year", year);
                req.setAttribute("month", month);
                req.setAttribute("ocrsn", ocrsn);
                req.setAttribute("seqnr", seqnr);  // 5�� 21�� �߰�
           		req.setAttribute("backBtn",  jobid_m.equals("search_back")?"Y":"" );  // �ǵ��ư��� ��ưȰ��

           		/*[CSR ID:3447340] �޿� ���� ����(PA03) �޿���ǥ ��� ���� ���� ��û*/
                req.setAttribute("E_CODE", rfc.getReturn().MSGTY ); //      �޿��۾���  M   �����Ͱ� ������ F

                dest = WebUtil.JspURL+"D/D05Mpay/D05MpayDetail_KR_m.jsp";

            } else if(jobid_m.equals("kubya_1")){
                year1  = box.get("year1");
                month1 = box.get("month1");
                ocrsn1 = box.get("ocrsn");
                ocrsn  = ocrsn1 + "00000";
                //   seqnr  = "00000";  // 5�� 21�� ���� �߰�
                yymm   = year1 + month1;

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());


                    //  lgȭ�а� ����ȭ���� ����(�ް��ϼ�)
                    if(user_m.companyCode.equals("C100")) {
                        yymmdd = year1 + month1 + "20";
                    } else {
                        yymmdd = year1 + month1 + "15";
                    }
                } // if ( user_m != null ) end

                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.D.D05Mpay.D05MpayDetailSV_m?jobid_m=kubya&year1="+year1+"&month1="+month1+"&ocrsn="+ocrsn);  // 5�� 21�� ���� �߰�
                dest = WebUtil.JspURL+"common/printFrame_m.jsp";
                Logger.debug.println(this, WebUtil.ServletURL+"hris.D.D05Mpay.D05MpayDetailSV_m?jobid_m=kubya&year1="+year1+"&month1="+month1+"&ocrsn="+ocrsn);  // 5�� 21�� ���� �߰�.


            } else if(jobid_m.equals("kubya_1_m")){
                year1  = box.get("year1");
                month1 = box.get("month1");
                ocrsn1 = box.get("ocrsn");
                ocrsn  = ocrsn1 + "00000";
                //   seqnr  = "00000";  // 5�� 21�� ���� �߰�
                yymm   = year1 + month1;

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());


                    //  lgȭ�а� ����ȭ���� ����(�ް��ϼ�)
                    if(user_m.companyCode.equals("C100")) {
                        yymmdd = year1 + month1 + "20";
                    } else {
                        yymmdd = year1 + month1 + "15";
                    }
                } // if ( user_m != null ) end

                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.D.D05Mpay.D05MpayDetailSV_m?jobid_m=kubya_m&year1="+year1+"&month1="+month1+"&ocrsn="+ocrsn);  // 5�� 21�� ���� �߰�
                dest = WebUtil.JspURL+"common/printFrame_m.jsp";
                Logger.debug.println(this, WebUtil.ServletURL+"hris.D.D05Mpay.D05MpayDetailSV_m?jobid_m=kubya_m&year1="+year1+"&month1="+month1+"&ocrsn="+ocrsn);  // 5�� 21�� ���� �߰�.


            } else if(jobid_m.equals("kubya_m")){
                year  = box.get("year1");
                month = box.get("month1");
                ocrsn = box.get("ocrsn");
                seqnr = ocrsn.substring(2,7);  // 5�� 21�� ���� �߰�
                yymm  = year + month;

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    //              lgȭ�а� ����ȭ���� ����(�ް��ϼ�)
                    if(user_m.companyCode.equals("C100")) {
                        yymmdd = year + month + "20";
                    } else {
                        yymmdd = year + month + "15";
                    }

                    mapfunc    = new MappingPernrRFC() ;
                    mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                    mapDate = "";
                    int cnt = 0;

                    if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                        cnt = mapData_vt.size();
                        for ( int i=0; i < mapData_vt.size(); i++) {
                            mapData = (MappingPernrData)mapData_vt.get(i);
                            mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                            mapDate = mapDate.substring(0,6);

                            if ( Integer.parseInt(yymm) >= Integer.parseInt(mapDate) ) {
                                cnt--;
                            }
                        }

                        if ( cnt == mapData_vt.size() ) {
                            mapPernr = user_m.empNo;
                        } else {
                            mapData = (MappingPernrData)mapData_vt.get(cnt);
                            mapPernr = mapData.PERNR;
                        }
                    } else {
                        mapPernr = user_m.empNo;
                    }
                    ///-----------------------------------------------------------------------------------

                    rfc_zocrsn           = new D05ZocrsnTextRFC();
                    d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm);  // �޿����� �ڵ�� TEXT

                    Logger.debug.println(this, "������ �⵵ : "+ year+"������ ��:"+month+"������ �ӱ�����:"+ocrsn+"yymm;"+yymm+"����:"+seqnr);
                    Logger.debug.println(this, "�޿����� �ڵ�� TEXT : "+ d05ZocrsnTextData_vt.toString());

                    rfc                = new D05MpayDetailRFC();
                    d05MpayDetailData4 = null;
                    d05MpayDetailData5 = null;
                    data               = new D05MpayDetailData3();
                    data4              = new D05MpayDetailData2();//�߰� 2002/02/21
                    data6              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21
                    data7              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21

                    Vector sum = rfc.getMpayDetail(mapPernr, yymmdd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData1_vt = (Vector) Utils.indexOf(sum, 0);  // �ؿܱ޿� �ݿ�����(�׸�) ����  5�� 21�� ���� �߰�
                    d05MpayDetailData2_vt = (Vector) Utils.indexOf(sum, 1);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData3_vt = (Vector) Utils.indexOf(sum, 2);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData4_vt = new Vector();
                    d05MpayDetailData5_vt = new Vector();//�߰� 2002/02/21
                    d05MpayDetailData6_vt = new Vector();//�߰�(�ؿܱ޿�) 2002/02/21

                    Logger.debug.println(this, "�����߰�����1 : "+ d05MpayDetailData3_vt.toString());
                    for( int i = 0 ; i < d05MpayDetailData3_vt.size() ; i++ ) {
                        data  = (D05MpayDetailData3)d05MpayDetailData3_vt.get(i);
                        D05MpayDetailData3 data1 = new D05MpayDetailData3();
                        D05MpayDetailData3 data2 = new D05MpayDetailData3();
                        D05MpayDetailData3 data3 = new D05MpayDetailData3();

                        data1.LGTX1 = data.LGTX1;
                        data1.BET01 = data.BET01;
                        data2.LGTX1 = data.LGTX2;
                        data2.BET01 = data.BET02;
                        data3.LGTX1 = data.LGTX3;
                        data3.BET01 = data.BET03;

                        d05MpayDetailData4_vt.addElement(data1);
                        d05MpayDetailData4_vt.addElement(data2);
                        d05MpayDetailData4_vt.addElement(data3);
                    }
                    Logger.debug.println(this, " ���� �����߰����� : "+ d05MpayDetailData4_vt.toString());

                    d05MpayDetailData4 = (D05MpayDetailData4)rfc.getPerson(mapPernr, yymmdd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData5 = (D05MpayDetailData5)rfc.getPaysum(mapPernr, yymmdd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�

                    //              ���޳��� text 2002/02/21
                    for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
                        data4  = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
                        D05MpayDetailData2 data5 = new D05MpayDetailData2();

                        if(!data4.LGTXT.equals("")) {
                            data5.LGTXT = data4.LGTXT ;
                            data5.ANZHL = data4.ANZHL ;
                            data5.BET01 = data4.BET01 ;

                            d05MpayDetailData5_vt.addElement(data5);
                        }
                    }
                    Logger.debug.println(this, " ���޳���size : "+ d05MpayDetailData5_vt.size());
                    Logger.debug.println(this, " ���޳���text : "+ d05MpayDetailData5_vt.toString());

                    for( int i = 0 ; i < d05MpayDetailData1_vt.size() ; i++ ) {
                        data6  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(i);
                        D05MpayDetailData1 data8 = new D05MpayDetailData1();
                        String LGT = (String)  data6.LGTXT+"(����ȭ)";

                        for( int j = 0 ; j < d05MpayDetailData1_vt.size() ; j++ ) {
                            data7  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(j);

                            if(LGT.equals((String) data7.LGTX1)) {
                                data8.LGTXT = data6.LGTXT;
                                data8.LGTX1 = data7.LGTX1;
                                data8.BET01 = data6.BET01;
                                data8.BET02 = data6.BET02;
                                data8.BET03 = data7.BET03;
                                break;
                            }else{
                                data8.LGTXT = data6.LGTXT;
                                data8.LGTX1 = "";
                                data8.BET01 = data6.BET01;
                                data8.BET02 = data6.BET02;
                                data8.BET03 = "0";
                            }
                        }

                        Logger.debug.println(this,"���" );
                        d05MpayDetailData6_vt.addElement(data8);
                    }
                    Logger.debug.println(this, " �ؿܳ������� : "+ d05MpayDetailData6_vt.toString());
                    ////////////////////////////////////////////////////////////////////////////
                    Logger.debug.println(this, "�ؿܱ޿� �ݿ�����(�׸�) ���� : "+ d05MpayDetailData1_vt.toString());
                    Logger.debug.println(this, "���޳���/��������  : "+ d05MpayDetailData1_vt.toString());
                    Logger.debug.println(this, "�����߰����� : "+ d05MpayDetailData1_vt.toString());

                    Logger.debug.println(this, "�޿���ǥ - ��������/ȯ�� ����  : "+ d05MpayDetailData4.toString());
                    Logger.debug.println(this, "���޳���/�������� ��  : "+ d05MpayDetailData5.toString());
                } // if ( user_m != null ) end

                req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
                req.setAttribute("d05MpayDetailData2_vt", d05MpayDetailData2_vt);
                req.setAttribute("d05MpayDetailData3_vt", d05MpayDetailData3_vt);
                req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
                req.setAttribute("d05MpayDetailData4_vt", d05MpayDetailData4_vt);
                req.setAttribute("d05MpayDetailData5_vt", d05MpayDetailData5_vt); //�߰� 2002/02/21
                req.setAttribute("d05MpayDetailData6_vt", d05MpayDetailData6_vt); //�ؿ����޳������� �߰� 2002/02/21

                req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
                req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

                req.setAttribute("year", year);
                req.setAttribute("month", month);
                req.setAttribute("ocrsn", ocrsn);
                req.setAttribute("seqnr", seqnr);  // 5�� 21�� ���� �߰�

                dest = WebUtil.JspURL+"D/D06Ypay/D06Mpayhwahak_m.jsp";


            } else if(jobid_m.equals("kubya")){
                year  = box.get("year1");
                month = box.get("month1");
                ocrsn = box.get("ocrsn");
                seqnr = ocrsn.substring(2,7);  // 5�� 21�� ���� �߰�
                yymm  = year + month;

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    //              lgȭ�а� ����ȭ���� ����(�ް��ϼ�)
                    if(user_m.companyCode.equals("C100")) {
                        yymmdd = year + month + "20";
                    } else {
                        yymmdd = year + month + "15";
                    }

                    mapfunc    = new MappingPernrRFC() ;
                    mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                    mapDate = "";
                    int cnt = 0;

                    if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                        cnt = mapData_vt.size();
                        for ( int i=0; i < mapData_vt.size(); i++) {
                            mapData = (MappingPernrData)mapData_vt.get(i);
                            mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                            mapDate = mapDate.substring(0,6);

                            if ( Integer.parseInt(yymm) >= Integer.parseInt(mapDate) ) {
                                cnt--;
                            }
                        }

                        if ( cnt == mapData_vt.size() ) {
                            mapPernr = user_m.empNo;
                        } else {
                            mapData = (MappingPernrData)mapData_vt.get(cnt);
                            mapPernr = mapData.PERNR;
                        }
                    } else {
                        mapPernr = user_m.empNo;
                    }
                    ///-----------------------------------------------------------------------------------

                    rfc_zocrsn           = new D05ZocrsnTextRFC();
                    d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm);  // �޿����� �ڵ�� TEXT

                    Logger.debug.println(this, "������ �⵵ : "+ year+"������ ��:"+month+"������ �ӱ�����:"+ocrsn+"yymm;"+yymm+"����:"+seqnr);
                    Logger.debug.println(this, "�޿����� �ڵ�� TEXT : "+ d05ZocrsnTextData_vt.toString());

                    rfc                = new D05MpayDetailRFC();
                    d05MpayDetailData4 = null;
                    d05MpayDetailData5 = null;
                    data               = new D05MpayDetailData3();
                    data4              = new D05MpayDetailData2();//�߰� 2002/02/21
                    data6              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21
                    data7              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21

                    Vector sum = rfc.getMpayDetail(mapPernr, yymmdd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData1_vt = (Vector) Utils.indexOf(sum, 0);  // �ؿܱ޿� �ݿ�����(�׸�) ����  5�� 21�� ���� �߰�
                    d05MpayDetailData2_vt = (Vector) Utils.indexOf(sum, 1);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData3_vt = (Vector) Utils.indexOf(sum, 2);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData4_vt = new Vector();
                    d05MpayDetailData5_vt = new Vector();//�߰� 2002/02/21
                    d05MpayDetailData6_vt = new Vector();//�߰�(�ؿܱ޿�) 2002/02/21

                    Logger.debug.println(this, "�����߰�����1 : "+ d05MpayDetailData3_vt.toString());
                    for( int i = 0 ; i < d05MpayDetailData3_vt.size() ; i++ ) {
                        data  = (D05MpayDetailData3)d05MpayDetailData3_vt.get(i);
                        D05MpayDetailData3 data1 = new D05MpayDetailData3();
                        D05MpayDetailData3 data2 = new D05MpayDetailData3();
                        D05MpayDetailData3 data3 = new D05MpayDetailData3();

                        data1.LGTX1 = data.LGTX1;
                        data1.BET01 = data.BET01;
                        data2.LGTX1 = data.LGTX2;
                        data2.BET01 = data.BET02;
                        data3.LGTX1 = data.LGTX3;
                        data3.BET01 = data.BET03;

                        d05MpayDetailData4_vt.addElement(data1);
                        d05MpayDetailData4_vt.addElement(data2);
                        d05MpayDetailData4_vt.addElement(data3);
                    }
                    Logger.debug.println(this, " ���� �����߰����� : "+ d05MpayDetailData4_vt.toString());

                    d05MpayDetailData4 = (D05MpayDetailData4)rfc.getPerson(mapPernr, yymmdd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData5 = (D05MpayDetailData5)rfc.getPaysum(mapPernr, yymmdd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�

                    //              ���޳��� text 2002/02/21
                    for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
                        data4  = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
                        D05MpayDetailData2 data5 = new D05MpayDetailData2();

                        if(!data4.LGTXT.equals("")) {
                            data5.LGTXT = data4.LGTXT ;
                            data5.ANZHL = data4.ANZHL ;
                            data5.BET01 = data4.BET01 ;

                            d05MpayDetailData5_vt.addElement(data5);
                        }
                    }
                    Logger.debug.println(this, " ���޳���size : "+ d05MpayDetailData5_vt.size());
                    Logger.debug.println(this, " ���޳���text : "+ d05MpayDetailData5_vt.toString());

                    for( int i = 0 ; i < d05MpayDetailData1_vt.size() ; i++ ) {
                        data6  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(i);
                        D05MpayDetailData1 data8 = new D05MpayDetailData1();
                        String LGT = (String)  data6.LGTXT+"(����ȭ)";

                        for( int j = 0 ; j < d05MpayDetailData1_vt.size() ; j++ ) {
                            data7  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(j);

                            if(LGT.equals((String) data7.LGTX1)) {
                                data8.LGTXT = data6.LGTXT;
                                data8.LGTX1 = data7.LGTX1;
                                data8.BET01 = data6.BET01;
                                data8.BET02 = data6.BET02;
                                data8.BET03 = data7.BET03;
                                break;
                            }else{
                                data8.LGTXT = data6.LGTXT;
                                data8.LGTX1 = "";
                                data8.BET01 = data6.BET01;
                                data8.BET02 = data6.BET02;
                                data8.BET03 = "0";
                            }
                        }

                        Logger.debug.println(this,"���" );
                        d05MpayDetailData6_vt.addElement(data8);
                    }
                    Logger.debug.println(this, " �ؿܳ������� : "+ d05MpayDetailData6_vt.toString());
                    ////////////////////////////////////////////////////////////////////////////
                    Logger.debug.println(this, "�ؿܱ޿� �ݿ�����(�׸�) ���� : "+ d05MpayDetailData1_vt.toString());
                    Logger.debug.println(this, "���޳���/��������  : "+ d05MpayDetailData1_vt.toString());
                    Logger.debug.println(this, "�����߰����� : "+ d05MpayDetailData1_vt.toString());

                    Logger.debug.println(this, "�޿���ǥ - ��������/ȯ�� ����  : "+ d05MpayDetailData4.toString());
                    Logger.debug.println(this, "���޳���/�������� ��  : "+ d05MpayDetailData5.toString());
                } // if ( user_m != null ) end

                req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
                req.setAttribute("d05MpayDetailData2_vt", d05MpayDetailData2_vt);
                req.setAttribute("d05MpayDetailData3_vt", d05MpayDetailData3_vt);
                req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
                req.setAttribute("d05MpayDetailData4_vt", d05MpayDetailData4_vt);
                req.setAttribute("d05MpayDetailData5_vt", d05MpayDetailData5_vt); //�߰� 2002/02/21
                req.setAttribute("d05MpayDetailData6_vt", d05MpayDetailData6_vt); //�ؿ����޳������� �߰� 2002/02/21

                req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
                req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

                req.setAttribute("year", year);
                req.setAttribute("month", month);
                req.setAttribute("ocrsn", ocrsn);
                req.setAttribute("seqnr", seqnr);  // 5�� 21�� ���� �߰�

                dest = WebUtil.JspURL+"D/D05Mpay/D05Mpayhwahak_m.jsp";

            } else if(jobid_m.equals("month_kubyo")){

                zyymm = box.get("zyymm");
                year  = zyymm.substring(0,4);
                month = zyymm.substring(4);
                ocrsn = "ZZ";
                seqnr = "";
                yymm  = year + month;

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    //  lgȭ�а� ����ȭ���� ����(�ް��ϼ�)
                    if(user_m.companyCode.equals("C100")) {
                        yymmdd = year + month + "20";
                    } else {
                        yymmdd = year + month + "15";
                    }

                    mapfunc    = new MappingPernrRFC() ;
                    mapData_vt = mapfunc.getPernr( user_m.empNo ) ;
                    mapDate = "";
                    int    cnt     = 0;

                    if ( user_m.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
                        cnt = mapData_vt.size();
                        for ( int i=0; i < mapData_vt.size(); i++) {
                            mapData = (MappingPernrData)mapData_vt.get(i);
                            mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                            mapDate = mapDate.substring(0,6);

                            if ( Integer.parseInt(yymm) >= Integer.parseInt(mapDate) ) {
                                cnt--;
                            }
                        }

                        if ( cnt == mapData_vt.size() ) {
                            mapPernr = user_m.empNo;
                        } else {
                            mapData = (MappingPernrData)mapData_vt.get(cnt);
                            mapPernr = mapData.PERNR;
                        }
                    } else {
                        mapPernr = user_m.empNo;
                    }
                    ///-----------------------------------------------------------------------------------

                    rfc_zocrsn           = new D05ZocrsnTextRFC();
                    d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm);  // �޿����� �ڵ�� TEXT

                    Logger.debug.println(this, "������ �⵵ : "+ year+"������ ��:"+month+"������ �ӱ�����:"+ocrsn+"yymm;"+yymm);
                    Logger.debug.println(this, "�޿����� �ڵ�� TEXT : "+ d05ZocrsnTextData_vt.toString());

                    rfc                = new D05MpayDetailRFC();
                    d05MpayDetailData4 = null;
                    d05MpayDetailData5 = null;
                    data               = new D05MpayDetailData3();
                    data4              = new D05MpayDetailData2();//�߰� 2002/02/21
                    data6              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21
                    data7              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21

                    Vector sum = rfc.getMpayDetail(mapPernr, yymmdd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData1_vt = (Vector) Utils.indexOf(sum, 0);  // �ؿܱ޿� �ݿ�����(�׸�) ����  5�� 21�� ���� �߰�
                    d05MpayDetailData2_vt = (Vector) Utils.indexOf(sum, 1);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData3_vt = (Vector) Utils.indexOf(sum, 2);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData4_vt = new Vector();
                    d05MpayDetailData5_vt = new Vector();//�߰� 2002/02/21
                    d05MpayDetailData6_vt = new Vector();//�߰�(�ؿܱ޿�) 2002/02/21

                    Logger.debug.println(this, "�����߰�����1 : "+ d05MpayDetailData3_vt.toString());
                    for( int i = 0 ; i < d05MpayDetailData3_vt.size() ; i++ ) {
                        data  = (D05MpayDetailData3)d05MpayDetailData3_vt.get(i);
                        D05MpayDetailData3 data1 = new D05MpayDetailData3();
                        D05MpayDetailData3 data2 = new D05MpayDetailData3();
                        D05MpayDetailData3 data3 = new D05MpayDetailData3();

                        data1.LGTX1 = data.LGTX1;
                        data1.BET01 = data.BET01;
                        data2.LGTX1 = data.LGTX2;
                        data2.BET01 = data.BET02;
                        data3.LGTX1 = data.LGTX3;
                        data3.BET01 = data.BET03;

                        d05MpayDetailData4_vt.addElement(data1);
                        d05MpayDetailData4_vt.addElement(data2);
                        d05MpayDetailData4_vt.addElement(data3);
                    }
                    Logger.debug.println(this, " ���� �����߰����� : "+ d05MpayDetailData4_vt.toString());

                    d05MpayDetailData4 = (D05MpayDetailData4)rfc.getPerson(mapPernr, yymmdd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�
                    d05MpayDetailData5 = (D05MpayDetailData5)rfc.getPaysum(mapPernr, yymmdd, ocrsn, flag, seqnr,user_m.webUserId);  // 5�� 21�� ���� �߰�

                    //              ���޳��� text 2002/02/21
                    for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
                        data4  = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
                        D05MpayDetailData2 data5 = new D05MpayDetailData2();

                        if(!data4.LGTXT.equals("")) {
                            data5.LGTXT = data4.LGTXT ;
                            data5.ANZHL = data4.ANZHL ;
                            data5.BET01 = data4.BET01 ;

                            d05MpayDetailData5_vt.addElement(data5);
                        }
                    }
                    Logger.debug.println(this, " ���޳���size : "+ d05MpayDetailData5_vt.size());
                    Logger.debug.println(this, " ���޳���text : "+ d05MpayDetailData5_vt.toString());

                    for( int i = 0 ; i < d05MpayDetailData1_vt.size() ; i++ ) {
                        data6  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(i);
                        D05MpayDetailData1 data8 = new D05MpayDetailData1();
                        String LGT = (String)  data6.LGTXT+"(����ȭ)";

                        for ( int j = 0 ; j < d05MpayDetailData1_vt.size() ; j++ ) {
                            data7  = (D05MpayDetailData1)d05MpayDetailData1_vt.get(j);

                            if(LGT.equals((String) data7.LGTX1)) {
                                data8.LGTXT = data6.LGTXT;
                                data8.LGTX1 = data7.LGTX1;
                                data8.BET01 = data6.BET01;
                                data8.BET02 = data6.BET02;
                                data8.BET03 = data7.BET03;
                                break;
                            }else{
                                data8.LGTXT = data6.LGTXT;
                                data8.LGTX1 = "";
                                data8.BET01 = data6.BET01;
                                data8.BET02 = data6.BET02;
                                data8.BET03 = "0";
                            }
                        }
                        Logger.debug.println(this,"���" );
                        d05MpayDetailData6_vt.addElement(data8);
                    }
                    Logger.debug.println(this, " �ؿܳ������� : "+ d05MpayDetailData6_vt.toString());

                    Logger.debug.println(this, "�ؿܱ޿� �ݿ�����(�׸�) ���� : "+ d05MpayDetailData1_vt.toString());
                    Logger.debug.println(this, "���޳���/��������  : "+ d05MpayDetailData1_vt.toString());
                    Logger.debug.println(this, "�����߰����� : "+ d05MpayDetailData1_vt.toString());

                    Logger.debug.println(this, "�޿���ǥ - ��������/ȯ�� ����  : "+ d05MpayDetailData4.toString());
                    Logger.debug.println(this, "���޳���/�������� ��  : "+ d05MpayDetailData5.toString());
                } // if ( user_m != null ) end

                req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
                req.setAttribute("d05MpayDetailData2_vt", d05MpayDetailData2_vt);
                req.setAttribute("d05MpayDetailData3_vt", d05MpayDetailData3_vt);
                req.setAttribute("d05ZocrsnTextData_vt",  d05ZocrsnTextData_vt);
                req.setAttribute("d05MpayDetailData4_vt", d05MpayDetailData4_vt);
                req.setAttribute("d05MpayDetailData5_vt", d05MpayDetailData5_vt); //�߰� 2002/02/21
                req.setAttribute("d05MpayDetailData6_vt", d05MpayDetailData6_vt); //�ؿ����޳������� �߰� 2002/02/21

                req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
                req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

                req.setAttribute("year", year);
                req.setAttribute("month", month);

                dest = WebUtil.JspURL+"D/D06Ypay/D06MpayDetail_m.jsp";
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}
