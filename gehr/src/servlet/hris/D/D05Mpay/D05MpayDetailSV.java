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

/**
 * D05MpayDetailSV.java
 * ������ ���޿����� ������ jsp�� �Ѱ��ִ� class
 * ������ ���޿����� ������ �������� D05MpayDetailRFC�� ȣ���Ͽ� D04VocationDetail.jsp�� ������ ���޿����� ������ �Ѱ��ش�.(x)
 * ������ ���޿����� ������ �������� D05MpayDetailRFC�� ȣ���Ͽ� D05MpayDetail.jsp�� ������ ���޿����� ������ �Ѱ��ش�.
 * @author chldudgh
 * @version 1.0, 2002/01/28
 *   Update       : 2013-06-24 [CSR ID:2353407] sap�� �߰��ϰ��� �߰� ��
 *                    : 2017-10-20 [CSR ID:3447340] �޿� ���� ����(PA03) �޿���ǥ ��� ���� ���� ��û
 *                     2017-11-06  eunha  [CSR ID:3516631] �±� ���� Roll in �� ���� Globlal HR Portal ���� ��û��
 *                     @PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32"))  2018/02/09 rdcamel
 *                     @PJ.��Ʈ�� ������ ���� Rollout ������Ʈ �߰� ����(Area = OT("99") && companyCode(G580) ) 2018/04/02 Kang DM
 */
