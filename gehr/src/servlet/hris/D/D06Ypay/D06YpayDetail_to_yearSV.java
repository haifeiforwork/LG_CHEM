/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  :                                                             */
/*   2Depth Name  : ���޿�                                                      */
/*   Program Name : ���޿�                                                      */
/*   Program ID   : D06YpayDetail_to_yearSV                                   */
/*   Description  : 2003/01/13 ������������ ���� ���޿� ����. (���������)      */
/*                  ������ ���޿��� ���� �󼼳����� ��ȸ�Ͽ� ���� �Ѱ��ִ� class*/
/*   Note         :                                                             */
/*   Creation     : 2003-01-13  �ֿ�ȣ                                          */
/*   Update       : 2005-01-20  �ֿ�ȣ                                          */
/*   Update       : 2007-01-22  @v1.0 lsa ���� clear �ȵǾ� ������ ����         */
/*                      2016-03-15 //[CSR ID:2995203] �������                                                         */
/********************************************************************************/
package servlet.hris.D.D06Ypay;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.D.D06Ypay.*;
import hris.D.D06Ypay.rfc.*;
import hris.common.WebUserData;
import hris.common.* ;
import hris.common.rfc.* ;

/**
 * D06YpayDetail_to_yearSV.java
 * 2003/01/13 ������������ ���� ���޿� ����. (���������)
 * ������ ���޿��� ���� �󼼳����� ��ȸ�Ͽ� D06YpayDetail.jsp ���� �Ѱ��ִ� class
 *   
 * @author �ֿ�ȣ
 * @version 1.0, 2003/01/13
 *   Update       : 2013-06-24 [CSR ID:2353407] sap�� �߰��ϰ��� �߰� ��  
 *                      2016-03-23 [CSR ID:2995203] ������� ����(Total Compensation)
 **/