public class D05MpayDetailSV extends EHRBaseServlet {
    protected void performTask(HttpServletRequest req, HttpServletResponse res)
    		throws GeneralException {
        try{
            HttpSession session = req.getSession(false);
            WebUserData user   = (WebUserData)session.getValue("user");

            Logger.debug.println(this, "-------------[user.area] = "+user.area  );
            Logger.debug.println(this, "-------------[user.companyCode] = "+user.companyCode  );

            /**
             * Start: ������ �б�ó��
             */
            String fdUrl = ".";

          //[CSR ID:3516631] �±� ���� Roll in �� ���� Globlal HR Portal ���� ��û�� Area.TH �߰�
          //@PJ.�߽��� ���� Rollout ������Ʈ �߰� ����(Area = MX("32"))  2018/02/09 rdcamel
          //@PJ.��Ʈ�� ������ ���� Rollout ������Ʈ �߰� ����(Area = OT("99") && companyCode(G580) ) 2018/04/02 Kang DM
            if (user.area.equals(Area.CN) || user.area.equals(Area.TW) || user.area.equals(Area.HK) || user.area.equals(Area.US)|| user.area.equals(Area.TH) || user.area.equals(Area.MX) || (user.area.equals(Area.OT) && user.companyCode.equals("G580")) ) {	// Ÿ�̿�,ȫ���� �߱�ȭ������
               fdUrl = "hris.D.D05Mpay.D05MpayDetailGlobalSV";
			} else if (user.area.equals(Area.PL) || user.area.equals(Area.DE)) { // PL ������, DE ���� �� ����ȭ������
        	   fdUrl = "hris.D.D05Mpay.D05MpayDetailEurpSV";
			} else if(user.area.getMolga().equals("")){
	            req.setAttribute("url", "history.back();");
	            req.setAttribute("msg2", g.getMessage("MSG.COMMON.0029")); //�����ڵ尡 �ٸ��� ���մϴ�
				printJspPage(req, res,  WebUtil.JspURL + "common/msg.jsp");
				return;
			}

           Logger.debug.println(this, "-------------[user.area] = "+user.area + " fdUrl: " + fdUrl );

            if( !".".equals(fdUrl )){
            	printJspPage(req, res, WebUtil.ServletURL+fdUrl);
		       	return;
           }

            /**
             * END: ������ �б�ó��
             */
            String jobid = "";
            String dest = "";
            String flag = " ";
            String yymmdd = "";
            String ymd = "";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid","first");

            String paydt  = box.get("paydt");
            String ocrsn  = "";
            String seqnr  = "";


            Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

/****************************************************************************
 * 			first �������ӽ� ��ȸȭ�鱸��          => D05MpayDetail_KR.jsp
 */
            if( jobid.equals("first") ) {

                D05LatestPaidRFC rfc_paid = new D05LatestPaidRFC();

//                String paydt = rfc_paid.getLatestPaid1(user.empNo, user.webUserId);
//                String ocrsn = rfc_paid.getLatestPaid2(user.empNo, user.webUserId);
//                String seqnr = rfc_paid.getLatestPaid3(user.empNo, user.webUserId);  // 5�� 21�� �߰�

                Vector v = rfc_paid.getLatestPaid(user.empNo, user.webUserId);  // 5�� 21�� �߰�
				 paydt = (String) Utils.indexOf(v, 0);
				 ocrsn = (String)Utils.indexOf(v, 1);;
				 seqnr = (String)Utils.indexOf(v, 2);;  // 5�� 21�� �߰�

                String year  = paydt.substring(0,4);
                String month = paydt.substring(5,7);
                String yymm  = year + month ;
                if(user.companyCode.equals("C100")) {
               	    ymd = year + month + "20";
                }else{
                    ymd = year + month + "15";
                }
           //     Logger.debug.println(this, "�����޿������� = "+paydt+ "�޿������ڵ� = "+ocrsn+"���� = "+seqnr);
           //     Logger.debug.println(this, "�����޿����޳⵵ = "+year+ "�����޿����޿� = "+month);

                D05ZocrsnTextRFC rfc_zocrsn           = new D05ZocrsnTextRFC();
                Vector           d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(user.empNo, yymm);  // �޿����� �ڵ�� TEXT

                if (ocrsn.equals("") && (d05ZocrsnTextData_vt.size()>0)){
                	ocrsn = ((D05ZocrsnTextData)d05ZocrsnTextData_vt.get(0)).ZOCRSN;
                }
         //      Logger.debug.println(this, "�޿����� �ڵ�� TEXT : "+ d05ZocrsnTextData_vt.toString());
          //      Logger.debug.println(this, "�޿����� �ڵ�� TEXT : "+ d05ZocrsnTextData_vt.size());

                D05MpayDetailRFC   rfc                = new D05MpayDetailRFC();
                D05MpayDetailData4 d05MpayDetailData4 = null;
                D05MpayDetailData5 d05MpayDetailData5 = null;
                D05MpayDetailData3 data               = new D05MpayDetailData3();
                D05MpayDetailData2 data4              = new D05MpayDetailData2();//�߰� 2002/02/21
                D05MpayDetailData1 data6              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21
                D05MpayDetailData1 data7              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21

                Logger.debug.println(this,"Step1");
                Vector sum = rfc.getMpayDetail(user.empNo, ymd, ocrsn, flag,  seqnr, user.webUserId);

                Vector d05MpayDetailData1_vt = (Vector) Utils.indexOf(sum, 0);  // �ؿܱ޿� �ݿ�����(�׸�) ����  5�� 21�� ���� �߰�

                Logger.debug.println(this, "�޿�����  d05MpayDetailData1_vt1 : " );
                Vector d05MpayDetailData2_vt = (Vector) Utils.indexOf(sum, 1);  // ���޳���/�������� 5�� 21�� ���� �߰�

                Logger.debug.println(this, "�޿�����  d05MpayDetailData1_vt2 : " );
                Vector d05MpayDetailData3_vt = (Vector) Utils.indexOf(sum, 2);  // �����߰�����  5�� 21�� ���� �߰�

                Logger.debug.println(this, "�޿�����  d05MpayDetailData1_vt3 : " );
                Vector d05MpayDetailData4_vt = new Vector();
                Vector d05MpayDetailData5_vt = new Vector();//�߰� 2002/02/21
                Vector d05MpayDetailData6_vt = new Vector();//�߰�(�ؿܱ޿�) 2002/02/21

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

                d05MpayDetailData4 = (D05MpayDetailData4)Utils.indexOf(sum, 3);  //rfc.getPerson(user.empNo, ymd, ocrsn, flag, seqnr, user.webUserId);  // 5�� 21�� ���� �߰�
                d05MpayDetailData5 = (D05MpayDetailData5)Utils.indexOf(sum, 4);  //rfc.getPaysum(user.empNo, ymd, ocrsn, flag, seqnr, user.webUserId);  // 5�� 21�� ���� �߰�

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
       //         Logger.debug.println(this, " ���޳���size : "+ d05MpayDetailData5_vt.size());
       //         Logger.debug.println(this, " ���޳���text : "+ d05MpayDetailData5_vt.toString());

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

             //       Logger.debug.println(this,"���" );
                    d05MpayDetailData6_vt.addElement(data8);
                }
                Logger.debug.println(this, " �ؿܳ������� : "+ d05MpayDetailData6_vt.toString());
//              if( d05MpayDetailData1_vt.size() == 0 && d05MpayDetailData2_vt.size() == 0 && d05MpayDetailData3_vt.size() == 0 ) {
//                  Logger.debug.println(this, "Data Not Found");
//                  String msg = "msg004";
//                     req.setAttribute("msg", msg);
//                  dest = WebUtil.JspURL+"common/caution.jsp";
//              } else {
                ////////////////////////////////////////////////////////////////////////////
      //          Logger.debug.println(this, "�ؿܱ޿� �ݿ�����(�׸�) ���� : "+ d05MpayDetailData1_vt.toString());
     //           Logger.debug.println(this, "���޳���/��������  : "+ d05MpayDetailData2_vt.toString());
      //          Logger.debug.println(this, "�����߰�����2 : "+ d05MpayDetailData3_vt.toString());

       //         Logger.debug.println(this, "�޿���ǥ - ��������/ȯ�� ����  : "+ d05MpayDetailData4.toString());
         //       Logger.debug.println(this, "���޳���/�������� ��  : "+ d05MpayDetailData5.toString());

                req.setAttribute("d05MpayDetailData1_vt", d05MpayDetailData1_vt);
                req.setAttribute("d05MpayDetailData2_vt", d05MpayDetailData2_vt);
                req.setAttribute("d05MpayDetailData3_vt", d05MpayDetailData3_vt);
                req.setAttribute("d05MpayDetailData4_vt", d05MpayDetailData4_vt);
                req.setAttribute("d05MpayDetailData5_vt", d05MpayDetailData5_vt); //�߰� 2002/02/21
                req.setAttribute("d05MpayDetailData6_vt", d05MpayDetailData6_vt); //�ؿ����޳������� �߰� 2002/02/21

                req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);

                req.setAttribute("d05MpayDetailData4", d05MpayDetailData4);
                req.setAttribute("d05MpayDetailData5", d05MpayDetailData5);

                req.setAttribute("paydt", paydt);
                req.setAttribute("ocrsn", ocrsn);

                req.setAttribute("year", year);
                req.setAttribute("month", month);
                req.setAttribute("ocrsn", ocrsn+seqnr);
                req.setAttribute("seqnr", seqnr);  // 5�� 21�� �߰�

                //[CSR ID:3447340] �޿� ���� ����(PA03) �޿���ǥ ��� ���� ���� ��û
                req.setAttribute("E_CODE", rfc.getReturn().MSGTY ); //      �޿� ������°� �ƴϸ�   M   �����Ͱ� ������ F

                dest = WebUtil.JspURL+"D/D05Mpay/D05MpayDetail_KR.jsp";
//           }

/****************************************************************************
 * 			getcode   �޿������ڵ尡������            => D05Hidden.jsp
 */

            }else if(jobid.equals("getcode")){
                String year   = box.get("year1");
                String month  = box.get("month1");
                String yymm   = year + month;

                D05ZocrsnTextRFC rfc_zocrsn           = new D05ZocrsnTextRFC();
                Vector           d05ZocrsnTextData_vt = new Vector() ;

                //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH ----------------------------------------
                MappingPernrRFC  mapfunc    = null ;
                MappingPernrData mapData    = new MappingPernrData();
                Vector           mapData_vt = new Vector() ;
                String           mapPernr = "";

                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( user.empNo ) ;
                String mapDate = "";
                int    cnt     = 0;

                if ( user.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
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
                        mapPernr = user.empNo;
                    } else {
                        mapData = (MappingPernrData)mapData_vt.get(cnt);
                        mapPernr = mapData.PERNR;
                    }
                } else {
                    mapPernr = user.empNo;
                }
                ///-----------------------------------------------------------------------------------