public class D06YpayDetail_to_yearSV extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;
        try{
            HttpSession session = req.getSession(false);
            WebUserData user    = (WebUserData)session.getValue("user");

            String dest  = "";
            String jobid = "";
            String flag  = " ";
            String seqnr = "00000";

            Box box = WebUtil.getBox(req);
            jobid = box.get("jobid");
           
          //[CSR ID:2995203] ������� �� �ڷΰ���.
            String RequestPageName = box.get("RequestPageName");
            req.setAttribute("RequestPageName", RequestPageName);

            if( jobid.equals("") ){
                jobid = "first";
            }
            //Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());

            if( jobid.equals("first") ) {

                String year  = DataUtil.getCurrentDate().substring(0,4);
                String month = DataUtil.getCurrentDate().substring(4,6);

                //Logger.debug.println(this, "���糯¥ = "+year);

                String from_year  = year;
                String from_month = "01";
                String to_year    = year;
                String to_month   = month;

                int year_be    = Integer.parseInt(from_year) + 1;
                int year_be_to = Integer.parseInt(to_year) + 1;

                String from_yymm = from_year + from_month;
                String to_yymm   = to_year + to_month;

                D06YpayDetail_to_yearRFC rfc = null;  //���� ���� 2003.01.13
                Vector D06YpayDetailData_vt = null;

                // D06YpayDetailRFC ������ ���޿� ������ ��ȸ
                // ���� ���� 2003.01.13
                rfc = new D06YpayDetail_to_yearRFC();
                D06YpayDetailData_vt = rfc.getYpayDetail(user.empNo, from_yymm, to_yymm,user.webUserId); //  [CSR ID:2353407]
                // ���� ���� 2003.01.13
                D06YpayDetail2_to_yearRFC rfc_tax2 = new D06YpayDetail2_to_yearRFC(); // 11�� 13�� ����������� �� ������ �߰� cyh.
                // ���� ���� 2003.01.13
              //  D06YpayDetailData2_to_year d06YpayDetailData2 = null;
              //  D06YpayDetailData3_to_year d06YpayDetailData3 = null;  // 11�� 13�� ������ �߰����� CYH.
                D06YpayDetailData4_to_year d06YpayDetailData4 = null;  // 11�� 13�� ����������� �߰����� CYH.
                Vector d06YpayDetailData2_vt = new Vector();
                Vector d06YpayDetailData3_vt = new Vector();
                Vector d06YpayDetailData4_vt = new Vector();  // 11�� 13�� ������ �߰����� CYH.
                Vector d06YpayDetailData5_vt = new Vector();  // 2003.01.02 �����ݿ����� ���� �߰�.
                Vector d06YpayDetailData6_vt = new Vector();  // 2003.01.02 �����ݿ����� ���� �߰�.
                int sum90 = 0;

/*------ 7�� 23�� �����ݿ��� �߰� --------*/
                int w_yymm = Integer.parseInt(from_yymm);
                int x_yymm = Integer.parseInt(to_yymm);

                for(int i = w_yymm; i < x_yymm+1 ; i++){

                    String yymmdd_tax = Integer.toString(i) + "20";
                    //BET01, 02, 03�� ���� ����, � ���� ����� ������ ���� �ʾƼ�, ��� ������ ��Ƽ� BET01�̶� LGTX1�� ��ƹ���.
                    d06YpayDetailData2_vt = rfc_tax2.getYpayDetail2(user.empNo, yymmdd_tax, "ZZ", flag, seqnr,user.webUserId);
                    d06YpayDetailData5_vt = DataUtil.clone(d06YpayDetailData2_vt);  // 2003.01.02 �����ݿ����� ���� �߰�.
                    d06YpayDetailData6_vt = DataUtil.clone(d06YpayDetailData2_vt);  // 2003.01.02 �����ݿ����� ���� �߰�.
//---------------------------------------------------------------------------------------------------------------//
//   11�� 13�� ����������� �� ������ ���� �����߰� CYH.
                    d06YpayDetailData4_vt = rfc_tax2.getYpayDetail3(user.empNo, yymmdd_tax, "ZZ", flag, seqnr,user.webUserId);
                    // ���� ���� 2003.01.13
                    d06YpayDetailData4 = (D06YpayDetailData4_to_year)rfc_tax2.getPerson(user.empNo, yymmdd_tax, "ZZ", flag, seqnr,user.webUserId);
               //     Logger.debug.println(this, "d06YpayDetailData4_vt. : "+ d06YpayDetailData4_vt.toString());
               //     Logger.debug.println(this, "d06YpayDetailData4 : "+ d06YpayDetailData4.toString());
//----------------------------------------------------------------------------------------------------------------//
               //     Logger.debug.println(this, "d06YpayDetailData2_vt. : "+ d06YpayDetailData2_vt);
                    // ���� ���� 2003.01.13
                    D06YpayDetailData2_to_year data9  = new D06YpayDetailData2_to_year();
                    D06YpayDetailData3_to_year data10 = new D06YpayDetailData3_to_year(); //11�� 13�� �߰����� ����������� �� ������ �߰� cyh
                    D06YpayDetailData2_to_year data11 = new D06YpayDetailData2_to_year(); // 2003.01.02 �����ݿ����� ���� �߰�.
                    D06YpayDetailData2_to_year data12 = new D06YpayDetailData2_to_year(); // 2008.12.26 �����ݿ����� ���� �߰�.
                    double kase = 0;
                    if(d06YpayDetailData2_vt.size() == 0) {
                        data9.BET02 = d06YpayDetailData4.BET19;
                        data9.YYMMDD = Integer.toString(i); 
                        
//----  11�� 13�� �߰����� ����������� �� ������ �߰� cyh.
                        for( int k = 0 ; k < d06YpayDetailData4_vt.size() ; k++ ){
                            // ���� ���� 2003.01.13
                            data10 = (D06YpayDetailData3_to_year)d06YpayDetailData4_vt.get(k);
                            if(data10.LGTX1.equals("LGȭ�г뵿����") || data10.LGTX1.equals("�������ֳ뵿����") || data10.LGTX1.equals("������")) {

                                data9.BET04 = data10.BET02;
                                data9.LGTX4  = "�����������";
                            }
                            //else {  data9.BET03 = "0";   }  //@v1.0 ������ ���� �߰�                             
                        }

                        d06YpayDetailData3_vt.addElement(data9);
                     //   Logger.debug.println(this, "data9_1==== : "+ data9.toString());
//----------------------------------------------------------------------------------------------------------------//
                    }else{
                        for( int j = 0 ; j < d06YpayDetailData2_vt.size() ; j++ ){
                            // ���� ���� 2003.01.13
                            data9 = (D06YpayDetailData2_to_year)d06YpayDetailData2_vt.get(j);
                            data9.YYMMDD = Integer.toString(i);
                            data9.BET02 = d06YpayDetailData4.BET19;  // 11�� 13�� �߰� �����������.

                            for( int k = 0 ; k < d06YpayDetailData4_vt.size() ; k++ ){
                                // ���� ���� 2003.01.13
                                data10 = (D06YpayDetailData3_to_year)d06YpayDetailData4_vt.get(k);
                                //Logger.debug.println(this, "data9_2 ����: data10. : "+ data10.toString());
                                
                                if(data10.LGTX1.equals("LGȭ�г뵿����") || data10.LGTX1.equals("�������ֳ뵿����") || data10.LGTX1.equals("������")) {

                                    data9.LGTX4  = "�����������"; //@v1.2 lsa �߰�                                   	
                                    data9.BET04 = data10.BET02;
                                }
                                //else {  data9.BET03 = "0";   }  //@v1.0 ������ ���� �߰�                                 
                            } 

                            kase = Double.parseDouble(data9.BET01);
                            data9.BET01 = Double.toString(kase);
                            sum90 += Double.parseDouble(data9.BET01.equals("") ? "0" : data9.BET01);

                            d06YpayDetailData3_vt.addElement(data9);
                        }
// 2002.01.02 �����ݿ����� ���� �߰� cyh. --------------------------------------------------//

                    //    Logger.debug.println(this, "d06YpayDetailData5_vt. : "+ d06YpayDetailData5_vt.toString());
                        for( int j = 0 ; j < d06YpayDetailData5_vt.size() ; j++ ){
                            // ���� ���� 2003.01.13
                            data11 = (D06YpayDetailData2_to_year)d06YpayDetailData5_vt.get(j);
                            data11.YYMMDD = Integer.toString(i);
                            kase = Double.parseDouble(data11.BET02);
                            data11.BET01 = Double.toString(kase);
                            data11.LGTX1 = data11.LGTX2; 

                            sum90 += Double.parseDouble(data11.BET01.equals("") ? "0" : data11.BET01);
                       //     Logger.debug.println(this, "data11. : "+ data11.toString());
                             d06YpayDetailData3_vt.addElement(data11);
                        }
                        for( int j = 0 ; j < d06YpayDetailData6_vt.size() ; j++ ){ 
                            data12 = (D06YpayDetailData2_to_year)d06YpayDetailData6_vt.get(j);
                            data12.YYMMDD = Integer.toString(i);

                            kase = Double.parseDouble(data12.BET03);
                            data12.BET01 = Double.toString(kase);
                            data12.LGTX1 = data12.LGTX3;
                            sum90 += Double.parseDouble(data12.BET01.equals("") ? "0" : data12.BET01);
                            d06YpayDetailData3_vt.addElement(data12);
                        }      
//-------------------------------------------------------------------------------------------//
                    }
                }
            //    Logger.debug.println(this, "d06YpayDetailData3_vt. : "+ d06YpayDetailData3_vt);
            //    Logger.debug.println(this, "D06YpayDetailData3_vt.SIZE : "+ d06YpayDetailData3_vt.size());

//----------------------------------------------------------------------------------------------------------------//
                // ���� ���� 2003.01.13
                D06YpayTaxDetail_to_yearRFC  rfc_tax              = new D06YpayTaxDetail_to_yearRFC();
                D06YpayTaxDetailData_to_year d06YpayTaxDetailData = null;
                D06YpayTaxDetailData_to_year data2                = new D06YpayTaxDetailData_to_year();
                Vector D06YpayTaxDetailData_vt = new Vector();

                int sum10 = 0;
                int sum11 = 0;
                int sum12 = 0;
                int sum21 = 0;  // 5�� 22�� ���������� �߰�
                int sum30 = 0;  // 2003.01.15 ��뺸��� ȯ�޾� �߰�

                for( int i = year_be ; i < year_be_to+1 ; i++ ){
                    String year_af = Integer.toString(i);
               //     Logger.debug.println(this, "i�� �� : "+ i);
                    // ���� ���� 2003.01.13
                    d06YpayTaxDetailData = (D06YpayTaxDetailData_to_year)rfc_tax.getTaxDetail(user.empNo, year_af, user.area);
                    D06YpayTaxDetailData_vt.addElement(d06YpayTaxDetailData);
                }
             //   Logger.debug.println(this, "D06YpayTaxDetailData_vt : "+ D06YpayTaxDetailData_vt.toString());
            //    Logger.debug.println(this, "D06YpayTaxDetailData_vt.size() : "+ D06YpayTaxDetailData_vt.size());
                for( int i = 0 ; i < D06YpayTaxDetailData_vt.size() ; i++ ){
                    // ���� ���� 2003.01.13
                    data2 = (D06YpayTaxDetailData_to_year)D06YpayTaxDetailData_vt.get(i);
                  //  Logger.debug.println(this, "data2 : "+ data2.toString());

                    sum10 += Double.parseDouble(data2.YAI == null ? "0" : data2.YAI);
                    sum11 += Double.parseDouble(data2.YAR == null ? "0" : data2.YAR);
                    sum12 += Double.parseDouble(data2.YAS == null ? "0" : data2.YAS);
                    sum21 += Double.parseDouble(data2.TAX == null ? "0" : data2.TAX);  // 5�� 22�� ���������� �߰�
                    sum30 += Double.parseDouble(data2.YFE == null ? "0" : data2.YFE);  // 2003�� 1�� 15�� ���������� �߰�
                }
           //     Logger.debug.println(this, "sum10 : "+ sum10+"sum11 :"+sum11+"sum12 :"+sum12+"sum21 :"+sum21);
                // ���� ���� 2003.01.13
                D06YpayDetailData_to_year data1 = new D06YpayDetailData_to_year();

                int sum1  = 0;
                double sum2  = 0;
                int sum3  = 0;
                double sum4  = 0;
                int sum5  = 0;
                int sum6  = 0;
                int sum7  = 0;
                int sum8  = 0;
                int sum9  = 0;
                int sum13 = 0;  // �����ݿ��ݾ� 4�� 15�� �߰�
                int sum14 = 0;  // ������ 5�� 5�� �߰�
                int sum15 = 0;  // �������޾� 5�� 5�� �߰�
                int sumBet13 = 0; //������ �հ�[CSR ID:2995203] 

                for( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ){
                    // ���� ���� 2003.01.13
                    data1 = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(i);

                    sum1  += Double.parseDouble(data1.BET01);
                    sum2  += Double.parseDouble(data1.BET02);
                    sum3  += Double.parseDouble(data1.BET03);
                    sum4  += Double.parseDouble(data1.BET04);
                    sum5  += Double.parseDouble(data1.BET05);
                    sum6  += Double.parseDouble(data1.BET06);
                    sum7  += Double.parseDouble(data1.BET07);
                    sum8  += Double.parseDouble(data1.BET08);
                    sum9  += Double.parseDouble(data1.BET09);
                    sum13 += Double.parseDouble(data1.BET10);   // �����ݿ��ݾ� 4�� 15�� �߰�
                    sum14 += Double.parseDouble(data1.BET11);   // ������ 5�� 5�� �߰�
                    sum15 += Double.parseDouble(data1.BET12);   // �������޾� 5�� 5�� �߰�
                    sumBet13 += Double.parseDouble(data1.BET13);  //������ �հ�[CSR ID:2995203] 
                }
          //      Logger.debug.println(this, "sum1 : "+ sum1 + "sum9:"+sum9);

          //      Logger.debug.println(this, "D06YpayDetailData_vt : "+ D06YpayDetailData_vt.toString());
//              Logger.debug.println(this, "d06YpayTaxDetailData : "+ d06YpayTaxDetailData.toString());

                req.setAttribute("D06YpayDetailData_vt", D06YpayDetailData_vt);
                req.setAttribute("D06YpayTaxDetailData_vt", D06YpayTaxDetailData_vt);
                req.setAttribute("from_year", from_year);
                req.setAttribute("total1", Integer.toString(sum1));
                req.setAttribute("total2", Double.toString(sum2));
                req.setAttribute("total3", Integer.toString(sum3));
                req.setAttribute("total4", Double.toString(sum4));
                req.setAttribute("total5", Integer.toString(sum5));
                req.setAttribute("total6", Integer.toString(sum6));
                req.setAttribute("total7", Integer.toString(sum7));
                req.setAttribute("total8", Integer.toString(sum8));
                req.setAttribute("total9", Integer.toString(sum9));
                req.setAttribute("total10", Integer.toString(sum10));
                req.setAttribute("total11", Integer.toString(sum11));
                req.setAttribute("total12", Integer.toString(sum12));
                req.setAttribute("total13", Integer.toString(sum13));  // �����ݿ��ݾ� 4�� 15�� �߰�
                req.setAttribute("total14", Integer.toString(sum14));  // ������ 5�� 05�� �߰�
                req.setAttribute("total15", Integer.toString(sum15));  // �������޾� 5�� 05�� �߰�
                req.setAttribute("total30", Integer.toString(sum30));  // ��뺸��� ȯ�޾� 2003.01.15 �߰�
                req.setAttribute("total21", Integer.toString(sum21));  // ���������� 5�� 22�� �߰�
                req.setAttribute("total90", Integer.toString(sum90));  // �����ݿ� �Ѿ�  7�� 23�� �߰�
                req.setAttribute("D06YpayDetailData3_vt", d06YpayDetailData3_vt);  // ���� �����ݿ��� 7�� 23��  �߰�
                req.setAttribute("totalBet13", Integer.toString(sumBet13));  // ������ �հ�[CSR ID:2995203]

                dest = WebUtil.JspURL+"D/D06Ypay/D06YpayDetail_to_year.jsp";
//            }


            }else if(jobid.equals("search")){

                String from_year  = box.get("from_year1");
                String from_month = box.get("from_month1");
                String to_year    = box.get("to_year1");
                String year       = DataUtil.getCurrentDate().substring(0,4);
                String to_month = "";
                if (!from_year.equals(year)){
                    to_month = "12";
                }else{
                    to_month = box.get("to_month1");
                }

                int year_be    = Integer.parseInt(from_year) + 1;
                int year_be_to = Integer.parseInt(to_year) + 1;

                String from_yymm = from_year + from_month;
                String to_yymm   = to_year + to_month;

            //   Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            //    Logger.debug.println(this, "������ ���۳⵵ : "+ from_year + "������ ���ۿ�:"+from_month);
             //   Logger.debug.println(this, "������ ���⵵ : "+ to_year + "������ ����:"+to_month);
                // ���� ���� 2003.01.13
            //    D06YpayDetail_to_yearRFC  rfc   = null;
                D06YpayDetailData_to_year data1 = new D06YpayDetailData_to_year();
                Vector  D06YpayDetailData_vt    = null;
                // ���� ���� 2003.01.13
                D06YpayDetail2_to_yearRFC  rfc_tax2           = new D06YpayDetail2_to_yearRFC();
            //    D06YpayDetailData2_to_year d06YpayDetailData2 = null;
            //    D06YpayDetailData3_to_year d06YpayDetailData3 = null;  // 11�� 13�� ������ �߰����� CYH.
                D06YpayDetailData4_to_year d06YpayDetailData4 = null;  // 11�� 13�� ����������� �߰����� CYH.
                Vector d06YpayDetailData2_vt = new Vector();
                Vector d06YpayDetailData3_vt = new Vector();
                Vector d06YpayDetailData4_vt = new Vector();  // 11�� 13�� ������ �߰����� CYH.
                Vector d06YpayDetailData5_vt = new Vector();  // 2003.01.02 �����ݿ����� ���� �߰�.
                Vector d06YpayDetailData6_vt = new Vector();  // 2003.01.02 �����ݿ����� ���� �߰�.
                int sum90 = 0;

/*------ 7�� 23�� �����ݿ��� �߰� --------*/
                int w_yymm = Integer.parseInt(from_yymm);
                int x_yymm = Integer.parseInt(to_yymm);

                for(int i = w_yymm; i < x_yymm+1 ; i++){

                    String yymmdd_tax = Integer.toString(i) + "20";

                    //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH /////////////////////////////////////////
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
                        for ( int a=0; a < mapData_vt.size(); a++) {
                            mapData = (MappingPernrData)mapData_vt.get(a);
                            mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                            mapDate = mapDate.substring(0,6);

                            if ( i >= Integer.parseInt(mapDate) ) {
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
                    ////////////////////////////////////////////////////////////////////////////////////////////

                    d06YpayDetailData2_vt = rfc_tax2.getYpayDetail2(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user.webUserId);
                    d06YpayDetailData5_vt = DataUtil.clone(d06YpayDetailData2_vt);  // 2003.01.02 �����ݿ����� ���� �߰�.
                    d06YpayDetailData6_vt = DataUtil.clone(d06YpayDetailData2_vt);  // 2003.01.02 �����ݿ����� ���� �߰�.
//---------------------------------------------------------------------------------------------------------------//
//   11�� 13�� ����������� �� ������ ���� �����߰� CYH.
                    d06YpayDetailData4_vt = rfc_tax2.getYpayDetail3(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user.webUserId);
                    // ���� ���� 2003.01.13
                    d06YpayDetailData4 = (D06YpayDetailData4_to_year)rfc_tax2.getPerson(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user.webUserId);
               //     Logger.debug.println(this, "d06YpayDetailData4_vt. : "+ d06YpayDetailData4_vt.toString());
               //     Logger.debug.println(this, "d06YpayDetailData4 : "+ d06YpayDetailData4.toString());
//----------------------------------------------------------------------------------------------------------------//
              //      Logger.debug.println(this, "d06YpayDetailData2_vt. : "+ d06YpayDetailData2_vt);
                    // ���� ���� 2003.01.13
                    D06YpayDetailData2_to_year data9  = new D06YpayDetailData2_to_year();
                    D06YpayDetailData3_to_year data10 = new D06YpayDetailData3_to_year(); //11�� 13�� �߰����� ����������� �� ������ �߰� cyh
                    D06YpayDetailData2_to_year data11 = new D06YpayDetailData2_to_year(); // 2003.01.02 �����ݿ����� ���� �߰�.
                    D06YpayDetailData2_to_year data12 = new D06YpayDetailData2_to_year(); // 2008.12.26 �����ݿ����� ���� �߰�.
                    double kase = 0;
                    if(d06YpayDetailData2_vt.size() == 0) {
                        data9.BET02 = d06YpayDetailData4.BET19;
                        data9.YYMMDD = Integer.toString(i);
//----  11�� 13�� �߰����� ����������� �� ������ �߰� cyh.
                        for( int k = 0 ; k < d06YpayDetailData4_vt.size() ; k++ ){
                            // ���� ���� 2003.01.13
                            data10 = (D06YpayDetailData3_to_year)d06YpayDetailData4_vt.get(k);
                            if(data10.LGTX1.equals("LGȭ�г뵿����") || data10.LGTX1.equals("�������ֳ뵿����") || data10.LGTX1.equals("������")) {
                                data9.LGTX4  = "�����������";
                                data9.BET04 = data10.BET02;
                            }
                            //else {  data9.BET03 = "0";   }  //@v1.0 ������ ���� �߰�                             
                        }
                        d06YpayDetailData3_vt.addElement(data9);
                  //      Logger.debug.println(this, "data9_1 : "+ data9.toString());
//----------------------------------------------------------------------------------------------------------------//
                    }else{
                        for( int j = 0 ; j < d06YpayDetailData2_vt.size() ; j++ ){
                            // ���� ���� 2003.01.13
                            data9 = (D06YpayDetailData2_to_year)d06YpayDetailData2_vt.get(j);
                            data9.YYMMDD = Integer.toString(i);
                            data9.BET02 = d06YpayDetailData4.BET19;  // 11�� 13�� �߰� �����������.
                            for( int k = 0 ; k < d06YpayDetailData4_vt.size() ; k++ ){
                                // ���� ���� 2003.01.13
                                data10 = (D06YpayDetailData3_to_year)d06YpayDetailData4_vt.get(k);
                                if(data10.LGTX1.equals("LGȭ�г뵿����") || data10.LGTX1.equals("�������ֳ뵿����") || data10.LGTX1.equals("������")) {
                                	data9.LGTX4  = "�����������"; //@v1.2 �߰�
                                    data9.BET04 = data10.BET02;
                                }
                                //else {  data9.BET03 = "0";   }  //@v1.0 ������ ���� �߰�                                 
                            }
                      //      Logger.debug.println(this, "data9.YYMMDD : "+ data9.YYMMDD);
                     //       Logger.debug.println(this, "data9_2 : "+ data9.toString());

                            kase = Double.parseDouble(data9.BET01);
                            data9.BET01 = Double.toString(kase);
                            sum90 += Double.parseDouble(data9.BET01.equals("") ? "0" : data9.BET01);
                            d06YpayDetailData3_vt.addElement(data9);
                        }
// 2002.01.02 �����ݿ����� ���� �߰� cyh. --------------------------------------------------//
                        for( int j = 0 ; j < d06YpayDetailData5_vt.size() ; j++ ){
                            // ���� ���� 2003.01.13
                            data11 = (D06YpayDetailData2_to_year)d06YpayDetailData5_vt.get(j);
                            data11.YYMMDD = Integer.toString(i);

                            kase = Double.parseDouble(data11.BET02);
                            data11.BET01 = Double.toString(kase);
                            data11.LGTX1 = data11.LGTX2;
                            sum90 += Double.parseDouble(data11.BET01.equals("") ? "0" : data11.BET01);
                            d06YpayDetailData3_vt.addElement(data11);
                        }
                        for( int j = 0 ; j < d06YpayDetailData6_vt.size() ; j++ ){ 
                            data12 = (D06YpayDetailData2_to_year)d06YpayDetailData6_vt.get(j);
                            data12.YYMMDD = Integer.toString(i);

                            kase = Double.parseDouble(data12.BET03);
                            data12.BET01 = Double.toString(kase);
                            data12.LGTX1 = data12.LGTX3;
                            sum90 += Double.parseDouble(data12.BET01.equals("") ? "0" : data12.BET01);
                            d06YpayDetailData3_vt.addElement(data12);
                        }                                    
//-------------------------------------------------------------------------------------------//
                    }
                } 
//----------------------------------------------------------------------------------------------------------------//
                // ���� ���� 2003.01.13
                D06YpayTaxDetail_to_yearRFC  rfc_tax              = new D06YpayTaxDetail_to_yearRFC();
                D06YpayTaxDetailData_to_year d06YpayTaxDetailData = null;
                D06YpayTaxDetailData_to_year data2                = new D06YpayTaxDetailData_to_year();
                Vector D06YpayTaxDetailData_vt = new Vector();

                int sum10 = 0;
                int sum11 = 0;
                int sum12 = 0;
                int sum21 = 0;  // 5�� 22�� ���������� �߰�
                int sum30 = 0;  // 2003.01.15 ��뺸��� ȯ�޾� �߰�

                for( int i = year_be ; i < year_be_to+1 ; i++ ){

                    //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH /////////////////////////////////////////
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
                        for ( int a=0; a < mapData_vt.size(); a++) {
                            mapData = (MappingPernrData)mapData_vt.get(a);
                            mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                            mapDate = mapDate.substring(0,4);

                            if ( (i-1) >= Integer.parseInt(mapDate) ) {
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
                    ////////////////////////////////////////////////////////////////////////////////////////////

                    String year_af = Integer.toString(i);
              //      Logger.debug.println(this, "i�� �� : "+ i);
                    // ���� ���� 2003.01.13
                    d06YpayTaxDetailData = (D06YpayTaxDetailData_to_year)rfc_tax.getTaxDetail(mapPernr, year_af, user.area);
                    D06YpayTaxDetailData_vt.addElement(d06YpayTaxDetailData);
                }
            //    Logger.debug.println(this, "D06YpayTaxDetailData_vt : "+ D06YpayTaxDetailData_vt.toString());
            //    Logger.debug.println(this, "D06YpayTaxDetailData_vt.size() : "+ D06YpayTaxDetailData_vt.size());
                for( int i = 0 ; i < D06YpayTaxDetailData_vt.size() ; i++ ){
                    // ���� ���� 2003.01.13
                    data2 = (D06YpayTaxDetailData_to_year)D06YpayTaxDetailData_vt.get(i);
               //     Logger.debug.println(this, "data2 : "+ data2.toString());
/*
 * public String YAI ;   // ���ټ�
    public String YAR ;   // �ֹμ�
    public String YAS ;   // ��Ư��
    public String TAX ;   // ����������  5�� 22�� �߰� 
    public String YIC ;   // �������ں� 7�� 25�� �߰� 
    public String YFE ;   // ��뺸��� ȯ�޾� 2003.01.15
 * */
                    sum10 += Double.parseDouble(data2.YAI == null ? "0" : data2.YAI);
                    sum11 += Double.parseDouble(data2.YAR == null ? "0" : data2.YAR);
                    sum12 += Double.parseDouble(data2.YAS == null ? "0" : data2.YAS);
                    sum21 += Double.parseDouble(data2.TAX == null ? "0" : data2.TAX);  // 5�� 22�� ���������� �߰�
                    sum30 += Double.parseDouble(data2.YFE == null ? "0" : data2.YFE);  // 5�� 22�� ���������� �߰�
                }
             //   Logger.debug.println(this, "sum10 : "+ sum10+"sum11 :"+sum11+"sum12 :"+sum12+"sum21 :"+sum21);

                //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH ////////////////////////////////////////
                MappingPernrRFC  mapfunc    = null ;
                MappingPernrData mapData    = new MappingPernrData();
                Vector           mapData_vt = new Vector() ;
           //     String           mapPernr = "";
                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( user.empNo ) ;
                Vector           mapD06Data_vt = null;
                D06YpayDetailData_to_year mdata = new D06YpayDetailData_to_year();
                D06YpayDetail_to_yearRFC mrfc = null;
                D06YpayDetailData_vt = new Vector();

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    mrfc = new D06YpayDetail_to_yearRFC();
                    mapD06Data_vt = new Vector();
                    mapD06Data_vt = mrfc.getYpayDetail(mapData.PERNR, from_yymm, to_yymm,user.webUserId);

                    for( int j = 0 ; j < mapD06Data_vt.size() ; j++ ) {
                        mdata = (D06YpayDetailData_to_year)mapD06Data_vt.get(j);
                        D06YpayDetailData_vt.addElement(mdata);
                    }

                }
                ////////////////////////////////////////////////////////////////////////////////////////////

                // D06YpayDetailRFC ������ ���޿� ������ ��ȸ
                // ���� ���� 2003.01.13
//                rfc = new D06YpayDetail_to_yearRFC();
//                D06YpayDetailData_vt = rfc.getYpayDetail(user.empNo, from_yymm, to_yymm);

                int sum1  = 0;
                double sum2  = 0;
                int sum3  = 0;
                double sum4  = 0;
                int sum5  = 0;
                int sum6  = 0;
                int sum7  = 0;
                int sum8  = 0;
                int sum9  = 0;
                int sum13 = 0;
                int sum14 = 0;  // ������ 5�� 5�� �߰�
                int sum15 = 0;  // �������޾� 5�� 5�� �߰�
                int sumBet13 = 0; //������ �հ�[CSR ID:2995203] 

                for( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ){
                    // ���� ���� 2003.01.13
                    data1 = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(i);

                    sum1  += Double.parseDouble(data1.BET01);
                    sum2  += Double.parseDouble(data1.BET02);
                    sum3  += Double.parseDouble(data1.BET03);
                    sum4  += Double.parseDouble(data1.BET04);
                    sum5  += Double.parseDouble(data1.BET05);
                    sum6  += Double.parseDouble(data1.BET06);
                    sum7  += Double.parseDouble(data1.BET07);
                    sum8  += Double.parseDouble(data1.BET08);
                    sum9  += Double.parseDouble(data1.BET09);
                    sum13 += Double.parseDouble(data1.BET10);
                    sum14 += Double.parseDouble(data1.BET11);   // ������ 5�� 5�� �߰�
                    sum15 += Double.parseDouble(data1.BET12);   // �������޾� 5�� 5�� �߰�
                    sumBet13 += Double.parseDouble(data1.BET13);  //������ �հ�[CSR ID:2995203] 
                }
            //    Logger.debug.println(this, "sum1 : "+ sum1 + "sum9:"+sum9);
            //    Logger.debug.println(this, "D06YpayDetailData_vt : "+ D06YpayDetailData_vt.toString());

                req.setAttribute("D06YpayDetailData_vt", D06YpayDetailData_vt);
                req.setAttribute("D06YpayTaxDetailData_vt", D06YpayTaxDetailData_vt);
                req.setAttribute("from_year", from_year);
                req.setAttribute("total1", Integer.toString(sum1));
                req.setAttribute("total2", Double.toString(sum2));
                req.setAttribute("total3", Integer.toString(sum3));
                req.setAttribute("total4", Double.toString(sum4));
                req.setAttribute("total5", Integer.toString(sum5));
                req.setAttribute("total6", Integer.toString(sum6));
                req.setAttribute("total7", Integer.toString(sum7));
                req.setAttribute("total8", Integer.toString(sum8));
                req.setAttribute("total9", Integer.toString(sum9));
                req.setAttribute("total10", Integer.toString(sum10));
                req.setAttribute("total11", Integer.toString(sum11));
                req.setAttribute("total12", Integer.toString(sum12));
                req.setAttribute("total13", Integer.toString(sum13));
                req.setAttribute("total14", Integer.toString(sum14));  // ������ 5�� 05�� �߰�
                req.setAttribute("total15", Integer.toString(sum15));  // �������޾� 5�� 05�� �߰�
                req.setAttribute("total21", Integer.toString(sum21));  // ���������� 5�� 22�� �߰�
                req.setAttribute("total30", Integer.toString(sum30));  // ��뺸��� ȯ�޾� 2003.01.15 �߰�
                req.setAttribute("total90", Integer.toString(sum90));  // �����ݿ� �Ѿ�  7�� 23�� �߰�
                req.setAttribute("D06YpayDetailData3_vt", d06YpayDetailData3_vt);  // ���� �����ݿ��� 7�� 23��  �߰�
                req.setAttribute("totalBet13", Integer.toString(sumBet13));  // ������ �հ�[CSR ID:2995203]

                dest = WebUtil.JspURL+"D/D06Ypay/D06YpayDetail_to_year.jsp";
//          }


            }else if(jobid.equals("foriegn")){

                String from_year  = box.get("from_year1");
                String from_month = box.get("from_month1");
                String to_year    = box.get("to_year1");
                String to_month   = box.get("to_month1");

//�������� ������ �������
                int year_be    = Integer.parseInt(from_year) + 1;
                int year_be_to = Integer.parseInt(to_year) + 1;

                String from_yymm = from_year + from_month;
                String to_yymm   = to_year + to_month;

            //    Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
           //     Logger.debug.println(this, "������ ���۳⵵ : "+ from_year + "������ ���ۿ�:"+from_month);
           //     Logger.debug.println(this, "������ ���⵵ : "+ to_year + "������ ����:"+to_month);

// �ؿܱٹ��� �����޿�����
                int s_yymm = Integer.parseInt(from_yymm);
                int e_yymm = Integer.parseInt(to_yymm);

                D06FpayDetailRFC  rfc_fpay = new D06FpayDetailRFC();
                D06FpayDetailData d06FpayDetailData = null;
                Vector d06FpayDetailData_vt  = new Vector();
            //    Vector d06FpayDetailData1_vt = new Vector();

                D06FpayDetailData1  data10 = new D06FpayDetailData1();

                int sum1 = 0;
                double sum2 = 0;
                int sum3 = 0;
                double sum4 = 0;
                int sum16 = 0;   // �޿��Ѿ�   5�� 13��
                int sum17 = 0;   // ���Ѿ�   5�� 13��
                int sum18 = 0;   // ��������� �Ѿ�   5�� 13��
                int sum19 = 0;   // �������ú� �Ѿ�   5�� 13��
                int sum20 = 0;   // �������ú� �Ѿ�   5�� 13��

                for(int i = s_yymm; i < e_yymm+1 ; i++){

                    String yymm1 = Integer.toString(i);
                    if(yymm1.substring(4).equals("13")){ i = i+100-12 ; }
                 //   Logger.debug.println(this, "i�� �� : "+ i);
                    String yymm = Integer.toString(i) + "25";

                    //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH /////////////////////////////////////////
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
                        for ( int a=0; a < mapData_vt.size(); a++) {
                            mapData = (MappingPernrData)mapData_vt.get(a);
                            mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                            mapDate = mapDate.substring(0,6);

                            if ( i >= Integer.parseInt(mapDate) ) {
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
                    ////////////////////////////////////////////////////////////////////////////////////////////

                    d06FpayDetailData = (D06FpayDetailData)rfc_fpay.getFpayDetail(mapPernr, yymm, "ZZ", " ");

                    Vector d05MpayDetailData5_vt = rfc_fpay.getMpayDetail(mapPernr, yymm, "ZZ", " ");
             //      Logger.debug.println(this, "d05MpayDetailData5_vt.size() : "+ d05MpayDetailData5_vt.size());

                    for(int j=0 ; j < d05MpayDetailData5_vt.size() ; j++) {

                 //       D06FpayDetailData data11 = new D06FpayDetailData();
                        data10 = (D06FpayDetailData1)d05MpayDetailData5_vt.get(j);

                        if( data10.LGTXT.equals("�󿩱�(�ؿܱ޿���)") ) {
                            d06FpayDetailData.BET15 = data10.BET01;  // �󿩱�.
                            sum4 += Double.parseDouble(data10.BET01);
                        }
                    }
                    sum1  += Double.parseDouble(d06FpayDetailData.BET01);
                    sum2  += Double.parseDouble(d06FpayDetailData.BET07);
                    sum3  += Double.parseDouble(d06FpayDetailData.BET08);
                    sum16 += Double.parseDouble(d06FpayDetailData.BET16);
                    sum17 += Double.parseDouble(d06FpayDetailData.BET17);
                    sum18 += Double.parseDouble(d06FpayDetailData.BET04);  // ��������� �Ѿ� 5�� 13��
                    sum19 += Double.parseDouble(d06FpayDetailData.BET05);  // �������ú� �Ѿ� 5�� 13��
                    sum20 += Double.parseDouble(d06FpayDetailData.BET16) + Double.parseDouble(d06FpayDetailData.BET17) + Double.parseDouble(d06FpayDetailData.BET04) + Double.parseDouble(d06FpayDetailData.BET05);

                    d06FpayDetailData.FYYMM = yymm;
                    d06FpayDetailData_vt.addElement(d06FpayDetailData);
                }
             //   Logger.debug.println(this, "d06FpayDetailData_vt : "+ d06FpayDetailData_vt.toString());


                //�������� RFC
                D06YpayTaxDetailRFC  rfc_tax              = new D06YpayTaxDetailRFC();
                D06YpayTaxDetailData d06YpayTaxDetailData = null;
                D06YpayTaxDetailData data2                = new D06YpayTaxDetailData();
                Vector D06YpayTaxDetailData_vt = new Vector();

                int sum10 = 0;
                int sum11 = 0;
                int sum12 = 0;
                int sum21 = 0;  // 5�� 22�� ���������� �߰�

                for( int i = year_be ; i < year_be_to+1 ; i++ ){

                    //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH /////////////////////////////////////////
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
                        for ( int a=0; a < mapData_vt.size(); a++) {
                            mapData = (MappingPernrData)mapData_vt.get(a);
                            mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                            mapDate = mapDate.substring(0,4);

                            if ( (i-1) >= Integer.parseInt(mapDate) ) {
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
                    ////////////////////////////////////////////////////////////////////////////////////////////

                    String year_af = Integer.toString(i);
              //      Logger.debug.println(this, "i�� value : "+ i);
                    d06YpayTaxDetailData = (D06YpayTaxDetailData)rfc_tax.getTaxDetail(mapPernr, year_af, user.area);
                    D06YpayTaxDetailData_vt.addElement(d06YpayTaxDetailData);
                }
           //     Logger.debug.println(this, "D06YpayTaxDetailData_vt : "+ D06YpayTaxDetailData_vt.toString());
           //     Logger.debug.println(this, "D06YpayTaxDetailData_vt.size() : "+ D06YpayTaxDetailData_vt.size());
                for( int i = 0 ; i < D06YpayTaxDetailData_vt.size() ; i++ ){

                    data2 = (D06YpayTaxDetailData)D06YpayTaxDetailData_vt.get(i);
              //      Logger.debug.println(this, "data2 : "+ data2.toString());

                    sum10 += Double.parseDouble(data2.YAI == null ? "0" : data2.YAI);
                    sum11 += Double.parseDouble(data2.YAR == null ? "0" : data2.YAR);
                    sum12 += Double.parseDouble(data2.YAS == null ? "0" : data2.YAS);
                    sum21 += Double.parseDouble(data2.TAX == null ? "0" : data2.TAX);  // 5�� 22�� ���������� �߰�
                }
              //  Logger.debug.println(this, "sum10 : "+ sum10+"sum11 :"+sum11+"sum12 :"+sum12);

                //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH ////////////////////////////////////////
                MappingPernrRFC  mapfunc    = null ;
                MappingPernrData mapData    = new MappingPernrData();
                Vector           mapData_vt = new Vector() ;
             //   String           mapPernr = "";
                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( user.empNo ) ;
                Vector           mapD06Data_vt = null;
                D06YpayDetailData mdata = new D06YpayDetailData();
                D06YpayDetailRFC mrfc = null;
                Vector D06YpayDetailData_vt = new Vector();

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    mrfc = new D06YpayDetailRFC();
                    mapD06Data_vt = new Vector();
                    mapD06Data_vt = mrfc.getYpayDetail(mapData.PERNR, from_yymm, to_yymm,user.webUserId);

                    for( int j = 0 ; j < mapD06Data_vt.size() ; j++ ) {
                        mdata = (D06YpayDetailData)mapD06Data_vt.get(j);
                        D06YpayDetailData_vt.addElement(mdata);
                    }

                }
                ////////////////////////////////////////////////////////////////////////////////////////////

// D06YpayDetailRFC ������ ���޿� ������ ��ȸ

//                D06YpayDetailRFC  rfc                  = null;
//                Vector            D06YpayDetailData_vt = null;
//                D06YpayDetailData data1                = new D06YpayDetailData();


//                rfc = new D06YpayDetailRFC();
//                D06YpayDetailData_vt = rfc.getYpayDetail(user.empNo, from_yymm, to_yymm);

                if ( D06YpayDetailData_vt.size() == 0 ) {
              //      Logger.debug.println(this, "Data Not Found");
                    String msg = "msg004";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";

                } else {
            //        Logger.debug.println(this, "D06YpayDetailData_vt : "+ D06YpayDetailData_vt.toString());

                    req.setAttribute("D06YpayDetailData_vt", D06YpayDetailData_vt);
                    req.setAttribute("d06FpayDetailData_vt", d06FpayDetailData_vt);
                    req.setAttribute("D06YpayTaxDetailData_vt", D06YpayTaxDetailData_vt);
                    req.setAttribute("from_year", from_year);
                    req.setAttribute("from_month", from_month);
                    req.setAttribute("to_year", to_year);
                    req.setAttribute("to_month", to_month);
                    req.setAttribute("total1", Integer.toString(sum1));
                    req.setAttribute("total2", Double.toString(sum2));
                    req.setAttribute("total3", Integer.toString(sum3));
                    req.setAttribute("total4", Double.toString(sum4));
                    req.setAttribute("total10", Integer.toString(sum10));
                    req.setAttribute("total11", Integer.toString(sum11));
                    req.setAttribute("total12", Integer.toString(sum12));
                    req.setAttribute("total16", Integer.toString(sum16));
                    req.setAttribute("total17", Integer.toString(sum17));
                    req.setAttribute("total18", Integer.toString(sum18));
                    req.setAttribute("total19", Integer.toString(sum19));
                    req.setAttribute("total20", Integer.toString(sum20));
                    req.setAttribute("total21", Integer.toString(sum21));  // ���������� 5�� 22�� �߰�

                    dest = WebUtil.JspURL+"D/D06Ypay/D06FpayDetail.jsp";
                }


            } else if(jobid.equals("print")){

                String from_year  = box.get("from_year1");
                String from_month = box.get("from_month1");
                String to_year    = box.get("to_year1");
                String year     = DataUtil.getCurrentDate().substring(0,4);
                String to_month = "";
                if (!from_year.equals(year)){
                    to_month = "12";
                }else{
                    to_month = box.get("to_month1");
                }

                int year_be    = Integer.parseInt(from_year) + 1;
                int year_be_to = Integer.parseInt(to_year) + 1;

                String from_yymm = from_year + from_month;
                String to_yymm   = to_year + to_month;

            //    Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
            //    Logger.debug.println(this, "������ ���۳⵵ : "+ from_year + "������ ���ۿ�:"+from_month);
             //   Logger.debug.println(this, "������ ���⵵ : "+ to_year + "������ ����:"+to_month);
            //    Logger.debug.println(this, "������ ���۳⵵1 : "+ from_yymm + "������ ����1:"+to_yymm);
                // ���� ���� 2003.01.13
           //     D06YpayDetail_to_yearRFC  rfc = null;
                Vector D06YpayDetailData_vt = null;
                D06YpayDetailData_to_year data1 = new D06YpayDetailData_to_year();
                // ���� ���� 2003.01.13
                D06YpayDetail2_to_yearRFC  rfc_tax2 = new D06YpayDetail2_to_yearRFC();
           //     D06YpayDetailData2_to_year d06YpayDetailData2 = null;
          //      D06YpayDetailData3_to_year d06YpayDetailData3 = null;          // 11�� 13�� ������ �߰����� CYH.
                D06YpayDetailData4_to_year d06YpayDetailData4 = null;          // 11�� 13�� ����������� �߰����� CYH.
                Vector d06YpayDetailData2_vt = new Vector();
                Vector d06YpayDetailData3_vt = new Vector();
                Vector d06YpayDetailData4_vt = new Vector();  // 11�� 13�� ������ �߰����� CYH.
                Vector d06YpayDetailData5_vt = new Vector();  // 2003.01.02 �����ݿ����� ���� �߰�.
                Vector d06YpayDetailData6_vt = new Vector();  // 2003.01.02 �����ݿ����� ���� �߰�.
                int sum90 = 0;

/*------ 7�� 23�� �����ݿ��� �߰� --------*/
                int w_yymm = Integer.parseInt(from_yymm);
                int x_yymm = Integer.parseInt(to_yymm);

                for(int i = w_yymm; i < x_yymm+1 ; i++){

                    String yymmdd_tax = Integer.toString(i) + "20";

                    //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH /////////////////////////////////////////
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
                        for ( int a=0; a < mapData_vt.size(); a++) {
                            mapData = (MappingPernrData)mapData_vt.get(a);
                            mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                            mapDate = mapDate.substring(0,6);

                            if ( i >= Integer.parseInt(mapDate) ) {
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
                    ////////////////////////////////////////////////////////////////////////////////////////////

                    d06YpayDetailData2_vt = rfc_tax2.getYpayDetail2(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user.webUserId);
                    d06YpayDetailData5_vt = rfc_tax2.getYpayDetail2(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user.webUserId);  // 2003.01.02 �����ݿ����� ���� �߰�.
                    d06YpayDetailData6_vt = rfc_tax2.getYpayDetail2(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user.webUserId);  // 2003.01.02 �����ݿ����� ���� �߰�.
//---------------------------------------------------------------------------------------------------------------//
//   11�� 13�� ����������� �� ������ ���� �����߰� CYH.
                    d06YpayDetailData4_vt = rfc_tax2.getYpayDetail3(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user.webUserId);
                    // ���� ���� 2003.01.13
                    d06YpayDetailData4 = (D06YpayDetailData4_to_year)rfc_tax2.getPerson(mapPernr, yymmdd_tax, "ZZ", flag, seqnr,user.webUserId);
               //     Logger.debug.println(this, "d06YpayDetailData4_vt. : "+ d06YpayDetailData4_vt.toString());
                //    Logger.debug.println(this, "d06YpayDetailData4 : "+ d06YpayDetailData4.toString());
//----------------------------------------------------------------------------------------------------------------//
                //    Logger.debug.println(this, "d06YpayDetailData2_vt. : "+ d06YpayDetailData2_vt);
                    // ���� ���� 2003.01.13
                    D06YpayDetailData2_to_year data9  = new D06YpayDetailData2_to_year();
                    D06YpayDetailData3_to_year data10 = new D06YpayDetailData3_to_year(); //11�� 13�� �߰����� ����������� �� ������ �߰� cyh
                    D06YpayDetailData2_to_year data11 = new D06YpayDetailData2_to_year(); // 2003.01.02 �����ݿ����� ���� �߰�.
                    D06YpayDetailData2_to_year data12 = new D06YpayDetailData2_to_year(); // 2008.12.26 �����ݿ����� ���� �߰�.
                    double kase = 0;
                    if(d06YpayDetailData2_vt.size() == 0) {
                        data9.BET02 = d06YpayDetailData4.BET19;
                        data9.YYMMDD = Integer.toString(i);
//----  11�� 13�� �߰����� ����������� �� ������ �߰� cyh.
                        for( int k = 0 ; k < d06YpayDetailData4_vt.size() ; k++ ){
                            // ���� ���� 2003.01.13
                            data10 = (D06YpayDetailData3_to_year)d06YpayDetailData4_vt.get(k);
                            if(data10.LGTX1.equals("LGȭ�г뵿����") || data10.LGTX1.equals("�������ֳ뵿����") || data10.LGTX1.equals("������")) {
                                data9.LGTX4  = "�����������";
                                data9.BET04 = data10.BET02;
                            }
                            //else {  data9.BET03 = "0";   }  //@v1.0 ������ ���� �߰�                             
                        }
                        d06YpayDetailData3_vt.addElement(data9);
                    //    Logger.debug.println(this, "data9_1 : "+ data9.toString());
//----------------------------------------------------------------------------------------------------------------//
                    }else{
                        for( int j = 0 ; j < d06YpayDetailData2_vt.size() ; j++ ){
                            // ���� ���� 2003.01.13
                            data9 = (D06YpayDetailData2_to_year)d06YpayDetailData2_vt.get(j);
                            data9.YYMMDD = Integer.toString(i);
                            data9.BET02 = d06YpayDetailData4.BET19;  // 11�� 13�� �߰� �����������.
                            for( int k = 0 ; k < d06YpayDetailData4_vt.size() ; k++ ){
                                // ���� ���� 2003.01.13
                                data10 = (D06YpayDetailData3_to_year)d06YpayDetailData4_vt.get(k);
                                if(data10.LGTX1.equals("LGȭ�г뵿����") || data10.LGTX1.equals("�������ֳ뵿����") || data10.LGTX1.equals("������")) {
                                	data9.LGTX4  = "�����������";
                                    data9.BET04 = data10.BET02;
                                }
                                //else {  data9.BET03 = "0";   }  //@v1.0 ������ ���� �߰�                                 
                            }
                     //       Logger.debug.println(this, "data9.YYMMDD : "+ data9.YYMMDD);
                     //       Logger.debug.println(this, "data9_2 : "+ data9.toString());

                            kase = Double.parseDouble(data9.BET01);

                            data9.BET01 = Double.toString(kase);
                            sum90 += Double.parseDouble(data9.BET01.equals("") ? "0" : data9.BET01);

                            d06YpayDetailData3_vt.addElement(data9);
                        }
// 2002.01.02 �����ݿ����� ���� �߰� cyh. --------------------------------------------------//
                        for( int j = 0 ; j < d06YpayDetailData5_vt.size() ; j++ ){
                            // ���� ���� 2003.01.13
                            data11 = (D06YpayDetailData2_to_year)d06YpayDetailData5_vt.get(j);
                            data11.YYMMDD = Integer.toString(i);

                            kase = Double.parseDouble(data11.BET02);
                            data11.BET01 = Double.toString(kase);
                            data11.LGTX1 = data11.LGTX2;
                            sum90 += Double.parseDouble(data11.BET01.equals("") ? "0" : data11.BET01);
                            d06YpayDetailData3_vt.addElement(data11);
                        }
                        for( int j = 0 ; j < d06YpayDetailData6_vt.size() ; j++ ){ 
                            data12 = (D06YpayDetailData2_to_year)d06YpayDetailData6_vt.get(j);
                            data12.YYMMDD = Integer.toString(i);

                            kase = Double.parseDouble(data12.BET03);
                            data12.BET01 = Double.toString(kase);
                            data12.LGTX1 = data12.LGTX3;
                            sum90 += Double.parseDouble(data12.BET01.equals("") ? "0" : data12.BET01);
                            d06YpayDetailData3_vt.addElement(data12);
                        }                        
//-------------------------------------------------------------------------------------------//
                    }
                }
         //       Logger.debug.println(this, "d06YpayDetailData3_vt. : "+ d06YpayDetailData3_vt);
         //       Logger.debug.println(this, "D06YpayDetailData3_vt.SIZE : "+ d06YpayDetailData3_vt.size());

//----------------------------------------------------------------------------------------------------------------//
                // ���� ���� 2003.01.13
                D06YpayTaxDetail_to_yearRFC  rfc_tax = new D06YpayTaxDetail_to_yearRFC();
                D06YpayTaxDetailData_to_year d06YpayTaxDetailData = null;
                D06YpayTaxDetailData_to_year data2                = new D06YpayTaxDetailData_to_year();
                Vector D06YpayTaxDetailData_vt = new Vector();

                int sum10 = 0;
                int sum11 = 0;
                int sum12 = 0;
                int sum21 = 0;  // 5�� 22�� ���������� �߰�
                int sum30 = 0;  // 2003.01.15 ��뺸��� ȯ�޾� �߰�

                for( int i = year_be ; i < year_be_to+1 ; i++ ){
                    //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH /////////////////////////////////////////
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
                        for ( int a=0; a < mapData_vt.size(); a++) {
                            mapData = (MappingPernrData)mapData_vt.get(a);
                            mapDate = DataUtil.delDateGubn(mapData.BEGDA);
                            mapDate = mapDate.substring(0,4);

                            if ( i >= Integer.parseInt(mapDate) ) {
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
                    ////////////////////////////////////////////////////////////////////////////////////////////

                    String year_af = Integer.toString(i);
               //     Logger.debug.println(this, "i�� �� : "+ i);
                    // ���� ���� 2003.01.13
                    d06YpayTaxDetailData = (D06YpayTaxDetailData_to_year)rfc_tax.getTaxDetail(mapPernr, year_af, user.area);
                    D06YpayTaxDetailData_vt.addElement(d06YpayTaxDetailData);
                }
            //    Logger.debug.println(this, "D06YpayTaxDetailData_vt : "+ D06YpayTaxDetailData_vt.toString());
            //    Logger.debug.println(this, "D06YpayTaxDetailData_vt.size() : "+ D06YpayTaxDetailData_vt.size());
                for( int i = 0 ; i < D06YpayTaxDetailData_vt.size() ; i++ ){
                    // ���� ���� 2003.01.13
                    data2 = (D06YpayTaxDetailData_to_year)D06YpayTaxDetailData_vt.get(i);
               //     Logger.debug.println(this, "data2 : "+ data2.toString());

                    sum10 += Double.parseDouble(data2.YAI == null ? "0" : data2.YAI);
                    sum11 += Double.parseDouble(data2.YAR == null ? "0" : data2.YAR);
                    sum12 += Double.parseDouble(data2.YAS == null ? "0" : data2.YAS);
                    sum21 += Double.parseDouble(data2.TAX == null ? "0" : data2.TAX);  // 5�� 22�� ���������� �߰�
                    sum30 += Double.parseDouble(data2.YFE == null ? "0" : data2.YFE);  // 5�� 22�� ���������� �߰�
                }
               // Logger.debug.println(this, "sum10 : "+ sum10+"sum11 :"+sum11+"sum12 :"+sum12+"sum30 :"+sum30);


                //// ���Ի��� ����� �������� RFC - 2004.11.19 YJH ////////////////////////////////////////
                MappingPernrRFC  mapfunc    = null ;
                MappingPernrData mapData    = new MappingPernrData();
                Vector           mapData_vt = new Vector() ;
               // String           mapPernr = "";
                mapfunc    = new MappingPernrRFC() ;
                mapData_vt = mapfunc.getPernr( user.empNo ) ;
                Vector           mapD06Data_vt = null;
                D06YpayDetailData_to_year mdata = new D06YpayDetailData_to_year();
                D06YpayDetail_to_yearRFC mrfc = null;
                D06YpayDetailData_vt = new Vector();

                for ( int i=0; i < mapData_vt.size(); i++) {
                    mapData = (MappingPernrData)mapData_vt.get(i);

                    mrfc = new D06YpayDetail_to_yearRFC();
                    mapD06Data_vt = new Vector();
                    mapD06Data_vt = mrfc.getYpayDetail(mapData.PERNR, from_yymm, to_yymm,user.webUserId);

                    for( int j = 0 ; j < mapD06Data_vt.size() ; j++ ) {
                        mdata = (D06YpayDetailData_to_year)mapD06Data_vt.get(j);
                        D06YpayDetailData_vt.addElement(mdata);
                    }

                }
                ////////////////////////////////////////////////////////////////////////////////////////////


                // D06YpayDetailRFC ������ ���޿� ������ ��ȸ
                // ���� ���� 2003.01.13
//                rfc = new D06YpayDetail_to_yearRFC();
//                D06YpayDetailData_vt = rfc.getYpayDetail(user.empNo, from_yymm, to_yymm);

                int sum1  = 0;
                double sum2  = 0;
                int sum3  = 0;
                double sum4  = 0;
                int sum5  = 0;
                int sum6  = 0;
                int sum7  = 0;
                int sum8  = 0;
                int sum9  = 0;
                int sum13 = 0;
                int sum14 = 0;  // ������ 5�� 5�� �߰�
                int sum15 = 0;  // �������޾� 5�� 5�� �߰�
                int sumBet13 = 0; //������ �հ�[CSR ID:2995203] 

                for( int i = 0 ; i < D06YpayDetailData_vt.size() ; i++ ){
                    // ���� ���� 2003.01.13
                    data1 = (D06YpayDetailData_to_year)D06YpayDetailData_vt.get(i);

                    sum1  += Double.parseDouble(data1.BET01);
                    sum2  += Double.parseDouble(data1.BET02);
                    sum3  += Double.parseDouble(data1.BET03);
                    sum4  += Double.parseDouble(data1.BET04);
                    sum5  += Double.parseDouble(data1.BET05);
                    sum6  += Double.parseDouble(data1.BET06);
                    sum7  += Double.parseDouble(data1.BET07);
                    sum8  += Double.parseDouble(data1.BET08);
                    sum9  += Double.parseDouble(data1.BET09);
                    sum13 += Double.parseDouble(data1.BET10);
                    sum14 += Double.parseDouble(data1.BET11);   // ������ 5�� 5�� �߰�
                    sum15 += Double.parseDouble(data1.BET12);   // �������޾� 5�� 5�� �߰�
                    sumBet13 += Double.parseDouble(data1.BET13);  //������ �հ�[CSR ID:2995203] 

                }
             //   Logger.debug.println(this, "sum1 : "+ sum1 + "sum9:"+sum9);

                if ( D06YpayDetailData_vt.size() == 0 ) {
            //        Logger.debug.println(this, "Data Not Found");
                    String msg = "msg004";
                    req.setAttribute("msg", msg);
                    dest = WebUtil.JspURL+"common/caution.jsp";

                } else {
                 //   Logger.debug.println(this, "D06YpayDetailData_vt : "+ D06YpayDetailData_vt.toString());

                    req.setAttribute("D06YpayDetailData_vt", D06YpayDetailData_vt);
                    req.setAttribute("D06YpayTaxDetailData_vt", D06YpayTaxDetailData_vt);
                    req.setAttribute("from_year", from_year);
                    req.setAttribute("from_month", from_month);
                    req.setAttribute("to_year", to_year);
                    req.setAttribute("to_month", to_month);
                    req.setAttribute("total1", Integer.toString(sum1));
                    req.setAttribute("total2", Double.toString(sum2));
                    req.setAttribute("total3", Integer.toString(sum3));
                    req.setAttribute("total4", Double.toString(sum4));
                    req.setAttribute("total5", Integer.toString(sum5));
                    req.setAttribute("total6", Integer.toString(sum6));
                    req.setAttribute("total7", Integer.toString(sum7));
                    req.setAttribute("total8", Integer.toString(sum8));
                    req.setAttribute("total9", Integer.toString(sum9));
                    req.setAttribute("total10", Integer.toString(sum10));
                    req.setAttribute("total11", Integer.toString(sum11));
                    req.setAttribute("total12", Integer.toString(sum12));
                    req.setAttribute("total13", Integer.toString(sum13));
                    req.setAttribute("total14", Integer.toString(sum14));  // ������ 5�� 05�� �߰�
                    req.setAttribute("total15", Integer.toString(sum15));  // �������޾� 5�� 05�� �߰�
                    req.setAttribute("total21", Integer.toString(sum21));  // ���������� 5�� 22�� �߰�
                    req.setAttribute("total30", Integer.toString(sum30));  // ��뺸��� ȯ�޾� 2003.01.15 �߰�
                    req.setAttribute("total90", Integer.toString(sum90));  // �����ݿ� �Ѿ�  7�� 23�� �߰�
                    req.setAttribute("D06YpayDetailData3_vt", d06YpayDetailData3_vt);  // ���� �����ݿ��� 7�� 23��  �߰�
                    req.setAttribute("totalBet13", Integer.toString(sumBet13));  // ������ �հ�[CSR ID:2995203]

                    dest = WebUtil.JspURL+"D/D06Ypay/D06YpayPrint_to_year.jsp";
                }
            }
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
        }
    }
}