                rfc_zocrsn           = new D05ZocrsnTextRFC();
                d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm);  // �޿����� �ڵ�� TEXT

                req.setAttribute("d05ZocrsnTextData_vt", d05ZocrsnTextData_vt);
                dest = WebUtil.JspURL+"D/D05Mpay/D05Hidden.jsp";

/******************************************************************************
 * ��ȸ�۾�
 */
            } else if(jobid.equals("search") || jobid.equals("search_back")){ // add search_back
                String year   = box.get("year1");
                String month  = box.get("month1");
                 ocrsn  = box.get("ocrsn");
                 paydt  = box.get("paydt");
                 seqnr  = ocrsn.substring(2,7);  // 5�� 21�� ���� �߰�
                String yymm   = year + month;

//              lgȭ�а� ����ȭ���� ����(�ް��ϼ�)
                if(user.companyCode.equals("C100")) {
                    yymmdd = year + month + "20";
                } else  {
        	        yymmdd = year + month + "15";
                }

                //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH ----------------------------------------
                MappingPernrRFC  mapfunc    = null ;
                MappingPernrData mapData    = new MappingPernrData();
                Vector           mapData_vt = new Vector() ;
                String           mapPernr = "";

                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( user.empNo ) ;
                String mapDate = "";
                int    cnt     = 0;

                if ( user.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
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
                        mapPernr = user.empNo;
                    } else {
                        mapData = (MappingPernrData)mapData_vt.get(cnt);
                        mapPernr = mapData.PERNR;
                    }
                } else {
                    mapPernr = user.empNo;
                }
                ///-----------------------------------------------------------------------------------

                D05ZocrsnTextRFC rfc_zocrsn           = new D05ZocrsnTextRFC();
                Vector           d05ZocrsnTextData_vt = new Vector() ;

                rfc_zocrsn           = new D05ZocrsnTextRFC();
                d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm);  // �޿����� �ڵ�� TEXT

        //        Logger.debug.println(this, "������ �⵵ : "+ year+"������ ��:"+month+"������ �ӱ�����:"+ocrsn+"yymm;"+yymm+"seqnr :"+seqnr);
     //           Logger.debug.println(this, "�޿����� �ڵ�� TEXT : "+ d05ZocrsnTextData_vt.toString());

                D05MpayDetailRFC   rfc                = new D05MpayDetailRFC();
                D05MpayDetailData4 d05MpayDetailData4 = null;
                D05MpayDetailData5 d05MpayDetailData5 = null;
                D05MpayDetailData3 data               = new D05MpayDetailData3();
                D05MpayDetailData2 data4              = new D05MpayDetailData2();//�߰� 2002/02/21
                D05MpayDetailData1 data6              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21
                D05MpayDetailData1 data7              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21

                Vector sum = rfc.getMpayDetail(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);

                Vector d05MpayDetailData1_vt = (Vector) Utils.indexOf(sum, 0);  // 5�� 21�� ���� �߰�
                Vector d05MpayDetailData2_vt = (Vector) Utils.indexOf(sum, 1);  // 5�� 21�� ���� �߰�
                Vector d05MpayDetailData3_vt = (Vector) Utils.indexOf(sum, 2);  // 5�� 21�� ���� �߰�
                Vector d05MpayDetailData4_vt = new Vector();
                Vector d05MpayDetailData5_vt = new Vector();//�߰� 2002/02/21
                Vector d05MpayDetailData6_vt = new Vector();//�߰�(�ؿܱ޿�) 2002/02/21

    //            Logger.debug.println(this, "�����߰�����1 : "+ d05MpayDetailData3_vt.toString());
                for( int i = 0 ; i < d05MpayDetailData3_vt.size() ; i++ ) {
            	    data  = (D05MpayDetailData3)d05MpayDetailData3_vt.get(i);
            	    D05MpayDetailData3 data1 = new D05MpayDetailData3();
            	    D05MpayDetailData3 data2 = new D05MpayDetailData3();
            	    D05MpayDetailData3 data3 = new D05MpayDetailData3();

				    data1.LGTX1 = data.LGTX1 ;
				    data1.BET01 = data.BET01 ;
				    data2.LGTX1 = data.LGTX2 ;
				    data2.BET01 = data.BET02 ;
				    data3.LGTX1 = data.LGTX3 ;
				    data3.BET01 = data.BET03 ;

            	    d05MpayDetailData4_vt.addElement(data1);
            	    d05MpayDetailData4_vt.addElement(data2);
            	    d05MpayDetailData4_vt.addElement(data3);
                }
      //          Logger.debug.println(this, " ���� �����߰����� : "+ d05MpayDetailData4_vt.toString());

                d05MpayDetailData4 = (D05MpayDetailData4)Utils.indexOf(sum, 3);  //rfc.getPerson(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);  // 5�� 21�� ���� �߰�
                d05MpayDetailData5 = (D05MpayDetailData5)Utils.indexOf(sum, 4);  //rfc.getPaysum(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);  // 5�� 21�� ���� �߰�

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
      //          Logger.debug.println(this, " ���޳���size : "+ d05MpayDetailData5_vt.size());
      //          Logger.debug.println(this, " ���޳���text : "+ d05MpayDetailData5_vt.toString());

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
        //           Logger.debug.println(this,"���" );
                   d05MpayDetailData6_vt.addElement(data8);
                }
      //          Logger.debug.println(this, " �ؿܳ������� : "+ d05MpayDetailData6_vt.toString());
      //          Logger.debug.println(this, "�ؿܱ޿� �ݿ�����(�׸�) ���� : "+ d05MpayDetailData1_vt.toString());
      //          Logger.debug.println(this, "���޳���/��������  : "+ d05MpayDetailData1_vt.toString());
      //          Logger.debug.println(this, "�����߰����� : "+ d05MpayDetailData1_vt.toString());

     //           Logger.debug.println(this, "�޿���ǥ - ��������/ȯ�� ����  : "+ d05MpayDetailData4.toString());
     //           Logger.debug.println(this, "���޳���/�������� ��  : "+ d05MpayDetailData5.toString());

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

           		req.setAttribute("backBtn",  jobid.equals("search_back")?"Y":"" );  // �ǵ��ư��� ��ưȰ��
                req.setAttribute("paydt", paydt);

                //[CSR ID:3447340] �޿� ���� ����(PA03) �޿���ǥ ��� ���� ���� ��û
                req.setAttribute("E_CODE", rfc.getReturn().MSGTY ); //      �޿� ������°� �ƴϸ�   M   �����Ͱ� ������ F


                dest = WebUtil.JspURL+"D/D05Mpay/D05MpayDetail_KR.jsp";

/****************************************************************************
 *           kubya_1 �޿����� (D05MpayDetail.jsp���� ȣ��)  jobid=kubya�� ��ȣ��   => printFrame.jsp
 *****************************************************************************/
            } else if(jobid.equals("kubya_1")){
                String year1   = box.get("year1");
                String month1 = box.get("month1");
                String ocrsn1  = box.get("ocrsn");
                 ocrsn  = ocrsn1 + "00000";
//              String seqnr  = "00000";  // 5�� 21�� ���� �߰�
                String yymm   = year1 + month1;

//              lgȭ�а� ����ȭ���� ����(�ް��ϼ�)
                if(user.companyCode.equals("C100")) {
                    yymmdd = year1 + month1 + "20";
                } else {
        	          yymmdd = year1 + month1 + "15";
                }

                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.D.D05Mpay.D05MpayDetailSV?jobid=kubya&year1="+year1+"&month1="+month1+"&ocrsn="+ocrsn);  // 5�� 21�� ���� �߰�
                dest = WebUtil.JspURL+"common/printFrame.jsp";
     //           Logger.debug.println(this, WebUtil.ServletURL+"hris.D.D05Mpay.D05MpayDetailSV?jobid=kubya&year1="+year1+"&month1="+month1+"&ocrsn="+ocrsn);  // 5�� 21�� ���� �߰�.


/******************************************************************************
 *        kubya �޿�����     => printFrame.jsp
********************************************************************************/
            }else if(jobid.equals("kubya")){
                String year  = box.get("year1");
                String month = box.get("month1");
                 ocrsn = box.get("ocrsn");
                 seqnr = ocrsn.substring(2,7);  // 5�� 21�� ���� �߰�
                String yymm  = year + month;
//              lgȭ�а� ����ȭ���� ����(�ް��ϼ�)
                if(user.companyCode.equals("C100")) {
                    yymmdd = year + month + "20";
                } else {
        	          yymmdd = year + month + "15";
                }

                //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH ----------------------------------------
                MappingPernrRFC  mapfunc    = null ;
                MappingPernrData mapData    = new MappingPernrData();
                Vector           mapData_vt = new Vector() ;
                String           mapPernr = "";

                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( user.empNo ) ;
                String mapDate = "";
                int    cnt     = 0;

                if ( user.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
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
                        mapPernr = user.empNo;
                    } else {
                        mapData = (MappingPernrData)mapData_vt.get(cnt);
                        mapPernr = mapData.PERNR;
                    }
                } else {
                    mapPernr = user.empNo;
                }
                ///-----------------------------------------------------------------------------------

                D05ZocrsnTextRFC rfc_zocrsn           = new D05ZocrsnTextRFC();
                Vector           d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm);  // �޿����� �ڵ�� TEXT

     //           Logger.debug.println(this, "������ �⵵ : "+ year+"������ ��:"+month+"������ �ӱ�����:"+ocrsn+"yymm;"+yymm+"����:"+seqnr);
     //           Logger.debug.println(this, "�޿����� �ڵ�� TEXT : "+ d05ZocrsnTextData_vt.toString());

                D05MpayDetailRFC   rfc                = new D05MpayDetailRFC();
                D05MpayDetailData4 d05MpayDetailData4 = null;
                D05MpayDetailData5 d05MpayDetailData5 = null;
                D05MpayDetailData3 data               = new D05MpayDetailData3();
                D05MpayDetailData2 data4              = new D05MpayDetailData2();//�߰� 2002/02/21
                D05MpayDetailData1 data6              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21
                D05MpayDetailData1 data7              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21

                Vector sum = rfc.getMpayDetail(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);

                Vector d05MpayDetailData1_vt = (Vector) Utils.indexOf(sum, 0);  // 5�� 21�� ���� �߰�
                Vector d05MpayDetailData2_vt = (Vector) Utils.indexOf(sum, 1);;  // 5�� 21�� ���� �߰�
                Vector d05MpayDetailData3_vt = (Vector) Utils.indexOf(sum, 2);  // 5�� 21�� ���� �߰�
                Vector d05MpayDetailData4_vt = new Vector();
                Vector d05MpayDetailData5_vt = new Vector();//�߰� 2002/02/21
                Vector d05MpayDetailData6_vt = new Vector();//�߰�(�ؿܱ޿�) 2002/02/21

      //          Logger.debug.println(this, "�����߰�����1 : "+ d05MpayDetailData3_vt.toString());
                for( int i = 0 ; i < d05MpayDetailData3_vt.size() ; i++ ) {
              	    data  = (D05MpayDetailData3)d05MpayDetailData3_vt.get(i);
              	    D05MpayDetailData3 data1 = new D05MpayDetailData3();
              	    D05MpayDetailData3 data2 = new D05MpayDetailData3();
              	    D05MpayDetailData3 data3 = new D05MpayDetailData3();

  				    data1.LGTX1 = data.LGTX1 ;
  				    data1.BET01 = data.BET01 ;
  				    data2.LGTX1 = data.LGTX2 ;
  				    data2.BET01 = data.BET02 ;
  				    data3.LGTX1 = data.LGTX3 ;
  				    data3.BET01 = data.BET03 ;

              	    d05MpayDetailData4_vt.addElement(data1);
              	    d05MpayDetailData4_vt.addElement(data2);
              	    d05MpayDetailData4_vt.addElement(data3);
                }
       //         Logger.debug.println(this, " ���� �����߰����� : "+ d05MpayDetailData4_vt.toString());

                d05MpayDetailData4 = (D05MpayDetailData4)Utils.indexOf(sum, 3);  //rfc.getPerson(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);  // 5�� 21�� ���� �߰�
                d05MpayDetailData5 = (D05MpayDetailData5)Utils.indexOf(sum, 4);  //rfc.getPaysum(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);  // 5�� 21�� ���� �߰�

//              ���޳��� text 2002/02/21
                for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
                    data4  = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
                    D05MpayDetailData2 data5               = new D05MpayDetailData2();

                    if(!data4.LGTXT.equals("")) {
                        data5.LGTXT = data4.LGTXT ;
                        data5.ANZHL = data4.ANZHL ;
                        data5.BET01 = data4.BET01 ;

                        d05MpayDetailData5_vt.addElement(data5);
                    }
                }
       //         Logger.debug.println(this, " ���޳���size : "+ d05MpayDetailData5_vt.size());
      //          Logger.debug.println(this, " ���޳���text : "+ d05MpayDetailData5_vt.toString());

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

        //            Logger.debug.println(this,"���" );
                    d05MpayDetailData6_vt.addElement(data8);
                }
    //            Logger.debug.println(this, " �ؿܳ������� : "+ d05MpayDetailData6_vt.toString());
//              if( d05MpayDetailData1_vt.size() == 0 && d05MpayDetailData2_vt.size() == 0 && d05MpayDetailData3_vt.size() == 0 ) {
//                  Logger.debug.println(this, "Data Not Found");
//                  String msg = "msg004";
//                     req.setAttribute("msg", msg);
//                  dest = WebUtil.JspURL+"common/caution.jsp";
//              } else {
                ////////////////////////////////////////////////////////////////////////////
         //       Logger.debug.println(this, "�ؿܱ޿� �ݿ�����(�׸�) ���� : "+ d05MpayDetailData1_vt.toString());
           //     Logger.debug.println(this, "���޳���/��������  : "+ d05MpayDetailData1_vt.toString());
         //       Logger.debug.println(this, "�����߰����� : "+ d05MpayDetailData1_vt.toString());

       //         Logger.debug.println(this, "�޿���ǥ - ��������/ȯ�� ����  : "+ d05MpayDetailData4.toString());
       //         Logger.debug.println(this, "���޳���/�������� ��  : "+ d05MpayDetailData5.toString());

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

               	dest = WebUtil.JspURL+"D/D05Mpay/D05Mpayhwahak.jsp";

 /****************************************************************************
 *   month_kubyo => ���޿�  => D06Ypay/D06MpayDetail.jsp ���޿��� ���޿���ȸ
 *****************************************************************************/
            }else if(jobid.equals("month_kubyo")){

                String zyymm = box.get("zyymm");
                String year  = zyymm.substring(0,4);
                String month = zyymm.substring(4);
                 ocrsn = "ZZ";
                 seqnr = "";
                String yymm  = year + month;

//              lgȭ�а� ����ȭ���� ����(�ް��ϼ�)
                if(user.companyCode.equals("C100")) {
                    yymmdd = year + month + "20";
                } else {
          	        yymmdd = year + month + "15";
                }

                //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH ----------------------------------------
                MappingPernrRFC  mapfunc    = null ;
                MappingPernrData mapData    = new MappingPernrData();
                Vector           mapData_vt = new Vector() ;
                String           mapPernr = "";

                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( user.empNo ) ;
                String mapDate = "";
                int    cnt     = 0;

                if ( user.companyCode.equals("C100") && mapData_vt != null && mapData_vt.size() > 0 ) {
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
                        mapPernr = user.empNo;
                    } else {
                        mapData = (MappingPernrData)mapData_vt.get(cnt);
                        mapPernr = mapData.PERNR;
                    }
                } else {
                    mapPernr = user.empNo;
                }
                ///-----------------------------------------------------------------------------------

                D05ZocrsnTextRFC rfc_zocrsn           = new D05ZocrsnTextRFC();
                Vector           d05ZocrsnTextData_vt = rfc_zocrsn.getZocrsnText(mapPernr, yymm);  // �޿����� �ڵ�� TEXT

       //         Logger.debug.println(this, "������ �⵵ : "+ year+"������ ��:"+month+"������ �ӱ�����:"+ocrsn+"yymm;"+yymm);
       //         Logger.debug.println(this, "�޿����� �ڵ�� TEXT : "+ d05ZocrsnTextData_vt.toString());

                D05MpayDetailRFC   rfc                = new D05MpayDetailRFC();
                D05MpayDetailData4 d05MpayDetailData4 = null;
                D05MpayDetailData5 d05MpayDetailData5 = null;
                D05MpayDetailData3 data               = new D05MpayDetailData3();
                D05MpayDetailData2 data4              = new D05MpayDetailData2();//�߰� 2002/02/21
                D05MpayDetailData1 data6              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21
                D05MpayDetailData1 data7              = new D05MpayDetailData1();//�߰�(�ؿܱ޿�)�߰� 2002/02/21

                Vector sum = rfc.getMpayDetail(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);

                Vector d05MpayDetailData1_vt = (Vector) Utils.indexOf(sum, 0);  // 5�� 21�� ���� �߰�
                Vector d05MpayDetailData2_vt = (Vector) Utils.indexOf(sum, 1);  // 5�� 21�� ���� �߰�
                Vector d05MpayDetailData3_vt = (Vector) Utils.indexOf(sum, 2);  // 5�� 21�� ���� �߰�
                Vector d05MpayDetailData4_vt = new Vector();
                Vector d05MpayDetailData5_vt = new Vector();//�߰� 2002/02/21
                Vector d05MpayDetailData6_vt = new Vector();//�߰�(�ؿܱ޿�) 2002/02/21

       //         Logger.debug.println(this, "�����߰�����1 : "+ d05MpayDetailData3_vt.toString());
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
     //           Logger.debug.println(this, " ���� �����߰����� : "+ d05MpayDetailData4_vt.toString());

                d05MpayDetailData4 = (D05MpayDetailData4)Utils.indexOf(sum, 3);  //rfc.getPerson(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);  // 5�� 21�� ���� �߰�
                d05MpayDetailData5 = (D05MpayDetailData5)Utils.indexOf(sum, 4);  //rfc.getPaysum(mapPernr, yymmdd, ocrsn, flag, seqnr, user.webUserId);  // 5�� 21�� ���� �߰�

//              ���޳��� text 2002/02/21
                for( int i = 0 ; i < d05MpayDetailData2_vt.size() ; i++ ) {
                    data4  = (D05MpayDetailData2)d05MpayDetailData2_vt.get(i);
                    D05MpayDetailData2 data5               = new D05MpayDetailData2();

                    if(!data4.LGTXT.equals("")) {
                        data5.LGTXT = data4.LGTXT ;
                        data5.ANZHL = data4.ANZHL ;
                        data5.BET01 = data4.BET01 ;

                        d05MpayDetailData5_vt.addElement(data5);
                    }
                }
      //          Logger.debug.println(this, " ���޳���size : "+ d05MpayDetailData5_vt.size());
     //           Logger.debug.println(this, " ���޳���text : "+ d05MpayDetailData5_vt.toString());

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
     //               Logger.debug.println(this,"���" );
                    d05MpayDetailData6_vt.addElement(data8);
                }
      //          Logger.debug.println(this, " �ؿܳ������� : "+ d05MpayDetailData6_vt.toString());

//                if( d05MpayDetailData1_vt.size() == 0 && d05MpayDetailData2_vt.size() == 0 && d05MpayDetailData3_vt.size() == 0 ) {
//                    Logger.debug.println(this, "Data Not Found");
//                    String msg = "msg004";
//                    req.setAttribute("msg", msg);
//                    dest = WebUtil.JspURL+"common/caution.jsp";
//                } else {
     //           Logger.debug.println(this, "�ؿܱ޿� �ݿ�����(�׸�) ���� : "+ d05MpayDetailData1_vt.toString());
     //           Logger.debug.println(this, "���޳���/��������  : "+ d05MpayDetailData1_vt.toString());
     //           Logger.debug.println(this, "�����߰����� : "+ d05MpayDetailData1_vt.toString());

     //           Logger.debug.println(this, "�޿���ǥ - ��������/ȯ�� ����  : "+ d05MpayDetailData4.toString());
     //           Logger.debug.println(this, "���޳���/�������� ��  : "+ d05MpayDetailData5.toString());

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

                dest = WebUtil.JspURL+"D/D06Ypay/D06MpayDetail.jsp";
//                }

/******************************************************************************
 * load ���޿�?                => D06YpayDetail_to_year2.jsp
 */
//            }else if(jobid.equals("load")){
//            	dest = WebUtil.JspURL+"D/D06Ypay/D06YpayDetail_to_year2.jsp";
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);
        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}
